
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 2b 06 00 00       	call   800661 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 68             	sub    $0x68,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 6c 1f 00 00       	call   801faf <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 96 1f 00 00       	call   801fe1 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 80 3d 80 00       	push   $0x803d80
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 2c 36 00 00       	call   80368e <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 c0             	lea    -0x40(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 86 3d 80 00       	push   $0x803d86
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 15 36 00 00       	call   80368e <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800082:	e8 50 36 00 00       	call   8036d7 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	68 8f 3d 80 00       	push   $0x803d8f
  800092:	ff 75 ec             	pushl  -0x14(%ebp)
  800095:	e8 e2 19 00 00       	call   801a7c <sget>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  8000a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a3:	8b 10                	mov    (%eax),%edx
  8000a5:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 a2 3d 80 00       	push   $0x803da2
  8000b0:	52                   	push   %edx
  8000b1:	50                   	push   %eax
  8000b2:	e8 d7 35 00 00       	call   80368e <get_semaphore>
  8000b7:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int *sharedArray = NULL;
  8000c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 b0 3d 80 00       	push   $0x803db0
  8000d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d3:	e8 a4 19 00 00       	call   801a7c <sget>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 b4 3d 80 00       	push   $0x803db4
  8000e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e9:	e8 8e 19 00 00       	call   801a7c <sget>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 00                	push   $0x0
  800101:	50                   	push   %eax
  800102:	68 bc 3d 80 00       	push   $0x803dbc
  800107:	e8 d5 17 00 00       	call   8018e1 <smalloc>
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800119:	eb 25                	jmp    800140 <_main+0x108>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80013d:	ff 45 f4             	incl   -0xc(%ebp)
  800140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800148:	7f d1                	jg     80011b <_main+0xe3>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  80014a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	8d 55 9c             	lea    -0x64(%ebp),%edx
  800155:	52                   	push   %edx
  800156:	8d 55 a0             	lea    -0x60(%ebp),%edx
  800159:	52                   	push   %edx
  80015a:	8d 55 a4             	lea    -0x5c(%ebp),%edx
  80015d:	52                   	push   %edx
  80015e:	8d 55 a8             	lea    -0x58(%ebp),%edx
  800161:	52                   	push   %edx
  800162:	8d 55 b0             	lea    -0x50(%ebp),%edx
  800165:	52                   	push   %edx
  800166:	50                   	push   %eax
  800167:	ff 75 dc             	pushl  -0x24(%ebp)
  80016a:	e8 ba 02 00 00       	call   800429 <ArrayStats>
  80016f:	83 c4 20             	add    $0x20,%esp

	wait_semaphore(cons_mutex);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	ff 75 bc             	pushl  -0x44(%ebp)
  800178:	e8 5a 35 00 00       	call   8036d7 <wait_semaphore>
  80017d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Stats Calculations are Finished!!!!\n") ;
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	68 c4 3d 80 00       	push   $0x803dc4
  800188:	e8 ed 06 00 00       	call   80087a <cprintf>
  80018d:	83 c4 10             	add    $0x10,%esp
		cprintf("will share the rsults & notify the master now...\n");
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 ec 3d 80 00       	push   $0x803dec
  800198:	e8 dd 06 00 00       	call   80087a <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8001a6:	e8 96 35 00 00       	call   803741 <signal_semaphore>
  8001ab:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int64 *shMean, *shVar;
	int *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int64), 0) ; *shMean = mean;
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 08                	push   $0x8
  8001b5:	68 1e 3e 80 00       	push   $0x803e1e
  8001ba:	e8 22 17 00 00       	call   8018e1 <smalloc>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001cb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8001ce:	89 01                	mov    %eax,(%ecx)
  8001d0:	89 51 04             	mov    %edx,0x4(%ecx)
	shVar = smalloc("var", sizeof(int64), 0) ; *shVar = var;
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	6a 00                	push   $0x0
  8001d8:	6a 08                	push   $0x8
  8001da:	68 23 3e 80 00       	push   $0x803e23
  8001df:	e8 fd 16 00 00       	call   8018e1 <smalloc>
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001ed:	8b 55 ac             	mov    -0x54(%ebp),%edx
  8001f0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8001f3:	89 01                	mov    %eax,(%ecx)
  8001f5:	89 51 04             	mov    %edx,0x4(%ecx)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	6a 04                	push   $0x4
  8001ff:	68 27 3e 80 00       	push   $0x803e27
  800204:	e8 d8 16 00 00       	call   8018e1 <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80020f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800212:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800215:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	6a 00                	push   $0x0
  80021c:	6a 04                	push   $0x4
  80021e:	68 2b 3e 80 00       	push   $0x803e2b
  800223:	e8 b9 16 00 00       	call   8018e1 <smalloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80022e:	8b 55 a0             	mov    -0x60(%ebp),%edx
  800231:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800234:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	6a 00                	push   $0x0
  80023b:	6a 04                	push   $0x4
  80023d:	68 2f 3e 80 00       	push   $0x803e2f
  800242:	e8 9a 16 00 00       	call   8018e1 <smalloc>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80024d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  800250:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800253:	89 10                	mov    %edx,(%eax)

	wait_semaphore(cons_mutex);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 bc             	pushl  -0x44(%ebp)
  80025b:	e8 77 34 00 00       	call   8036d7 <wait_semaphore>
  800260:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Stats app says GOOD BYE :)\n") ;
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	68 33 3e 80 00       	push   $0x803e33
  80026b:	e8 0a 06 00 00       	call   80087a <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	ff 75 bc             	pushl  -0x44(%ebp)
  800279:	e8 c3 34 00 00       	call   803741 <signal_semaphore>
  80027e:	83 c4 10             	add    $0x10,%esp

	signal_semaphore(finished);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	ff 75 c0             	pushl  -0x40(%ebp)
  800287:	e8 b5 34 00 00       	call   803741 <signal_semaphore>
  80028c:	83 c4 10             	add    $0x10,%esp

}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  800298:	8b 45 10             	mov    0x10(%ebp),%eax
  80029b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a1:	48                   	dec    %eax
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	52                   	push   %edx
  8002a6:	50                   	push   %eax
  8002a7:	6a 00                	push   $0x0
  8002a9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ac:	ff 75 08             	pushl  0x8(%ebp)
  8002af:	e8 05 00 00 00       	call   8002b9 <QSort>
  8002b4:	83 c4 20             	add    $0x20,%esp
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  8002bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c2:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002c5:	7c 16                	jl     8002dd <QSort+0x24>
  8002c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 d0                	add    %edx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	e9 4a 01 00 00       	jmp    800427 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  8002dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	50                   	push   %eax
  8002e4:	e8 2b 1d 00 00       	call   802014 <sys_get_virtual_time>
  8002e9:	83 c4 0c             	add    $0xc,%esp
  8002ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ef:	8b 55 14             	mov    0x14(%ebp),%edx
  8002f2:	2b 55 10             	sub    0x10(%ebp),%edx
  8002f5:	89 d1                	mov    %edx,%ecx
  8002f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fc:	f7 f1                	div    %ecx
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	ff 75 ec             	pushl  -0x14(%ebp)
  80030c:	ff 75 10             	pushl  0x10(%ebp)
  80030f:	ff 75 08             	pushl  0x8(%ebp)
  800312:	e8 f7 02 00 00       	call   80060e <Swap>
  800317:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80031a:	8b 45 10             	mov    0x10(%ebp),%eax
  80031d:	40                   	inc    %eax
  80031e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800321:	8b 45 14             	mov    0x14(%ebp),%eax
  800324:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800327:	e9 80 00 00 00       	jmp    8003ac <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80032c:	ff 45 f4             	incl   -0xc(%ebp)
  80032f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800332:	3b 45 14             	cmp    0x14(%ebp),%eax
  800335:	7f 2b                	jg     800362 <QSort+0xa9>
  800337:	8b 45 10             	mov    0x10(%ebp),%eax
  80033a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	01 d0                	add    %edx,%eax
  800346:	8b 10                	mov    (%eax),%edx
  800348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80034b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	01 c8                	add    %ecx,%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	39 c2                	cmp    %eax,%edx
  80035b:	7d cf                	jge    80032c <QSort+0x73>
		while (j > startIndex && Elements[startIndex] < Elements[j]) j--;
  80035d:	eb 03                	jmp    800362 <QSort+0xa9>
  80035f:	ff 4d f0             	decl   -0x10(%ebp)
  800362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800365:	3b 45 10             	cmp    0x10(%ebp),%eax
  800368:	7e 26                	jle    800390 <QSort+0xd7>
  80036a:	8b 45 10             	mov    0x10(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800385:	8b 45 08             	mov    0x8(%ebp),%eax
  800388:	01 c8                	add    %ecx,%eax
  80038a:	8b 00                	mov    (%eax),%eax
  80038c:	39 c2                	cmp    %eax,%edx
  80038e:	7c cf                	jl     80035f <QSort+0xa6>

		if (i <= j)
  800390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800393:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800396:	7f 14                	jg     8003ac <QSort+0xf3>
		{
			Swap(Elements, i, j);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	ff 75 f0             	pushl  -0x10(%ebp)
  80039e:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a1:	ff 75 08             	pushl  0x8(%ebp)
  8003a4:	e8 65 02 00 00       	call   80060e <Swap>
  8003a9:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b2:	0f 8e 77 ff ff ff    	jle    80032f <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8003be:	ff 75 10             	pushl  0x10(%ebp)
  8003c1:	ff 75 08             	pushl  0x8(%ebp)
  8003c4:	e8 45 02 00 00       	call   80060e <Swap>
  8003c9:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  8003cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8003cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d2:	75 13                	jne    8003e7 <QSort+0x12e>
		return Elements[kIndex] ;
  8003d4:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	eb 40                	jmp    800427 <QSort+0x16e>
	else if (kIndex < j)
  8003e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003ed:	7d 1e                	jge    80040d <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	48                   	dec    %eax
  8003f3:	83 ec 0c             	sub    $0xc,%esp
  8003f6:	ff 75 18             	pushl  0x18(%ebp)
  8003f9:	50                   	push   %eax
  8003fa:	ff 75 10             	pushl  0x10(%ebp)
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 b1 fe ff ff       	call   8002b9 <QSort>
  800408:	83 c4 20             	add    $0x20,%esp
  80040b:	eb 1a                	jmp    800427 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  80040d:	83 ec 0c             	sub    $0xc,%esp
  800410:	ff 75 18             	pushl  0x18(%ebp)
  800413:	ff 75 14             	pushl  0x14(%ebp)
  800416:	ff 75 f4             	pushl  -0xc(%ebp)
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 95 fe ff ff       	call   8002b9 <QSort>
  800424:	83 c4 20             	add    $0x20,%esp
}
  800427:	c9                   	leave  
  800428:	c3                   	ret    

00800429 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med)
{
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	57                   	push   %edi
  80042d:	56                   	push   %esi
  80042e:	53                   	push   %ebx
  80042f:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  800432:	8b 45 10             	mov    0x10(%ebp),%eax
  800435:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80043b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	*min = 0x7FFFFFFF ;
  800442:	8b 45 18             	mov    0x18(%ebp),%eax
  800445:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80044b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80044e:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800454:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80045b:	e9 89 00 00 00       	jmp    8004e9 <ArrayStats+0xc0>
	{
		(*mean) += Elements[i];
  800460:	8b 45 10             	mov    0x10(%ebp),%eax
  800463:	8b 08                	mov    (%eax),%ecx
  800465:	8b 58 04             	mov    0x4(%eax),%ebx
  800468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	99                   	cltd   
  80047a:	01 c8                	add    %ecx,%eax
  80047c:	11 da                	adc    %ebx,%edx
  80047e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800481:	89 01                	mov    %eax,(%ecx)
  800483:	89 51 04             	mov    %edx,0x4(%ecx)
		if (Elements[i] < (*min))
  800486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800489:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	01 d0                	add    %edx,%eax
  800495:	8b 10                	mov    (%eax),%edx
  800497:	8b 45 18             	mov    0x18(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	39 c2                	cmp    %eax,%edx
  80049e:	7d 16                	jge    8004b6 <ArrayStats+0x8d>
		{
			(*min) = Elements[i];
  8004a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	01 d0                	add    %edx,%eax
  8004af:	8b 10                	mov    (%eax),%edx
  8004b1:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b4:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8004b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 10                	mov    (%eax),%edx
  8004c7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	39 c2                	cmp    %eax,%edx
  8004ce:	7e 16                	jle    8004e6 <ArrayStats+0xbd>
		{
			(*max) = Elements[i];
  8004d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	01 d0                	add    %edx,%eax
  8004df:	8b 10                	mov    (%eax),%edx
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e6:	ff 45 e4             	incl   -0x1c(%ebp)
  8004e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ef:	0f 8c 6b ff ff ff    	jl     800460 <ArrayStats+0x37>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	89 c2                	mov    %eax,%edx
  8004fa:	c1 ea 1f             	shr    $0x1f,%edx
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	d1 f8                	sar    %eax
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	50                   	push   %eax
  800505:	ff 75 0c             	pushl  0xc(%ebp)
  800508:	ff 75 08             	pushl  0x8(%ebp)
  80050b:	e8 82 fd ff ff       	call   800292 <KthElement>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	89 c2                	mov    %eax,%edx
  800515:	8b 45 20             	mov    0x20(%ebp),%eax
  800518:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  80051a:	8b 45 10             	mov    0x10(%ebp),%eax
  80051d:	8b 50 04             	mov    0x4(%eax),%edx
  800520:	8b 00                	mov    (%eax),%eax
  800522:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800525:	89 cb                	mov    %ecx,%ebx
  800527:	c1 fb 1f             	sar    $0x1f,%ebx
  80052a:	53                   	push   %ebx
  80052b:	51                   	push   %ecx
  80052c:	52                   	push   %edx
  80052d:	50                   	push   %eax
  80052e:	e8 65 34 00 00       	call   803998 <__divdi3>
  800533:	83 c4 10             	add    $0x10,%esp
  800536:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800539:	89 01                	mov    %eax,(%ecx)
  80053b:	89 51 04             	mov    %edx,0x4(%ecx)
	(*var) = 0;
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800547:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80054e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800555:	eb 7e                	jmp    8005d5 <ArrayStats+0x1ac>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8b 50 04             	mov    0x4(%eax),%edx
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800562:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	01 d0                	add    %edx,%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 c1                	mov    %eax,%ecx
  800578:	89 c3                	mov    %eax,%ebx
  80057a:	c1 fb 1f             	sar    $0x1f,%ebx
  80057d:	8b 45 10             	mov    0x10(%ebp),%eax
  800580:	8b 50 04             	mov    0x4(%eax),%edx
  800583:	8b 00                	mov    (%eax),%eax
  800585:	29 c1                	sub    %eax,%ecx
  800587:	19 d3                	sbb    %edx,%ebx
  800589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80058c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	89 c6                	mov    %eax,%esi
  80059c:	89 c7                	mov    %eax,%edi
  80059e:	c1 ff 1f             	sar    $0x1f,%edi
  8005a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a4:	8b 50 04             	mov    0x4(%eax),%edx
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	29 c6                	sub    %eax,%esi
  8005ab:	19 d7                	sbb    %edx,%edi
  8005ad:	89 f0                	mov    %esi,%eax
  8005af:	89 fa                	mov    %edi,%edx
  8005b1:	89 df                	mov    %ebx,%edi
  8005b3:	0f af f8             	imul   %eax,%edi
  8005b6:	89 d6                	mov    %edx,%esi
  8005b8:	0f af f1             	imul   %ecx,%esi
  8005bb:	01 fe                	add    %edi,%esi
  8005bd:	f7 e1                	mul    %ecx
  8005bf:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  8005c2:	89 ca                	mov    %ecx,%edx
  8005c4:	03 45 d0             	add    -0x30(%ebp),%eax
  8005c7:	13 55 d4             	adc    -0x2c(%ebp),%edx
  8005ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8005cd:	89 01                	mov    %eax,(%ecx)
  8005cf:	89 51 04             	mov    %edx,0x4(%ecx)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8005d2:	ff 45 e4             	incl   -0x1c(%ebp)
  8005d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005db:	0f 8c 76 ff ff ff    	jl     800557 <ArrayStats+0x12e>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
	}
	(*var) /= NumOfElements;
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 50 04             	mov    0x4(%eax),%edx
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ec:	89 cb                	mov    %ecx,%ebx
  8005ee:	c1 fb 1f             	sar    $0x1f,%ebx
  8005f1:	53                   	push   %ebx
  8005f2:	51                   	push   %ecx
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	e8 9e 33 00 00       	call   803998 <__divdi3>
  8005fa:	83 c4 10             	add    $0x10,%esp
  8005fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800600:	89 01                	mov    %eax,(%ecx)
  800602:	89 51 04             	mov    %edx,0x4(%ecx)
}
  800605:	90                   	nop
  800606:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800609:	5b                   	pop    %ebx
  80060a:	5e                   	pop    %esi
  80060b:	5f                   	pop    %edi
  80060c:	5d                   	pop    %ebp
  80060d:	c3                   	ret    

0080060e <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800614:	8b 45 0c             	mov    0xc(%ebp),%eax
  800617:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	01 d0                	add    %edx,%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	01 c2                	add    %eax,%edx
  800637:	8b 45 10             	mov    0x10(%ebp),%eax
  80063a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	01 c8                	add    %ecx,%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80064a:	8b 45 10             	mov    0x10(%ebp),%eax
  80064d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	01 c2                	add    %eax,%edx
  800659:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80065c:	89 02                	mov    %eax,(%edx)
}
  80065e:	90                   	nop
  80065f:	c9                   	leave  
  800660:	c3                   	ret    

00800661 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800667:	e8 5c 19 00 00       	call   801fc8 <sys_getenvindex>
  80066c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80066f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800672:	89 d0                	mov    %edx,%eax
  800674:	c1 e0 02             	shl    $0x2,%eax
  800677:	01 d0                	add    %edx,%eax
  800679:	c1 e0 03             	shl    $0x3,%eax
  80067c:	01 d0                	add    %edx,%eax
  80067e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800685:	01 d0                	add    %edx,%eax
  800687:	c1 e0 02             	shl    $0x2,%eax
  80068a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80068f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800694:	a1 20 50 80 00       	mov    0x805020,%eax
  800699:	8a 40 20             	mov    0x20(%eax),%al
  80069c:	84 c0                	test   %al,%al
  80069e:	74 0d                	je     8006ad <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8006a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a5:	83 c0 20             	add    $0x20,%eax
  8006a8:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006b1:	7e 0a                	jle    8006bd <libmain+0x5c>
		binaryname = argv[0];
  8006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 0c             	pushl  0xc(%ebp)
  8006c3:	ff 75 08             	pushl  0x8(%ebp)
  8006c6:	e8 6d f9 ff ff       	call   800038 <_main>
  8006cb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006ce:	a1 00 50 80 00       	mov    0x805000,%eax
  8006d3:	85 c0                	test   %eax,%eax
  8006d5:	0f 84 9f 00 00 00    	je     80077a <libmain+0x119>
	{
		sys_lock_cons();
  8006db:	e8 6c 16 00 00       	call   801d4c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006e0:	83 ec 0c             	sub    $0xc,%esp
  8006e3:	68 68 3e 80 00       	push   $0x803e68
  8006e8:	e8 8d 01 00 00       	call   80087a <cprintf>
  8006ed:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8006fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800700:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800706:	83 ec 04             	sub    $0x4,%esp
  800709:	52                   	push   %edx
  80070a:	50                   	push   %eax
  80070b:	68 90 3e 80 00       	push   $0x803e90
  800710:	e8 65 01 00 00       	call   80087a <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800718:	a1 20 50 80 00       	mov    0x805020,%eax
  80071d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800723:	a1 20 50 80 00       	mov    0x805020,%eax
  800728:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80072e:	a1 20 50 80 00       	mov    0x805020,%eax
  800733:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800739:	51                   	push   %ecx
  80073a:	52                   	push   %edx
  80073b:	50                   	push   %eax
  80073c:	68 b8 3e 80 00       	push   $0x803eb8
  800741:	e8 34 01 00 00       	call   80087a <cprintf>
  800746:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800749:	a1 20 50 80 00       	mov    0x805020,%eax
  80074e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	50                   	push   %eax
  800758:	68 10 3f 80 00       	push   $0x803f10
  80075d:	e8 18 01 00 00       	call   80087a <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800765:	83 ec 0c             	sub    $0xc,%esp
  800768:	68 68 3e 80 00       	push   $0x803e68
  80076d:	e8 08 01 00 00       	call   80087a <cprintf>
  800772:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800775:	e8 ec 15 00 00       	call   801d66 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80077a:	e8 19 00 00 00       	call   800798 <exit>
}
  80077f:	90                   	nop
  800780:	c9                   	leave  
  800781:	c3                   	ret    

00800782 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800788:	83 ec 0c             	sub    $0xc,%esp
  80078b:	6a 00                	push   $0x0
  80078d:	e8 02 18 00 00       	call   801f94 <sys_destroy_env>
  800792:	83 c4 10             	add    $0x10,%esp
}
  800795:	90                   	nop
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <exit>:

void
exit(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80079e:	e8 57 18 00 00       	call   801ffa <sys_exit_env>
}
  8007a3:	90                   	nop
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8007b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b7:	89 0a                	mov    %ecx,(%edx)
  8007b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8007bc:	88 d1                	mov    %dl,%cl
  8007be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007cf:	75 2c                	jne    8007fd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007d1:	a0 44 50 98 00       	mov    0x985044,%al
  8007d6:	0f b6 c0             	movzbl %al,%eax
  8007d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007dc:	8b 12                	mov    (%edx),%edx
  8007de:	89 d1                	mov    %edx,%ecx
  8007e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e3:	83 c2 08             	add    $0x8,%edx
  8007e6:	83 ec 04             	sub    $0x4,%esp
  8007e9:	50                   	push   %eax
  8007ea:	51                   	push   %ecx
  8007eb:	52                   	push   %edx
  8007ec:	e8 19 15 00 00       	call   801d0a <sys_cputs>
  8007f1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800800:	8b 40 04             	mov    0x4(%eax),%eax
  800803:	8d 50 01             	lea    0x1(%eax),%edx
  800806:	8b 45 0c             	mov    0xc(%ebp),%eax
  800809:	89 50 04             	mov    %edx,0x4(%eax)
}
  80080c:	90                   	nop
  80080d:	c9                   	leave  
  80080e:	c3                   	ret    

0080080f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800818:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80081f:	00 00 00 
	b.cnt = 0;
  800822:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800829:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	ff 75 08             	pushl  0x8(%ebp)
  800832:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800838:	50                   	push   %eax
  800839:	68 a6 07 80 00       	push   $0x8007a6
  80083e:	e8 11 02 00 00       	call   800a54 <vprintfmt>
  800843:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800846:	a0 44 50 98 00       	mov    0x985044,%al
  80084b:	0f b6 c0             	movzbl %al,%eax
  80084e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800854:	83 ec 04             	sub    $0x4,%esp
  800857:	50                   	push   %eax
  800858:	52                   	push   %edx
  800859:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80085f:	83 c0 08             	add    $0x8,%eax
  800862:	50                   	push   %eax
  800863:	e8 a2 14 00 00       	call   801d0a <sys_cputs>
  800868:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80086b:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800872:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800880:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800887:	8d 45 0c             	lea    0xc(%ebp),%eax
  80088a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	ff 75 f4             	pushl  -0xc(%ebp)
  800896:	50                   	push   %eax
  800897:	e8 73 ff ff ff       	call   80080f <vcprintf>
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008a5:	c9                   	leave  
  8008a6:	c3                   	ret    

008008a7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8008ad:	e8 9a 14 00 00       	call   801d4c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8008b2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c1:	50                   	push   %eax
  8008c2:	e8 48 ff ff ff       	call   80080f <vcprintf>
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008cd:	e8 94 14 00 00       	call   801d66 <sys_unlock_cons>
	return cnt;
  8008d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	83 ec 14             	sub    $0x14,%esp
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8008ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008f5:	77 55                	ja     80094c <printnum+0x75>
  8008f7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008fa:	72 05                	jb     800901 <printnum+0x2a>
  8008fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008ff:	77 4b                	ja     80094c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800901:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800904:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800907:	8b 45 18             	mov    0x18(%ebp),%eax
  80090a:	ba 00 00 00 00       	mov    $0x0,%edx
  80090f:	52                   	push   %edx
  800910:	50                   	push   %eax
  800911:	ff 75 f4             	pushl  -0xc(%ebp)
  800914:	ff 75 f0             	pushl  -0x10(%ebp)
  800917:	e8 e4 31 00 00       	call   803b00 <__udivdi3>
  80091c:	83 c4 10             	add    $0x10,%esp
  80091f:	83 ec 04             	sub    $0x4,%esp
  800922:	ff 75 20             	pushl  0x20(%ebp)
  800925:	53                   	push   %ebx
  800926:	ff 75 18             	pushl  0x18(%ebp)
  800929:	52                   	push   %edx
  80092a:	50                   	push   %eax
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	ff 75 08             	pushl  0x8(%ebp)
  800931:	e8 a1 ff ff ff       	call   8008d7 <printnum>
  800936:	83 c4 20             	add    $0x20,%esp
  800939:	eb 1a                	jmp    800955 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	ff 75 20             	pushl  0x20(%ebp)
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80094c:	ff 4d 1c             	decl   0x1c(%ebp)
  80094f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800953:	7f e6                	jg     80093b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800955:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800958:	bb 00 00 00 00       	mov    $0x0,%ebx
  80095d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800963:	53                   	push   %ebx
  800964:	51                   	push   %ecx
  800965:	52                   	push   %edx
  800966:	50                   	push   %eax
  800967:	e8 a4 32 00 00       	call   803c10 <__umoddi3>
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	05 54 41 80 00       	add    $0x804154,%eax
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f be c0             	movsbl %al,%eax
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 0c             	pushl  0xc(%ebp)
  80097f:	50                   	push   %eax
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
}
  800988:	90                   	nop
  800989:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098c:	c9                   	leave  
  80098d:	c3                   	ret    

0080098e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800991:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800995:	7e 1c                	jle    8009b3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	8d 50 08             	lea    0x8(%eax),%edx
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	89 10                	mov    %edx,(%eax)
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 e8 08             	sub    $0x8,%eax
  8009ac:	8b 50 04             	mov    0x4(%eax),%edx
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	eb 40                	jmp    8009f3 <getuint+0x65>
	else if (lflag)
  8009b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b7:	74 1e                	je     8009d7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	8d 50 04             	lea    0x4(%eax),%edx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	89 10                	mov    %edx,(%eax)
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	83 e8 04             	sub    $0x4,%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d5:	eb 1c                	jmp    8009f3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 00                	mov    (%eax),%eax
  8009dc:	8d 50 04             	lea    0x4(%eax),%edx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	89 10                	mov    %edx,(%eax)
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8b 00                	mov    (%eax),%eax
  8009e9:	83 e8 04             	sub    $0x4,%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009f8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009fc:	7e 1c                	jle    800a1a <getint+0x25>
		return va_arg(*ap, long long);
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 00                	mov    (%eax),%eax
  800a03:	8d 50 08             	lea    0x8(%eax),%edx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	89 10                	mov    %edx,(%eax)
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	83 e8 08             	sub    $0x8,%eax
  800a13:	8b 50 04             	mov    0x4(%eax),%edx
  800a16:	8b 00                	mov    (%eax),%eax
  800a18:	eb 38                	jmp    800a52 <getint+0x5d>
	else if (lflag)
  800a1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1e:	74 1a                	je     800a3a <getint+0x45>
		return va_arg(*ap, long);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	8d 50 04             	lea    0x4(%eax),%edx
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 10                	mov    %edx,(%eax)
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	83 e8 04             	sub    $0x4,%eax
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	99                   	cltd   
  800a38:	eb 18                	jmp    800a52 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	8d 50 04             	lea    0x4(%eax),%edx
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	89 10                	mov    %edx,(%eax)
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	83 e8 04             	sub    $0x4,%eax
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	99                   	cltd   
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	56                   	push   %esi
  800a58:	53                   	push   %ebx
  800a59:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5c:	eb 17                	jmp    800a75 <vprintfmt+0x21>
			if (ch == '\0')
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	0f 84 c1 03 00 00    	je     800e27 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	53                   	push   %ebx
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a75:	8b 45 10             	mov    0x10(%ebp),%eax
  800a78:	8d 50 01             	lea    0x1(%eax),%edx
  800a7b:	89 55 10             	mov    %edx,0x10(%ebp)
  800a7e:	8a 00                	mov    (%eax),%al
  800a80:	0f b6 d8             	movzbl %al,%ebx
  800a83:	83 fb 25             	cmp    $0x25,%ebx
  800a86:	75 d6                	jne    800a5e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a88:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a8c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a93:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a9a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800aa1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aa8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aab:	8d 50 01             	lea    0x1(%eax),%edx
  800aae:	89 55 10             	mov    %edx,0x10(%ebp)
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	0f b6 d8             	movzbl %al,%ebx
  800ab6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ab9:	83 f8 5b             	cmp    $0x5b,%eax
  800abc:	0f 87 3d 03 00 00    	ja     800dff <vprintfmt+0x3ab>
  800ac2:	8b 04 85 78 41 80 00 	mov    0x804178(,%eax,4),%eax
  800ac9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800acb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800acf:	eb d7                	jmp    800aa8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ad1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ad5:	eb d1                	jmp    800aa8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ade:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae1:	89 d0                	mov    %edx,%eax
  800ae3:	c1 e0 02             	shl    $0x2,%eax
  800ae6:	01 d0                	add    %edx,%eax
  800ae8:	01 c0                	add    %eax,%eax
  800aea:	01 d8                	add    %ebx,%eax
  800aec:	83 e8 30             	sub    $0x30,%eax
  800aef:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800afa:	83 fb 2f             	cmp    $0x2f,%ebx
  800afd:	7e 3e                	jle    800b3d <vprintfmt+0xe9>
  800aff:	83 fb 39             	cmp    $0x39,%ebx
  800b02:	7f 39                	jg     800b3d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b04:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b07:	eb d5                	jmp    800ade <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	83 c0 04             	add    $0x4,%eax
  800b0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b12:	8b 45 14             	mov    0x14(%ebp),%eax
  800b15:	83 e8 04             	sub    $0x4,%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b1d:	eb 1f                	jmp    800b3e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b23:	79 83                	jns    800aa8 <vprintfmt+0x54>
				width = 0;
  800b25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b2c:	e9 77 ff ff ff       	jmp    800aa8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b31:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b38:	e9 6b ff ff ff       	jmp    800aa8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b3d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b42:	0f 89 60 ff ff ff    	jns    800aa8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b4e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b55:	e9 4e ff ff ff       	jmp    800aa8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b5a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b5d:	e9 46 ff ff ff       	jmp    800aa8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	83 c0 04             	add    $0x4,%eax
  800b68:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	83 e8 04             	sub    $0x4,%eax
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	50                   	push   %eax
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	ff d0                	call   *%eax
  800b7f:	83 c4 10             	add    $0x10,%esp
			break;
  800b82:	e9 9b 02 00 00       	jmp    800e22 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b87:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8a:	83 c0 04             	add    $0x4,%eax
  800b8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b90:	8b 45 14             	mov    0x14(%ebp),%eax
  800b93:	83 e8 04             	sub    $0x4,%eax
  800b96:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b98:	85 db                	test   %ebx,%ebx
  800b9a:	79 02                	jns    800b9e <vprintfmt+0x14a>
				err = -err;
  800b9c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b9e:	83 fb 64             	cmp    $0x64,%ebx
  800ba1:	7f 0b                	jg     800bae <vprintfmt+0x15a>
  800ba3:	8b 34 9d c0 3f 80 00 	mov    0x803fc0(,%ebx,4),%esi
  800baa:	85 f6                	test   %esi,%esi
  800bac:	75 19                	jne    800bc7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800bae:	53                   	push   %ebx
  800baf:	68 65 41 80 00       	push   $0x804165
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	ff 75 08             	pushl  0x8(%ebp)
  800bba:	e8 70 02 00 00       	call   800e2f <printfmt>
  800bbf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bc2:	e9 5b 02 00 00       	jmp    800e22 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bc7:	56                   	push   %esi
  800bc8:	68 6e 41 80 00       	push   $0x80416e
  800bcd:	ff 75 0c             	pushl  0xc(%ebp)
  800bd0:	ff 75 08             	pushl  0x8(%ebp)
  800bd3:	e8 57 02 00 00       	call   800e2f <printfmt>
  800bd8:	83 c4 10             	add    $0x10,%esp
			break;
  800bdb:	e9 42 02 00 00       	jmp    800e22 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800be0:	8b 45 14             	mov    0x14(%ebp),%eax
  800be3:	83 c0 04             	add    $0x4,%eax
  800be6:	89 45 14             	mov    %eax,0x14(%ebp)
  800be9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 30                	mov    (%eax),%esi
  800bf1:	85 f6                	test   %esi,%esi
  800bf3:	75 05                	jne    800bfa <vprintfmt+0x1a6>
				p = "(null)";
  800bf5:	be 71 41 80 00       	mov    $0x804171,%esi
			if (width > 0 && padc != '-')
  800bfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bfe:	7e 6d                	jle    800c6d <vprintfmt+0x219>
  800c00:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c04:	74 67                	je     800c6d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	50                   	push   %eax
  800c0d:	56                   	push   %esi
  800c0e:	e8 1e 03 00 00       	call   800f31 <strnlen>
  800c13:	83 c4 10             	add    $0x10,%esp
  800c16:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c19:	eb 16                	jmp    800c31 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c1b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	ff 75 0c             	pushl  0xc(%ebp)
  800c25:	50                   	push   %eax
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	ff d0                	call   *%eax
  800c2b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2e:	ff 4d e4             	decl   -0x1c(%ebp)
  800c31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c35:	7f e4                	jg     800c1b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c37:	eb 34                	jmp    800c6d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c39:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c3d:	74 1c                	je     800c5b <vprintfmt+0x207>
  800c3f:	83 fb 1f             	cmp    $0x1f,%ebx
  800c42:	7e 05                	jle    800c49 <vprintfmt+0x1f5>
  800c44:	83 fb 7e             	cmp    $0x7e,%ebx
  800c47:	7e 12                	jle    800c5b <vprintfmt+0x207>
					putch('?', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 3f                	push   $0x3f
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
  800c59:	eb 0f                	jmp    800c6a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	53                   	push   %ebx
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c6a:	ff 4d e4             	decl   -0x1c(%ebp)
  800c6d:	89 f0                	mov    %esi,%eax
  800c6f:	8d 70 01             	lea    0x1(%eax),%esi
  800c72:	8a 00                	mov    (%eax),%al
  800c74:	0f be d8             	movsbl %al,%ebx
  800c77:	85 db                	test   %ebx,%ebx
  800c79:	74 24                	je     800c9f <vprintfmt+0x24b>
  800c7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c7f:	78 b8                	js     800c39 <vprintfmt+0x1e5>
  800c81:	ff 4d e0             	decl   -0x20(%ebp)
  800c84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c88:	79 af                	jns    800c39 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c8a:	eb 13                	jmp    800c9f <vprintfmt+0x24b>
				putch(' ', putdat);
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	6a 20                	push   $0x20
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	ff d0                	call   *%eax
  800c99:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c9c:	ff 4d e4             	decl   -0x1c(%ebp)
  800c9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca3:	7f e7                	jg     800c8c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ca5:	e9 78 01 00 00       	jmp    800e22 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb0:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb3:	50                   	push   %eax
  800cb4:	e8 3c fd ff ff       	call   8009f5 <getint>
  800cb9:	83 c4 10             	add    $0x10,%esp
  800cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	85 d2                	test   %edx,%edx
  800cca:	79 23                	jns    800cef <vprintfmt+0x29b>
				putch('-', putdat);
  800ccc:	83 ec 08             	sub    $0x8,%esp
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	6a 2d                	push   $0x2d
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	ff d0                	call   *%eax
  800cd9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce2:	f7 d8                	neg    %eax
  800ce4:	83 d2 00             	adc    $0x0,%edx
  800ce7:	f7 da                	neg    %edx
  800ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cf6:	e9 bc 00 00 00       	jmp    800db7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	ff 75 e8             	pushl  -0x18(%ebp)
  800d01:	8d 45 14             	lea    0x14(%ebp),%eax
  800d04:	50                   	push   %eax
  800d05:	e8 84 fc ff ff       	call   80098e <getuint>
  800d0a:	83 c4 10             	add    $0x10,%esp
  800d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d13:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d1a:	e9 98 00 00 00       	jmp    800db7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	6a 58                	push   $0x58
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d2f:	83 ec 08             	sub    $0x8,%esp
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	6a 58                	push   $0x58
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	ff d0                	call   *%eax
  800d3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	6a 58                	push   $0x58
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	ff d0                	call   *%eax
  800d4c:	83 c4 10             	add    $0x10,%esp
			break;
  800d4f:	e9 ce 00 00 00       	jmp    800e22 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d54:	83 ec 08             	sub    $0x8,%esp
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	6a 30                	push   $0x30
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 78                	push   $0x78
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d74:	8b 45 14             	mov    0x14(%ebp),%eax
  800d77:	83 c0 04             	add    $0x4,%eax
  800d7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 e8 04             	sub    $0x4,%eax
  800d83:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d8f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d96:	eb 1f                	jmp    800db7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d98:	83 ec 08             	sub    $0x8,%esp
  800d9b:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9e:	8d 45 14             	lea    0x14(%ebp),%eax
  800da1:	50                   	push   %eax
  800da2:	e8 e7 fb ff ff       	call   80098e <getuint>
  800da7:	83 c4 10             	add    $0x10,%esp
  800daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800db0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800db7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	52                   	push   %edx
  800dc2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dc5:	50                   	push   %eax
  800dc6:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc9:	ff 75 f0             	pushl  -0x10(%ebp)
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	ff 75 08             	pushl  0x8(%ebp)
  800dd2:	e8 00 fb ff ff       	call   8008d7 <printnum>
  800dd7:	83 c4 20             	add    $0x20,%esp
			break;
  800dda:	eb 46                	jmp    800e22 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	53                   	push   %ebx
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	ff d0                	call   *%eax
  800de8:	83 c4 10             	add    $0x10,%esp
			break;
  800deb:	eb 35                	jmp    800e22 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ded:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800df4:	eb 2c                	jmp    800e22 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800df6:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800dfd:	eb 23                	jmp    800e22 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	ff 75 0c             	pushl  0xc(%ebp)
  800e05:	6a 25                	push   $0x25
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	ff d0                	call   *%eax
  800e0c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	eb 03                	jmp    800e17 <vprintfmt+0x3c3>
  800e14:	ff 4d 10             	decl   0x10(%ebp)
  800e17:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1a:	48                   	dec    %eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	3c 25                	cmp    $0x25,%al
  800e1f:	75 f3                	jne    800e14 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e21:	90                   	nop
		}
	}
  800e22:	e9 35 fc ff ff       	jmp    800a5c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e27:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e35:	8d 45 10             	lea    0x10(%ebp),%eax
  800e38:	83 c0 04             	add    $0x4,%eax
  800e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e41:	ff 75 f4             	pushl  -0xc(%ebp)
  800e44:	50                   	push   %eax
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	ff 75 08             	pushl  0x8(%ebp)
  800e4b:	e8 04 fc ff ff       	call   800a54 <vprintfmt>
  800e50:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e53:	90                   	nop
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	8b 40 08             	mov    0x8(%eax),%eax
  800e5f:	8d 50 01             	lea    0x1(%eax),%edx
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8b 10                	mov    (%eax),%edx
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8b 40 04             	mov    0x4(%eax),%eax
  800e73:	39 c2                	cmp    %eax,%edx
  800e75:	73 12                	jae    800e89 <sprintputch+0x33>
		*b->buf++ = ch;
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	8b 00                	mov    (%eax),%eax
  800e7c:	8d 48 01             	lea    0x1(%eax),%ecx
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	89 0a                	mov    %ecx,(%edx)
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	88 10                	mov    %dl,(%eax)
}
  800e89:	90                   	nop
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	01 d0                	add    %edx,%eax
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ead:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eb1:	74 06                	je     800eb9 <vsnprintf+0x2d>
  800eb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb7:	7f 07                	jg     800ec0 <vsnprintf+0x34>
		return -E_INVAL;
  800eb9:	b8 03 00 00 00       	mov    $0x3,%eax
  800ebe:	eb 20                	jmp    800ee0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ec0:	ff 75 14             	pushl  0x14(%ebp)
  800ec3:	ff 75 10             	pushl  0x10(%ebp)
  800ec6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ec9:	50                   	push   %eax
  800eca:	68 56 0e 80 00       	push   $0x800e56
  800ecf:	e8 80 fb ff ff       	call   800a54 <vprintfmt>
  800ed4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ee8:	8d 45 10             	lea    0x10(%ebp),%eax
  800eeb:	83 c0 04             	add    $0x4,%eax
  800eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef7:	50                   	push   %eax
  800ef8:	ff 75 0c             	pushl  0xc(%ebp)
  800efb:	ff 75 08             	pushl  0x8(%ebp)
  800efe:	e8 89 ff ff ff       	call   800e8c <vsnprintf>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f1b:	eb 06                	jmp    800f23 <strlen+0x15>
		n++;
  800f1d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f20:	ff 45 08             	incl   0x8(%ebp)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	75 f1                	jne    800f1d <strlen+0xf>
		n++;
	return n;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f3e:	eb 09                	jmp    800f49 <strnlen+0x18>
		n++;
  800f40:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	ff 4d 0c             	decl   0xc(%ebp)
  800f49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f4d:	74 09                	je     800f58 <strnlen+0x27>
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	84 c0                	test   %al,%al
  800f56:	75 e8                	jne    800f40 <strnlen+0xf>
		n++;
	return n;
  800f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f5b:	c9                   	leave  
  800f5c:	c3                   	ret    

00800f5d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f69:	90                   	nop
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8d 50 01             	lea    0x1(%eax),%edx
  800f70:	89 55 08             	mov    %edx,0x8(%ebp)
  800f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f79:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f7c:	8a 12                	mov    (%edx),%dl
  800f7e:	88 10                	mov    %dl,(%eax)
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	84 c0                	test   %al,%al
  800f84:	75 e4                	jne    800f6a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f9e:	eb 1f                	jmp    800fbf <strncpy+0x34>
		*dst++ = *src;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8d 50 01             	lea    0x1(%eax),%edx
  800fa6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fac:	8a 12                	mov    (%edx),%dl
  800fae:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	84 c0                	test   %al,%al
  800fb7:	74 03                	je     800fbc <strncpy+0x31>
			src++;
  800fb9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fbc:	ff 45 fc             	incl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fc5:	72 d9                	jb     800fa0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdc:	74 30                	je     80100e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fde:	eb 16                	jmp    800ff6 <strlcpy+0x2a>
			*dst++ = *src++;
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fef:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ff2:	8a 12                	mov    (%edx),%dl
  800ff4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ff6:	ff 4d 10             	decl   0x10(%ebp)
  800ff9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffd:	74 09                	je     801008 <strlcpy+0x3c>
  800fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	84 c0                	test   %al,%al
  801006:	75 d8                	jne    800fe0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801014:	29 c2                	sub    %eax,%edx
  801016:	89 d0                	mov    %edx,%eax
}
  801018:	c9                   	leave  
  801019:	c3                   	ret    

0080101a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80101d:	eb 06                	jmp    801025 <strcmp+0xb>
		p++, q++;
  80101f:	ff 45 08             	incl   0x8(%ebp)
  801022:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	84 c0                	test   %al,%al
  80102c:	74 0e                	je     80103c <strcmp+0x22>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 10                	mov    (%eax),%dl
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	38 c2                	cmp    %al,%dl
  80103a:	74 e3                	je     80101f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	0f b6 d0             	movzbl %al,%edx
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	0f b6 c0             	movzbl %al,%eax
  80104c:	29 c2                	sub    %eax,%edx
  80104e:	89 d0                	mov    %edx,%eax
}
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801055:	eb 09                	jmp    801060 <strncmp+0xe>
		n--, p++, q++;
  801057:	ff 4d 10             	decl   0x10(%ebp)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	74 17                	je     80107d <strncmp+0x2b>
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	84 c0                	test   %al,%al
  80106d:	74 0e                	je     80107d <strncmp+0x2b>
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 10                	mov    (%eax),%dl
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	38 c2                	cmp    %al,%dl
  80107b:	74 da                	je     801057 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80107d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801081:	75 07                	jne    80108a <strncmp+0x38>
		return 0;
  801083:	b8 00 00 00 00       	mov    $0x0,%eax
  801088:	eb 14                	jmp    80109e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	0f b6 d0             	movzbl %al,%edx
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	0f b6 c0             	movzbl %al,%eax
  80109a:	29 c2                	sub    %eax,%edx
  80109c:	89 d0                	mov    %edx,%eax
}
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    

008010a0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 04             	sub    $0x4,%esp
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010ac:	eb 12                	jmp    8010c0 <strchr+0x20>
		if (*s == c)
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010b6:	75 05                	jne    8010bd <strchr+0x1d>
			return (char *) s;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	eb 11                	jmp    8010ce <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010bd:	ff 45 08             	incl   0x8(%ebp)
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	75 e5                	jne    8010ae <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    

008010d0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 04             	sub    $0x4,%esp
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010dc:	eb 0d                	jmp    8010eb <strfind+0x1b>
		if (*s == c)
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010e6:	74 0e                	je     8010f6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010e8:	ff 45 08             	incl   0x8(%ebp)
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	84 c0                	test   %al,%al
  8010f2:	75 ea                	jne    8010de <strfind+0xe>
  8010f4:	eb 01                	jmp    8010f7 <strfind+0x27>
		if (*s == c)
			break;
  8010f6:	90                   	nop
	return (char *) s;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801108:	8b 45 10             	mov    0x10(%ebp),%eax
  80110b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80110e:	eb 0e                	jmp    80111e <memset+0x22>
		*p++ = c;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801113:	8d 50 01             	lea    0x1(%eax),%edx
  801116:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801119:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80111e:	ff 4d f8             	decl   -0x8(%ebp)
  801121:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801125:	79 e9                	jns    801110 <memset+0x14>
		*p++ = c;

	return v;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80113e:	eb 16                	jmp    801156 <memcpy+0x2a>
		*d++ = *s++;
  801140:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801143:	8d 50 01             	lea    0x1(%eax),%edx
  801146:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801149:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80114f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801152:	8a 12                	mov    (%edx),%dl
  801154:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115c:	89 55 10             	mov    %edx,0x10(%ebp)
  80115f:	85 c0                	test   %eax,%eax
  801161:	75 dd                	jne    801140 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801180:	73 50                	jae    8011d2 <memmove+0x6a>
  801182:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801185:	8b 45 10             	mov    0x10(%ebp),%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80118d:	76 43                	jbe    8011d2 <memmove+0x6a>
		s += n;
  80118f:	8b 45 10             	mov    0x10(%ebp),%eax
  801192:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801195:	8b 45 10             	mov    0x10(%ebp),%eax
  801198:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80119b:	eb 10                	jmp    8011ad <memmove+0x45>
			*--d = *--s;
  80119d:	ff 4d f8             	decl   -0x8(%ebp)
  8011a0:	ff 4d fc             	decl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	8a 10                	mov    (%eax),%dl
  8011a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ab:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 e3                	jne    80119d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011ba:	eb 23                	jmp    8011df <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bf:	8d 50 01             	lea    0x1(%eax),%edx
  8011c2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011cb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011ce:	8a 12                	mov    (%edx),%dl
  8011d0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	75 dd                	jne    8011bc <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011f6:	eb 2a                	jmp    801222 <memcmp+0x3e>
		if (*s1 != *s2)
  8011f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fb:	8a 10                	mov    (%eax),%dl
  8011fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	38 c2                	cmp    %al,%dl
  801204:	74 16                	je     80121c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	0f b6 d0             	movzbl %al,%edx
  80120e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	0f b6 c0             	movzbl %al,%eax
  801216:	29 c2                	sub    %eax,%edx
  801218:	89 d0                	mov    %edx,%eax
  80121a:	eb 18                	jmp    801234 <memcmp+0x50>
		s1++, s2++;
  80121c:	ff 45 fc             	incl   -0x4(%ebp)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	8d 50 ff             	lea    -0x1(%eax),%edx
  801228:	89 55 10             	mov    %edx,0x10(%ebp)
  80122b:	85 c0                	test   %eax,%eax
  80122d:	75 c9                	jne    8011f8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80122f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80123c:	8b 55 08             	mov    0x8(%ebp),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801247:	eb 15                	jmp    80125e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	0f b6 d0             	movzbl %al,%edx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	0f b6 c0             	movzbl %al,%eax
  801257:	39 c2                	cmp    %eax,%edx
  801259:	74 0d                	je     801268 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80125b:	ff 45 08             	incl   0x8(%ebp)
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801264:	72 e3                	jb     801249 <memfind+0x13>
  801266:	eb 01                	jmp    801269 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801268:	90                   	nop
	return (void *) s;
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801282:	eb 03                	jmp    801287 <strtol+0x19>
		s++;
  801284:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 20                	cmp    $0x20,%al
  80128e:	74 f4                	je     801284 <strtol+0x16>
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	3c 09                	cmp    $0x9,%al
  801297:	74 eb                	je     801284 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 2b                	cmp    $0x2b,%al
  8012a0:	75 05                	jne    8012a7 <strtol+0x39>
		s++;
  8012a2:	ff 45 08             	incl   0x8(%ebp)
  8012a5:	eb 13                	jmp    8012ba <strtol+0x4c>
	else if (*s == '-')
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 2d                	cmp    $0x2d,%al
  8012ae:	75 0a                	jne    8012ba <strtol+0x4c>
		s++, neg = 1;
  8012b0:	ff 45 08             	incl   0x8(%ebp)
  8012b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012be:	74 06                	je     8012c6 <strtol+0x58>
  8012c0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012c4:	75 20                	jne    8012e6 <strtol+0x78>
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3c 30                	cmp    $0x30,%al
  8012cd:	75 17                	jne    8012e6 <strtol+0x78>
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	40                   	inc    %eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 78                	cmp    $0x78,%al
  8012d7:	75 0d                	jne    8012e6 <strtol+0x78>
		s += 2, base = 16;
  8012d9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012dd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012e4:	eb 28                	jmp    80130e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ea:	75 15                	jne    801301 <strtol+0x93>
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	3c 30                	cmp    $0x30,%al
  8012f3:	75 0c                	jne    801301 <strtol+0x93>
		s++, base = 8;
  8012f5:	ff 45 08             	incl   0x8(%ebp)
  8012f8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ff:	eb 0d                	jmp    80130e <strtol+0xa0>
	else if (base == 0)
  801301:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801305:	75 07                	jne    80130e <strtol+0xa0>
		base = 10;
  801307:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	3c 2f                	cmp    $0x2f,%al
  801315:	7e 19                	jle    801330 <strtol+0xc2>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	3c 39                	cmp    $0x39,%al
  80131e:	7f 10                	jg     801330 <strtol+0xc2>
			dig = *s - '0';
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	0f be c0             	movsbl %al,%eax
  801328:	83 e8 30             	sub    $0x30,%eax
  80132b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132e:	eb 42                	jmp    801372 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	3c 60                	cmp    $0x60,%al
  801337:	7e 19                	jle    801352 <strtol+0xe4>
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	3c 7a                	cmp    $0x7a,%al
  801340:	7f 10                	jg     801352 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	0f be c0             	movsbl %al,%eax
  80134a:	83 e8 57             	sub    $0x57,%eax
  80134d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801350:	eb 20                	jmp    801372 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	3c 40                	cmp    $0x40,%al
  801359:	7e 39                	jle    801394 <strtol+0x126>
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8a 00                	mov    (%eax),%al
  801360:	3c 5a                	cmp    $0x5a,%al
  801362:	7f 30                	jg     801394 <strtol+0x126>
			dig = *s - 'A' + 10;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	0f be c0             	movsbl %al,%eax
  80136c:	83 e8 37             	sub    $0x37,%eax
  80136f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801375:	3b 45 10             	cmp    0x10(%ebp),%eax
  801378:	7d 19                	jge    801393 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80137a:	ff 45 08             	incl   0x8(%ebp)
  80137d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801380:	0f af 45 10          	imul   0x10(%ebp),%eax
  801384:	89 c2                	mov    %eax,%edx
  801386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801389:	01 d0                	add    %edx,%eax
  80138b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80138e:	e9 7b ff ff ff       	jmp    80130e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801393:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801394:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801398:	74 08                	je     8013a2 <strtol+0x134>
		*endptr = (char *) s;
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a6:	74 07                	je     8013af <strtol+0x141>
  8013a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ab:	f7 d8                	neg    %eax
  8013ad:	eb 03                	jmp    8013b2 <strtol+0x144>
  8013af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <ltostr>:

void
ltostr(long value, char *str)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013cc:	79 13                	jns    8013e1 <ltostr+0x2d>
	{
		neg = 1;
  8013ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013db:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013de:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013e9:	99                   	cltd   
  8013ea:	f7 f9                	idiv   %ecx
  8013ec:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801402:	83 c2 30             	add    $0x30,%edx
  801405:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801407:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80140f:	f7 e9                	imul   %ecx
  801411:	c1 fa 02             	sar    $0x2,%edx
  801414:	89 c8                	mov    %ecx,%eax
  801416:	c1 f8 1f             	sar    $0x1f,%eax
  801419:	29 c2                	sub    %eax,%edx
  80141b:	89 d0                	mov    %edx,%eax
  80141d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801420:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801424:	75 bb                	jne    8013e1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80142d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801430:	48                   	dec    %eax
  801431:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801434:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801438:	74 3d                	je     801477 <ltostr+0xc3>
		start = 1 ;
  80143a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801441:	eb 34                	jmp    801477 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801450:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 c2                	add    %eax,%edx
  801458:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	01 c8                	add    %ecx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	01 c2                	add    %eax,%edx
  80146c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80146f:	88 02                	mov    %al,(%edx)
		start++ ;
  801471:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801474:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80147d:	7c c4                	jl     801443 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80147f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	01 d0                	add    %edx,%eax
  801487:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80148a:	90                   	nop
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801493:	ff 75 08             	pushl  0x8(%ebp)
  801496:	e8 73 fa ff ff       	call   800f0e <strlen>
  80149b:	83 c4 04             	add    $0x4,%esp
  80149e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014a1:	ff 75 0c             	pushl  0xc(%ebp)
  8014a4:	e8 65 fa ff ff       	call   800f0e <strlen>
  8014a9:	83 c4 04             	add    $0x4,%esp
  8014ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014bd:	eb 17                	jmp    8014d6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c5:	01 c2                	add    %eax,%edx
  8014c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	01 c8                	add    %ecx,%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014d3:	ff 45 fc             	incl   -0x4(%ebp)
  8014d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014dc:	7c e1                	jl     8014bf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014ec:	eb 1f                	jmp    80150d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014f7:	89 c2                	mov    %eax,%edx
  8014f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fc:	01 c2                	add    %eax,%edx
  8014fe:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	01 c8                	add    %ecx,%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80150a:	ff 45 f8             	incl   -0x8(%ebp)
  80150d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801510:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801513:	7c d9                	jl     8014ee <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801515:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801518:	8b 45 10             	mov    0x10(%ebp),%eax
  80151b:	01 d0                	add    %edx,%eax
  80151d:	c6 00 00             	movb   $0x0,(%eax)
}
  801520:	90                   	nop
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801526:	8b 45 14             	mov    0x14(%ebp),%eax
  801529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80152f:	8b 45 14             	mov    0x14(%ebp),%eax
  801532:	8b 00                	mov    (%eax),%eax
  801534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	01 d0                	add    %edx,%eax
  801540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801546:	eb 0c                	jmp    801554 <strsplit+0x31>
			*string++ = 0;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8d 50 01             	lea    0x1(%eax),%edx
  80154e:	89 55 08             	mov    %edx,0x8(%ebp)
  801551:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 18                	je     801575 <strsplit+0x52>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f be c0             	movsbl %al,%eax
  801565:	50                   	push   %eax
  801566:	ff 75 0c             	pushl  0xc(%ebp)
  801569:	e8 32 fb ff ff       	call   8010a0 <strchr>
  80156e:	83 c4 08             	add    $0x8,%esp
  801571:	85 c0                	test   %eax,%eax
  801573:	75 d3                	jne    801548 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	8a 00                	mov    (%eax),%al
  80157a:	84 c0                	test   %al,%al
  80157c:	74 5a                	je     8015d8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80157e:	8b 45 14             	mov    0x14(%ebp),%eax
  801581:	8b 00                	mov    (%eax),%eax
  801583:	83 f8 0f             	cmp    $0xf,%eax
  801586:	75 07                	jne    80158f <strsplit+0x6c>
		{
			return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 66                	jmp    8015f5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80158f:	8b 45 14             	mov    0x14(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	8d 48 01             	lea    0x1(%eax),%ecx
  801597:	8b 55 14             	mov    0x14(%ebp),%edx
  80159a:	89 0a                	mov    %ecx,(%edx)
  80159c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	01 c2                	add    %eax,%edx
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015ad:	eb 03                	jmp    8015b2 <strsplit+0x8f>
			string++;
  8015af:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	84 c0                	test   %al,%al
  8015b9:	74 8b                	je     801546 <strsplit+0x23>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	0f be c0             	movsbl %al,%eax
  8015c3:	50                   	push   %eax
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	e8 d4 fa ff ff       	call   8010a0 <strchr>
  8015cc:	83 c4 08             	add    $0x8,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	74 dc                	je     8015af <strsplit+0x8c>
			string++;
	}
  8015d3:	e9 6e ff ff ff       	jmp    801546 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015d8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015dc:	8b 00                	mov    (%eax),%eax
  8015de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	01 d0                	add    %edx,%eax
  8015ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	68 e8 42 80 00       	push   $0x8042e8
  801605:	68 3f 01 00 00       	push   $0x13f
  80160a:	68 0a 43 80 00       	push   $0x80430a
  80160f:	e8 9a 21 00 00       	call   8037ae <_panic>

00801614 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	ff 75 08             	pushl  0x8(%ebp)
  801620:	e8 90 0c 00 00       	call   8022b5 <sys_sbrk>
  801625:	83 c4 10             	add    $0x10,%esp
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801630:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801634:	75 0a                	jne    801640 <malloc+0x16>
		return NULL;
  801636:	b8 00 00 00 00       	mov    $0x0,%eax
  80163b:	e9 9e 01 00 00       	jmp    8017de <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801640:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801647:	77 2c                	ja     801675 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801649:	e8 eb 0a 00 00       	call   802139 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	74 19                	je     80166b <malloc+0x41>

			void * block = alloc_block_FF(size);
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	ff 75 08             	pushl  0x8(%ebp)
  801658:	e8 85 11 00 00       	call   8027e2 <alloc_block_FF>
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801666:	e9 73 01 00 00       	jmp    8017de <malloc+0x1b4>
		} else {
			return NULL;
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
  801670:	e9 69 01 00 00       	jmp    8017de <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801675:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80167c:	8b 55 08             	mov    0x8(%ebp),%edx
  80167f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801682:	01 d0                	add    %edx,%eax
  801684:	48                   	dec    %eax
  801685:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801688:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80168b:	ba 00 00 00 00       	mov    $0x0,%edx
  801690:	f7 75 e0             	divl   -0x20(%ebp)
  801693:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801696:	29 d0                	sub    %edx,%eax
  801698:	c1 e8 0c             	shr    $0xc,%eax
  80169b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80169e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8016a5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8016ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8016b1:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016b4:	05 00 10 00 00       	add    $0x1000,%eax
  8016b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8016bc:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8016c1:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8016c4:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8016c7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8016ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	48                   	dec    %eax
  8016d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8016da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e2:	f7 75 cc             	divl   -0x34(%ebp)
  8016e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016e8:	29 d0                	sub    %edx,%eax
  8016ea:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8016ed:	76 0a                	jbe    8016f9 <malloc+0xcf>
		return NULL;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	e9 e5 00 00 00       	jmp    8017de <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8016f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016ff:	eb 48                	jmp    801749 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801704:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801707:	c1 e8 0c             	shr    $0xc,%eax
  80170a:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  80170d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801710:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801717:	85 c0                	test   %eax,%eax
  801719:	75 11                	jne    80172c <malloc+0x102>
			freePagesCount++;
  80171b:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80171e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801722:	75 16                	jne    80173a <malloc+0x110>
				start = i;
  801724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172a:	eb 0e                	jmp    80173a <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  80172c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801733:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  80173a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801740:	74 12                	je     801754 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801742:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801749:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801750:	76 af                	jbe    801701 <malloc+0xd7>
  801752:	eb 01                	jmp    801755 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801754:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801755:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801759:	74 08                	je     801763 <malloc+0x139>
  80175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801761:	74 07                	je     80176a <malloc+0x140>
		return NULL;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	eb 74                	jmp    8017de <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801770:	c1 e8 0c             	shr    $0xc,%eax
  801773:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801776:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801779:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80177c:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801783:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801786:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801789:	eb 11                	jmp    80179c <malloc+0x172>
		markedPages[i] = 1;
  80178b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178e:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801795:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801799:	ff 45 e8             	incl   -0x18(%ebp)
  80179c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80179f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017a2:	01 d0                	add    %edx,%eax
  8017a4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017a7:	77 e2                	ja     80178b <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8017a9:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8017b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8017b6:	01 d0                	add    %edx,%eax
  8017b8:	48                   	dec    %eax
  8017b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8017bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c4:	f7 75 bc             	divl   -0x44(%ebp)
  8017c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017ca:	29 d0                	sub    %edx,%eax
  8017cc:	83 ec 08             	sub    $0x8,%esp
  8017cf:	50                   	push   %eax
  8017d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d3:	e8 14 0b 00 00       	call   8022ec <sys_allocate_user_mem>
  8017d8:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8017db:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8017e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017ea:	0f 84 ee 00 00 00    	je     8018de <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8017f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8017f5:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8017f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017fb:	77 09                	ja     801806 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8017fd:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801804:	76 14                	jbe    80181a <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	68 18 43 80 00       	push   $0x804318
  80180e:	6a 68                	push   $0x68
  801810:	68 32 43 80 00       	push   $0x804332
  801815:	e8 94 1f 00 00       	call   8037ae <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  80181a:	a1 20 50 80 00       	mov    0x805020,%eax
  80181f:	8b 40 74             	mov    0x74(%eax),%eax
  801822:	3b 45 08             	cmp    0x8(%ebp),%eax
  801825:	77 20                	ja     801847 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801827:	a1 20 50 80 00       	mov    0x805020,%eax
  80182c:	8b 40 78             	mov    0x78(%eax),%eax
  80182f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801832:	76 13                	jbe    801847 <free+0x67>
		free_block(virtual_address);
  801834:	83 ec 0c             	sub    $0xc,%esp
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	e8 6c 16 00 00       	call   802eab <free_block>
  80183f:	83 c4 10             	add    $0x10,%esp
		return;
  801842:	e9 98 00 00 00       	jmp    8018df <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801847:	8b 55 08             	mov    0x8(%ebp),%edx
  80184a:	a1 20 50 80 00       	mov    0x805020,%eax
  80184f:	8b 40 7c             	mov    0x7c(%eax),%eax
  801852:	29 c2                	sub    %eax,%edx
  801854:	89 d0                	mov    %edx,%eax
  801856:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  80185b:	c1 e8 0c             	shr    $0xc,%eax
  80185e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801861:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801868:	eb 16                	jmp    801880 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  80186a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801870:	01 d0                	add    %edx,%eax
  801872:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801879:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80187d:	ff 45 f4             	incl   -0xc(%ebp)
  801880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801883:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80188a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80188d:	7f db                	jg     80186a <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80188f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801892:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801899:	c1 e0 0c             	shl    $0xc,%eax
  80189c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018a5:	eb 1a                	jmp    8018c1 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8018a7:	83 ec 08             	sub    $0x8,%esp
  8018aa:	68 00 10 00 00       	push   $0x1000
  8018af:	ff 75 f0             	pushl  -0x10(%ebp)
  8018b2:	e8 19 0a 00 00       	call   8022d0 <sys_free_user_mem>
  8018b7:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  8018ba:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8018c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c7:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8018c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018cc:	77 d9                	ja     8018a7 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8018ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d1:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  8018d8:	00 00 00 00 
  8018dc:	eb 01                	jmp    8018df <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8018de:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 58             	sub    $0x58,%esp
  8018e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ea:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8018ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018f1:	75 0a                	jne    8018fd <smalloc+0x1c>
		return NULL;
  8018f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f8:	e9 7d 01 00 00       	jmp    801a7a <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8018fd:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80190a:	01 d0                	add    %edx,%eax
  80190c:	48                   	dec    %eax
  80190d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801913:	ba 00 00 00 00       	mov    $0x0,%edx
  801918:	f7 75 e4             	divl   -0x1c(%ebp)
  80191b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191e:	29 d0                	sub    %edx,%eax
  801920:	c1 e8 0c             	shr    $0xc,%eax
  801923:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801926:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80192d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801934:	a1 20 50 80 00       	mov    0x805020,%eax
  801939:	8b 40 7c             	mov    0x7c(%eax),%eax
  80193c:	05 00 10 00 00       	add    $0x1000,%eax
  801941:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801944:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801949:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80194c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80194f:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80195c:	01 d0                	add    %edx,%eax
  80195e:	48                   	dec    %eax
  80195f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801962:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801965:	ba 00 00 00 00       	mov    $0x0,%edx
  80196a:	f7 75 d0             	divl   -0x30(%ebp)
  80196d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801970:	29 d0                	sub    %edx,%eax
  801972:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801975:	76 0a                	jbe    801981 <smalloc+0xa0>
		return NULL;
  801977:	b8 00 00 00 00       	mov    $0x0,%eax
  80197c:	e9 f9 00 00 00       	jmp    801a7a <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801981:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801987:	eb 48                	jmp    8019d1 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80198f:	c1 e8 0c             	shr    $0xc,%eax
  801992:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801995:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801998:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	75 11                	jne    8019b4 <smalloc+0xd3>
			freePagesCount++;
  8019a3:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8019a6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019aa:	75 16                	jne    8019c2 <smalloc+0xe1>
				start = s;
  8019ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b2:	eb 0e                	jmp    8019c2 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  8019b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8019bb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8019c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8019c8:	74 12                	je     8019dc <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8019ca:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8019d1:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8019d8:	76 af                	jbe    801989 <smalloc+0xa8>
  8019da:	eb 01                	jmp    8019dd <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8019dc:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8019dd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019e1:	74 08                	je     8019eb <smalloc+0x10a>
  8019e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8019e9:	74 0a                	je     8019f5 <smalloc+0x114>
		return NULL;
  8019eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f0:	e9 85 00 00 00       	jmp    801a7a <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8019f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8019fb:	c1 e8 0c             	shr    $0xc,%eax
  8019fe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801a01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a07:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801a0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a11:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a14:	eb 11                	jmp    801a27 <smalloc+0x146>
		markedPages[s] = 1;
  801a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a19:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801a20:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801a24:	ff 45 e8             	incl   -0x18(%ebp)
  801a27:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801a2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a2d:	01 d0                	add    %edx,%eax
  801a2f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a32:	77 e2                	ja     801a16 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801a34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a37:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801a3b:	52                   	push   %edx
  801a3c:	50                   	push   %eax
  801a3d:	ff 75 0c             	pushl  0xc(%ebp)
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	e8 8f 04 00 00       	call   801ed7 <sys_createSharedObject>
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801a4e:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801a52:	78 12                	js     801a66 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801a54:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a57:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801a5a:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a64:	eb 14                	jmp    801a7a <smalloc+0x199>
	}
	free((void*) start);
  801a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a69:	83 ec 0c             	sub    $0xc,%esp
  801a6c:	50                   	push   %eax
  801a6d:	e8 6e fd ff ff       	call   8017e0 <free>
  801a72:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	e8 71 04 00 00       	call   801f01 <sys_getSizeOfSharedObject>
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801a96:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	48                   	dec    %eax
  801aa6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801aa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aac:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab1:	f7 75 e0             	divl   -0x20(%ebp)
  801ab4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ab7:	29 d0                	sub    %edx,%eax
  801ab9:	c1 e8 0c             	shr    $0xc,%eax
  801abc:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801abf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801ac6:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801acd:	a1 20 50 80 00       	mov    0x805020,%eax
  801ad2:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ad5:	05 00 10 00 00       	add    $0x1000,%eax
  801ada:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801add:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ae2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ae5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801ae8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801aef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801af2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801af5:	01 d0                	add    %edx,%eax
  801af7:	48                   	dec    %eax
  801af8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801afb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801afe:	ba 00 00 00 00       	mov    $0x0,%edx
  801b03:	f7 75 cc             	divl   -0x34(%ebp)
  801b06:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b09:	29 d0                	sub    %edx,%eax
  801b0b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801b0e:	76 0a                	jbe    801b1a <sget+0x9e>
		return NULL;
  801b10:	b8 00 00 00 00       	mov    $0x0,%eax
  801b15:	e9 f7 00 00 00       	jmp    801c11 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801b1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b20:	eb 48                	jmp    801b6a <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b25:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b28:	c1 e8 0c             	shr    $0xc,%eax
  801b2b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801b2e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801b31:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	75 11                	jne    801b4d <sget+0xd1>
			free_Pages_Count++;
  801b3c:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801b3f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b43:	75 16                	jne    801b5b <sget+0xdf>
				start = s;
  801b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b4b:	eb 0e                	jmp    801b5b <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801b54:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b61:	74 12                	je     801b75 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801b63:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801b6a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801b71:	76 af                	jbe    801b22 <sget+0xa6>
  801b73:	eb 01                	jmp    801b76 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801b75:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801b76:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b7a:	74 08                	je     801b84 <sget+0x108>
  801b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b82:	74 0a                	je     801b8e <sget+0x112>
		return NULL;
  801b84:	b8 00 00 00 00       	mov    $0x0,%eax
  801b89:	e9 83 00 00 00       	jmp    801c11 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b91:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b94:	c1 e8 0c             	shr    $0xc,%eax
  801b97:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801b9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ba0:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801ba7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801baa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bad:	eb 11                	jmp    801bc0 <sget+0x144>
		markedPages[k] = 1;
  801baf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bb2:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801bb9:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801bbd:	ff 45 e8             	incl   -0x18(%ebp)
  801bc0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801bc3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bc6:	01 d0                	add    %edx,%eax
  801bc8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bcb:	77 e2                	ja     801baf <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd0:	83 ec 04             	sub    $0x4,%esp
  801bd3:	50                   	push   %eax
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	e8 3f 03 00 00       	call   801f1e <sys_getSharedObject>
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801be5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801be9:	78 12                	js     801bfd <sget+0x181>
		shardIDs[startPage] = ss;
  801beb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bee:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801bf1:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfb:	eb 14                	jmp    801c11 <sget+0x195>
	}
	free((void*) start);
  801bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c00:	83 ec 0c             	sub    $0xc,%esp
  801c03:	50                   	push   %eax
  801c04:	e8 d7 fb ff ff       	call   8017e0 <free>
  801c09:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801c19:	8b 55 08             	mov    0x8(%ebp),%edx
  801c1c:	a1 20 50 80 00       	mov    0x805020,%eax
  801c21:	8b 40 7c             	mov    0x7c(%eax),%eax
  801c24:	29 c2                	sub    %eax,%edx
  801c26:	89 d0                	mov    %edx,%eax
  801c28:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801c2d:	c1 e8 0c             	shr    $0xc,%eax
  801c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c36:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801c40:	83 ec 08             	sub    $0x8,%esp
  801c43:	ff 75 08             	pushl  0x8(%ebp)
  801c46:	ff 75 f0             	pushl  -0x10(%ebp)
  801c49:	e8 ef 02 00 00       	call   801f3d <sys_freeSharedObject>
  801c4e:	83 c4 10             	add    $0x10,%esp
  801c51:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801c54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c58:	75 0e                	jne    801c68 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5d:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801c64:	ff ff ff ff 
	}

}
  801c68:	90                   	nop
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	68 40 43 80 00       	push   $0x804340
  801c79:	68 19 01 00 00       	push   $0x119
  801c7e:	68 32 43 80 00       	push   $0x804332
  801c83:	e8 26 1b 00 00       	call   8037ae <_panic>

00801c88 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c8e:	83 ec 04             	sub    $0x4,%esp
  801c91:	68 66 43 80 00       	push   $0x804366
  801c96:	68 23 01 00 00       	push   $0x123
  801c9b:	68 32 43 80 00       	push   $0x804332
  801ca0:	e8 09 1b 00 00       	call   8037ae <_panic>

00801ca5 <shrink>:

}
void shrink(uint32 newSize) {
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	68 66 43 80 00       	push   $0x804366
  801cb3:	68 27 01 00 00       	push   $0x127
  801cb8:	68 32 43 80 00       	push   $0x804332
  801cbd:	e8 ec 1a 00 00       	call   8037ae <_panic>

00801cc2 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	68 66 43 80 00       	push   $0x804366
  801cd0:	68 2b 01 00 00       	push   $0x12b
  801cd5:	68 32 43 80 00       	push   $0x804332
  801cda:	e8 cf 1a 00 00       	call   8037ae <_panic>

00801cdf <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	57                   	push   %edi
  801ce3:	56                   	push   %esi
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cf7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cfa:	cd 30                	int    $0x30
  801cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5f                   	pop    %edi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    

00801d0a <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	8b 45 10             	mov    0x10(%ebp),%eax
  801d13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801d16:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	52                   	push   %edx
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	50                   	push   %eax
  801d26:	6a 00                	push   $0x0
  801d28:	e8 b2 ff ff ff       	call   801cdf <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	90                   	nop
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_cgetc>:

int sys_cgetc(void) {
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 02                	push   $0x2
  801d42:	e8 98 ff ff ff       	call   801cdf <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_lock_cons>:

void sys_lock_cons(void) {
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 03                	push   $0x3
  801d5b:	e8 7f ff ff ff       	call   801cdf <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
}
  801d63:	90                   	nop
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 04                	push   $0x4
  801d75:	e8 65 ff ff ff       	call   801cdf <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	90                   	nop
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 08                	push   $0x8
  801d93:	e8 47 ff ff ff       	call   801cdf <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801da2:	8b 75 18             	mov    0x18(%ebp),%esi
  801da5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	56                   	push   %esi
  801db2:	53                   	push   %ebx
  801db3:	51                   	push   %ecx
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 09                	push   $0x9
  801db8:	e8 22 ff ff ff       	call   801cdf <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801dc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc3:	5b                   	pop    %ebx
  801dc4:	5e                   	pop    %esi
  801dc5:	5d                   	pop    %ebp
  801dc6:	c3                   	ret    

00801dc7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	52                   	push   %edx
  801dd7:	50                   	push   %eax
  801dd8:	6a 0a                	push   $0xa
  801dda:	e8 00 ff ff ff       	call   801cdf <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 0b                	push   $0xb
  801df5:	e8 e5 fe ff ff       	call   801cdf <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 0c                	push   $0xc
  801e0e:	e8 cc fe ff ff       	call   801cdf <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 0d                	push   $0xd
  801e27:	e8 b3 fe ff ff       	call   801cdf <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 0e                	push   $0xe
  801e40:	e8 9a fe ff ff       	call   801cdf <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 0f                	push   $0xf
  801e59:	e8 81 fe ff ff       	call   801cdf <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	6a 10                	push   $0x10
  801e73:	e8 67 fe ff ff       	call   801cdf <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_scarce_memory>:

void sys_scarce_memory() {
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 11                	push   $0x11
  801e8c:	e8 4e fe ff ff       	call   801cdf <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	90                   	nop
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_cputc>:

void sys_cputc(const char c) {
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 04             	sub    $0x4,%esp
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ea3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	50                   	push   %eax
  801eb0:	6a 01                	push   $0x1
  801eb2:	e8 28 fe ff ff       	call   801cdf <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
}
  801eba:	90                   	nop
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 14                	push   $0x14
  801ecc:	e8 0e fe ff ff       	call   801cdf <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	90                   	nop
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801ee3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ee6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	51                   	push   %ecx
  801ef0:	52                   	push   %edx
  801ef1:	ff 75 0c             	pushl  0xc(%ebp)
  801ef4:	50                   	push   %eax
  801ef5:	6a 15                	push   $0x15
  801ef7:	e8 e3 fd ff ff       	call   801cdf <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 16                	push   $0x16
  801f14:	e8 c6 fd ff ff       	call   801cdf <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801f21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	51                   	push   %ecx
  801f2f:	52                   	push   %edx
  801f30:	50                   	push   %eax
  801f31:	6a 17                	push   $0x17
  801f33:	e8 a7 fd ff ff       	call   801cdf <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	52                   	push   %edx
  801f4d:	50                   	push   %eax
  801f4e:	6a 18                	push   $0x18
  801f50:	e8 8a fd ff ff       	call   801cdf <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	ff 75 14             	pushl  0x14(%ebp)
  801f65:	ff 75 10             	pushl  0x10(%ebp)
  801f68:	ff 75 0c             	pushl  0xc(%ebp)
  801f6b:	50                   	push   %eax
  801f6c:	6a 19                	push   $0x19
  801f6e:	e8 6c fd ff ff       	call   801cdf <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_run_env>:

void sys_run_env(int32 envId) {
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	50                   	push   %eax
  801f87:	6a 1a                	push   $0x1a
  801f89:	e8 51 fd ff ff       	call   801cdf <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	90                   	nop
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	50                   	push   %eax
  801fa3:	6a 1b                	push   $0x1b
  801fa5:	e8 35 fd ff ff       	call   801cdf <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_getenvid>:

int32 sys_getenvid(void) {
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 05                	push   $0x5
  801fbe:	e8 1c fd ff ff       	call   801cdf <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 06                	push   $0x6
  801fd7:	e8 03 fd ff ff       	call   801cdf <syscall>
  801fdc:	83 c4 18             	add    $0x18,%esp
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 07                	push   $0x7
  801ff0:	e8 ea fc ff ff       	call   801cdf <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <sys_exit_env>:

void sys_exit_env(void) {
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 1c                	push   $0x1c
  802009:	e8 d1 fc ff ff       	call   801cdf <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
}
  802011:	90                   	nop
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80201a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80201d:	8d 50 04             	lea    0x4(%eax),%edx
  802020:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	52                   	push   %edx
  80202a:	50                   	push   %eax
  80202b:	6a 1d                	push   $0x1d
  80202d:	e8 ad fc ff ff       	call   801cdf <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  802035:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802038:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80203b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80203e:	89 01                	mov    %eax,(%ecx)
  802040:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	c9                   	leave  
  802047:	c2 04 00             	ret    $0x4

0080204a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	ff 75 10             	pushl  0x10(%ebp)
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	ff 75 08             	pushl  0x8(%ebp)
  80205a:	6a 13                	push   $0x13
  80205c:	e8 7e fc ff ff       	call   801cdf <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802064:	90                   	nop
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_rcr2>:
uint32 sys_rcr2() {
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 1e                	push   $0x1e
  802076:	e8 64 fc ff ff       	call   801cdf <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80208c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	50                   	push   %eax
  802099:	6a 1f                	push   $0x1f
  80209b:	e8 3f fc ff ff       	call   801cdf <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
	return;
  8020a3:	90                   	nop
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <rsttst>:
void rsttst() {
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 21                	push   $0x21
  8020b5:	e8 25 fc ff ff       	call   801cdf <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
	return;
  8020bd:	90                   	nop
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020cc:	8b 55 18             	mov    0x18(%ebp),%edx
  8020cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020d3:	52                   	push   %edx
  8020d4:	50                   	push   %eax
  8020d5:	ff 75 10             	pushl  0x10(%ebp)
  8020d8:	ff 75 0c             	pushl  0xc(%ebp)
  8020db:	ff 75 08             	pushl  0x8(%ebp)
  8020de:	6a 20                	push   $0x20
  8020e0:	e8 fa fb ff ff       	call   801cdf <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
	return;
  8020e8:	90                   	nop
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <chktst>:
void chktst(uint32 n) {
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	ff 75 08             	pushl  0x8(%ebp)
  8020f9:	6a 22                	push   $0x22
  8020fb:	e8 df fb ff ff       	call   801cdf <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
	return;
  802103:	90                   	nop
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <inctst>:

void inctst() {
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 23                	push   $0x23
  802115:	e8 c5 fb ff ff       	call   801cdf <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
	return;
  80211d:	90                   	nop
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <gettst>:
uint32 gettst() {
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 24                	push   $0x24
  80212f:	e8 ab fb ff ff       	call   801cdf <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 25                	push   $0x25
  80214b:	e8 8f fb ff ff       	call   801cdf <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
  802153:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802156:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80215a:	75 07                	jne    802163 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80215c:	b8 01 00 00 00       	mov    $0x1,%eax
  802161:	eb 05                	jmp    802168 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 25                	push   $0x25
  80217c:	e8 5e fb ff ff       	call   801cdf <syscall>
  802181:	83 c4 18             	add    $0x18,%esp
  802184:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802187:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80218b:	75 07                	jne    802194 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80218d:	b8 01 00 00 00       	mov    $0x1,%eax
  802192:	eb 05                	jmp    802199 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 25                	push   $0x25
  8021ad:	e8 2d fb ff ff       	call   801cdf <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
  8021b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021b8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021bc:	75 07                	jne    8021c5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021be:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c3:	eb 05                	jmp    8021ca <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 25                	push   $0x25
  8021de:	e8 fc fa ff ff       	call   801cdf <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
  8021e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021e9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021ed:	75 07                	jne    8021f6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f4:	eb 05                	jmp    8021fb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	ff 75 08             	pushl  0x8(%ebp)
  80220b:	6a 26                	push   $0x26
  80220d:	e8 cd fa ff ff       	call   801cdf <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
	return;
  802215:	90                   	nop
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80221c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80221f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802222:	8b 55 0c             	mov    0xc(%ebp),%edx
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	6a 00                	push   $0x0
  80222a:	53                   	push   %ebx
  80222b:	51                   	push   %ecx
  80222c:	52                   	push   %edx
  80222d:	50                   	push   %eax
  80222e:	6a 27                	push   $0x27
  802230:	e8 aa fa ff ff       	call   801cdf <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802238:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802240:	8b 55 0c             	mov    0xc(%ebp),%edx
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	52                   	push   %edx
  80224d:	50                   	push   %eax
  80224e:	6a 28                	push   $0x28
  802250:	e8 8a fa ff ff       	call   801cdf <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  80225d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802260:	8b 55 0c             	mov    0xc(%ebp),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	51                   	push   %ecx
  802269:	ff 75 10             	pushl  0x10(%ebp)
  80226c:	52                   	push   %edx
  80226d:	50                   	push   %eax
  80226e:	6a 29                	push   $0x29
  802270:	e8 6a fa ff ff       	call   801cdf <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	ff 75 10             	pushl  0x10(%ebp)
  802284:	ff 75 0c             	pushl  0xc(%ebp)
  802287:	ff 75 08             	pushl  0x8(%ebp)
  80228a:	6a 12                	push   $0x12
  80228c:	e8 4e fa ff ff       	call   801cdf <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
	return;
  802294:	90                   	nop
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80229a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	52                   	push   %edx
  8022a7:	50                   	push   %eax
  8022a8:	6a 2a                	push   $0x2a
  8022aa:	e8 30 fa ff ff       	call   801cdf <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
	return;
  8022b2:	90                   	nop
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	50                   	push   %eax
  8022c4:	6a 2b                	push   $0x2b
  8022c6:	e8 14 fa ff ff       	call   801cdf <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	ff 75 0c             	pushl  0xc(%ebp)
  8022dc:	ff 75 08             	pushl  0x8(%ebp)
  8022df:	6a 2c                	push   $0x2c
  8022e1:	e8 f9 f9 ff ff       	call   801cdf <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
	return;
  8022e9:	90                   	nop
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	ff 75 0c             	pushl  0xc(%ebp)
  8022f8:	ff 75 08             	pushl  0x8(%ebp)
  8022fb:	6a 2d                	push   $0x2d
  8022fd:	e8 dd f9 ff ff       	call   801cdf <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
	return;
  802305:	90                   	nop
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	50                   	push   %eax
  802317:	6a 2f                	push   $0x2f
  802319:	e8 c1 f9 ff ff       	call   801cdf <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
	return;
  802321:	90                   	nop
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	52                   	push   %edx
  802334:	50                   	push   %eax
  802335:	6a 30                	push   $0x30
  802337:	e8 a3 f9 ff ff       	call   801cdf <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
	return;
  80233f:	90                   	nop
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	50                   	push   %eax
  802351:	6a 31                	push   $0x31
  802353:	e8 87 f9 ff ff       	call   801cdf <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
	return;
  80235b:	90                   	nop
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802361:	8b 55 0c             	mov    0xc(%ebp),%edx
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	52                   	push   %edx
  80236e:	50                   	push   %eax
  80236f:	6a 2e                	push   $0x2e
  802371:	e8 69 f9 ff ff       	call   801cdf <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
    return;
  802379:	90                   	nop
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	83 e8 04             	sub    $0x4,%eax
  802388:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80238b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	83 e8 04             	sub    $0x4,%eax
  8023a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8023a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	83 e0 01             	and    $0x1,%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	0f 94 c0             	sete   %al
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8023b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8023c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c3:	83 f8 02             	cmp    $0x2,%eax
  8023c6:	74 2b                	je     8023f3 <alloc_block+0x40>
  8023c8:	83 f8 02             	cmp    $0x2,%eax
  8023cb:	7f 07                	jg     8023d4 <alloc_block+0x21>
  8023cd:	83 f8 01             	cmp    $0x1,%eax
  8023d0:	74 0e                	je     8023e0 <alloc_block+0x2d>
  8023d2:	eb 58                	jmp    80242c <alloc_block+0x79>
  8023d4:	83 f8 03             	cmp    $0x3,%eax
  8023d7:	74 2d                	je     802406 <alloc_block+0x53>
  8023d9:	83 f8 04             	cmp    $0x4,%eax
  8023dc:	74 3b                	je     802419 <alloc_block+0x66>
  8023de:	eb 4c                	jmp    80242c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8023e0:	83 ec 0c             	sub    $0xc,%esp
  8023e3:	ff 75 08             	pushl  0x8(%ebp)
  8023e6:	e8 f7 03 00 00       	call   8027e2 <alloc_block_FF>
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023f1:	eb 4a                	jmp    80243d <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8023f3:	83 ec 0c             	sub    $0xc,%esp
  8023f6:	ff 75 08             	pushl  0x8(%ebp)
  8023f9:	e8 f0 11 00 00       	call   8035ee <alloc_block_NF>
  8023fe:	83 c4 10             	add    $0x10,%esp
  802401:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802404:	eb 37                	jmp    80243d <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802406:	83 ec 0c             	sub    $0xc,%esp
  802409:	ff 75 08             	pushl  0x8(%ebp)
  80240c:	e8 08 08 00 00       	call   802c19 <alloc_block_BF>
  802411:	83 c4 10             	add    $0x10,%esp
  802414:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802417:	eb 24                	jmp    80243d <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802419:	83 ec 0c             	sub    $0xc,%esp
  80241c:	ff 75 08             	pushl  0x8(%ebp)
  80241f:	e8 ad 11 00 00       	call   8035d1 <alloc_block_WF>
  802424:	83 c4 10             	add    $0x10,%esp
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80242a:	eb 11                	jmp    80243d <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80242c:	83 ec 0c             	sub    $0xc,%esp
  80242f:	68 78 43 80 00       	push   $0x804378
  802434:	e8 41 e4 ff ff       	call   80087a <cprintf>
  802439:	83 c4 10             	add    $0x10,%esp
		break;
  80243c:	90                   	nop
	}
	return va;
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	53                   	push   %ebx
  802446:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	68 98 43 80 00       	push   $0x804398
  802451:	e8 24 e4 ff ff       	call   80087a <cprintf>
  802456:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802459:	83 ec 0c             	sub    $0xc,%esp
  80245c:	68 c3 43 80 00       	push   $0x8043c3
  802461:	e8 14 e4 ff ff       	call   80087a <cprintf>
  802466:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246f:	eb 37                	jmp    8024a8 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802471:	83 ec 0c             	sub    $0xc,%esp
  802474:	ff 75 f4             	pushl  -0xc(%ebp)
  802477:	e8 19 ff ff ff       	call   802395 <is_free_block>
  80247c:	83 c4 10             	add    $0x10,%esp
  80247f:	0f be d8             	movsbl %al,%ebx
  802482:	83 ec 0c             	sub    $0xc,%esp
  802485:	ff 75 f4             	pushl  -0xc(%ebp)
  802488:	e8 ef fe ff ff       	call   80237c <get_block_size>
  80248d:	83 c4 10             	add    $0x10,%esp
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	53                   	push   %ebx
  802494:	50                   	push   %eax
  802495:	68 db 43 80 00       	push   $0x8043db
  80249a:	e8 db e3 ff ff       	call   80087a <cprintf>
  80249f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8024a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ac:	74 07                	je     8024b5 <print_blocks_list+0x73>
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 00                	mov    (%eax),%eax
  8024b3:	eb 05                	jmp    8024ba <print_blocks_list+0x78>
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ba:	89 45 10             	mov    %eax,0x10(%ebp)
  8024bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	75 ad                	jne    802471 <print_blocks_list+0x2f>
  8024c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c8:	75 a7                	jne    802471 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8024ca:	83 ec 0c             	sub    $0xc,%esp
  8024cd:	68 98 43 80 00       	push   $0x804398
  8024d2:	e8 a3 e3 ff ff       	call   80087a <cprintf>
  8024d7:	83 c4 10             	add    $0x10,%esp

}
  8024da:	90                   	nop
  8024db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8024e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e9:	83 e0 01             	and    $0x1,%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	74 03                	je     8024f3 <initialize_dynamic_allocator+0x13>
  8024f0:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8024f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024f7:	0f 84 f8 00 00 00    	je     8025f5 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8024fd:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802504:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802507:	a1 40 50 98 00       	mov    0x985040,%eax
  80250c:	85 c0                	test   %eax,%eax
  80250e:	0f 84 e2 00 00 00    	je     8025f6 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802523:	8b 55 08             	mov    0x8(%ebp),%edx
  802526:	8b 45 0c             	mov    0xc(%ebp),%eax
  802529:	01 d0                	add    %edx,%eax
  80252b:	83 e8 04             	sub    $0x4,%eax
  80252e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802534:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	83 c0 08             	add    $0x8,%eax
  802540:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802543:	8b 45 0c             	mov    0xc(%ebp),%eax
  802546:	83 e8 08             	sub    $0x8,%eax
  802549:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80254c:	83 ec 04             	sub    $0x4,%esp
  80254f:	6a 00                	push   $0x0
  802551:	ff 75 e8             	pushl  -0x18(%ebp)
  802554:	ff 75 ec             	pushl  -0x14(%ebp)
  802557:	e8 9c 00 00 00       	call   8025f8 <set_block_data>
  80255c:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802572:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802579:	00 00 00 
  80257c:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802583:	00 00 00 
  802586:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80258d:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802590:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802594:	75 17                	jne    8025ad <initialize_dynamic_allocator+0xcd>
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 f4 43 80 00       	push   $0x8043f4
  80259e:	68 80 00 00 00       	push   $0x80
  8025a3:	68 17 44 80 00       	push   $0x804417
  8025a8:	e8 01 12 00 00       	call   8037ae <_panic>
  8025ad:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8025b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b6:	89 10                	mov    %edx,(%eax)
  8025b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 0d                	je     8025ce <initialize_dynamic_allocator+0xee>
  8025c1:	a1 48 50 98 00       	mov    0x985048,%eax
  8025c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c9:	89 50 04             	mov    %edx,0x4(%eax)
  8025cc:	eb 08                	jmp    8025d6 <initialize_dynamic_allocator+0xf6>
  8025ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8025d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d9:	a3 48 50 98 00       	mov    %eax,0x985048
  8025de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e8:	a1 54 50 98 00       	mov    0x985054,%eax
  8025ed:	40                   	inc    %eax
  8025ee:	a3 54 50 98 00       	mov    %eax,0x985054
  8025f3:	eb 01                	jmp    8025f6 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8025f5:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8025fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802601:	83 e0 01             	and    $0x1,%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 03                	je     80260b <set_block_data+0x13>
	{
		totalSize++;
  802608:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	83 e8 04             	sub    $0x4,%eax
  802611:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802614:	8b 45 0c             	mov    0xc(%ebp),%eax
  802617:	83 e0 fe             	and    $0xfffffffe,%eax
  80261a:	89 c2                	mov    %eax,%edx
  80261c:	8b 45 10             	mov    0x10(%ebp),%eax
  80261f:	83 e0 01             	and    $0x1,%eax
  802622:	09 c2                	or     %eax,%edx
  802624:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802627:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	01 d0                	add    %edx,%eax
  802634:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263a:	83 e0 fe             	and    $0xfffffffe,%eax
  80263d:	89 c2                	mov    %eax,%edx
  80263f:	8b 45 10             	mov    0x10(%ebp),%eax
  802642:	83 e0 01             	and    $0x1,%eax
  802645:	09 c2                	or     %eax,%edx
  802647:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80264a:	89 10                	mov    %edx,(%eax)
}
  80264c:	90                   	nop
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802655:	a1 48 50 98 00       	mov    0x985048,%eax
  80265a:	85 c0                	test   %eax,%eax
  80265c:	75 68                	jne    8026c6 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80265e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802662:	75 17                	jne    80267b <insert_sorted_in_freeList+0x2c>
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 f4 43 80 00       	push   $0x8043f4
  80266c:	68 9d 00 00 00       	push   $0x9d
  802671:	68 17 44 80 00       	push   $0x804417
  802676:	e8 33 11 00 00       	call   8037ae <_panic>
  80267b:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	89 10                	mov    %edx,(%eax)
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 0d                	je     80269c <insert_sorted_in_freeList+0x4d>
  80268f:	a1 48 50 98 00       	mov    0x985048,%eax
  802694:	8b 55 08             	mov    0x8(%ebp),%edx
  802697:	89 50 04             	mov    %edx,0x4(%eax)
  80269a:	eb 08                	jmp    8026a4 <insert_sorted_in_freeList+0x55>
  80269c:	8b 45 08             	mov    0x8(%ebp),%eax
  80269f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	a3 48 50 98 00       	mov    %eax,0x985048
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b6:	a1 54 50 98 00       	mov    0x985054,%eax
  8026bb:	40                   	inc    %eax
  8026bc:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8026c1:	e9 1a 01 00 00       	jmp    8027e0 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8026c6:	a1 48 50 98 00       	mov    0x985048,%eax
  8026cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ce:	eb 7f                	jmp    80274f <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d6:	76 6f                	jbe    802747 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8026d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dc:	74 06                	je     8026e4 <insert_sorted_in_freeList+0x95>
  8026de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e2:	75 17                	jne    8026fb <insert_sorted_in_freeList+0xac>
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 30 44 80 00       	push   $0x804430
  8026ec:	68 a6 00 00 00       	push   $0xa6
  8026f1:	68 17 44 80 00       	push   $0x804417
  8026f6:	e8 b3 10 00 00       	call   8037ae <_panic>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 50 04             	mov    0x4(%eax),%edx
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	89 50 04             	mov    %edx,0x4(%eax)
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270d:	89 10                	mov    %edx,(%eax)
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	85 c0                	test   %eax,%eax
  802717:	74 0d                	je     802726 <insert_sorted_in_freeList+0xd7>
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	8b 55 08             	mov    0x8(%ebp),%edx
  802722:	89 10                	mov    %edx,(%eax)
  802724:	eb 08                	jmp    80272e <insert_sorted_in_freeList+0xdf>
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	a3 48 50 98 00       	mov    %eax,0x985048
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 55 08             	mov    0x8(%ebp),%edx
  802734:	89 50 04             	mov    %edx,0x4(%eax)
  802737:	a1 54 50 98 00       	mov    0x985054,%eax
  80273c:	40                   	inc    %eax
  80273d:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802742:	e9 99 00 00 00       	jmp    8027e0 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802747:	a1 50 50 98 00       	mov    0x985050,%eax
  80274c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802753:	74 07                	je     80275c <insert_sorted_in_freeList+0x10d>
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 00                	mov    (%eax),%eax
  80275a:	eb 05                	jmp    802761 <insert_sorted_in_freeList+0x112>
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
  802761:	a3 50 50 98 00       	mov    %eax,0x985050
  802766:	a1 50 50 98 00       	mov    0x985050,%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	0f 85 5d ff ff ff    	jne    8026d0 <insert_sorted_in_freeList+0x81>
  802773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802777:	0f 85 53 ff ff ff    	jne    8026d0 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80277d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802781:	75 17                	jne    80279a <insert_sorted_in_freeList+0x14b>
  802783:	83 ec 04             	sub    $0x4,%esp
  802786:	68 68 44 80 00       	push   $0x804468
  80278b:	68 ab 00 00 00       	push   $0xab
  802790:	68 17 44 80 00       	push   $0x804417
  802795:	e8 14 10 00 00       	call   8037ae <_panic>
  80279a:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	89 50 04             	mov    %edx,0x4(%eax)
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 0c                	je     8027bc <insert_sorted_in_freeList+0x16d>
  8027b0:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8027b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b8:	89 10                	mov    %edx,(%eax)
  8027ba:	eb 08                	jmp    8027c4 <insert_sorted_in_freeList+0x175>
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	a3 48 50 98 00       	mov    %eax,0x985048
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d5:	a1 54 50 98 00       	mov    0x985054,%eax
  8027da:	40                   	inc    %eax
  8027db:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	83 e0 01             	and    $0x1,%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	74 03                	je     8027f5 <alloc_block_FF+0x13>
  8027f2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027f5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027f9:	77 07                	ja     802802 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027fb:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802802:	a1 40 50 98 00       	mov    0x985040,%eax
  802807:	85 c0                	test   %eax,%eax
  802809:	75 63                	jne    80286e <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	83 c0 10             	add    $0x10,%eax
  802811:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802814:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80281b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	01 d0                	add    %edx,%eax
  802823:	48                   	dec    %eax
  802824:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802827:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282a:	ba 00 00 00 00       	mov    $0x0,%edx
  80282f:	f7 75 ec             	divl   -0x14(%ebp)
  802832:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802835:	29 d0                	sub    %edx,%eax
  802837:	c1 e8 0c             	shr    $0xc,%eax
  80283a:	83 ec 0c             	sub    $0xc,%esp
  80283d:	50                   	push   %eax
  80283e:	e8 d1 ed ff ff       	call   801614 <sbrk>
  802843:	83 c4 10             	add    $0x10,%esp
  802846:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802849:	83 ec 0c             	sub    $0xc,%esp
  80284c:	6a 00                	push   $0x0
  80284e:	e8 c1 ed ff ff       	call   801614 <sbrk>
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802859:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80285f:	83 ec 08             	sub    $0x8,%esp
  802862:	50                   	push   %eax
  802863:	ff 75 e4             	pushl  -0x1c(%ebp)
  802866:	e8 75 fc ff ff       	call   8024e0 <initialize_dynamic_allocator>
  80286b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80286e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802872:	75 0a                	jne    80287e <alloc_block_FF+0x9c>
	{
		return NULL;
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
  802879:	e9 99 03 00 00       	jmp    802c17 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80287e:	8b 45 08             	mov    0x8(%ebp),%eax
  802881:	83 c0 08             	add    $0x8,%eax
  802884:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802887:	a1 48 50 98 00       	mov    0x985048,%eax
  80288c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288f:	e9 03 02 00 00       	jmp    802a97 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802894:	83 ec 0c             	sub    $0xc,%esp
  802897:	ff 75 f4             	pushl  -0xc(%ebp)
  80289a:	e8 dd fa ff ff       	call   80237c <get_block_size>
  80289f:	83 c4 10             	add    $0x10,%esp
  8028a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8028a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8028a8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8028ab:	0f 82 de 01 00 00    	jb     802a8f <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8028b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028b4:	83 c0 10             	add    $0x10,%eax
  8028b7:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8028ba:	0f 87 32 01 00 00    	ja     8029f2 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8028c0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8028c3:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8028c6:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8028c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028cf:	01 d0                	add    %edx,%eax
  8028d1:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8028d4:	83 ec 04             	sub    $0x4,%esp
  8028d7:	6a 00                	push   $0x0
  8028d9:	ff 75 98             	pushl  -0x68(%ebp)
  8028dc:	ff 75 94             	pushl  -0x6c(%ebp)
  8028df:	e8 14 fd ff ff       	call   8025f8 <set_block_data>
  8028e4:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8028e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028eb:	74 06                	je     8028f3 <alloc_block_FF+0x111>
  8028ed:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8028f1:	75 17                	jne    80290a <alloc_block_FF+0x128>
  8028f3:	83 ec 04             	sub    $0x4,%esp
  8028f6:	68 8c 44 80 00       	push   $0x80448c
  8028fb:	68 de 00 00 00       	push   $0xde
  802900:	68 17 44 80 00       	push   $0x804417
  802905:	e8 a4 0e 00 00       	call   8037ae <_panic>
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 10                	mov    (%eax),%edx
  80290f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802912:	89 10                	mov    %edx,(%eax)
  802914:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	74 0b                	je     802928 <alloc_block_FF+0x146>
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802925:	89 50 04             	mov    %edx,0x4(%eax)
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80292e:	89 10                	mov    %edx,(%eax)
  802930:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802933:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802936:	89 50 04             	mov    %edx,0x4(%eax)
  802939:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	75 08                	jne    80294a <alloc_block_FF+0x168>
  802942:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802945:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80294a:	a1 54 50 98 00       	mov    0x985054,%eax
  80294f:	40                   	inc    %eax
  802950:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802955:	83 ec 04             	sub    $0x4,%esp
  802958:	6a 01                	push   $0x1
  80295a:	ff 75 dc             	pushl  -0x24(%ebp)
  80295d:	ff 75 f4             	pushl  -0xc(%ebp)
  802960:	e8 93 fc ff ff       	call   8025f8 <set_block_data>
  802965:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296c:	75 17                	jne    802985 <alloc_block_FF+0x1a3>
  80296e:	83 ec 04             	sub    $0x4,%esp
  802971:	68 c0 44 80 00       	push   $0x8044c0
  802976:	68 e3 00 00 00       	push   $0xe3
  80297b:	68 17 44 80 00       	push   $0x804417
  802980:	e8 29 0e 00 00       	call   8037ae <_panic>
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	74 10                	je     80299e <alloc_block_FF+0x1bc>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802996:	8b 52 04             	mov    0x4(%edx),%edx
  802999:	89 50 04             	mov    %edx,0x4(%eax)
  80299c:	eb 0b                	jmp    8029a9 <alloc_block_FF+0x1c7>
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 40 04             	mov    0x4(%eax),%eax
  8029a4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 40 04             	mov    0x4(%eax),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	74 0f                	je     8029c2 <alloc_block_FF+0x1e0>
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 40 04             	mov    0x4(%eax),%eax
  8029b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bc:	8b 12                	mov    (%edx),%edx
  8029be:	89 10                	mov    %edx,(%eax)
  8029c0:	eb 0a                	jmp    8029cc <alloc_block_FF+0x1ea>
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 00                	mov    (%eax),%eax
  8029c7:	a3 48 50 98 00       	mov    %eax,0x985048
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029df:	a1 54 50 98 00       	mov    0x985054,%eax
  8029e4:	48                   	dec    %eax
  8029e5:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	e9 25 02 00 00       	jmp    802c17 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	6a 01                	push   $0x1
  8029f7:	ff 75 9c             	pushl  -0x64(%ebp)
  8029fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8029fd:	e8 f6 fb ff ff       	call   8025f8 <set_block_data>
  802a02:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a09:	75 17                	jne    802a22 <alloc_block_FF+0x240>
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	68 c0 44 80 00       	push   $0x8044c0
  802a13:	68 eb 00 00 00       	push   $0xeb
  802a18:	68 17 44 80 00       	push   $0x804417
  802a1d:	e8 8c 0d 00 00       	call   8037ae <_panic>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 10                	je     802a3b <alloc_block_FF+0x259>
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 00                	mov    (%eax),%eax
  802a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a33:	8b 52 04             	mov    0x4(%edx),%edx
  802a36:	89 50 04             	mov    %edx,0x4(%eax)
  802a39:	eb 0b                	jmp    802a46 <alloc_block_FF+0x264>
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	85 c0                	test   %eax,%eax
  802a4e:	74 0f                	je     802a5f <alloc_block_FF+0x27d>
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 40 04             	mov    0x4(%eax),%eax
  802a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a59:	8b 12                	mov    (%edx),%edx
  802a5b:	89 10                	mov    %edx,(%eax)
  802a5d:	eb 0a                	jmp    802a69 <alloc_block_FF+0x287>
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	a3 48 50 98 00       	mov    %eax,0x985048
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7c:	a1 54 50 98 00       	mov    0x985054,%eax
  802a81:	48                   	dec    %eax
  802a82:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	e9 88 01 00 00       	jmp    802c17 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a8f:	a1 50 50 98 00       	mov    0x985050,%eax
  802a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9b:	74 07                	je     802aa4 <alloc_block_FF+0x2c2>
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 00                	mov    (%eax),%eax
  802aa2:	eb 05                	jmp    802aa9 <alloc_block_FF+0x2c7>
  802aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa9:	a3 50 50 98 00       	mov    %eax,0x985050
  802aae:	a1 50 50 98 00       	mov    0x985050,%eax
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	0f 85 d9 fd ff ff    	jne    802894 <alloc_block_FF+0xb2>
  802abb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abf:	0f 85 cf fd ff ff    	jne    802894 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802ac5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802acc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802acf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ad2:	01 d0                	add    %edx,%eax
  802ad4:	48                   	dec    %eax
  802ad5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ad8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802adb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae0:	f7 75 d8             	divl   -0x28(%ebp)
  802ae3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ae6:	29 d0                	sub    %edx,%eax
  802ae8:	c1 e8 0c             	shr    $0xc,%eax
  802aeb:	83 ec 0c             	sub    $0xc,%esp
  802aee:	50                   	push   %eax
  802aef:	e8 20 eb ff ff       	call   801614 <sbrk>
  802af4:	83 c4 10             	add    $0x10,%esp
  802af7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802afa:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802afe:	75 0a                	jne    802b0a <alloc_block_FF+0x328>
		return NULL;
  802b00:	b8 00 00 00 00       	mov    $0x0,%eax
  802b05:	e9 0d 01 00 00       	jmp    802c17 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802b0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b0d:	83 e8 04             	sub    $0x4,%eax
  802b10:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802b13:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802b1a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b20:	01 d0                	add    %edx,%eax
  802b22:	48                   	dec    %eax
  802b23:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802b26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b29:	ba 00 00 00 00       	mov    $0x0,%edx
  802b2e:	f7 75 c8             	divl   -0x38(%ebp)
  802b31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b34:	29 d0                	sub    %edx,%eax
  802b36:	c1 e8 02             	shr    $0x2,%eax
  802b39:	c1 e0 02             	shl    $0x2,%eax
  802b3c:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802b3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b42:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802b48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b4b:	83 e8 08             	sub    $0x8,%eax
  802b4e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802b51:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	83 e0 fe             	and    $0xfffffffe,%eax
  802b59:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802b5c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b5f:	f7 d8                	neg    %eax
  802b61:	89 c2                	mov    %eax,%edx
  802b63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b66:	01 d0                	add    %edx,%eax
  802b68:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802b6b:	83 ec 0c             	sub    $0xc,%esp
  802b6e:	ff 75 b8             	pushl  -0x48(%ebp)
  802b71:	e8 1f f8 ff ff       	call   802395 <is_free_block>
  802b76:	83 c4 10             	add    $0x10,%esp
  802b79:	0f be c0             	movsbl %al,%eax
  802b7c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802b7f:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802b83:	74 42                	je     802bc7 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802b85:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b8f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b92:	01 d0                	add    %edx,%eax
  802b94:	48                   	dec    %eax
  802b95:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b98:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba0:	f7 75 b0             	divl   -0x50(%ebp)
  802ba3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ba6:	29 d0                	sub    %edx,%eax
  802ba8:	89 c2                	mov    %eax,%edx
  802baa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bad:	01 d0                	add    %edx,%eax
  802baf:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	6a 00                	push   $0x0
  802bb7:	ff 75 a8             	pushl  -0x58(%ebp)
  802bba:	ff 75 b8             	pushl  -0x48(%ebp)
  802bbd:	e8 36 fa ff ff       	call   8025f8 <set_block_data>
  802bc2:	83 c4 10             	add    $0x10,%esp
  802bc5:	eb 42                	jmp    802c09 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802bc7:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802bce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bd1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802bd4:	01 d0                	add    %edx,%eax
  802bd6:	48                   	dec    %eax
  802bd7:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802bda:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  802be2:	f7 75 a4             	divl   -0x5c(%ebp)
  802be5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802be8:	29 d0                	sub    %edx,%eax
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	6a 00                	push   $0x0
  802bef:	50                   	push   %eax
  802bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  802bf3:	e8 00 fa ff ff       	call   8025f8 <set_block_data>
  802bf8:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802bfb:	83 ec 0c             	sub    $0xc,%esp
  802bfe:	ff 75 d0             	pushl  -0x30(%ebp)
  802c01:	e8 49 fa ff ff       	call   80264f <insert_sorted_in_freeList>
  802c06:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802c09:	83 ec 0c             	sub    $0xc,%esp
  802c0c:	ff 75 08             	pushl  0x8(%ebp)
  802c0f:	e8 ce fb ff ff       	call   8027e2 <alloc_block_FF>
  802c14:	83 c4 10             	add    $0x10,%esp
}
  802c17:	c9                   	leave  
  802c18:	c3                   	ret    

00802c19 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c19:	55                   	push   %ebp
  802c1a:	89 e5                	mov    %esp,%ebp
  802c1c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c23:	75 0a                	jne    802c2f <alloc_block_BF+0x16>
	{
		return NULL;
  802c25:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2a:	e9 7a 02 00 00       	jmp    802ea9 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	83 c0 08             	add    $0x8,%eax
  802c35:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802c3f:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c46:	a1 48 50 98 00       	mov    0x985048,%eax
  802c4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c4e:	eb 32                	jmp    802c82 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802c50:	ff 75 ec             	pushl  -0x14(%ebp)
  802c53:	e8 24 f7 ff ff       	call   80237c <get_block_size>
  802c58:	83 c4 04             	add    $0x4,%esp
  802c5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c61:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c64:	72 14                	jb     802c7a <alloc_block_BF+0x61>
  802c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c6c:	73 0c                	jae    802c7a <alloc_block_BF+0x61>
		{
			minBlk = block;
  802c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c7a:	a1 50 50 98 00       	mov    0x985050,%eax
  802c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c86:	74 07                	je     802c8f <alloc_block_BF+0x76>
  802c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	eb 05                	jmp    802c94 <alloc_block_BF+0x7b>
  802c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c94:	a3 50 50 98 00       	mov    %eax,0x985050
  802c99:	a1 50 50 98 00       	mov    0x985050,%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	75 ae                	jne    802c50 <alloc_block_BF+0x37>
  802ca2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ca6:	75 a8                	jne    802c50 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cac:	75 22                	jne    802cd0 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802cae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb1:	83 ec 0c             	sub    $0xc,%esp
  802cb4:	50                   	push   %eax
  802cb5:	e8 5a e9 ff ff       	call   801614 <sbrk>
  802cba:	83 c4 10             	add    $0x10,%esp
  802cbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802cc0:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802cc4:	75 0a                	jne    802cd0 <alloc_block_BF+0xb7>
			return NULL;
  802cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccb:	e9 d9 01 00 00       	jmp    802ea9 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802cd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd3:	83 c0 10             	add    $0x10,%eax
  802cd6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cd9:	0f 87 32 01 00 00    	ja     802e11 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ce5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802ce8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cee:	01 d0                	add    %edx,%eax
  802cf0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	6a 00                	push   $0x0
  802cf8:	ff 75 dc             	pushl  -0x24(%ebp)
  802cfb:	ff 75 d8             	pushl  -0x28(%ebp)
  802cfe:	e8 f5 f8 ff ff       	call   8025f8 <set_block_data>
  802d03:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0a:	74 06                	je     802d12 <alloc_block_BF+0xf9>
  802d0c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802d10:	75 17                	jne    802d29 <alloc_block_BF+0x110>
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	68 8c 44 80 00       	push   $0x80448c
  802d1a:	68 49 01 00 00       	push   $0x149
  802d1f:	68 17 44 80 00       	push   $0x804417
  802d24:	e8 85 0a 00 00       	call   8037ae <_panic>
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 10                	mov    (%eax),%edx
  802d2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	74 0b                	je     802d47 <alloc_block_BF+0x12e>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d4d:	89 10                	mov    %edx,(%eax)
  802d4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%eax)
  802d58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	75 08                	jne    802d69 <alloc_block_BF+0x150>
  802d61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d64:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d69:	a1 54 50 98 00       	mov    0x985054,%eax
  802d6e:	40                   	inc    %eax
  802d6f:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802d74:	83 ec 04             	sub    $0x4,%esp
  802d77:	6a 01                	push   $0x1
  802d79:	ff 75 e8             	pushl  -0x18(%ebp)
  802d7c:	ff 75 f4             	pushl  -0xc(%ebp)
  802d7f:	e8 74 f8 ff ff       	call   8025f8 <set_block_data>
  802d84:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8b:	75 17                	jne    802da4 <alloc_block_BF+0x18b>
  802d8d:	83 ec 04             	sub    $0x4,%esp
  802d90:	68 c0 44 80 00       	push   $0x8044c0
  802d95:	68 4e 01 00 00       	push   $0x14e
  802d9a:	68 17 44 80 00       	push   $0x804417
  802d9f:	e8 0a 0a 00 00       	call   8037ae <_panic>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	74 10                	je     802dbd <alloc_block_BF+0x1a4>
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db5:	8b 52 04             	mov    0x4(%edx),%edx
  802db8:	89 50 04             	mov    %edx,0x4(%eax)
  802dbb:	eb 0b                	jmp    802dc8 <alloc_block_BF+0x1af>
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 40 04             	mov    0x4(%eax),%eax
  802dc3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 40 04             	mov    0x4(%eax),%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	74 0f                	je     802de1 <alloc_block_BF+0x1c8>
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 40 04             	mov    0x4(%eax),%eax
  802dd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddb:	8b 12                	mov    (%edx),%edx
  802ddd:	89 10                	mov    %edx,(%eax)
  802ddf:	eb 0a                	jmp    802deb <alloc_block_BF+0x1d2>
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	a3 48 50 98 00       	mov    %eax,0x985048
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfe:	a1 54 50 98 00       	mov    0x985054,%eax
  802e03:	48                   	dec    %eax
  802e04:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	e9 98 00 00 00       	jmp    802ea9 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802e11:	83 ec 04             	sub    $0x4,%esp
  802e14:	6a 01                	push   $0x1
  802e16:	ff 75 f0             	pushl  -0x10(%ebp)
  802e19:	ff 75 f4             	pushl  -0xc(%ebp)
  802e1c:	e8 d7 f7 ff ff       	call   8025f8 <set_block_data>
  802e21:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e28:	75 17                	jne    802e41 <alloc_block_BF+0x228>
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	68 c0 44 80 00       	push   $0x8044c0
  802e32:	68 56 01 00 00       	push   $0x156
  802e37:	68 17 44 80 00       	push   $0x804417
  802e3c:	e8 6d 09 00 00       	call   8037ae <_panic>
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 10                	je     802e5a <alloc_block_BF+0x241>
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e52:	8b 52 04             	mov    0x4(%edx),%edx
  802e55:	89 50 04             	mov    %edx,0x4(%eax)
  802e58:	eb 0b                	jmp    802e65 <alloc_block_BF+0x24c>
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 40 04             	mov    0x4(%eax),%eax
  802e60:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	74 0f                	je     802e7e <alloc_block_BF+0x265>
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e78:	8b 12                	mov    (%edx),%edx
  802e7a:	89 10                	mov    %edx,(%eax)
  802e7c:	eb 0a                	jmp    802e88 <alloc_block_BF+0x26f>
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	a3 48 50 98 00       	mov    %eax,0x985048
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9b:	a1 54 50 98 00       	mov    0x985054,%eax
  802ea0:	48                   	dec    %eax
  802ea1:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802ea9:	c9                   	leave  
  802eaa:	c3                   	ret    

00802eab <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802eab:	55                   	push   %ebp
  802eac:	89 e5                	mov    %esp,%ebp
  802eae:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802eb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb5:	0f 84 6a 02 00 00    	je     803125 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802ebb:	ff 75 08             	pushl  0x8(%ebp)
  802ebe:	e8 b9 f4 ff ff       	call   80237c <get_block_size>
  802ec3:	83 c4 04             	add    $0x4,%esp
  802ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	83 e8 08             	sub    $0x8,%eax
  802ecf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed5:	8b 00                	mov    (%eax),%eax
  802ed7:	83 e0 fe             	and    $0xfffffffe,%eax
  802eda:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee0:	f7 d8                	neg    %eax
  802ee2:	89 c2                	mov    %eax,%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	01 d0                	add    %edx,%eax
  802ee9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802eec:	ff 75 e8             	pushl  -0x18(%ebp)
  802eef:	e8 a1 f4 ff ff       	call   802395 <is_free_block>
  802ef4:	83 c4 04             	add    $0x4,%esp
  802ef7:	0f be c0             	movsbl %al,%eax
  802efa:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802efd:	8b 55 08             	mov    0x8(%ebp),%edx
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	01 d0                	add    %edx,%eax
  802f05:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802f08:	ff 75 e0             	pushl  -0x20(%ebp)
  802f0b:	e8 85 f4 ff ff       	call   802395 <is_free_block>
  802f10:	83 c4 04             	add    $0x4,%esp
  802f13:	0f be c0             	movsbl %al,%eax
  802f16:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802f19:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802f1d:	75 34                	jne    802f53 <free_block+0xa8>
  802f1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f23:	75 2e                	jne    802f53 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802f25:	ff 75 e8             	pushl  -0x18(%ebp)
  802f28:	e8 4f f4 ff ff       	call   80237c <get_block_size>
  802f2d:	83 c4 04             	add    $0x4,%esp
  802f30:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f36:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f39:	01 d0                	add    %edx,%eax
  802f3b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802f3e:	6a 00                	push   $0x0
  802f40:	ff 75 d4             	pushl  -0x2c(%ebp)
  802f43:	ff 75 e8             	pushl  -0x18(%ebp)
  802f46:	e8 ad f6 ff ff       	call   8025f8 <set_block_data>
  802f4b:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802f4e:	e9 d3 01 00 00       	jmp    803126 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802f53:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802f57:	0f 85 c8 00 00 00    	jne    803025 <free_block+0x17a>
  802f5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f61:	0f 85 be 00 00 00    	jne    803025 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802f67:	ff 75 e0             	pushl  -0x20(%ebp)
  802f6a:	e8 0d f4 ff ff       	call   80237c <get_block_size>
  802f6f:	83 c4 04             	add    $0x4,%esp
  802f72:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f7b:	01 d0                	add    %edx,%eax
  802f7d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802f80:	6a 00                	push   $0x0
  802f82:	ff 75 cc             	pushl  -0x34(%ebp)
  802f85:	ff 75 08             	pushl  0x8(%ebp)
  802f88:	e8 6b f6 ff ff       	call   8025f8 <set_block_data>
  802f8d:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802f90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f94:	75 17                	jne    802fad <free_block+0x102>
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	68 c0 44 80 00       	push   $0x8044c0
  802f9e:	68 87 01 00 00       	push   $0x187
  802fa3:	68 17 44 80 00       	push   $0x804417
  802fa8:	e8 01 08 00 00       	call   8037ae <_panic>
  802fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 10                	je     802fc6 <free_block+0x11b>
  802fb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fbe:	8b 52 04             	mov    0x4(%edx),%edx
  802fc1:	89 50 04             	mov    %edx,0x4(%eax)
  802fc4:	eb 0b                	jmp    802fd1 <free_block+0x126>
  802fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc9:	8b 40 04             	mov    0x4(%eax),%eax
  802fcc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	74 0f                	je     802fea <free_block+0x13f>
  802fdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fde:	8b 40 04             	mov    0x4(%eax),%eax
  802fe1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fe4:	8b 12                	mov    (%edx),%edx
  802fe6:	89 10                	mov    %edx,(%eax)
  802fe8:	eb 0a                	jmp    802ff4 <free_block+0x149>
  802fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	a3 48 50 98 00       	mov    %eax,0x985048
  802ff4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803000:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803007:	a1 54 50 98 00       	mov    0x985054,%eax
  80300c:	48                   	dec    %eax
  80300d:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803012:	83 ec 0c             	sub    $0xc,%esp
  803015:	ff 75 08             	pushl  0x8(%ebp)
  803018:	e8 32 f6 ff ff       	call   80264f <insert_sorted_in_freeList>
  80301d:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803020:	e9 01 01 00 00       	jmp    803126 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  803025:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803029:	0f 85 d3 00 00 00    	jne    803102 <free_block+0x257>
  80302f:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803033:	0f 85 c9 00 00 00    	jne    803102 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803039:	83 ec 0c             	sub    $0xc,%esp
  80303c:	ff 75 e8             	pushl  -0x18(%ebp)
  80303f:	e8 38 f3 ff ff       	call   80237c <get_block_size>
  803044:	83 c4 10             	add    $0x10,%esp
  803047:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  80304a:	83 ec 0c             	sub    $0xc,%esp
  80304d:	ff 75 e0             	pushl  -0x20(%ebp)
  803050:	e8 27 f3 ff ff       	call   80237c <get_block_size>
  803055:	83 c4 10             	add    $0x10,%esp
  803058:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  80305b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803061:	01 c2                	add    %eax,%edx
  803063:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803066:	01 d0                	add    %edx,%eax
  803068:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	6a 00                	push   $0x0
  803070:	ff 75 c0             	pushl  -0x40(%ebp)
  803073:	ff 75 e8             	pushl  -0x18(%ebp)
  803076:	e8 7d f5 ff ff       	call   8025f8 <set_block_data>
  80307b:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  80307e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803082:	75 17                	jne    80309b <free_block+0x1f0>
  803084:	83 ec 04             	sub    $0x4,%esp
  803087:	68 c0 44 80 00       	push   $0x8044c0
  80308c:	68 94 01 00 00       	push   $0x194
  803091:	68 17 44 80 00       	push   $0x804417
  803096:	e8 13 07 00 00       	call   8037ae <_panic>
  80309b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 10                	je     8030b4 <free_block+0x209>
  8030a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ac:	8b 52 04             	mov    0x4(%edx),%edx
  8030af:	89 50 04             	mov    %edx,0x4(%eax)
  8030b2:	eb 0b                	jmp    8030bf <free_block+0x214>
  8030b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ba:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c2:	8b 40 04             	mov    0x4(%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 0f                	je     8030d8 <free_block+0x22d>
  8030c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030cc:	8b 40 04             	mov    0x4(%eax),%eax
  8030cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030d2:	8b 12                	mov    (%edx),%edx
  8030d4:	89 10                	mov    %edx,(%eax)
  8030d6:	eb 0a                	jmp    8030e2 <free_block+0x237>
  8030d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	a3 48 50 98 00       	mov    %eax,0x985048
  8030e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f5:	a1 54 50 98 00       	mov    0x985054,%eax
  8030fa:	48                   	dec    %eax
  8030fb:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803100:	eb 24                	jmp    803126 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	6a 00                	push   $0x0
  803107:	ff 75 f4             	pushl  -0xc(%ebp)
  80310a:	ff 75 08             	pushl  0x8(%ebp)
  80310d:	e8 e6 f4 ff ff       	call   8025f8 <set_block_data>
  803112:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803115:	83 ec 0c             	sub    $0xc,%esp
  803118:	ff 75 08             	pushl  0x8(%ebp)
  80311b:	e8 2f f5 ff ff       	call   80264f <insert_sorted_in_freeList>
  803120:	83 c4 10             	add    $0x10,%esp
  803123:	eb 01                	jmp    803126 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803125:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803126:	c9                   	leave  
  803127:	c3                   	ret    

00803128 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803128:	55                   	push   %ebp
  803129:	89 e5                	mov    %esp,%ebp
  80312b:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  80312e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803132:	75 10                	jne    803144 <realloc_block_FF+0x1c>
  803134:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803138:	75 0a                	jne    803144 <realloc_block_FF+0x1c>
	{
		return NULL;
  80313a:	b8 00 00 00 00       	mov    $0x0,%eax
  80313f:	e9 8b 04 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803144:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803148:	75 18                	jne    803162 <realloc_block_FF+0x3a>
	{
		free_block(va);
  80314a:	83 ec 0c             	sub    $0xc,%esp
  80314d:	ff 75 08             	pushl  0x8(%ebp)
  803150:	e8 56 fd ff ff       	call   802eab <free_block>
  803155:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803158:	b8 00 00 00 00       	mov    $0x0,%eax
  80315d:	e9 6d 04 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803166:	75 13                	jne    80317b <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803168:	83 ec 0c             	sub    $0xc,%esp
  80316b:	ff 75 0c             	pushl  0xc(%ebp)
  80316e:	e8 6f f6 ff ff       	call   8027e2 <alloc_block_FF>
  803173:	83 c4 10             	add    $0x10,%esp
  803176:	e9 54 04 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  80317b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317e:	83 e0 01             	and    $0x1,%eax
  803181:	85 c0                	test   %eax,%eax
  803183:	74 03                	je     803188 <realloc_block_FF+0x60>
	{
		new_size++;
  803185:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803188:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80318c:	77 07                	ja     803195 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80318e:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803195:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803199:	83 ec 0c             	sub    $0xc,%esp
  80319c:	ff 75 08             	pushl  0x8(%ebp)
  80319f:	e8 d8 f1 ff ff       	call   80237c <get_block_size>
  8031a4:	83 c4 10             	add    $0x10,%esp
  8031a7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031b0:	75 08                	jne    8031ba <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	e9 15 04 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8031ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	01 d0                	add    %edx,%eax
  8031c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8031c5:	83 ec 0c             	sub    $0xc,%esp
  8031c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8031cb:	e8 c5 f1 ff ff       	call   802395 <is_free_block>
  8031d0:	83 c4 10             	add    $0x10,%esp
  8031d3:	0f be c0             	movsbl %al,%eax
  8031d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8031d9:	83 ec 0c             	sub    $0xc,%esp
  8031dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8031df:	e8 98 f1 ff ff       	call   80237c <get_block_size>
  8031e4:	83 c4 10             	add    $0x10,%esp
  8031e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8031ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8031f0:	0f 86 a7 02 00 00    	jbe    80349d <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8031f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031fa:	0f 84 86 02 00 00    	je     803486 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803200:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	01 d0                	add    %edx,%eax
  803208:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80320b:	0f 85 b2 00 00 00    	jne    8032c3 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803211:	83 ec 0c             	sub    $0xc,%esp
  803214:	ff 75 08             	pushl  0x8(%ebp)
  803217:	e8 79 f1 ff ff       	call   802395 <is_free_block>
  80321c:	83 c4 10             	add    $0x10,%esp
  80321f:	84 c0                	test   %al,%al
  803221:	0f 94 c0             	sete   %al
  803224:	0f b6 c0             	movzbl %al,%eax
  803227:	83 ec 04             	sub    $0x4,%esp
  80322a:	50                   	push   %eax
  80322b:	ff 75 0c             	pushl  0xc(%ebp)
  80322e:	ff 75 08             	pushl  0x8(%ebp)
  803231:	e8 c2 f3 ff ff       	call   8025f8 <set_block_data>
  803236:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803239:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80323d:	75 17                	jne    803256 <realloc_block_FF+0x12e>
  80323f:	83 ec 04             	sub    $0x4,%esp
  803242:	68 c0 44 80 00       	push   $0x8044c0
  803247:	68 db 01 00 00       	push   $0x1db
  80324c:	68 17 44 80 00       	push   $0x804417
  803251:	e8 58 05 00 00       	call   8037ae <_panic>
  803256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 10                	je     80326f <realloc_block_FF+0x147>
  80325f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803267:	8b 52 04             	mov    0x4(%edx),%edx
  80326a:	89 50 04             	mov    %edx,0x4(%eax)
  80326d:	eb 0b                	jmp    80327a <realloc_block_FF+0x152>
  80326f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803272:	8b 40 04             	mov    0x4(%eax),%eax
  803275:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 0f                	je     803293 <realloc_block_FF+0x16b>
  803284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328d:	8b 12                	mov    (%edx),%edx
  80328f:	89 10                	mov    %edx,(%eax)
  803291:	eb 0a                	jmp    80329d <realloc_block_FF+0x175>
  803293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	a3 48 50 98 00       	mov    %eax,0x985048
  80329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b0:	a1 54 50 98 00       	mov    0x985054,%eax
  8032b5:	48                   	dec    %eax
  8032b6:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	e9 0c 03 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8032c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c9:	01 d0                	add    %edx,%eax
  8032cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032ce:	0f 86 b2 01 00 00    	jbe    803486 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8032d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d7:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8032da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8032dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8032e3:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8032e6:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8032ea:	0f 87 b8 00 00 00    	ja     8033a8 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8032f0:	83 ec 0c             	sub    $0xc,%esp
  8032f3:	ff 75 08             	pushl  0x8(%ebp)
  8032f6:	e8 9a f0 ff ff       	call   802395 <is_free_block>
  8032fb:	83 c4 10             	add    $0x10,%esp
  8032fe:	84 c0                	test   %al,%al
  803300:	0f 94 c0             	sete   %al
  803303:	0f b6 c0             	movzbl %al,%eax
  803306:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803309:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330c:	01 ca                	add    %ecx,%edx
  80330e:	83 ec 04             	sub    $0x4,%esp
  803311:	50                   	push   %eax
  803312:	52                   	push   %edx
  803313:	ff 75 08             	pushl  0x8(%ebp)
  803316:	e8 dd f2 ff ff       	call   8025f8 <set_block_data>
  80331b:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80331e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803322:	75 17                	jne    80333b <realloc_block_FF+0x213>
  803324:	83 ec 04             	sub    $0x4,%esp
  803327:	68 c0 44 80 00       	push   $0x8044c0
  80332c:	68 e8 01 00 00       	push   $0x1e8
  803331:	68 17 44 80 00       	push   $0x804417
  803336:	e8 73 04 00 00       	call   8037ae <_panic>
  80333b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 10                	je     803354 <realloc_block_FF+0x22c>
  803344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334c:	8b 52 04             	mov    0x4(%edx),%edx
  80334f:	89 50 04             	mov    %edx,0x4(%eax)
  803352:	eb 0b                	jmp    80335f <realloc_block_FF+0x237>
  803354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80335f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 0f                	je     803378 <realloc_block_FF+0x250>
  803369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336c:	8b 40 04             	mov    0x4(%eax),%eax
  80336f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803372:	8b 12                	mov    (%edx),%edx
  803374:	89 10                	mov    %edx,(%eax)
  803376:	eb 0a                	jmp    803382 <realloc_block_FF+0x25a>
  803378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337b:	8b 00                	mov    (%eax),%eax
  80337d:	a3 48 50 98 00       	mov    %eax,0x985048
  803382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803395:	a1 54 50 98 00       	mov    0x985054,%eax
  80339a:	48                   	dec    %eax
  80339b:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	e9 27 02 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8033a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ac:	75 17                	jne    8033c5 <realloc_block_FF+0x29d>
  8033ae:	83 ec 04             	sub    $0x4,%esp
  8033b1:	68 c0 44 80 00       	push   $0x8044c0
  8033b6:	68 ed 01 00 00       	push   $0x1ed
  8033bb:	68 17 44 80 00       	push   $0x804417
  8033c0:	e8 e9 03 00 00       	call   8037ae <_panic>
  8033c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c8:	8b 00                	mov    (%eax),%eax
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	74 10                	je     8033de <realloc_block_FF+0x2b6>
  8033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d1:	8b 00                	mov    (%eax),%eax
  8033d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d6:	8b 52 04             	mov    0x4(%edx),%edx
  8033d9:	89 50 04             	mov    %edx,0x4(%eax)
  8033dc:	eb 0b                	jmp    8033e9 <realloc_block_FF+0x2c1>
  8033de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e1:	8b 40 04             	mov    0x4(%eax),%eax
  8033e4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ec:	8b 40 04             	mov    0x4(%eax),%eax
  8033ef:	85 c0                	test   %eax,%eax
  8033f1:	74 0f                	je     803402 <realloc_block_FF+0x2da>
  8033f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f6:	8b 40 04             	mov    0x4(%eax),%eax
  8033f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033fc:	8b 12                	mov    (%edx),%edx
  8033fe:	89 10                	mov    %edx,(%eax)
  803400:	eb 0a                	jmp    80340c <realloc_block_FF+0x2e4>
  803402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	a3 48 50 98 00       	mov    %eax,0x985048
  80340c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803418:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341f:	a1 54 50 98 00       	mov    0x985054,%eax
  803424:	48                   	dec    %eax
  803425:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  80342a:	8b 55 08             	mov    0x8(%ebp),%edx
  80342d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803430:	01 d0                	add    %edx,%eax
  803432:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803435:	83 ec 04             	sub    $0x4,%esp
  803438:	6a 00                	push   $0x0
  80343a:	ff 75 e0             	pushl  -0x20(%ebp)
  80343d:	ff 75 f0             	pushl  -0x10(%ebp)
  803440:	e8 b3 f1 ff ff       	call   8025f8 <set_block_data>
  803445:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803448:	83 ec 0c             	sub    $0xc,%esp
  80344b:	ff 75 08             	pushl  0x8(%ebp)
  80344e:	e8 42 ef ff ff       	call   802395 <is_free_block>
  803453:	83 c4 10             	add    $0x10,%esp
  803456:	84 c0                	test   %al,%al
  803458:	0f 94 c0             	sete   %al
  80345b:	0f b6 c0             	movzbl %al,%eax
  80345e:	83 ec 04             	sub    $0x4,%esp
  803461:	50                   	push   %eax
  803462:	ff 75 0c             	pushl  0xc(%ebp)
  803465:	ff 75 08             	pushl  0x8(%ebp)
  803468:	e8 8b f1 ff ff       	call   8025f8 <set_block_data>
  80346d:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803470:	83 ec 0c             	sub    $0xc,%esp
  803473:	ff 75 f0             	pushl  -0x10(%ebp)
  803476:	e8 d4 f1 ff ff       	call   80264f <insert_sorted_in_freeList>
  80347b:	83 c4 10             	add    $0x10,%esp
					return va;
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	e9 49 01 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803486:	8b 45 0c             	mov    0xc(%ebp),%eax
  803489:	83 e8 08             	sub    $0x8,%eax
  80348c:	83 ec 0c             	sub    $0xc,%esp
  80348f:	50                   	push   %eax
  803490:	e8 4d f3 ff ff       	call   8027e2 <alloc_block_FF>
  803495:	83 c4 10             	add    $0x10,%esp
  803498:	e9 32 01 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80349d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8034a3:	0f 83 21 01 00 00    	jae    8035ca <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ac:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034af:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8034b2:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8034b6:	77 0e                	ja     8034c6 <realloc_block_FF+0x39e>
  8034b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034bc:	75 08                	jne    8034c6 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	e9 09 01 00 00       	jmp    8035cf <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8034cc:	83 ec 0c             	sub    $0xc,%esp
  8034cf:	ff 75 08             	pushl  0x8(%ebp)
  8034d2:	e8 be ee ff ff       	call   802395 <is_free_block>
  8034d7:	83 c4 10             	add    $0x10,%esp
  8034da:	84 c0                	test   %al,%al
  8034dc:	0f 94 c0             	sete   %al
  8034df:	0f b6 c0             	movzbl %al,%eax
  8034e2:	83 ec 04             	sub    $0x4,%esp
  8034e5:	50                   	push   %eax
  8034e6:	ff 75 0c             	pushl  0xc(%ebp)
  8034e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8034ec:	e8 07 f1 ff ff       	call   8025f8 <set_block_data>
  8034f1:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8034f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	6a 00                	push   $0x0
  803504:	ff 75 dc             	pushl  -0x24(%ebp)
  803507:	ff 75 d4             	pushl  -0x2c(%ebp)
  80350a:	e8 e9 f0 ff ff       	call   8025f8 <set_block_data>
  80350f:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803512:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803516:	0f 84 9b 00 00 00    	je     8035b7 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  80351c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80351f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803522:	01 d0                	add    %edx,%eax
  803524:	83 ec 04             	sub    $0x4,%esp
  803527:	6a 00                	push   $0x0
  803529:	50                   	push   %eax
  80352a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80352d:	e8 c6 f0 ff ff       	call   8025f8 <set_block_data>
  803532:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803535:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803539:	75 17                	jne    803552 <realloc_block_FF+0x42a>
  80353b:	83 ec 04             	sub    $0x4,%esp
  80353e:	68 c0 44 80 00       	push   $0x8044c0
  803543:	68 10 02 00 00       	push   $0x210
  803548:	68 17 44 80 00       	push   $0x804417
  80354d:	e8 5c 02 00 00       	call   8037ae <_panic>
  803552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803555:	8b 00                	mov    (%eax),%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	74 10                	je     80356b <realloc_block_FF+0x443>
  80355b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803563:	8b 52 04             	mov    0x4(%edx),%edx
  803566:	89 50 04             	mov    %edx,0x4(%eax)
  803569:	eb 0b                	jmp    803576 <realloc_block_FF+0x44e>
  80356b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356e:	8b 40 04             	mov    0x4(%eax),%eax
  803571:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803579:	8b 40 04             	mov    0x4(%eax),%eax
  80357c:	85 c0                	test   %eax,%eax
  80357e:	74 0f                	je     80358f <realloc_block_FF+0x467>
  803580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803583:	8b 40 04             	mov    0x4(%eax),%eax
  803586:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803589:	8b 12                	mov    (%edx),%edx
  80358b:	89 10                	mov    %edx,(%eax)
  80358d:	eb 0a                	jmp    803599 <realloc_block_FF+0x471>
  80358f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803592:	8b 00                	mov    (%eax),%eax
  803594:	a3 48 50 98 00       	mov    %eax,0x985048
  803599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ac:	a1 54 50 98 00       	mov    0x985054,%eax
  8035b1:	48                   	dec    %eax
  8035b2:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8035b7:	83 ec 0c             	sub    $0xc,%esp
  8035ba:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035bd:	e8 8d f0 ff ff       	call   80264f <insert_sorted_in_freeList>
  8035c2:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8035c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035c8:	eb 05                	jmp    8035cf <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8035ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035cf:	c9                   	leave  
  8035d0:	c3                   	ret    

008035d1 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8035d1:	55                   	push   %ebp
  8035d2:	89 e5                	mov    %esp,%ebp
  8035d4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8035d7:	83 ec 04             	sub    $0x4,%esp
  8035da:	68 e0 44 80 00       	push   $0x8044e0
  8035df:	68 20 02 00 00       	push   $0x220
  8035e4:	68 17 44 80 00       	push   $0x804417
  8035e9:	e8 c0 01 00 00       	call   8037ae <_panic>

008035ee <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8035ee:	55                   	push   %ebp
  8035ef:	89 e5                	mov    %esp,%ebp
  8035f1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8035f4:	83 ec 04             	sub    $0x4,%esp
  8035f7:	68 08 45 80 00       	push   $0x804508
  8035fc:	68 28 02 00 00       	push   $0x228
  803601:	68 17 44 80 00       	push   $0x804417
  803606:	e8 a3 01 00 00       	call   8037ae <_panic>

0080360b <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80360b:	55                   	push   %ebp
  80360c:	89 e5                	mov    %esp,%ebp
  80360e:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  803611:	83 ec 04             	sub    $0x4,%esp
  803614:	6a 01                	push   $0x1
  803616:	6a 58                	push   $0x58
  803618:	ff 75 0c             	pushl  0xc(%ebp)
  80361b:	e8 c1 e2 ff ff       	call   8018e1 <smalloc>
  803620:	83 c4 10             	add    $0x10,%esp
  803623:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362a:	75 14                	jne    803640 <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  80362c:	83 ec 04             	sub    $0x4,%esp
  80362f:	68 30 45 80 00       	push   $0x804530
  803634:	6a 10                	push   $0x10
  803636:	68 5e 45 80 00       	push   $0x80455e
  80363b:	e8 6e 01 00 00       	call   8037ae <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  803640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803643:	83 ec 0c             	sub    $0xc,%esp
  803646:	50                   	push   %eax
  803647:	e8 bc ec ff ff       	call   802308 <sys_init_queue>
  80364c:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  80364f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803652:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  803659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365c:	83 c0 18             	add    $0x18,%eax
  80365f:	83 ec 04             	sub    $0x4,%esp
  803662:	6a 40                	push   $0x40
  803664:	ff 75 0c             	pushl  0xc(%ebp)
  803667:	50                   	push   %eax
  803668:	e8 1e d9 ff ff       	call   800f8b <strncpy>
  80366d:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  803670:	8b 55 10             	mov    0x10(%ebp),%edx
  803673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803676:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  80367f:	8b 45 08             	mov    0x8(%ebp),%eax
  803682:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803685:	89 10                	mov    %edx,(%eax)
}
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	c9                   	leave  
  80368b:	c2 04 00             	ret    $0x4

0080368e <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80368e:	55                   	push   %ebp
  80368f:	89 e5                	mov    %esp,%ebp
  803691:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  803694:	83 ec 08             	sub    $0x8,%esp
  803697:	ff 75 10             	pushl  0x10(%ebp)
  80369a:	ff 75 0c             	pushl  0xc(%ebp)
  80369d:	e8 da e3 ff ff       	call   801a7c <sget>
  8036a2:	83 c4 10             	add    $0x10,%esp
  8036a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8036a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ac:	75 14                	jne    8036c2 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 70 45 80 00       	push   $0x804570
  8036b6:	6a 2c                	push   $0x2c
  8036b8:	68 5e 45 80 00       	push   $0x80455e
  8036bd:	e8 ec 00 00 00       	call   8037ae <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ce:	89 10                	mov    %edx,(%eax)
}
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	c9                   	leave  
  8036d4:	c2 04 00             	ret    $0x4

008036d7 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  8036d7:	55                   	push   %ebp
  8036d8:	89 e5                	mov    %esp,%ebp
  8036da:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  8036dd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	8b 40 14             	mov    0x14(%eax),%eax
  8036ea:	8d 55 e8             	lea    -0x18(%ebp),%edx
  8036ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8036f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8036f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8036fc:	f0 87 02             	lock xchg %eax,(%edx)
  8036ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803705:	85 c0                	test   %eax,%eax
  803707:	75 db                	jne    8036e4 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	8b 50 10             	mov    0x10(%eax),%edx
  80370f:	4a                   	dec    %edx
  803710:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  803713:	8b 45 08             	mov    0x8(%ebp),%eax
  803716:	8b 40 10             	mov    0x10(%eax),%eax
  803719:	85 c0                	test   %eax,%eax
  80371b:	79 18                	jns    803735 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	8d 50 14             	lea    0x14(%eax),%edx
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	83 ec 08             	sub    $0x8,%esp
  803729:	52                   	push   %edx
  80372a:	50                   	push   %eax
  80372b:	e8 f4 eb ff ff       	call   802324 <sys_block_process>
  803730:	83 c4 10             	add    $0x10,%esp
  803733:	eb 0a                	jmp    80373f <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  80373f:	c9                   	leave  
  803740:	c3                   	ret    

00803741 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803741:	55                   	push   %ebp
  803742:	89 e5                	mov    %esp,%ebp
  803744:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803747:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	8b 40 14             	mov    0x14(%eax),%eax
  803754:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803757:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80375a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80375d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803763:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803766:	f0 87 02             	lock xchg %eax,(%edx)
  803769:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  80376c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376f:	85 c0                	test   %eax,%eax
  803771:	75 db                	jne    80374e <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	8b 50 10             	mov    0x10(%eax),%edx
  803779:	42                   	inc    %edx
  80377a:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  80377d:	8b 45 08             	mov    0x8(%ebp),%eax
  803780:	8b 40 10             	mov    0x10(%eax),%eax
  803783:	85 c0                	test   %eax,%eax
  803785:	7f 0f                	jg     803796 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  803787:	8b 45 08             	mov    0x8(%ebp),%eax
  80378a:	83 ec 0c             	sub    $0xc,%esp
  80378d:	50                   	push   %eax
  80378e:	e8 af eb ff ff       	call   802342 <sys_unblock_process>
  803793:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8037a0:	90                   	nop
  8037a1:	c9                   	leave  
  8037a2:	c3                   	ret    

008037a3 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  8037a3:	55                   	push   %ebp
  8037a4:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	8b 40 10             	mov    0x10(%eax),%eax
}
  8037ac:	5d                   	pop    %ebp
  8037ad:	c3                   	ret    

008037ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8037ae:	55                   	push   %ebp
  8037af:	89 e5                	mov    %esp,%ebp
  8037b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8037b7:	83 c0 04             	add    $0x4,%eax
  8037ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8037bd:	a1 60 50 98 00       	mov    0x985060,%eax
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	74 16                	je     8037dc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8037c6:	a1 60 50 98 00       	mov    0x985060,%eax
  8037cb:	83 ec 08             	sub    $0x8,%esp
  8037ce:	50                   	push   %eax
  8037cf:	68 94 45 80 00       	push   $0x804594
  8037d4:	e8 a1 d0 ff ff       	call   80087a <cprintf>
  8037d9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8037dc:	a1 04 50 80 00       	mov    0x805004,%eax
  8037e1:	ff 75 0c             	pushl  0xc(%ebp)
  8037e4:	ff 75 08             	pushl  0x8(%ebp)
  8037e7:	50                   	push   %eax
  8037e8:	68 99 45 80 00       	push   $0x804599
  8037ed:	e8 88 d0 ff ff       	call   80087a <cprintf>
  8037f2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8037f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8037f8:	83 ec 08             	sub    $0x8,%esp
  8037fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8037fe:	50                   	push   %eax
  8037ff:	e8 0b d0 ff ff       	call   80080f <vcprintf>
  803804:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803807:	83 ec 08             	sub    $0x8,%esp
  80380a:	6a 00                	push   $0x0
  80380c:	68 b5 45 80 00       	push   $0x8045b5
  803811:	e8 f9 cf ff ff       	call   80080f <vcprintf>
  803816:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803819:	e8 7a cf ff ff       	call   800798 <exit>

	// should not return here
	while (1) ;
  80381e:	eb fe                	jmp    80381e <_panic+0x70>

00803820 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803820:	55                   	push   %ebp
  803821:	89 e5                	mov    %esp,%ebp
  803823:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803826:	a1 20 50 80 00       	mov    0x805020,%eax
  80382b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803831:	8b 45 0c             	mov    0xc(%ebp),%eax
  803834:	39 c2                	cmp    %eax,%edx
  803836:	74 14                	je     80384c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803838:	83 ec 04             	sub    $0x4,%esp
  80383b:	68 b8 45 80 00       	push   $0x8045b8
  803840:	6a 26                	push   $0x26
  803842:	68 04 46 80 00       	push   $0x804604
  803847:	e8 62 ff ff ff       	call   8037ae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80384c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803853:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80385a:	e9 c5 00 00 00       	jmp    803924 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80385f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803862:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	01 d0                	add    %edx,%eax
  80386e:	8b 00                	mov    (%eax),%eax
  803870:	85 c0                	test   %eax,%eax
  803872:	75 08                	jne    80387c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803874:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803877:	e9 a5 00 00 00       	jmp    803921 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80387c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803883:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80388a:	eb 69                	jmp    8038f5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80388c:	a1 20 50 80 00       	mov    0x805020,%eax
  803891:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80389a:	89 d0                	mov    %edx,%eax
  80389c:	01 c0                	add    %eax,%eax
  80389e:	01 d0                	add    %edx,%eax
  8038a0:	c1 e0 03             	shl    $0x3,%eax
  8038a3:	01 c8                	add    %ecx,%eax
  8038a5:	8a 40 04             	mov    0x4(%eax),%al
  8038a8:	84 c0                	test   %al,%al
  8038aa:	75 46                	jne    8038f2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8038b1:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8038b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038ba:	89 d0                	mov    %edx,%eax
  8038bc:	01 c0                	add    %eax,%eax
  8038be:	01 d0                	add    %edx,%eax
  8038c0:	c1 e0 03             	shl    $0x3,%eax
  8038c3:	01 c8                	add    %ecx,%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8038ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8038d2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8038d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8038de:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e1:	01 c8                	add    %ecx,%eax
  8038e3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038e5:	39 c2                	cmp    %eax,%edx
  8038e7:	75 09                	jne    8038f2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8038e9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8038f0:	eb 15                	jmp    803907 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038f2:	ff 45 e8             	incl   -0x18(%ebp)
  8038f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8038fa:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803900:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803903:	39 c2                	cmp    %eax,%edx
  803905:	77 85                	ja     80388c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803907:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80390b:	75 14                	jne    803921 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80390d:	83 ec 04             	sub    $0x4,%esp
  803910:	68 10 46 80 00       	push   $0x804610
  803915:	6a 3a                	push   $0x3a
  803917:	68 04 46 80 00       	push   $0x804604
  80391c:	e8 8d fe ff ff       	call   8037ae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803921:	ff 45 f0             	incl   -0x10(%ebp)
  803924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803927:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80392a:	0f 8c 2f ff ff ff    	jl     80385f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803930:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803937:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80393e:	eb 26                	jmp    803966 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803940:	a1 20 50 80 00       	mov    0x805020,%eax
  803945:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80394b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80394e:	89 d0                	mov    %edx,%eax
  803950:	01 c0                	add    %eax,%eax
  803952:	01 d0                	add    %edx,%eax
  803954:	c1 e0 03             	shl    $0x3,%eax
  803957:	01 c8                	add    %ecx,%eax
  803959:	8a 40 04             	mov    0x4(%eax),%al
  80395c:	3c 01                	cmp    $0x1,%al
  80395e:	75 03                	jne    803963 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803960:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803963:	ff 45 e0             	incl   -0x20(%ebp)
  803966:	a1 20 50 80 00       	mov    0x805020,%eax
  80396b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803974:	39 c2                	cmp    %eax,%edx
  803976:	77 c8                	ja     803940 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80397e:	74 14                	je     803994 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803980:	83 ec 04             	sub    $0x4,%esp
  803983:	68 64 46 80 00       	push   $0x804664
  803988:	6a 44                	push   $0x44
  80398a:	68 04 46 80 00       	push   $0x804604
  80398f:	e8 1a fe ff ff       	call   8037ae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803994:	90                   	nop
  803995:	c9                   	leave  
  803996:	c3                   	ret    
  803997:	90                   	nop

00803998 <__divdi3>:
  803998:	55                   	push   %ebp
  803999:	57                   	push   %edi
  80399a:	56                   	push   %esi
  80399b:	53                   	push   %ebx
  80399c:	83 ec 1c             	sub    $0x1c,%esp
  80399f:	8b 44 24 30          	mov    0x30(%esp),%eax
  8039a3:	8b 54 24 34          	mov    0x34(%esp),%edx
  8039a7:	8b 74 24 38          	mov    0x38(%esp),%esi
  8039ab:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8039af:	89 f9                	mov    %edi,%ecx
  8039b1:	85 d2                	test   %edx,%edx
  8039b3:	0f 88 bb 00 00 00    	js     803a74 <__divdi3+0xdc>
  8039b9:	31 ed                	xor    %ebp,%ebp
  8039bb:	85 c9                	test   %ecx,%ecx
  8039bd:	0f 88 99 00 00 00    	js     803a5c <__divdi3+0xc4>
  8039c3:	89 34 24             	mov    %esi,(%esp)
  8039c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8039ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039ce:	89 d3                	mov    %edx,%ebx
  8039d0:	8b 34 24             	mov    (%esp),%esi
  8039d3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8039d7:	89 74 24 08          	mov    %esi,0x8(%esp)
  8039db:	8b 34 24             	mov    (%esp),%esi
  8039de:	89 c1                	mov    %eax,%ecx
  8039e0:	85 ff                	test   %edi,%edi
  8039e2:	75 10                	jne    8039f4 <__divdi3+0x5c>
  8039e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8039e8:	39 d7                	cmp    %edx,%edi
  8039ea:	76 4c                	jbe    803a38 <__divdi3+0xa0>
  8039ec:	f7 f7                	div    %edi
  8039ee:	89 c1                	mov    %eax,%ecx
  8039f0:	31 f6                	xor    %esi,%esi
  8039f2:	eb 08                	jmp    8039fc <__divdi3+0x64>
  8039f4:	39 d7                	cmp    %edx,%edi
  8039f6:	76 1c                	jbe    803a14 <__divdi3+0x7c>
  8039f8:	31 f6                	xor    %esi,%esi
  8039fa:	31 c9                	xor    %ecx,%ecx
  8039fc:	89 c8                	mov    %ecx,%eax
  8039fe:	89 f2                	mov    %esi,%edx
  803a00:	85 ed                	test   %ebp,%ebp
  803a02:	74 07                	je     803a0b <__divdi3+0x73>
  803a04:	f7 d8                	neg    %eax
  803a06:	83 d2 00             	adc    $0x0,%edx
  803a09:	f7 da                	neg    %edx
  803a0b:	83 c4 1c             	add    $0x1c,%esp
  803a0e:	5b                   	pop    %ebx
  803a0f:	5e                   	pop    %esi
  803a10:	5f                   	pop    %edi
  803a11:	5d                   	pop    %ebp
  803a12:	c3                   	ret    
  803a13:	90                   	nop
  803a14:	0f bd f7             	bsr    %edi,%esi
  803a17:	83 f6 1f             	xor    $0x1f,%esi
  803a1a:	75 6c                	jne    803a88 <__divdi3+0xf0>
  803a1c:	39 d7                	cmp    %edx,%edi
  803a1e:	72 0e                	jb     803a2e <__divdi3+0x96>
  803a20:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  803a24:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  803a28:	0f 87 ca 00 00 00    	ja     803af8 <__divdi3+0x160>
  803a2e:	b9 01 00 00 00       	mov    $0x1,%ecx
  803a33:	eb c7                	jmp    8039fc <__divdi3+0x64>
  803a35:	8d 76 00             	lea    0x0(%esi),%esi
  803a38:	85 f6                	test   %esi,%esi
  803a3a:	75 0b                	jne    803a47 <__divdi3+0xaf>
  803a3c:	b8 01 00 00 00       	mov    $0x1,%eax
  803a41:	31 d2                	xor    %edx,%edx
  803a43:	f7 f6                	div    %esi
  803a45:	89 c6                	mov    %eax,%esi
  803a47:	31 d2                	xor    %edx,%edx
  803a49:	89 d8                	mov    %ebx,%eax
  803a4b:	f7 f6                	div    %esi
  803a4d:	89 c7                	mov    %eax,%edi
  803a4f:	89 c8                	mov    %ecx,%eax
  803a51:	f7 f6                	div    %esi
  803a53:	89 c1                	mov    %eax,%ecx
  803a55:	89 fe                	mov    %edi,%esi
  803a57:	eb a3                	jmp    8039fc <__divdi3+0x64>
  803a59:	8d 76 00             	lea    0x0(%esi),%esi
  803a5c:	f7 d5                	not    %ebp
  803a5e:	f7 de                	neg    %esi
  803a60:	83 d7 00             	adc    $0x0,%edi
  803a63:	f7 df                	neg    %edi
  803a65:	89 34 24             	mov    %esi,(%esp)
  803a68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803a6c:	e9 59 ff ff ff       	jmp    8039ca <__divdi3+0x32>
  803a71:	8d 76 00             	lea    0x0(%esi),%esi
  803a74:	f7 d8                	neg    %eax
  803a76:	83 d2 00             	adc    $0x0,%edx
  803a79:	f7 da                	neg    %edx
  803a7b:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  803a80:	e9 36 ff ff ff       	jmp    8039bb <__divdi3+0x23>
  803a85:	8d 76 00             	lea    0x0(%esi),%esi
  803a88:	b8 20 00 00 00       	mov    $0x20,%eax
  803a8d:	29 f0                	sub    %esi,%eax
  803a8f:	89 f1                	mov    %esi,%ecx
  803a91:	d3 e7                	shl    %cl,%edi
  803a93:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a97:	88 c1                	mov    %al,%cl
  803a99:	d3 ea                	shr    %cl,%edx
  803a9b:	89 d1                	mov    %edx,%ecx
  803a9d:	09 f9                	or     %edi,%ecx
  803a9f:	89 0c 24             	mov    %ecx,(%esp)
  803aa2:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aa6:	89 f1                	mov    %esi,%ecx
  803aa8:	d3 e2                	shl    %cl,%edx
  803aaa:	89 54 24 08          	mov    %edx,0x8(%esp)
  803aae:	89 df                	mov    %ebx,%edi
  803ab0:	88 c1                	mov    %al,%cl
  803ab2:	d3 ef                	shr    %cl,%edi
  803ab4:	89 f1                	mov    %esi,%ecx
  803ab6:	d3 e3                	shl    %cl,%ebx
  803ab8:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803abc:	88 c1                	mov    %al,%cl
  803abe:	d3 ea                	shr    %cl,%edx
  803ac0:	09 d3                	or     %edx,%ebx
  803ac2:	89 d8                	mov    %ebx,%eax
  803ac4:	89 fa                	mov    %edi,%edx
  803ac6:	f7 34 24             	divl   (%esp)
  803ac9:	89 d1                	mov    %edx,%ecx
  803acb:	89 c3                	mov    %eax,%ebx
  803acd:	f7 64 24 08          	mull   0x8(%esp)
  803ad1:	39 d1                	cmp    %edx,%ecx
  803ad3:	72 17                	jb     803aec <__divdi3+0x154>
  803ad5:	74 09                	je     803ae0 <__divdi3+0x148>
  803ad7:	89 d9                	mov    %ebx,%ecx
  803ad9:	31 f6                	xor    %esi,%esi
  803adb:	e9 1c ff ff ff       	jmp    8039fc <__divdi3+0x64>
  803ae0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803ae4:	89 f1                	mov    %esi,%ecx
  803ae6:	d3 e2                	shl    %cl,%edx
  803ae8:	39 c2                	cmp    %eax,%edx
  803aea:	73 eb                	jae    803ad7 <__divdi3+0x13f>
  803aec:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  803aef:	31 f6                	xor    %esi,%esi
  803af1:	e9 06 ff ff ff       	jmp    8039fc <__divdi3+0x64>
  803af6:	66 90                	xchg   %ax,%ax
  803af8:	31 c9                	xor    %ecx,%ecx
  803afa:	e9 fd fe ff ff       	jmp    8039fc <__divdi3+0x64>
  803aff:	90                   	nop

00803b00 <__udivdi3>:
  803b00:	55                   	push   %ebp
  803b01:	57                   	push   %edi
  803b02:	56                   	push   %esi
  803b03:	53                   	push   %ebx
  803b04:	83 ec 1c             	sub    $0x1c,%esp
  803b07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b17:	89 ca                	mov    %ecx,%edx
  803b19:	89 f8                	mov    %edi,%eax
  803b1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b1f:	85 f6                	test   %esi,%esi
  803b21:	75 2d                	jne    803b50 <__udivdi3+0x50>
  803b23:	39 cf                	cmp    %ecx,%edi
  803b25:	77 65                	ja     803b8c <__udivdi3+0x8c>
  803b27:	89 fd                	mov    %edi,%ebp
  803b29:	85 ff                	test   %edi,%edi
  803b2b:	75 0b                	jne    803b38 <__udivdi3+0x38>
  803b2d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b32:	31 d2                	xor    %edx,%edx
  803b34:	f7 f7                	div    %edi
  803b36:	89 c5                	mov    %eax,%ebp
  803b38:	31 d2                	xor    %edx,%edx
  803b3a:	89 c8                	mov    %ecx,%eax
  803b3c:	f7 f5                	div    %ebp
  803b3e:	89 c1                	mov    %eax,%ecx
  803b40:	89 d8                	mov    %ebx,%eax
  803b42:	f7 f5                	div    %ebp
  803b44:	89 cf                	mov    %ecx,%edi
  803b46:	89 fa                	mov    %edi,%edx
  803b48:	83 c4 1c             	add    $0x1c,%esp
  803b4b:	5b                   	pop    %ebx
  803b4c:	5e                   	pop    %esi
  803b4d:	5f                   	pop    %edi
  803b4e:	5d                   	pop    %ebp
  803b4f:	c3                   	ret    
  803b50:	39 ce                	cmp    %ecx,%esi
  803b52:	77 28                	ja     803b7c <__udivdi3+0x7c>
  803b54:	0f bd fe             	bsr    %esi,%edi
  803b57:	83 f7 1f             	xor    $0x1f,%edi
  803b5a:	75 40                	jne    803b9c <__udivdi3+0x9c>
  803b5c:	39 ce                	cmp    %ecx,%esi
  803b5e:	72 0a                	jb     803b6a <__udivdi3+0x6a>
  803b60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b64:	0f 87 9e 00 00 00    	ja     803c08 <__udivdi3+0x108>
  803b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6f:	89 fa                	mov    %edi,%edx
  803b71:	83 c4 1c             	add    $0x1c,%esp
  803b74:	5b                   	pop    %ebx
  803b75:	5e                   	pop    %esi
  803b76:	5f                   	pop    %edi
  803b77:	5d                   	pop    %ebp
  803b78:	c3                   	ret    
  803b79:	8d 76 00             	lea    0x0(%esi),%esi
  803b7c:	31 ff                	xor    %edi,%edi
  803b7e:	31 c0                	xor    %eax,%eax
  803b80:	89 fa                	mov    %edi,%edx
  803b82:	83 c4 1c             	add    $0x1c,%esp
  803b85:	5b                   	pop    %ebx
  803b86:	5e                   	pop    %esi
  803b87:	5f                   	pop    %edi
  803b88:	5d                   	pop    %ebp
  803b89:	c3                   	ret    
  803b8a:	66 90                	xchg   %ax,%ax
  803b8c:	89 d8                	mov    %ebx,%eax
  803b8e:	f7 f7                	div    %edi
  803b90:	31 ff                	xor    %edi,%edi
  803b92:	89 fa                	mov    %edi,%edx
  803b94:	83 c4 1c             	add    $0x1c,%esp
  803b97:	5b                   	pop    %ebx
  803b98:	5e                   	pop    %esi
  803b99:	5f                   	pop    %edi
  803b9a:	5d                   	pop    %ebp
  803b9b:	c3                   	ret    
  803b9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ba1:	89 eb                	mov    %ebp,%ebx
  803ba3:	29 fb                	sub    %edi,%ebx
  803ba5:	89 f9                	mov    %edi,%ecx
  803ba7:	d3 e6                	shl    %cl,%esi
  803ba9:	89 c5                	mov    %eax,%ebp
  803bab:	88 d9                	mov    %bl,%cl
  803bad:	d3 ed                	shr    %cl,%ebp
  803baf:	89 e9                	mov    %ebp,%ecx
  803bb1:	09 f1                	or     %esi,%ecx
  803bb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bb7:	89 f9                	mov    %edi,%ecx
  803bb9:	d3 e0                	shl    %cl,%eax
  803bbb:	89 c5                	mov    %eax,%ebp
  803bbd:	89 d6                	mov    %edx,%esi
  803bbf:	88 d9                	mov    %bl,%cl
  803bc1:	d3 ee                	shr    %cl,%esi
  803bc3:	89 f9                	mov    %edi,%ecx
  803bc5:	d3 e2                	shl    %cl,%edx
  803bc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bcb:	88 d9                	mov    %bl,%cl
  803bcd:	d3 e8                	shr    %cl,%eax
  803bcf:	09 c2                	or     %eax,%edx
  803bd1:	89 d0                	mov    %edx,%eax
  803bd3:	89 f2                	mov    %esi,%edx
  803bd5:	f7 74 24 0c          	divl   0xc(%esp)
  803bd9:	89 d6                	mov    %edx,%esi
  803bdb:	89 c3                	mov    %eax,%ebx
  803bdd:	f7 e5                	mul    %ebp
  803bdf:	39 d6                	cmp    %edx,%esi
  803be1:	72 19                	jb     803bfc <__udivdi3+0xfc>
  803be3:	74 0b                	je     803bf0 <__udivdi3+0xf0>
  803be5:	89 d8                	mov    %ebx,%eax
  803be7:	31 ff                	xor    %edi,%edi
  803be9:	e9 58 ff ff ff       	jmp    803b46 <__udivdi3+0x46>
  803bee:	66 90                	xchg   %ax,%ax
  803bf0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bf4:	89 f9                	mov    %edi,%ecx
  803bf6:	d3 e2                	shl    %cl,%edx
  803bf8:	39 c2                	cmp    %eax,%edx
  803bfa:	73 e9                	jae    803be5 <__udivdi3+0xe5>
  803bfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bff:	31 ff                	xor    %edi,%edi
  803c01:	e9 40 ff ff ff       	jmp    803b46 <__udivdi3+0x46>
  803c06:	66 90                	xchg   %ax,%ax
  803c08:	31 c0                	xor    %eax,%eax
  803c0a:	e9 37 ff ff ff       	jmp    803b46 <__udivdi3+0x46>
  803c0f:	90                   	nop

00803c10 <__umoddi3>:
  803c10:	55                   	push   %ebp
  803c11:	57                   	push   %edi
  803c12:	56                   	push   %esi
  803c13:	53                   	push   %ebx
  803c14:	83 ec 1c             	sub    $0x1c,%esp
  803c17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c2f:	89 f3                	mov    %esi,%ebx
  803c31:	89 fa                	mov    %edi,%edx
  803c33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c37:	89 34 24             	mov    %esi,(%esp)
  803c3a:	85 c0                	test   %eax,%eax
  803c3c:	75 1a                	jne    803c58 <__umoddi3+0x48>
  803c3e:	39 f7                	cmp    %esi,%edi
  803c40:	0f 86 a2 00 00 00    	jbe    803ce8 <__umoddi3+0xd8>
  803c46:	89 c8                	mov    %ecx,%eax
  803c48:	89 f2                	mov    %esi,%edx
  803c4a:	f7 f7                	div    %edi
  803c4c:	89 d0                	mov    %edx,%eax
  803c4e:	31 d2                	xor    %edx,%edx
  803c50:	83 c4 1c             	add    $0x1c,%esp
  803c53:	5b                   	pop    %ebx
  803c54:	5e                   	pop    %esi
  803c55:	5f                   	pop    %edi
  803c56:	5d                   	pop    %ebp
  803c57:	c3                   	ret    
  803c58:	39 f0                	cmp    %esi,%eax
  803c5a:	0f 87 ac 00 00 00    	ja     803d0c <__umoddi3+0xfc>
  803c60:	0f bd e8             	bsr    %eax,%ebp
  803c63:	83 f5 1f             	xor    $0x1f,%ebp
  803c66:	0f 84 ac 00 00 00    	je     803d18 <__umoddi3+0x108>
  803c6c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c71:	29 ef                	sub    %ebp,%edi
  803c73:	89 fe                	mov    %edi,%esi
  803c75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c79:	89 e9                	mov    %ebp,%ecx
  803c7b:	d3 e0                	shl    %cl,%eax
  803c7d:	89 d7                	mov    %edx,%edi
  803c7f:	89 f1                	mov    %esi,%ecx
  803c81:	d3 ef                	shr    %cl,%edi
  803c83:	09 c7                	or     %eax,%edi
  803c85:	89 e9                	mov    %ebp,%ecx
  803c87:	d3 e2                	shl    %cl,%edx
  803c89:	89 14 24             	mov    %edx,(%esp)
  803c8c:	89 d8                	mov    %ebx,%eax
  803c8e:	d3 e0                	shl    %cl,%eax
  803c90:	89 c2                	mov    %eax,%edx
  803c92:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c96:	d3 e0                	shl    %cl,%eax
  803c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ca0:	89 f1                	mov    %esi,%ecx
  803ca2:	d3 e8                	shr    %cl,%eax
  803ca4:	09 d0                	or     %edx,%eax
  803ca6:	d3 eb                	shr    %cl,%ebx
  803ca8:	89 da                	mov    %ebx,%edx
  803caa:	f7 f7                	div    %edi
  803cac:	89 d3                	mov    %edx,%ebx
  803cae:	f7 24 24             	mull   (%esp)
  803cb1:	89 c6                	mov    %eax,%esi
  803cb3:	89 d1                	mov    %edx,%ecx
  803cb5:	39 d3                	cmp    %edx,%ebx
  803cb7:	0f 82 87 00 00 00    	jb     803d44 <__umoddi3+0x134>
  803cbd:	0f 84 91 00 00 00    	je     803d54 <__umoddi3+0x144>
  803cc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cc7:	29 f2                	sub    %esi,%edx
  803cc9:	19 cb                	sbb    %ecx,%ebx
  803ccb:	89 d8                	mov    %ebx,%eax
  803ccd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cd1:	d3 e0                	shl    %cl,%eax
  803cd3:	89 e9                	mov    %ebp,%ecx
  803cd5:	d3 ea                	shr    %cl,%edx
  803cd7:	09 d0                	or     %edx,%eax
  803cd9:	89 e9                	mov    %ebp,%ecx
  803cdb:	d3 eb                	shr    %cl,%ebx
  803cdd:	89 da                	mov    %ebx,%edx
  803cdf:	83 c4 1c             	add    $0x1c,%esp
  803ce2:	5b                   	pop    %ebx
  803ce3:	5e                   	pop    %esi
  803ce4:	5f                   	pop    %edi
  803ce5:	5d                   	pop    %ebp
  803ce6:	c3                   	ret    
  803ce7:	90                   	nop
  803ce8:	89 fd                	mov    %edi,%ebp
  803cea:	85 ff                	test   %edi,%edi
  803cec:	75 0b                	jne    803cf9 <__umoddi3+0xe9>
  803cee:	b8 01 00 00 00       	mov    $0x1,%eax
  803cf3:	31 d2                	xor    %edx,%edx
  803cf5:	f7 f7                	div    %edi
  803cf7:	89 c5                	mov    %eax,%ebp
  803cf9:	89 f0                	mov    %esi,%eax
  803cfb:	31 d2                	xor    %edx,%edx
  803cfd:	f7 f5                	div    %ebp
  803cff:	89 c8                	mov    %ecx,%eax
  803d01:	f7 f5                	div    %ebp
  803d03:	89 d0                	mov    %edx,%eax
  803d05:	e9 44 ff ff ff       	jmp    803c4e <__umoddi3+0x3e>
  803d0a:	66 90                	xchg   %ax,%ax
  803d0c:	89 c8                	mov    %ecx,%eax
  803d0e:	89 f2                	mov    %esi,%edx
  803d10:	83 c4 1c             	add    $0x1c,%esp
  803d13:	5b                   	pop    %ebx
  803d14:	5e                   	pop    %esi
  803d15:	5f                   	pop    %edi
  803d16:	5d                   	pop    %ebp
  803d17:	c3                   	ret    
  803d18:	3b 04 24             	cmp    (%esp),%eax
  803d1b:	72 06                	jb     803d23 <__umoddi3+0x113>
  803d1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d21:	77 0f                	ja     803d32 <__umoddi3+0x122>
  803d23:	89 f2                	mov    %esi,%edx
  803d25:	29 f9                	sub    %edi,%ecx
  803d27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d2b:	89 14 24             	mov    %edx,(%esp)
  803d2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d32:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d36:	8b 14 24             	mov    (%esp),%edx
  803d39:	83 c4 1c             	add    $0x1c,%esp
  803d3c:	5b                   	pop    %ebx
  803d3d:	5e                   	pop    %esi
  803d3e:	5f                   	pop    %edi
  803d3f:	5d                   	pop    %ebp
  803d40:	c3                   	ret    
  803d41:	8d 76 00             	lea    0x0(%esi),%esi
  803d44:	2b 04 24             	sub    (%esp),%eax
  803d47:	19 fa                	sbb    %edi,%edx
  803d49:	89 d1                	mov    %edx,%ecx
  803d4b:	89 c6                	mov    %eax,%esi
  803d4d:	e9 71 ff ff ff       	jmp    803cc3 <__umoddi3+0xb3>
  803d52:	66 90                	xchg   %ax,%ax
  803d54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d58:	72 ea                	jb     803d44 <__umoddi3+0x134>
  803d5a:	89 d9                	mov    %ebx,%ecx
  803d5c:	e9 62 ff ff ff       	jmp    803cc3 <__umoddi3+0xb3>
