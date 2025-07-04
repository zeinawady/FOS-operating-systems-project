
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 64 04 00 00       	call   80049a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 d1 1d 00 00       	call   801e1a <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 89 3a 80 00       	mov    $0x803a89,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 93 3a 80 00       	mov    $0x803a93,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 9f 3a 80 00       	mov    $0x803a9f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb ae 3a 80 00       	mov    $0x803aae,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb bd 3a 80 00       	mov    $0x803abd,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb d2 3a 80 00       	mov    $0x803ad2,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb e7 3a 80 00       	mov    $0x803ae7,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb f8 3a 80 00       	mov    $0x803af8,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 09 3b 80 00       	mov    $0x803b09,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 1a 3b 80 00       	mov    $0x803b1a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 23 3b 80 00       	mov    $0x803b23,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 2d 3b 80 00       	mov    $0x803b2d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 38 3b 80 00       	mov    $0x803b38,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 44 3b 80 00       	mov    $0x803b44,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 4e 3b 80 00       	mov    $0x803b4e,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb 58 3b 80 00       	mov    $0x803b58,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 66 3b 80 00       	mov    $0x803b66,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 75 3b 80 00       	mov    $0x803b75,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 7c 3b 80 00       	mov    $0x803b7c,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 8e 16 00 00       	call   8018b5 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 79 16 00 00       	call   8018b5 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 61 16 00 00       	call   8018b5 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 49 16 00 00       	call   8018b5 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	struct semaphore custCounterCS = get_semaphore(parentenvID, _custCounterCS);
  800272:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  800281:	52                   	push   %edx
  800282:	ff 75 e4             	pushl  -0x1c(%ebp)
  800285:	50                   	push   %eax
  800286:	e8 3c 32 00 00       	call   8034c7 <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 20 32 00 00       	call   8034c7 <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 04 32 00 00       	call   8034c7 <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 e8 31 00 00       	call   8034c7 <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 cc 31 00 00       	call   8034c7 <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 04 32 00 00       	call   803510 <wait_semaphore>
  80030c:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  800317:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80031a:	8b 00                	mov    (%eax),%eax
  80031c:	8d 50 01             	lea    0x1(%eax),%edx
  80031f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800322:	89 10                	mov    %edx,(%eax)
	}
	signal_semaphore(custCounterCS);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  80032d:	e8 48 32 00 00       	call   80357a <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 cd 31 00 00       	call   803510 <wait_semaphore>
  800343:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  800346:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800349:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800350:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800353:	01 d0                	add    %edx,%eax
  800355:	8b 00                	mov    (%eax),%eax
  800357:	89 45 cc             	mov    %eax,-0x34(%ebp)
	wait_semaphore(custQueueCS);
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
  800363:	e8 a8 31 00 00       	call   803510 <wait_semaphore>
  800368:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  80036b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800377:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80037a:	01 c2                	add    %eax,%edx
  80037c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80037f:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800381:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800384:	8b 00                	mov    (%eax),%eax
  800386:	8d 50 01             	lea    0x1(%eax),%edx
  800389:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038c:	89 10                	mov    %edx,(%eax)
	}
	signal_semaphore(custQueueCS);
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
  800397:	e8 de 31 00 00       	call   80357a <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 cd 31 00 00       	call   80357a <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb 83 3b 80 00       	mov    $0x803b83,%ebx
  8003bb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003c0:	89 c7                	mov    %eax,%edi
  8003c2:	89 de                	mov    %ebx,%esi
  8003c4:	89 d1                	mov    %edx,%ecx
  8003c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003c8:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8003ce:	b9 04 00 00 00       	mov    $0x4,%ecx
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	89 d7                	mov    %edx,%edi
  8003da:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  8003dc:	83 ec 08             	sub    $0x8,%esp
  8003df:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8003e5:	50                   	push   %eax
  8003e6:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e9:	e8 ff 0d 00 00       	call   8011ed <ltostr>
  8003ee:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8003fa:	50                   	push   %eax
  8003fb:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  800401:	50                   	push   %eax
  800402:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800408:	50                   	push   %eax
  800409:	e8 b8 0e 00 00       	call   8012c6 <strcconcat>
  80040e:	83 c4 10             	add    $0x10,%esp
	//sys_waitSemaphore(parentenvID, sname);
	struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  800411:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	8d 95 63 fe ff ff    	lea    -0x19d(%ebp),%edx
  800420:	52                   	push   %edx
  800421:	ff 75 e4             	pushl  -0x1c(%ebp)
  800424:	50                   	push   %eax
  800425:	e8 9d 30 00 00       	call   8034c7 <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 d5 30 00 00       	call   803510 <wait_semaphore>
  80043b:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  80043e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800441:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 40 04             	mov    0x4(%eax),%eax
  800450:	83 f8 01             	cmp    $0x1,%eax
  800453:	75 18                	jne    80046d <_main+0x435>
	{
		atomic_cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	ff 75 cc             	pushl  -0x34(%ebp)
  80045b:	ff 75 d0             	pushl  -0x30(%ebp)
  80045e:	68 40 3a 80 00       	push   $0x803a40
  800463:	e8 78 02 00 00       	call   8006e0 <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 68 3a 80 00       	push   $0x803a68
  800478:	e8 63 02 00 00       	call   8006e0 <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 ec 30 00 00       	call   80357a <signal_semaphore>
  80048e:	83 c4 10             	add    $0x10,%esp

	return;
  800491:	90                   	nop
}
  800492:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800495:	5b                   	pop    %ebx
  800496:	5e                   	pop    %esi
  800497:	5f                   	pop    %edi
  800498:	5d                   	pop    %ebp
  800499:	c3                   	ret    

0080049a <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8004a0:	e8 5c 19 00 00       	call   801e01 <sys_getenvindex>
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8004a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004ab:	89 d0                	mov    %edx,%eax
  8004ad:	c1 e0 02             	shl    $0x2,%eax
  8004b0:	01 d0                	add    %edx,%eax
  8004b2:	c1 e0 03             	shl    $0x3,%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004be:	01 d0                	add    %edx,%eax
  8004c0:	c1 e0 02             	shl    $0x2,%eax
  8004c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004c8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d2:	8a 40 20             	mov    0x20(%eax),%al
  8004d5:	84 c0                	test   %al,%al
  8004d7:	74 0d                	je     8004e6 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8004d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004de:	83 c0 20             	add    $0x20,%eax
  8004e1:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004ea:	7e 0a                	jle    8004f6 <libmain+0x5c>
		binaryname = argv[0];
  8004ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	ff 75 0c             	pushl  0xc(%ebp)
  8004fc:	ff 75 08             	pushl  0x8(%ebp)
  8004ff:	e8 34 fb ff ff       	call   800038 <_main>
  800504:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800507:	a1 00 50 80 00       	mov    0x805000,%eax
  80050c:	85 c0                	test   %eax,%eax
  80050e:	0f 84 9f 00 00 00    	je     8005b3 <libmain+0x119>
	{
		sys_lock_cons();
  800514:	e8 6c 16 00 00       	call   801b85 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800519:	83 ec 0c             	sub    $0xc,%esp
  80051c:	68 bc 3b 80 00       	push   $0x803bbc
  800521:	e8 8d 01 00 00       	call   8006b3 <cprintf>
  800526:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800529:	a1 20 50 80 00       	mov    0x805020,%eax
  80052e:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800534:	a1 20 50 80 00       	mov    0x805020,%eax
  800539:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	52                   	push   %edx
  800543:	50                   	push   %eax
  800544:	68 e4 3b 80 00       	push   $0x803be4
  800549:	e8 65 01 00 00       	call   8006b3 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800551:	a1 20 50 80 00       	mov    0x805020,%eax
  800556:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80055c:	a1 20 50 80 00       	mov    0x805020,%eax
  800561:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800567:	a1 20 50 80 00       	mov    0x805020,%eax
  80056c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800572:	51                   	push   %ecx
  800573:	52                   	push   %edx
  800574:	50                   	push   %eax
  800575:	68 0c 3c 80 00       	push   $0x803c0c
  80057a:	e8 34 01 00 00       	call   8006b3 <cprintf>
  80057f:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800582:	a1 20 50 80 00       	mov    0x805020,%eax
  800587:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	50                   	push   %eax
  800591:	68 64 3c 80 00       	push   $0x803c64
  800596:	e8 18 01 00 00       	call   8006b3 <cprintf>
  80059b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	68 bc 3b 80 00       	push   $0x803bbc
  8005a6:	e8 08 01 00 00       	call   8006b3 <cprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8005ae:	e8 ec 15 00 00       	call   801b9f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8005b3:	e8 19 00 00 00       	call   8005d1 <exit>
}
  8005b8:	90                   	nop
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	6a 00                	push   $0x0
  8005c6:	e8 02 18 00 00       	call   801dcd <sys_destroy_env>
  8005cb:	83 c4 10             	add    $0x10,%esp
}
  8005ce:	90                   	nop
  8005cf:	c9                   	leave  
  8005d0:	c3                   	ret    

008005d1 <exit>:

void
exit(void)
{
  8005d1:	55                   	push   %ebp
  8005d2:	89 e5                	mov    %esp,%ebp
  8005d4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005d7:	e8 57 18 00 00       	call   801e33 <sys_exit_env>
}
  8005dc:	90                   	nop
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f0:	89 0a                	mov    %ecx,(%edx)
  8005f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f5:	88 d1                	mov    %dl,%cl
  8005f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	3d ff 00 00 00       	cmp    $0xff,%eax
  800608:	75 2c                	jne    800636 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80060a:	a0 44 50 98 00       	mov    0x985044,%al
  80060f:	0f b6 c0             	movzbl %al,%eax
  800612:	8b 55 0c             	mov    0xc(%ebp),%edx
  800615:	8b 12                	mov    (%edx),%edx
  800617:	89 d1                	mov    %edx,%ecx
  800619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061c:	83 c2 08             	add    $0x8,%edx
  80061f:	83 ec 04             	sub    $0x4,%esp
  800622:	50                   	push   %eax
  800623:	51                   	push   %ecx
  800624:	52                   	push   %edx
  800625:	e8 19 15 00 00       	call   801b43 <sys_cputs>
  80062a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800636:	8b 45 0c             	mov    0xc(%ebp),%eax
  800639:	8b 40 04             	mov    0x4(%eax),%eax
  80063c:	8d 50 01             	lea    0x1(%eax),%edx
  80063f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800642:	89 50 04             	mov    %edx,0x4(%eax)
}
  800645:	90                   	nop
  800646:	c9                   	leave  
  800647:	c3                   	ret    

00800648 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
  80064b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800651:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800658:	00 00 00 
	b.cnt = 0;
  80065b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800662:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800665:	ff 75 0c             	pushl  0xc(%ebp)
  800668:	ff 75 08             	pushl  0x8(%ebp)
  80066b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800671:	50                   	push   %eax
  800672:	68 df 05 80 00       	push   $0x8005df
  800677:	e8 11 02 00 00       	call   80088d <vprintfmt>
  80067c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067f:	a0 44 50 98 00       	mov    0x985044,%al
  800684:	0f b6 c0             	movzbl %al,%eax
  800687:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068d:	83 ec 04             	sub    $0x4,%esp
  800690:	50                   	push   %eax
  800691:	52                   	push   %edx
  800692:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800698:	83 c0 08             	add    $0x8,%eax
  80069b:	50                   	push   %eax
  80069c:	e8 a2 14 00 00       	call   801b43 <sys_cputs>
  8006a1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a4:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8006ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b9:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8006c0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cf:	50                   	push   %eax
  8006d0:	e8 73 ff ff ff       	call   800648 <vcprintf>
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006e6:	e8 9a 14 00 00       	call   801b85 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006eb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	e8 48 ff ff ff       	call   800648 <vcprintf>
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800706:	e8 94 14 00 00       	call   801b9f <sys_unlock_cons>
	return cnt;
  80070b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	53                   	push   %ebx
  800714:	83 ec 14             	sub    $0x14,%esp
  800717:	8b 45 10             	mov    0x10(%ebp),%eax
  80071a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800723:	8b 45 18             	mov    0x18(%ebp),%eax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
  80072b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072e:	77 55                	ja     800785 <printnum+0x75>
  800730:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800733:	72 05                	jb     80073a <printnum+0x2a>
  800735:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800738:	77 4b                	ja     800785 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80073a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800740:	8b 45 18             	mov    0x18(%ebp),%eax
  800743:	ba 00 00 00 00       	mov    $0x0,%edx
  800748:	52                   	push   %edx
  800749:	50                   	push   %eax
  80074a:	ff 75 f4             	pushl  -0xc(%ebp)
  80074d:	ff 75 f0             	pushl  -0x10(%ebp)
  800750:	e8 7b 30 00 00       	call   8037d0 <__udivdi3>
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	83 ec 04             	sub    $0x4,%esp
  80075b:	ff 75 20             	pushl  0x20(%ebp)
  80075e:	53                   	push   %ebx
  80075f:	ff 75 18             	pushl  0x18(%ebp)
  800762:	52                   	push   %edx
  800763:	50                   	push   %eax
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	ff 75 08             	pushl  0x8(%ebp)
  80076a:	e8 a1 ff ff ff       	call   800710 <printnum>
  80076f:	83 c4 20             	add    $0x20,%esp
  800772:	eb 1a                	jmp    80078e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	ff 75 20             	pushl  0x20(%ebp)
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	ff d0                	call   *%eax
  800782:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800785:	ff 4d 1c             	decl   0x1c(%ebp)
  800788:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80078c:	7f e6                	jg     800774 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800791:	bb 00 00 00 00       	mov    $0x0,%ebx
  800796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079c:	53                   	push   %ebx
  80079d:	51                   	push   %ecx
  80079e:	52                   	push   %edx
  80079f:	50                   	push   %eax
  8007a0:	e8 3b 31 00 00       	call   8038e0 <__umoddi3>
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	05 94 3e 80 00       	add    $0x803e94,%eax
  8007ad:	8a 00                	mov    (%eax),%al
  8007af:	0f be c0             	movsbl %al,%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
}
  8007c1:	90                   	nop
  8007c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c5:	c9                   	leave  
  8007c6:	c3                   	ret    

008007c7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007ce:	7e 1c                	jle    8007ec <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	8d 50 08             	lea    0x8(%eax),%edx
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	89 10                	mov    %edx,(%eax)
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	83 e8 08             	sub    $0x8,%eax
  8007e5:	8b 50 04             	mov    0x4(%eax),%edx
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	eb 40                	jmp    80082c <getuint+0x65>
	else if (lflag)
  8007ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f0:	74 1e                	je     800810 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	89 10                	mov    %edx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	ba 00 00 00 00       	mov    $0x0,%edx
  80080e:	eb 1c                	jmp    80082c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	8d 50 04             	lea    0x4(%eax),%edx
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	89 10                	mov    %edx,(%eax)
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	83 e8 04             	sub    $0x4,%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800831:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800835:	7e 1c                	jle    800853 <getint+0x25>
		return va_arg(*ap, long long);
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	8d 50 08             	lea    0x8(%eax),%edx
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	89 10                	mov    %edx,(%eax)
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	83 e8 08             	sub    $0x8,%eax
  80084c:	8b 50 04             	mov    0x4(%eax),%edx
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	eb 38                	jmp    80088b <getint+0x5d>
	else if (lflag)
  800853:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800857:	74 1a                	je     800873 <getint+0x45>
		return va_arg(*ap, long);
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	8d 50 04             	lea    0x4(%eax),%edx
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	89 10                	mov    %edx,(%eax)
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	83 e8 04             	sub    $0x4,%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	99                   	cltd   
  800871:	eb 18                	jmp    80088b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	8d 50 04             	lea    0x4(%eax),%edx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	89 10                	mov    %edx,(%eax)
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	83 e8 04             	sub    $0x4,%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	99                   	cltd   
}
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	56                   	push   %esi
  800891:	53                   	push   %ebx
  800892:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800895:	eb 17                	jmp    8008ae <vprintfmt+0x21>
			if (ch == '\0')
  800897:	85 db                	test   %ebx,%ebx
  800899:	0f 84 c1 03 00 00    	je     800c60 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	53                   	push   %ebx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b1:	8d 50 01             	lea    0x1(%eax),%edx
  8008b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b7:	8a 00                	mov    (%eax),%al
  8008b9:	0f b6 d8             	movzbl %al,%ebx
  8008bc:	83 fb 25             	cmp    $0x25,%ebx
  8008bf:	75 d6                	jne    800897 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e4:	8d 50 01             	lea    0x1(%eax),%edx
  8008e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ea:	8a 00                	mov    (%eax),%al
  8008ec:	0f b6 d8             	movzbl %al,%ebx
  8008ef:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008f2:	83 f8 5b             	cmp    $0x5b,%eax
  8008f5:	0f 87 3d 03 00 00    	ja     800c38 <vprintfmt+0x3ab>
  8008fb:	8b 04 85 b8 3e 80 00 	mov    0x803eb8(,%eax,4),%eax
  800902:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800904:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800908:	eb d7                	jmp    8008e1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80090a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090e:	eb d1                	jmp    8008e1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800910:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	c1 e0 02             	shl    $0x2,%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	01 d8                	add    %ebx,%eax
  800925:	83 e8 30             	sub    $0x30,%eax
  800928:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80092b:	8b 45 10             	mov    0x10(%ebp),%eax
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800933:	83 fb 2f             	cmp    $0x2f,%ebx
  800936:	7e 3e                	jle    800976 <vprintfmt+0xe9>
  800938:	83 fb 39             	cmp    $0x39,%ebx
  80093b:	7f 39                	jg     800976 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800940:	eb d5                	jmp    800917 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 c0 04             	add    $0x4,%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 e8 04             	sub    $0x4,%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800956:	eb 1f                	jmp    800977 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	79 83                	jns    8008e1 <vprintfmt+0x54>
				width = 0;
  80095e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800965:	e9 77 ff ff ff       	jmp    8008e1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80096a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800971:	e9 6b ff ff ff       	jmp    8008e1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800976:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800977:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097b:	0f 89 60 ff ff ff    	jns    8008e1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800981:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800984:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800987:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098e:	e9 4e ff ff ff       	jmp    8008e1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800993:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800996:	e9 46 ff ff ff       	jmp    8008e1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	83 c0 04             	add    $0x4,%eax
  8009a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	83 e8 04             	sub    $0x4,%eax
  8009aa:	8b 00                	mov    (%eax),%eax
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	50                   	push   %eax
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	ff d0                	call   *%eax
  8009b8:	83 c4 10             	add    $0x10,%esp
			break;
  8009bb:	e9 9b 02 00 00       	jmp    800c5b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	83 c0 04             	add    $0x4,%eax
  8009c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	83 e8 04             	sub    $0x4,%eax
  8009cf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009d1:	85 db                	test   %ebx,%ebx
  8009d3:	79 02                	jns    8009d7 <vprintfmt+0x14a>
				err = -err;
  8009d5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d7:	83 fb 64             	cmp    $0x64,%ebx
  8009da:	7f 0b                	jg     8009e7 <vprintfmt+0x15a>
  8009dc:	8b 34 9d 00 3d 80 00 	mov    0x803d00(,%ebx,4),%esi
  8009e3:	85 f6                	test   %esi,%esi
  8009e5:	75 19                	jne    800a00 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e7:	53                   	push   %ebx
  8009e8:	68 a5 3e 80 00       	push   $0x803ea5
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	ff 75 08             	pushl  0x8(%ebp)
  8009f3:	e8 70 02 00 00       	call   800c68 <printfmt>
  8009f8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009fb:	e9 5b 02 00 00       	jmp    800c5b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a00:	56                   	push   %esi
  800a01:	68 ae 3e 80 00       	push   $0x803eae
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	ff 75 08             	pushl  0x8(%ebp)
  800a0c:	e8 57 02 00 00       	call   800c68 <printfmt>
  800a11:	83 c4 10             	add    $0x10,%esp
			break;
  800a14:	e9 42 02 00 00       	jmp    800c5b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 30                	mov    (%eax),%esi
  800a2a:	85 f6                	test   %esi,%esi
  800a2c:	75 05                	jne    800a33 <vprintfmt+0x1a6>
				p = "(null)";
  800a2e:	be b1 3e 80 00       	mov    $0x803eb1,%esi
			if (width > 0 && padc != '-')
  800a33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a37:	7e 6d                	jle    800aa6 <vprintfmt+0x219>
  800a39:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3d:	74 67                	je     800aa6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	50                   	push   %eax
  800a46:	56                   	push   %esi
  800a47:	e8 1e 03 00 00       	call   800d6a <strnlen>
  800a4c:	83 c4 10             	add    $0x10,%esp
  800a4f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a52:	eb 16                	jmp    800a6a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a54:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	50                   	push   %eax
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a67:	ff 4d e4             	decl   -0x1c(%ebp)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	7f e4                	jg     800a54 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a70:	eb 34                	jmp    800aa6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a72:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a76:	74 1c                	je     800a94 <vprintfmt+0x207>
  800a78:	83 fb 1f             	cmp    $0x1f,%ebx
  800a7b:	7e 05                	jle    800a82 <vprintfmt+0x1f5>
  800a7d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a80:	7e 12                	jle    800a94 <vprintfmt+0x207>
					putch('?', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 3f                	push   $0x3f
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
  800a92:	eb 0f                	jmp    800aa3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa3:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa6:	89 f0                	mov    %esi,%eax
  800aa8:	8d 70 01             	lea    0x1(%eax),%esi
  800aab:	8a 00                	mov    (%eax),%al
  800aad:	0f be d8             	movsbl %al,%ebx
  800ab0:	85 db                	test   %ebx,%ebx
  800ab2:	74 24                	je     800ad8 <vprintfmt+0x24b>
  800ab4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab8:	78 b8                	js     800a72 <vprintfmt+0x1e5>
  800aba:	ff 4d e0             	decl   -0x20(%ebp)
  800abd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac1:	79 af                	jns    800a72 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac3:	eb 13                	jmp    800ad8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	6a 20                	push   $0x20
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	ff d0                	call   *%eax
  800ad2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adc:	7f e7                	jg     800ac5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ade:	e9 78 01 00 00       	jmp    800c5b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aec:	50                   	push   %eax
  800aed:	e8 3c fd ff ff       	call   80082e <getint>
  800af2:	83 c4 10             	add    $0x10,%esp
  800af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b01:	85 d2                	test   %edx,%edx
  800b03:	79 23                	jns    800b28 <vprintfmt+0x29b>
				putch('-', putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	6a 2d                	push   $0x2d
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	ff d0                	call   *%eax
  800b12:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1b:	f7 d8                	neg    %eax
  800b1d:	83 d2 00             	adc    $0x0,%edx
  800b20:	f7 da                	neg    %edx
  800b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b25:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b28:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2f:	e9 bc 00 00 00       	jmp    800bf0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3d:	50                   	push   %eax
  800b3e:	e8 84 fc ff ff       	call   8007c7 <getuint>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b4c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b53:	e9 98 00 00 00       	jmp    800bf0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	6a 58                	push   $0x58
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	6a 58                	push   $0x58
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	ff d0                	call   *%eax
  800b75:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	6a 58                	push   $0x58
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	ff d0                	call   *%eax
  800b85:	83 c4 10             	add    $0x10,%esp
			break;
  800b88:	e9 ce 00 00 00       	jmp    800c5b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 0c             	pushl  0xc(%ebp)
  800b93:	6a 30                	push   $0x30
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	ff d0                	call   *%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9d:	83 ec 08             	sub    $0x8,%esp
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	6a 78                	push   $0x78
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	ff d0                	call   *%eax
  800baa:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bad:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb0:	83 c0 04             	add    $0x4,%eax
  800bb3:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	83 e8 04             	sub    $0x4,%eax
  800bbc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bcf:	eb 1f                	jmp    800bf0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	e8 e7 fb ff ff       	call   8007c7 <getuint>
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf7:	83 ec 04             	sub    $0x4,%esp
  800bfa:	52                   	push   %edx
  800bfb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bfe:	50                   	push   %eax
  800bff:	ff 75 f4             	pushl  -0xc(%ebp)
  800c02:	ff 75 f0             	pushl  -0x10(%ebp)
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	ff 75 08             	pushl  0x8(%ebp)
  800c0b:	e8 00 fb ff ff       	call   800710 <printnum>
  800c10:	83 c4 20             	add    $0x20,%esp
			break;
  800c13:	eb 46                	jmp    800c5b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c15:	83 ec 08             	sub    $0x8,%esp
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	53                   	push   %ebx
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			break;
  800c24:	eb 35                	jmp    800c5b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c26:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800c2d:	eb 2c                	jmp    800c5b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c2f:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800c36:	eb 23                	jmp    800c5b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c38:	83 ec 08             	sub    $0x8,%esp
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	6a 25                	push   $0x25
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	ff d0                	call   *%eax
  800c45:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c48:	ff 4d 10             	decl   0x10(%ebp)
  800c4b:	eb 03                	jmp    800c50 <vprintfmt+0x3c3>
  800c4d:	ff 4d 10             	decl   0x10(%ebp)
  800c50:	8b 45 10             	mov    0x10(%ebp),%eax
  800c53:	48                   	dec    %eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	3c 25                	cmp    $0x25,%al
  800c58:	75 f3                	jne    800c4d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c5a:	90                   	nop
		}
	}
  800c5b:	e9 35 fc ff ff       	jmp    800895 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c60:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c71:	83 c0 04             	add    $0x4,%eax
  800c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c77:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	ff 75 0c             	pushl  0xc(%ebp)
  800c81:	ff 75 08             	pushl  0x8(%ebp)
  800c84:	e8 04 fc ff ff       	call   80088d <vprintfmt>
  800c89:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c8c:	90                   	nop
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	8b 40 08             	mov    0x8(%eax),%eax
  800c98:	8d 50 01             	lea    0x1(%eax),%edx
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	8b 10                	mov    (%eax),%edx
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8b 40 04             	mov    0x4(%eax),%eax
  800cac:	39 c2                	cmp    %eax,%edx
  800cae:	73 12                	jae    800cc2 <sprintputch+0x33>
		*b->buf++ = ch;
  800cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb3:	8b 00                	mov    (%eax),%eax
  800cb5:	8d 48 01             	lea    0x1(%eax),%ecx
  800cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbb:	89 0a                	mov    %ecx,(%edx)
  800cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc0:	88 10                	mov    %dl,(%eax)
}
  800cc2:	90                   	nop
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cea:	74 06                	je     800cf2 <vsnprintf+0x2d>
  800cec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf0:	7f 07                	jg     800cf9 <vsnprintf+0x34>
		return -E_INVAL;
  800cf2:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf7:	eb 20                	jmp    800d19 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cf9:	ff 75 14             	pushl  0x14(%ebp)
  800cfc:	ff 75 10             	pushl  0x10(%ebp)
  800cff:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d02:	50                   	push   %eax
  800d03:	68 8f 0c 80 00       	push   $0x800c8f
  800d08:	e8 80 fb ff ff       	call   80088d <vprintfmt>
  800d0d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d13:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d21:	8d 45 10             	lea    0x10(%ebp),%eax
  800d24:	83 c0 04             	add    $0x4,%eax
  800d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d30:	50                   	push   %eax
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	ff 75 08             	pushl  0x8(%ebp)
  800d37:	e8 89 ff ff ff       	call   800cc5 <vsnprintf>
  800d3c:	83 c4 10             	add    $0x10,%esp
  800d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d45:	c9                   	leave  
  800d46:	c3                   	ret    

00800d47 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d54:	eb 06                	jmp    800d5c <strlen+0x15>
		n++;
  800d56:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d59:	ff 45 08             	incl   0x8(%ebp)
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 f1                	jne    800d56 <strlen+0xf>
		n++;
	return n;
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d77:	eb 09                	jmp    800d82 <strnlen+0x18>
		n++;
  800d79:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	ff 4d 0c             	decl   0xc(%ebp)
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	74 09                	je     800d91 <strnlen+0x27>
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	84 c0                	test   %al,%al
  800d8f:	75 e8                	jne    800d79 <strnlen+0xf>
		n++;
	return n;
  800d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800da2:	90                   	nop
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8d 50 01             	lea    0x1(%eax),%edx
  800da9:	89 55 08             	mov    %edx,0x8(%ebp)
  800dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db5:	8a 12                	mov    (%edx),%dl
  800db7:	88 10                	mov    %dl,(%eax)
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e4                	jne    800da3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    

00800dc4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd7:	eb 1f                	jmp    800df8 <strncpy+0x34>
		*dst++ = *src;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 08             	mov    %edx,0x8(%ebp)
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de5:	8a 12                	mov    (%edx),%dl
  800de7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	84 c0                	test   %al,%al
  800df0:	74 03                	je     800df5 <strncpy+0x31>
			src++;
  800df2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df5:	ff 45 fc             	incl   -0x4(%ebp)
  800df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dfe:	72 d9                	jb     800dd9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e00:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e15:	74 30                	je     800e47 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e17:	eb 16                	jmp    800e2f <strlcpy+0x2a>
			*dst++ = *src++;
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8d 50 01             	lea    0x1(%eax),%edx
  800e1f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e28:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2b:	8a 12                	mov    (%edx),%dl
  800e2d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e2f:	ff 4d 10             	decl   0x10(%ebp)
  800e32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e36:	74 09                	je     800e41 <strlcpy+0x3c>
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	84 c0                	test   %al,%al
  800e3f:	75 d8                	jne    800e19 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e47:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	29 c2                	sub    %eax,%edx
  800e4f:	89 d0                	mov    %edx,%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e56:	eb 06                	jmp    800e5e <strcmp+0xb>
		p++, q++;
  800e58:	ff 45 08             	incl   0x8(%ebp)
  800e5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	84 c0                	test   %al,%al
  800e65:	74 0e                	je     800e75 <strcmp+0x22>
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 10                	mov    (%eax),%dl
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	38 c2                	cmp    %al,%dl
  800e73:	74 e3                	je     800e58 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	0f b6 d0             	movzbl %al,%edx
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	0f b6 c0             	movzbl %al,%eax
  800e85:	29 c2                	sub    %eax,%edx
  800e87:	89 d0                	mov    %edx,%eax
}
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e8e:	eb 09                	jmp    800e99 <strncmp+0xe>
		n--, p++, q++;
  800e90:	ff 4d 10             	decl   0x10(%ebp)
  800e93:	ff 45 08             	incl   0x8(%ebp)
  800e96:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	74 17                	je     800eb6 <strncmp+0x2b>
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	84 c0                	test   %al,%al
  800ea6:	74 0e                	je     800eb6 <strncmp+0x2b>
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8a 10                	mov    (%eax),%dl
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	38 c2                	cmp    %al,%dl
  800eb4:	74 da                	je     800e90 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eba:	75 07                	jne    800ec3 <strncmp+0x38>
		return 0;
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec1:	eb 14                	jmp    800ed7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f b6 d0             	movzbl %al,%edx
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f b6 c0             	movzbl %al,%eax
  800ed3:	29 c2                	sub    %eax,%edx
  800ed5:	89 d0                	mov    %edx,%eax
}
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 04             	sub    $0x4,%esp
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee5:	eb 12                	jmp    800ef9 <strchr+0x20>
		if (*s == c)
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eef:	75 05                	jne    800ef6 <strchr+0x1d>
			return (char *) s;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	eb 11                	jmp    800f07 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef6:	ff 45 08             	incl   0x8(%ebp)
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	84 c0                	test   %al,%al
  800f00:	75 e5                	jne    800ee7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 04             	sub    $0x4,%esp
  800f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f12:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f15:	eb 0d                	jmp    800f24 <strfind+0x1b>
		if (*s == c)
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f1f:	74 0e                	je     800f2f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f21:	ff 45 08             	incl   0x8(%ebp)
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	84 c0                	test   %al,%al
  800f2b:	75 ea                	jne    800f17 <strfind+0xe>
  800f2d:	eb 01                	jmp    800f30 <strfind+0x27>
		if (*s == c)
			break;
  800f2f:	90                   	nop
	return (char *) s;
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f47:	eb 0e                	jmp    800f57 <memset+0x22>
		*p++ = c;
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8d 50 01             	lea    0x1(%eax),%edx
  800f4f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f55:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f57:	ff 4d f8             	decl   -0x8(%ebp)
  800f5a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f5e:	79 e9                	jns    800f49 <memset+0x14>
		*p++ = c;

	return v;
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f77:	eb 16                	jmp    800f8f <memcpy+0x2a>
		*d++ = *s++;
  800f79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7c:	8d 50 01             	lea    0x1(%eax),%edx
  800f7f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f88:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f8b:	8a 12                	mov    (%edx),%dl
  800f8d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	89 55 10             	mov    %edx,0x10(%ebp)
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	75 dd                	jne    800f79 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb9:	73 50                	jae    80100b <memmove+0x6a>
  800fbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc1:	01 d0                	add    %edx,%eax
  800fc3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc6:	76 43                	jbe    80100b <memmove+0x6a>
		s += n;
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fce:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd4:	eb 10                	jmp    800fe6 <memmove+0x45>
			*--d = *--s;
  800fd6:	ff 4d f8             	decl   -0x8(%ebp)
  800fd9:	ff 4d fc             	decl   -0x4(%ebp)
  800fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdf:	8a 10                	mov    (%eax),%dl
  800fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	89 55 10             	mov    %edx,0x10(%ebp)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	75 e3                	jne    800fd6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff3:	eb 23                	jmp    801018 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff8:	8d 50 01             	lea    0x1(%eax),%edx
  800ffb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801001:	8d 4a 01             	lea    0x1(%edx),%ecx
  801004:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801007:	8a 12                	mov    (%edx),%dl
  801009:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100b:	8b 45 10             	mov    0x10(%ebp),%eax
  80100e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801011:	89 55 10             	mov    %edx,0x10(%ebp)
  801014:	85 c0                	test   %eax,%eax
  801016:	75 dd                	jne    800ff5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80102f:	eb 2a                	jmp    80105b <memcmp+0x3e>
		if (*s1 != *s2)
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	8a 10                	mov    (%eax),%dl
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	38 c2                	cmp    %al,%dl
  80103d:	74 16                	je     801055 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80103f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f b6 d0             	movzbl %al,%edx
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	0f b6 c0             	movzbl %al,%eax
  80104f:	29 c2                	sub    %eax,%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	eb 18                	jmp    80106d <memcmp+0x50>
		s1++, s2++;
  801055:	ff 45 fc             	incl   -0x4(%ebp)
  801058:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	89 55 10             	mov    %edx,0x10(%ebp)
  801064:	85 c0                	test   %eax,%eax
  801066:	75 c9                	jne    801031 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 d0                	add    %edx,%eax
  80107d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801080:	eb 15                	jmp    801097 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	0f b6 d0             	movzbl %al,%edx
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	0f b6 c0             	movzbl %al,%eax
  801090:	39 c2                	cmp    %eax,%edx
  801092:	74 0d                	je     8010a1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80109d:	72 e3                	jb     801082 <memfind+0x13>
  80109f:	eb 01                	jmp    8010a2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a1:	90                   	nop
	return (void *) s;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bb:	eb 03                	jmp    8010c0 <strtol+0x19>
		s++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 20                	cmp    $0x20,%al
  8010c7:	74 f4                	je     8010bd <strtol+0x16>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 09                	cmp    $0x9,%al
  8010d0:	74 eb                	je     8010bd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 2b                	cmp    $0x2b,%al
  8010d9:	75 05                	jne    8010e0 <strtol+0x39>
		s++;
  8010db:	ff 45 08             	incl   0x8(%ebp)
  8010de:	eb 13                	jmp    8010f3 <strtol+0x4c>
	else if (*s == '-')
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	3c 2d                	cmp    $0x2d,%al
  8010e7:	75 0a                	jne    8010f3 <strtol+0x4c>
		s++, neg = 1;
  8010e9:	ff 45 08             	incl   0x8(%ebp)
  8010ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f7:	74 06                	je     8010ff <strtol+0x58>
  8010f9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010fd:	75 20                	jne    80111f <strtol+0x78>
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	3c 30                	cmp    $0x30,%al
  801106:	75 17                	jne    80111f <strtol+0x78>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	40                   	inc    %eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	3c 78                	cmp    $0x78,%al
  801110:	75 0d                	jne    80111f <strtol+0x78>
		s += 2, base = 16;
  801112:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801116:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80111d:	eb 28                	jmp    801147 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80111f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801123:	75 15                	jne    80113a <strtol+0x93>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 30                	cmp    $0x30,%al
  80112c:	75 0c                	jne    80113a <strtol+0x93>
		s++, base = 8;
  80112e:	ff 45 08             	incl   0x8(%ebp)
  801131:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801138:	eb 0d                	jmp    801147 <strtol+0xa0>
	else if (base == 0)
  80113a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113e:	75 07                	jne    801147 <strtol+0xa0>
		base = 10;
  801140:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 2f                	cmp    $0x2f,%al
  80114e:	7e 19                	jle    801169 <strtol+0xc2>
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	3c 39                	cmp    $0x39,%al
  801157:	7f 10                	jg     801169 <strtol+0xc2>
			dig = *s - '0';
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	0f be c0             	movsbl %al,%eax
  801161:	83 e8 30             	sub    $0x30,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801167:	eb 42                	jmp    8011ab <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	3c 60                	cmp    $0x60,%al
  801170:	7e 19                	jle    80118b <strtol+0xe4>
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	3c 7a                	cmp    $0x7a,%al
  801179:	7f 10                	jg     80118b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	0f be c0             	movsbl %al,%eax
  801183:	83 e8 57             	sub    $0x57,%eax
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801189:	eb 20                	jmp    8011ab <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	3c 40                	cmp    $0x40,%al
  801192:	7e 39                	jle    8011cd <strtol+0x126>
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	3c 5a                	cmp    $0x5a,%al
  80119b:	7f 30                	jg     8011cd <strtol+0x126>
			dig = *s - 'A' + 10;
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	0f be c0             	movsbl %al,%eax
  8011a5:	83 e8 37             	sub    $0x37,%eax
  8011a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ae:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b1:	7d 19                	jge    8011cc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c7:	e9 7b ff ff ff       	jmp    801147 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011cc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d1:	74 08                	je     8011db <strtol+0x134>
		*endptr = (char *) s;
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011df:	74 07                	je     8011e8 <strtol+0x141>
  8011e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e4:	f7 d8                	neg    %eax
  8011e6:	eb 03                	jmp    8011eb <strtol+0x144>
  8011e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <ltostr>:

void
ltostr(long value, char *str)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801205:	79 13                	jns    80121a <ltostr+0x2d>
	{
		neg = 1;
  801207:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801214:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801217:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801222:	99                   	cltd   
  801223:	f7 f9                	idiv   %ecx
  801225:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801228:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122b:	8d 50 01             	lea    0x1(%eax),%edx
  80122e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801231:	89 c2                	mov    %eax,%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123b:	83 c2 30             	add    $0x30,%edx
  80123e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801240:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801243:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801248:	f7 e9                	imul   %ecx
  80124a:	c1 fa 02             	sar    $0x2,%edx
  80124d:	89 c8                	mov    %ecx,%eax
  80124f:	c1 f8 1f             	sar    $0x1f,%eax
  801252:	29 c2                	sub    %eax,%edx
  801254:	89 d0                	mov    %edx,%eax
  801256:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801259:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125d:	75 bb                	jne    80121a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80125f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801266:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801271:	74 3d                	je     8012b0 <ltostr+0xc3>
		start = 1 ;
  801273:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127a:	eb 34                	jmp    8012b0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80127c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	01 d0                	add    %edx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 c2                	add    %eax,%edx
  801291:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801294:	8b 45 0c             	mov    0xc(%ebp),%eax
  801297:	01 c8                	add    %ecx,%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8012aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b6:	7c c4                	jl     80127c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c3:	90                   	nop
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cc:	ff 75 08             	pushl  0x8(%ebp)
  8012cf:	e8 73 fa ff ff       	call   800d47 <strlen>
  8012d4:	83 c4 04             	add    $0x4,%esp
  8012d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012da:	ff 75 0c             	pushl  0xc(%ebp)
  8012dd:	e8 65 fa ff ff       	call   800d47 <strlen>
  8012e2:	83 c4 04             	add    $0x4,%esp
  8012e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f6:	eb 17                	jmp    80130f <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fe:	01 c2                	add    %eax,%edx
  801300:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	01 c8                	add    %ecx,%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130c:	ff 45 fc             	incl   -0x4(%ebp)
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801315:	7c e1                	jl     8012f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801317:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80131e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801325:	eb 1f                	jmp    801346 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801327:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132a:	8d 50 01             	lea    0x1(%eax),%edx
  80132d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801330:	89 c2                	mov    %eax,%edx
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	01 c2                	add    %eax,%edx
  801337:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133d:	01 c8                	add    %ecx,%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801343:	ff 45 f8             	incl   -0x8(%ebp)
  801346:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801349:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134c:	7c d9                	jl     801327 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80134e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c6 00 00             	movb   $0x0,(%eax)
}
  801359:	90                   	nop
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80135f:	8b 45 14             	mov    0x14(%ebp),%eax
  801362:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801368:	8b 45 14             	mov    0x14(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	01 d0                	add    %edx,%eax
  801379:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137f:	eb 0c                	jmp    80138d <strsplit+0x31>
			*string++ = 0;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8d 50 01             	lea    0x1(%eax),%edx
  801387:	89 55 08             	mov    %edx,0x8(%ebp)
  80138a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	84 c0                	test   %al,%al
  801394:	74 18                	je     8013ae <strsplit+0x52>
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	0f be c0             	movsbl %al,%eax
  80139e:	50                   	push   %eax
  80139f:	ff 75 0c             	pushl  0xc(%ebp)
  8013a2:	e8 32 fb ff ff       	call   800ed9 <strchr>
  8013a7:	83 c4 08             	add    $0x8,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	75 d3                	jne    801381 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	84 c0                	test   %al,%al
  8013b5:	74 5a                	je     801411 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ba:	8b 00                	mov    (%eax),%eax
  8013bc:	83 f8 0f             	cmp    $0xf,%eax
  8013bf:	75 07                	jne    8013c8 <strsplit+0x6c>
		{
			return 0;
  8013c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c6:	eb 66                	jmp    80142e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cb:	8b 00                	mov    (%eax),%eax
  8013cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d3:	89 0a                	mov    %ecx,(%edx)
  8013d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013df:	01 c2                	add    %eax,%edx
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e6:	eb 03                	jmp    8013eb <strsplit+0x8f>
			string++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	84 c0                	test   %al,%al
  8013f2:	74 8b                	je     80137f <strsplit+0x23>
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	0f be c0             	movsbl %al,%eax
  8013fc:	50                   	push   %eax
  8013fd:	ff 75 0c             	pushl  0xc(%ebp)
  801400:	e8 d4 fa ff ff       	call   800ed9 <strchr>
  801405:	83 c4 08             	add    $0x8,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	74 dc                	je     8013e8 <strsplit+0x8c>
			string++;
	}
  80140c:	e9 6e ff ff ff       	jmp    80137f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801411:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801412:	8b 45 14             	mov    0x14(%ebp),%eax
  801415:	8b 00                	mov    (%eax),%eax
  801417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141e:	8b 45 10             	mov    0x10(%ebp),%eax
  801421:	01 d0                	add    %edx,%eax
  801423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801429:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	68 28 40 80 00       	push   $0x804028
  80143e:	68 3f 01 00 00       	push   $0x13f
  801443:	68 4a 40 80 00       	push   $0x80404a
  801448:	e8 9a 21 00 00       	call   8035e7 <_panic>

0080144d <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801453:	83 ec 0c             	sub    $0xc,%esp
  801456:	ff 75 08             	pushl  0x8(%ebp)
  801459:	e8 90 0c 00 00       	call   8020ee <sys_sbrk>
  80145e:	83 c4 10             	add    $0x10,%esp
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801469:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146d:	75 0a                	jne    801479 <malloc+0x16>
		return NULL;
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
  801474:	e9 9e 01 00 00       	jmp    801617 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801479:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801480:	77 2c                	ja     8014ae <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801482:	e8 eb 0a 00 00       	call   801f72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801487:	85 c0                	test   %eax,%eax
  801489:	74 19                	je     8014a4 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80148b:	83 ec 0c             	sub    $0xc,%esp
  80148e:	ff 75 08             	pushl  0x8(%ebp)
  801491:	e8 85 11 00 00       	call   80261b <alloc_block_FF>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80149c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80149f:	e9 73 01 00 00       	jmp    801617 <malloc+0x1b4>
		} else {
			return NULL;
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a9:	e9 69 01 00 00       	jmp    801617 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8014ae:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014bb:	01 d0                	add    %edx,%eax
  8014bd:	48                   	dec    %eax
  8014be:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c9:	f7 75 e0             	divl   -0x20(%ebp)
  8014cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014cf:	29 d0                	sub    %edx,%eax
  8014d1:	c1 e8 0c             	shr    $0xc,%eax
  8014d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8014d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8014de:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8014e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8014ea:	8b 40 7c             	mov    0x7c(%eax),%eax
  8014ed:	05 00 10 00 00       	add    $0x1000,%eax
  8014f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8014f5:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8014fa:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8014fd:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801500:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801507:	8b 55 08             	mov    0x8(%ebp),%edx
  80150a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	48                   	dec    %eax
  801510:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801513:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801516:	ba 00 00 00 00       	mov    $0x0,%edx
  80151b:	f7 75 cc             	divl   -0x34(%ebp)
  80151e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801521:	29 d0                	sub    %edx,%eax
  801523:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801526:	76 0a                	jbe    801532 <malloc+0xcf>
		return NULL;
  801528:	b8 00 00 00 00       	mov    $0x0,%eax
  80152d:	e9 e5 00 00 00       	jmp    801617 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801535:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801538:	eb 48                	jmp    801582 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80153a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801540:	c1 e8 0c             	shr    $0xc,%eax
  801543:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801546:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801549:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801550:	85 c0                	test   %eax,%eax
  801552:	75 11                	jne    801565 <malloc+0x102>
			freePagesCount++;
  801554:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801557:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80155b:	75 16                	jne    801573 <malloc+0x110>
				start = i;
  80155d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801560:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801563:	eb 0e                	jmp    801573 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801565:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80156c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801576:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801579:	74 12                	je     80158d <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80157b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801582:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801589:	76 af                	jbe    80153a <malloc+0xd7>
  80158b:	eb 01                	jmp    80158e <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80158d:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80158e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801592:	74 08                	je     80159c <malloc+0x139>
  801594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801597:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80159a:	74 07                	je     8015a3 <malloc+0x140>
		return NULL;
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a1:	eb 74                	jmp    801617 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a6:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8015a9:	c1 e8 0c             	shr    $0xc,%eax
  8015ac:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8015af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015b2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015b5:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8015bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015c2:	eb 11                	jmp    8015d5 <malloc+0x172>
		markedPages[i] = 1;
  8015c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c7:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8015ce:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8015d2:	ff 45 e8             	incl   -0x18(%ebp)
  8015d5:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8015d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015db:	01 d0                	add    %edx,%eax
  8015dd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015e0:	77 e2                	ja     8015c4 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8015e2:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8015e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ec:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8015ef:	01 d0                	add    %edx,%eax
  8015f1:	48                   	dec    %eax
  8015f2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8015f5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8015f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fd:	f7 75 bc             	divl   -0x44(%ebp)
  801600:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801603:	29 d0                	sub    %edx,%eax
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	50                   	push   %eax
  801609:	ff 75 f0             	pushl  -0x10(%ebp)
  80160c:	e8 14 0b 00 00       	call   802125 <sys_allocate_user_mem>
  801611:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  80161f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801623:	0f 84 ee 00 00 00    	je     801717 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801629:	a1 20 50 80 00       	mov    0x805020,%eax
  80162e:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801631:	3b 45 08             	cmp    0x8(%ebp),%eax
  801634:	77 09                	ja     80163f <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801636:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  80163d:	76 14                	jbe    801653 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	68 58 40 80 00       	push   $0x804058
  801647:	6a 68                	push   $0x68
  801649:	68 72 40 80 00       	push   $0x804072
  80164e:	e8 94 1f 00 00       	call   8035e7 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801653:	a1 20 50 80 00       	mov    0x805020,%eax
  801658:	8b 40 74             	mov    0x74(%eax),%eax
  80165b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80165e:	77 20                	ja     801680 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801660:	a1 20 50 80 00       	mov    0x805020,%eax
  801665:	8b 40 78             	mov    0x78(%eax),%eax
  801668:	3b 45 08             	cmp    0x8(%ebp),%eax
  80166b:	76 13                	jbe    801680 <free+0x67>
		free_block(virtual_address);
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 6c 16 00 00       	call   802ce4 <free_block>
  801678:	83 c4 10             	add    $0x10,%esp
		return;
  80167b:	e9 98 00 00 00       	jmp    801718 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801680:	8b 55 08             	mov    0x8(%ebp),%edx
  801683:	a1 20 50 80 00       	mov    0x805020,%eax
  801688:	8b 40 7c             	mov    0x7c(%eax),%eax
  80168b:	29 c2                	sub    %eax,%edx
  80168d:	89 d0                	mov    %edx,%eax
  80168f:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801694:	c1 e8 0c             	shr    $0xc,%eax
  801697:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80169a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016a1:	eb 16                	jmp    8016b9 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8016a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a9:	01 d0                	add    %edx,%eax
  8016ab:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  8016b2:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8016b6:	ff 45 f4             	incl   -0xc(%ebp)
  8016b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bc:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8016c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016c6:	7f db                	jg     8016a3 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  8016c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cb:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8016d2:	c1 e0 0c             	shl    $0xc,%eax
  8016d5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016de:	eb 1a                	jmp    8016fa <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	68 00 10 00 00       	push   $0x1000
  8016e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8016eb:	e8 19 0a 00 00       	call   802109 <sys_free_user_mem>
  8016f0:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  8016f3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8016fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801700:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801702:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801705:	77 d9                	ja     8016e0 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170a:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801711:	00 00 00 00 
  801715:	eb 01                	jmp    801718 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801717:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	83 ec 58             	sub    $0x58,%esp
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801726:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172a:	75 0a                	jne    801736 <smalloc+0x1c>
		return NULL;
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
  801731:	e9 7d 01 00 00       	jmp    8018b3 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801736:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801743:	01 d0                	add    %edx,%eax
  801745:	48                   	dec    %eax
  801746:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174c:	ba 00 00 00 00       	mov    $0x0,%edx
  801751:	f7 75 e4             	divl   -0x1c(%ebp)
  801754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801757:	29 d0                	sub    %edx,%eax
  801759:	c1 e8 0c             	shr    $0xc,%eax
  80175c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  80175f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801766:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80176d:	a1 20 50 80 00       	mov    0x805020,%eax
  801772:	8b 40 7c             	mov    0x7c(%eax),%eax
  801775:	05 00 10 00 00       	add    $0x1000,%eax
  80177a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80177d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801782:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801785:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801788:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801795:	01 d0                	add    %edx,%eax
  801797:	48                   	dec    %eax
  801798:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80179b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	f7 75 d0             	divl   -0x30(%ebp)
  8017a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017a9:	29 d0                	sub    %edx,%eax
  8017ab:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017ae:	76 0a                	jbe    8017ba <smalloc+0xa0>
		return NULL;
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b5:	e9 f9 00 00 00       	jmp    8018b3 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017c0:	eb 48                	jmp    80180a <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  8017c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8017c8:	c1 e8 0c             	shr    $0xc,%eax
  8017cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  8017ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017d1:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	75 11                	jne    8017ed <smalloc+0xd3>
			freePagesCount++;
  8017dc:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8017df:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017e3:	75 16                	jne    8017fb <smalloc+0xe1>
				start = s;
  8017e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017eb:	eb 0e                	jmp    8017fb <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  8017ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8017f4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fe:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801801:	74 12                	je     801815 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801803:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80180a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801811:	76 af                	jbe    8017c2 <smalloc+0xa8>
  801813:	eb 01                	jmp    801816 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801815:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801816:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80181a:	74 08                	je     801824 <smalloc+0x10a>
  80181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801822:	74 0a                	je     80182e <smalloc+0x114>
		return NULL;
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
  801829:	e9 85 00 00 00       	jmp    8018b3 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80182e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801831:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801834:	c1 e8 0c             	shr    $0xc,%eax
  801837:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80183a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80183d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801840:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801847:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80184a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80184d:	eb 11                	jmp    801860 <smalloc+0x146>
		markedPages[s] = 1;
  80184f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801852:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801859:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80185d:	ff 45 e8             	incl   -0x18(%ebp)
  801860:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801863:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80186b:	77 e2                	ja     80184f <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  80186d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801870:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801874:	52                   	push   %edx
  801875:	50                   	push   %eax
  801876:	ff 75 0c             	pushl  0xc(%ebp)
  801879:	ff 75 08             	pushl  0x8(%ebp)
  80187c:	e8 8f 04 00 00       	call   801d10 <sys_createSharedObject>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801887:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80188b:	78 12                	js     80189f <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  80188d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801890:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801893:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	eb 14                	jmp    8018b3 <smalloc+0x199>
	}
	free((void*) start);
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	50                   	push   %eax
  8018a6:	e8 6e fd ff ff       	call   801619 <free>
  8018ab:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  8018bb:	83 ec 08             	sub    $0x8,%esp
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	e8 71 04 00 00       	call   801d3a <sys_getSizeOfSharedObject>
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8018cf:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8018d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018dc:	01 d0                	add    %edx,%eax
  8018de:	48                   	dec    %eax
  8018df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ea:	f7 75 e0             	divl   -0x20(%ebp)
  8018ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f0:	29 d0                	sub    %edx,%eax
  8018f2:	c1 e8 0c             	shr    $0xc,%eax
  8018f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  8018f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8018ff:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801906:	a1 20 50 80 00       	mov    0x805020,%eax
  80190b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80190e:	05 00 10 00 00       	add    $0x1000,%eax
  801913:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801916:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80191b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80191e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801921:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801928:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80192b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80192e:	01 d0                	add    %edx,%eax
  801930:	48                   	dec    %eax
  801931:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801934:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	f7 75 cc             	divl   -0x34(%ebp)
  80193f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801942:	29 d0                	sub    %edx,%eax
  801944:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801947:	76 0a                	jbe    801953 <sget+0x9e>
		return NULL;
  801949:	b8 00 00 00 00       	mov    $0x0,%eax
  80194e:	e9 f7 00 00 00       	jmp    801a4a <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801956:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801959:	eb 48                	jmp    8019a3 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  80195b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801961:	c1 e8 0c             	shr    $0xc,%eax
  801964:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801967:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80196a:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801971:	85 c0                	test   %eax,%eax
  801973:	75 11                	jne    801986 <sget+0xd1>
			free_Pages_Count++;
  801975:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801978:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80197c:	75 16                	jne    801994 <sget+0xdf>
				start = s;
  80197e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801981:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801984:	eb 0e                	jmp    801994 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801986:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80198d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80199a:	74 12                	je     8019ae <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80199c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8019a3:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8019aa:	76 af                	jbe    80195b <sget+0xa6>
  8019ac:	eb 01                	jmp    8019af <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8019ae:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8019af:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019b3:	74 08                	je     8019bd <sget+0x108>
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019bb:	74 0a                	je     8019c7 <sget+0x112>
		return NULL;
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	e9 83 00 00 00       	jmp    801a4a <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8019c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ca:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8019cd:	c1 e8 0c             	shr    $0xc,%eax
  8019d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  8019d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019d9:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8019e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019e6:	eb 11                	jmp    8019f9 <sget+0x144>
		markedPages[k] = 1;
  8019e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019eb:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8019f2:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8019f6:	ff 45 e8             	incl   -0x18(%ebp)
  8019f9:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8019fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019ff:	01 d0                	add    %edx,%eax
  801a01:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a04:	77 e2                	ja     8019e8 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	50                   	push   %eax
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	e8 3f 03 00 00       	call   801d57 <sys_getSharedObject>
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801a1e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801a22:	78 12                	js     801a36 <sget+0x181>
		shardIDs[startPage] = ss;
  801a24:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a27:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a2a:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a34:	eb 14                	jmp    801a4a <sget+0x195>
	}
	free((void*) start);
  801a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	50                   	push   %eax
  801a3d:	e8 d7 fb ff ff       	call   801619 <free>
  801a42:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801a52:	8b 55 08             	mov    0x8(%ebp),%edx
  801a55:	a1 20 50 80 00       	mov    0x805020,%eax
  801a5a:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a5d:	29 c2                	sub    %eax,%edx
  801a5f:	89 d0                	mov    %edx,%eax
  801a61:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801a66:	c1 e8 0c             	shr    $0xc,%eax
  801a69:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6f:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801a76:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801a79:	83 ec 08             	sub    $0x8,%esp
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a82:	e8 ef 02 00 00       	call   801d76 <sys_freeSharedObject>
  801a87:	83 c4 10             	add    $0x10,%esp
  801a8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801a8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a91:	75 0e                	jne    801aa1 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a96:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801a9d:	ff ff ff ff 
	}

}
  801aa1:	90                   	nop
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	68 80 40 80 00       	push   $0x804080
  801ab2:	68 19 01 00 00       	push   $0x119
  801ab7:	68 72 40 80 00       	push   $0x804072
  801abc:	e8 26 1b 00 00       	call   8035e7 <_panic>

00801ac1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	68 a6 40 80 00       	push   $0x8040a6
  801acf:	68 23 01 00 00       	push   $0x123
  801ad4:	68 72 40 80 00       	push   $0x804072
  801ad9:	e8 09 1b 00 00       	call   8035e7 <_panic>

00801ade <shrink>:

}
void shrink(uint32 newSize) {
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	68 a6 40 80 00       	push   $0x8040a6
  801aec:	68 27 01 00 00       	push   $0x127
  801af1:	68 72 40 80 00       	push   $0x804072
  801af6:	e8 ec 1a 00 00       	call   8035e7 <_panic>

00801afb <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b01:	83 ec 04             	sub    $0x4,%esp
  801b04:	68 a6 40 80 00       	push   $0x8040a6
  801b09:	68 2b 01 00 00       	push   $0x12b
  801b0e:	68 72 40 80 00       	push   $0x804072
  801b13:	e8 cf 1a 00 00       	call   8035e7 <_panic>

00801b18 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	57                   	push   %edi
  801b1c:	56                   	push   %esi
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b2d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b30:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b33:	cd 30                	int    $0x30
  801b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5f                   	pop    %edi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    

00801b43 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 04             	sub    $0x4,%esp
  801b49:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801b4f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	52                   	push   %edx
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	50                   	push   %eax
  801b5f:	6a 00                	push   $0x0
  801b61:	e8 b2 ff ff ff       	call   801b18 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	90                   	nop
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_cgetc>:

int sys_cgetc(void) {
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 02                	push   $0x2
  801b7b:	e8 98 ff ff ff       	call   801b18 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_lock_cons>:

void sys_lock_cons(void) {
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 03                	push   $0x3
  801b94:	e8 7f ff ff ff       	call   801b18 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	90                   	nop
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 04                	push   $0x4
  801bae:	e8 65 ff ff ff       	call   801b18 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	90                   	nop
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 08                	push   $0x8
  801bcc:	e8 47 ff ff ff       	call   801b18 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801bdb:	8b 75 18             	mov    0x18(%ebp),%esi
  801bde:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801be1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	56                   	push   %esi
  801beb:	53                   	push   %ebx
  801bec:	51                   	push   %ecx
  801bed:	52                   	push   %edx
  801bee:	50                   	push   %eax
  801bef:	6a 09                	push   $0x9
  801bf1:	e8 22 ff ff ff       	call   801b18 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801bf9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    

00801c00 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	52                   	push   %edx
  801c10:	50                   	push   %eax
  801c11:	6a 0a                	push   $0xa
  801c13:	e8 00 ff ff ff       	call   801b18 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	ff 75 0c             	pushl  0xc(%ebp)
  801c29:	ff 75 08             	pushl  0x8(%ebp)
  801c2c:	6a 0b                	push   $0xb
  801c2e:	e8 e5 fe ff ff       	call   801b18 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 0c                	push   $0xc
  801c47:	e8 cc fe ff ff       	call   801b18 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 0d                	push   $0xd
  801c60:	e8 b3 fe ff ff       	call   801b18 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 0e                	push   $0xe
  801c79:	e8 9a fe ff ff       	call   801b18 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 0f                	push   $0xf
  801c92:	e8 81 fe ff ff       	call   801b18 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	6a 10                	push   $0x10
  801cac:	e8 67 fe ff ff       	call   801b18 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_scarce_memory>:

void sys_scarce_memory() {
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 11                	push   $0x11
  801cc5:	e8 4e fe ff ff       	call   801b18 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_cputc>:

void sys_cputc(const char c) {
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cdc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	50                   	push   %eax
  801ce9:	6a 01                	push   $0x1
  801ceb:	e8 28 fe ff ff       	call   801b18 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 14                	push   $0x14
  801d05:	e8 0e fe ff ff       	call   801b18 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 04             	sub    $0x4,%esp
  801d16:	8b 45 10             	mov    0x10(%ebp),%eax
  801d19:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801d1c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d1f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	6a 00                	push   $0x0
  801d28:	51                   	push   %ecx
  801d29:	52                   	push   %edx
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	50                   	push   %eax
  801d2e:	6a 15                	push   $0x15
  801d30:	e8 e3 fd ff ff       	call   801b18 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	52                   	push   %edx
  801d4a:	50                   	push   %eax
  801d4b:	6a 16                	push   $0x16
  801d4d:	e8 c6 fd ff ff       	call   801b18 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801d5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	51                   	push   %ecx
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	6a 17                	push   $0x17
  801d6c:	e8 a7 fd ff ff       	call   801b18 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	6a 18                	push   $0x18
  801d89:	e8 8a fd ff ff       	call   801b18 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	6a 00                	push   $0x0
  801d9b:	ff 75 14             	pushl  0x14(%ebp)
  801d9e:	ff 75 10             	pushl  0x10(%ebp)
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	50                   	push   %eax
  801da5:	6a 19                	push   $0x19
  801da7:	e8 6c fd ff ff       	call   801b18 <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_run_env>:

void sys_run_env(int32 envId) {
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	50                   	push   %eax
  801dc0:	6a 1a                	push   $0x1a
  801dc2:	e8 51 fd ff ff       	call   801b18 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	90                   	nop
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	50                   	push   %eax
  801ddc:	6a 1b                	push   $0x1b
  801dde:	e8 35 fd ff ff       	call   801b18 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_getenvid>:

int32 sys_getenvid(void) {
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 05                	push   $0x5
  801df7:	e8 1c fd ff ff       	call   801b18 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 06                	push   $0x6
  801e10:	e8 03 fd ff ff       	call   801b18 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 07                	push   $0x7
  801e29:	e8 ea fc ff ff       	call   801b18 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_exit_env>:

void sys_exit_env(void) {
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 1c                	push   $0x1c
  801e42:	e8 d1 fc ff ff       	call   801b18 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	90                   	nop
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801e53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e56:	8d 50 04             	lea    0x4(%eax),%edx
  801e59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	52                   	push   %edx
  801e63:	50                   	push   %eax
  801e64:	6a 1d                	push   $0x1d
  801e66:	e8 ad fc ff ff       	call   801b18 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801e6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e77:	89 01                	mov    %eax,(%ecx)
  801e79:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	c9                   	leave  
  801e80:	c2 04 00             	ret    $0x4

00801e83 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	ff 75 10             	pushl  0x10(%ebp)
  801e8d:	ff 75 0c             	pushl  0xc(%ebp)
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	6a 13                	push   $0x13
  801e95:	e8 7e fc ff ff       	call   801b18 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801e9d:	90                   	nop
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_rcr2>:
uint32 sys_rcr2() {
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 1e                	push   $0x1e
  801eaf:	e8 64 fc ff ff       	call   801b18 <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 04             	sub    $0x4,%esp
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ec5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	50                   	push   %eax
  801ed2:	6a 1f                	push   $0x1f
  801ed4:	e8 3f fc ff ff       	call   801b18 <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
	return;
  801edc:	90                   	nop
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <rsttst>:
void rsttst() {
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 21                	push   $0x21
  801eee:	e8 25 fc ff ff       	call   801b18 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
	return;
  801ef6:	90                   	nop
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	8b 45 14             	mov    0x14(%ebp),%eax
  801f02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f05:	8b 55 18             	mov    0x18(%ebp),%edx
  801f08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	ff 75 10             	pushl  0x10(%ebp)
  801f11:	ff 75 0c             	pushl  0xc(%ebp)
  801f14:	ff 75 08             	pushl  0x8(%ebp)
  801f17:	6a 20                	push   $0x20
  801f19:	e8 fa fb ff ff       	call   801b18 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
	return;
  801f21:	90                   	nop
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <chktst>:
void chktst(uint32 n) {
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	ff 75 08             	pushl  0x8(%ebp)
  801f32:	6a 22                	push   $0x22
  801f34:	e8 df fb ff ff       	call   801b18 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
	return;
  801f3c:	90                   	nop
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <inctst>:

void inctst() {
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 23                	push   $0x23
  801f4e:	e8 c5 fb ff ff       	call   801b18 <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
	return;
  801f56:	90                   	nop
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <gettst>:
uint32 gettst() {
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 24                	push   $0x24
  801f68:	e8 ab fb ff ff       	call   801b18 <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 25                	push   $0x25
  801f84:	e8 8f fb ff ff       	call   801b18 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
  801f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f8f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f93:	75 07                	jne    801f9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f95:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9a:	eb 05                	jmp    801fa1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 25                	push   $0x25
  801fb5:	e8 5e fb ff ff       	call   801b18 <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
  801fbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fc0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fc4:	75 07                	jne    801fcd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcb:	eb 05                	jmp    801fd2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 25                	push   $0x25
  801fe6:	e8 2d fb ff ff       	call   801b18 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
  801fee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ff1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ff5:	75 07                	jne    801ffe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ff7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffc:	eb 05                	jmp    802003 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 25                	push   $0x25
  802017:	e8 fc fa ff ff       	call   801b18 <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
  80201f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802022:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802026:	75 07                	jne    80202f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802028:	b8 01 00 00 00       	mov    $0x1,%eax
  80202d:	eb 05                	jmp    802034 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	ff 75 08             	pushl  0x8(%ebp)
  802044:	6a 26                	push   $0x26
  802046:	e8 cd fa ff ff       	call   801b18 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
	return;
  80204e:	90                   	nop
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802055:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802058:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	53                   	push   %ebx
  802064:	51                   	push   %ecx
  802065:	52                   	push   %edx
  802066:	50                   	push   %eax
  802067:	6a 27                	push   $0x27
  802069:	e8 aa fa ff ff       	call   801b18 <syscall>
  80206e:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802071:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	52                   	push   %edx
  802086:	50                   	push   %eax
  802087:	6a 28                	push   $0x28
  802089:	e8 8a fa ff ff       	call   801b18 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802096:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802099:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	6a 00                	push   $0x0
  8020a1:	51                   	push   %ecx
  8020a2:	ff 75 10             	pushl  0x10(%ebp)
  8020a5:	52                   	push   %edx
  8020a6:	50                   	push   %eax
  8020a7:	6a 29                	push   $0x29
  8020a9:	e8 6a fa ff ff       	call   801b18 <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	ff 75 10             	pushl  0x10(%ebp)
  8020bd:	ff 75 0c             	pushl  0xc(%ebp)
  8020c0:	ff 75 08             	pushl  0x8(%ebp)
  8020c3:	6a 12                	push   $0x12
  8020c5:	e8 4e fa ff ff       	call   801b18 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
	return;
  8020cd:	90                   	nop
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8020d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	52                   	push   %edx
  8020e0:	50                   	push   %eax
  8020e1:	6a 2a                	push   $0x2a
  8020e3:	e8 30 fa ff ff       	call   801b18 <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
	return;
  8020eb:	90                   	nop
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	50                   	push   %eax
  8020fd:	6a 2b                	push   $0x2b
  8020ff:	e8 14 fa ff ff       	call   801b18 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	ff 75 0c             	pushl  0xc(%ebp)
  802115:	ff 75 08             	pushl  0x8(%ebp)
  802118:	6a 2c                	push   $0x2c
  80211a:	e8 f9 f9 ff ff       	call   801b18 <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
	return;
  802122:	90                   	nop
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	ff 75 0c             	pushl  0xc(%ebp)
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	6a 2d                	push   $0x2d
  802136:	e8 dd f9 ff ff       	call   801b18 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
	return;
  80213e:	90                   	nop
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	50                   	push   %eax
  802150:	6a 2f                	push   $0x2f
  802152:	e8 c1 f9 ff ff       	call   801b18 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
	return;
  80215a:	90                   	nop
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802160:	8b 55 0c             	mov    0xc(%ebp),%edx
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	52                   	push   %edx
  80216d:	50                   	push   %eax
  80216e:	6a 30                	push   $0x30
  802170:	e8 a3 f9 ff ff       	call   801b18 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
	return;
  802178:	90                   	nop
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	50                   	push   %eax
  80218a:	6a 31                	push   $0x31
  80218c:	e8 87 f9 ff ff       	call   801b18 <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
	return;
  802194:	90                   	nop
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80219a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	52                   	push   %edx
  8021a7:	50                   	push   %eax
  8021a8:	6a 2e                	push   $0x2e
  8021aa:	e8 69 f9 ff ff       	call   801b18 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
    return;
  8021b2:	90                   	nop
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	83 e8 04             	sub    $0x4,%eax
  8021c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c7:	8b 00                	mov    (%eax),%eax
  8021c9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	83 e8 04             	sub    $0x4,%eax
  8021da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8021dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	83 e0 01             	and    $0x1,%eax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	0f 94 c0             	sete   %al
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8021f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fc:	83 f8 02             	cmp    $0x2,%eax
  8021ff:	74 2b                	je     80222c <alloc_block+0x40>
  802201:	83 f8 02             	cmp    $0x2,%eax
  802204:	7f 07                	jg     80220d <alloc_block+0x21>
  802206:	83 f8 01             	cmp    $0x1,%eax
  802209:	74 0e                	je     802219 <alloc_block+0x2d>
  80220b:	eb 58                	jmp    802265 <alloc_block+0x79>
  80220d:	83 f8 03             	cmp    $0x3,%eax
  802210:	74 2d                	je     80223f <alloc_block+0x53>
  802212:	83 f8 04             	cmp    $0x4,%eax
  802215:	74 3b                	je     802252 <alloc_block+0x66>
  802217:	eb 4c                	jmp    802265 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	e8 f7 03 00 00       	call   80261b <alloc_block_FF>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80222a:	eb 4a                	jmp    802276 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80222c:	83 ec 0c             	sub    $0xc,%esp
  80222f:	ff 75 08             	pushl  0x8(%ebp)
  802232:	e8 f0 11 00 00       	call   803427 <alloc_block_NF>
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80223d:	eb 37                	jmp    802276 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80223f:	83 ec 0c             	sub    $0xc,%esp
  802242:	ff 75 08             	pushl  0x8(%ebp)
  802245:	e8 08 08 00 00       	call   802a52 <alloc_block_BF>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802250:	eb 24                	jmp    802276 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802252:	83 ec 0c             	sub    $0xc,%esp
  802255:	ff 75 08             	pushl  0x8(%ebp)
  802258:	e8 ad 11 00 00       	call   80340a <alloc_block_WF>
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802263:	eb 11                	jmp    802276 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802265:	83 ec 0c             	sub    $0xc,%esp
  802268:	68 b8 40 80 00       	push   $0x8040b8
  80226d:	e8 41 e4 ff ff       	call   8006b3 <cprintf>
  802272:	83 c4 10             	add    $0x10,%esp
		break;
  802275:	90                   	nop
	}
	return va;
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	53                   	push   %ebx
  80227f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	68 d8 40 80 00       	push   $0x8040d8
  80228a:	e8 24 e4 ff ff       	call   8006b3 <cprintf>
  80228f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802292:	83 ec 0c             	sub    $0xc,%esp
  802295:	68 03 41 80 00       	push   $0x804103
  80229a:	e8 14 e4 ff ff       	call   8006b3 <cprintf>
  80229f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a8:	eb 37                	jmp    8022e1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022aa:	83 ec 0c             	sub    $0xc,%esp
  8022ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b0:	e8 19 ff ff ff       	call   8021ce <is_free_block>
  8022b5:	83 c4 10             	add    $0x10,%esp
  8022b8:	0f be d8             	movsbl %al,%ebx
  8022bb:	83 ec 0c             	sub    $0xc,%esp
  8022be:	ff 75 f4             	pushl  -0xc(%ebp)
  8022c1:	e8 ef fe ff ff       	call   8021b5 <get_block_size>
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	53                   	push   %ebx
  8022cd:	50                   	push   %eax
  8022ce:	68 1b 41 80 00       	push   $0x80411b
  8022d3:	e8 db e3 ff ff       	call   8006b3 <cprintf>
  8022d8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8022db:	8b 45 10             	mov    0x10(%ebp),%eax
  8022de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e5:	74 07                	je     8022ee <print_blocks_list+0x73>
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	eb 05                	jmp    8022f3 <print_blocks_list+0x78>
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f3:	89 45 10             	mov    %eax,0x10(%ebp)
  8022f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	75 ad                	jne    8022aa <print_blocks_list+0x2f>
  8022fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802301:	75 a7                	jne    8022aa <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802303:	83 ec 0c             	sub    $0xc,%esp
  802306:	68 d8 40 80 00       	push   $0x8040d8
  80230b:	e8 a3 e3 ff ff       	call   8006b3 <cprintf>
  802310:	83 c4 10             	add    $0x10,%esp

}
  802313:	90                   	nop
  802314:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80231f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802322:	83 e0 01             	and    $0x1,%eax
  802325:	85 c0                	test   %eax,%eax
  802327:	74 03                	je     80232c <initialize_dynamic_allocator+0x13>
  802329:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80232c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802330:	0f 84 f8 00 00 00    	je     80242e <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802336:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  80233d:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802340:	a1 40 50 98 00       	mov    0x985040,%eax
  802345:	85 c0                	test   %eax,%eax
  802347:	0f 84 e2 00 00 00    	je     80242f <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80235c:	8b 55 08             	mov    0x8(%ebp),%edx
  80235f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802362:	01 d0                	add    %edx,%eax
  802364:	83 e8 04             	sub    $0x4,%eax
  802367:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	83 c0 08             	add    $0x8,%eax
  802379:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80237c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237f:	83 e8 08             	sub    $0x8,%eax
  802382:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802385:	83 ec 04             	sub    $0x4,%esp
  802388:	6a 00                	push   $0x0
  80238a:	ff 75 e8             	pushl  -0x18(%ebp)
  80238d:	ff 75 ec             	pushl  -0x14(%ebp)
  802390:	e8 9c 00 00 00       	call   802431 <set_block_data>
  802395:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8023a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8023ab:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  8023b2:	00 00 00 
  8023b5:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  8023bc:	00 00 00 
  8023bf:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  8023c6:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8023c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023cd:	75 17                	jne    8023e6 <initialize_dynamic_allocator+0xcd>
  8023cf:	83 ec 04             	sub    $0x4,%esp
  8023d2:	68 34 41 80 00       	push   $0x804134
  8023d7:	68 80 00 00 00       	push   $0x80
  8023dc:	68 57 41 80 00       	push   $0x804157
  8023e1:	e8 01 12 00 00       	call   8035e7 <_panic>
  8023e6:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8023ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ef:	89 10                	mov    %edx,(%eax)
  8023f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f4:	8b 00                	mov    (%eax),%eax
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	74 0d                	je     802407 <initialize_dynamic_allocator+0xee>
  8023fa:	a1 48 50 98 00       	mov    0x985048,%eax
  8023ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802402:	89 50 04             	mov    %edx,0x4(%eax)
  802405:	eb 08                	jmp    80240f <initialize_dynamic_allocator+0xf6>
  802407:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80240f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802412:	a3 48 50 98 00       	mov    %eax,0x985048
  802417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802421:	a1 54 50 98 00       	mov    0x985054,%eax
  802426:	40                   	inc    %eax
  802427:	a3 54 50 98 00       	mov    %eax,0x985054
  80242c:	eb 01                	jmp    80242f <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80242e:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243a:	83 e0 01             	and    $0x1,%eax
  80243d:	85 c0                	test   %eax,%eax
  80243f:	74 03                	je     802444 <set_block_data+0x13>
	{
		totalSize++;
  802441:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	83 e8 04             	sub    $0x4,%eax
  80244a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  80244d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802450:	83 e0 fe             	and    $0xfffffffe,%eax
  802453:	89 c2                	mov    %eax,%edx
  802455:	8b 45 10             	mov    0x10(%ebp),%eax
  802458:	83 e0 01             	and    $0x1,%eax
  80245b:	09 c2                	or     %eax,%edx
  80245d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802460:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802462:	8b 45 0c             	mov    0xc(%ebp),%eax
  802465:	8d 50 f8             	lea    -0x8(%eax),%edx
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	01 d0                	add    %edx,%eax
  80246d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802470:	8b 45 0c             	mov    0xc(%ebp),%eax
  802473:	83 e0 fe             	and    $0xfffffffe,%eax
  802476:	89 c2                	mov    %eax,%edx
  802478:	8b 45 10             	mov    0x10(%ebp),%eax
  80247b:	83 e0 01             	and    $0x1,%eax
  80247e:	09 c2                	or     %eax,%edx
  802480:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802483:	89 10                	mov    %edx,(%eax)
}
  802485:	90                   	nop
  802486:	c9                   	leave  
  802487:	c3                   	ret    

00802488 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
  80248b:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80248e:	a1 48 50 98 00       	mov    0x985048,%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	75 68                	jne    8024ff <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802497:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249b:	75 17                	jne    8024b4 <insert_sorted_in_freeList+0x2c>
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	68 34 41 80 00       	push   $0x804134
  8024a5:	68 9d 00 00 00       	push   $0x9d
  8024aa:	68 57 41 80 00       	push   $0x804157
  8024af:	e8 33 11 00 00       	call   8035e7 <_panic>
  8024b4:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 0d                	je     8024d5 <insert_sorted_in_freeList+0x4d>
  8024c8:	a1 48 50 98 00       	mov    0x985048,%eax
  8024cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d0:	89 50 04             	mov    %edx,0x4(%eax)
  8024d3:	eb 08                	jmp    8024dd <insert_sorted_in_freeList+0x55>
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	a3 48 50 98 00       	mov    %eax,0x985048
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ef:	a1 54 50 98 00       	mov    0x985054,%eax
  8024f4:	40                   	inc    %eax
  8024f5:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8024fa:	e9 1a 01 00 00       	jmp    802619 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8024ff:	a1 48 50 98 00       	mov    0x985048,%eax
  802504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802507:	eb 7f                	jmp    802588 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250f:	76 6f                	jbe    802580 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802511:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802515:	74 06                	je     80251d <insert_sorted_in_freeList+0x95>
  802517:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80251b:	75 17                	jne    802534 <insert_sorted_in_freeList+0xac>
  80251d:	83 ec 04             	sub    $0x4,%esp
  802520:	68 70 41 80 00       	push   $0x804170
  802525:	68 a6 00 00 00       	push   $0xa6
  80252a:	68 57 41 80 00       	push   $0x804157
  80252f:	e8 b3 10 00 00       	call   8035e7 <_panic>
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 50 04             	mov    0x4(%eax),%edx
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	89 50 04             	mov    %edx,0x4(%eax)
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802546:	89 10                	mov    %edx,(%eax)
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	74 0d                	je     80255f <insert_sorted_in_freeList+0xd7>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 04             	mov    0x4(%eax),%eax
  802558:	8b 55 08             	mov    0x8(%ebp),%edx
  80255b:	89 10                	mov    %edx,(%eax)
  80255d:	eb 08                	jmp    802567 <insert_sorted_in_freeList+0xdf>
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	a3 48 50 98 00       	mov    %eax,0x985048
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 55 08             	mov    0x8(%ebp),%edx
  80256d:	89 50 04             	mov    %edx,0x4(%eax)
  802570:	a1 54 50 98 00       	mov    0x985054,%eax
  802575:	40                   	inc    %eax
  802576:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  80257b:	e9 99 00 00 00       	jmp    802619 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802580:	a1 50 50 98 00       	mov    0x985050,%eax
  802585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258c:	74 07                	je     802595 <insert_sorted_in_freeList+0x10d>
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	eb 05                	jmp    80259a <insert_sorted_in_freeList+0x112>
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
  80259a:	a3 50 50 98 00       	mov    %eax,0x985050
  80259f:	a1 50 50 98 00       	mov    0x985050,%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	0f 85 5d ff ff ff    	jne    802509 <insert_sorted_in_freeList+0x81>
  8025ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b0:	0f 85 53 ff ff ff    	jne    802509 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8025b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025ba:	75 17                	jne    8025d3 <insert_sorted_in_freeList+0x14b>
  8025bc:	83 ec 04             	sub    $0x4,%esp
  8025bf:	68 a8 41 80 00       	push   $0x8041a8
  8025c4:	68 ab 00 00 00       	push   $0xab
  8025c9:	68 57 41 80 00       	push   $0x804157
  8025ce:	e8 14 10 00 00       	call   8035e7 <_panic>
  8025d3:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	89 50 04             	mov    %edx,0x4(%eax)
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 0c                	je     8025f5 <insert_sorted_in_freeList+0x16d>
  8025e9:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8025ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f1:	89 10                	mov    %edx,(%eax)
  8025f3:	eb 08                	jmp    8025fd <insert_sorted_in_freeList+0x175>
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	a3 48 50 98 00       	mov    %eax,0x985048
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802605:	8b 45 08             	mov    0x8(%ebp),%eax
  802608:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260e:	a1 54 50 98 00       	mov    0x985054,%eax
  802613:	40                   	inc    %eax
  802614:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	83 e0 01             	and    $0x1,%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	74 03                	je     80262e <alloc_block_FF+0x13>
  80262b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80262e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802632:	77 07                	ja     80263b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802634:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80263b:	a1 40 50 98 00       	mov    0x985040,%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	75 63                	jne    8026a7 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	83 c0 10             	add    $0x10,%eax
  80264a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80264d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802654:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265a:	01 d0                	add    %edx,%eax
  80265c:	48                   	dec    %eax
  80265d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802660:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802663:	ba 00 00 00 00       	mov    $0x0,%edx
  802668:	f7 75 ec             	divl   -0x14(%ebp)
  80266b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266e:	29 d0                	sub    %edx,%eax
  802670:	c1 e8 0c             	shr    $0xc,%eax
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	50                   	push   %eax
  802677:	e8 d1 ed ff ff       	call   80144d <sbrk>
  80267c:	83 c4 10             	add    $0x10,%esp
  80267f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802682:	83 ec 0c             	sub    $0xc,%esp
  802685:	6a 00                	push   $0x0
  802687:	e8 c1 ed ff ff       	call   80144d <sbrk>
  80268c:	83 c4 10             	add    $0x10,%esp
  80268f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802695:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802698:	83 ec 08             	sub    $0x8,%esp
  80269b:	50                   	push   %eax
  80269c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80269f:	e8 75 fc ff ff       	call   802319 <initialize_dynamic_allocator>
  8026a4:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8026a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026ab:	75 0a                	jne    8026b7 <alloc_block_FF+0x9c>
	{
		return NULL;
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b2:	e9 99 03 00 00       	jmp    802a50 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	83 c0 08             	add    $0x8,%eax
  8026bd:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8026c0:	a1 48 50 98 00       	mov    0x985048,%eax
  8026c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c8:	e9 03 02 00 00       	jmp    8028d0 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8026cd:	83 ec 0c             	sub    $0xc,%esp
  8026d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d3:	e8 dd fa ff ff       	call   8021b5 <get_block_size>
  8026d8:	83 c4 10             	add    $0x10,%esp
  8026db:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8026de:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8026e1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026e4:	0f 82 de 01 00 00    	jb     8028c8 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8026ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ed:	83 c0 10             	add    $0x10,%eax
  8026f0:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8026f3:	0f 87 32 01 00 00    	ja     80282b <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8026f9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8026fc:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8026ff:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802705:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802708:	01 d0                	add    %edx,%eax
  80270a:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  80270d:	83 ec 04             	sub    $0x4,%esp
  802710:	6a 00                	push   $0x0
  802712:	ff 75 98             	pushl  -0x68(%ebp)
  802715:	ff 75 94             	pushl  -0x6c(%ebp)
  802718:	e8 14 fd ff ff       	call   802431 <set_block_data>
  80271d:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802724:	74 06                	je     80272c <alloc_block_FF+0x111>
  802726:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80272a:	75 17                	jne    802743 <alloc_block_FF+0x128>
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	68 cc 41 80 00       	push   $0x8041cc
  802734:	68 de 00 00 00       	push   $0xde
  802739:	68 57 41 80 00       	push   $0x804157
  80273e:	e8 a4 0e 00 00       	call   8035e7 <_panic>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 10                	mov    (%eax),%edx
  802748:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80274b:	89 10                	mov    %edx,(%eax)
  80274d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	74 0b                	je     802761 <alloc_block_FF+0x146>
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80275e:	89 50 04             	mov    %edx,0x4(%eax)
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802767:	89 10                	mov    %edx,(%eax)
  802769:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80276c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276f:	89 50 04             	mov    %edx,0x4(%eax)
  802772:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	75 08                	jne    802783 <alloc_block_FF+0x168>
  80277b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80277e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802783:	a1 54 50 98 00       	mov    0x985054,%eax
  802788:	40                   	inc    %eax
  802789:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  80278e:	83 ec 04             	sub    $0x4,%esp
  802791:	6a 01                	push   $0x1
  802793:	ff 75 dc             	pushl  -0x24(%ebp)
  802796:	ff 75 f4             	pushl  -0xc(%ebp)
  802799:	e8 93 fc ff ff       	call   802431 <set_block_data>
  80279e:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8027a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a5:	75 17                	jne    8027be <alloc_block_FF+0x1a3>
  8027a7:	83 ec 04             	sub    $0x4,%esp
  8027aa:	68 00 42 80 00       	push   $0x804200
  8027af:	68 e3 00 00 00       	push   $0xe3
  8027b4:	68 57 41 80 00       	push   $0x804157
  8027b9:	e8 29 0e 00 00       	call   8035e7 <_panic>
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	74 10                	je     8027d7 <alloc_block_FF+0x1bc>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cf:	8b 52 04             	mov    0x4(%edx),%edx
  8027d2:	89 50 04             	mov    %edx,0x4(%eax)
  8027d5:	eb 0b                	jmp    8027e2 <alloc_block_FF+0x1c7>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 04             	mov    0x4(%eax),%eax
  8027dd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 40 04             	mov    0x4(%eax),%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	74 0f                	je     8027fb <alloc_block_FF+0x1e0>
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 04             	mov    0x4(%eax),%eax
  8027f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f5:	8b 12                	mov    (%edx),%edx
  8027f7:	89 10                	mov    %edx,(%eax)
  8027f9:	eb 0a                	jmp    802805 <alloc_block_FF+0x1ea>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	a3 48 50 98 00       	mov    %eax,0x985048
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802818:	a1 54 50 98 00       	mov    0x985054,%eax
  80281d:	48                   	dec    %eax
  80281e:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	e9 25 02 00 00       	jmp    802a50 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80282b:	83 ec 04             	sub    $0x4,%esp
  80282e:	6a 01                	push   $0x1
  802830:	ff 75 9c             	pushl  -0x64(%ebp)
  802833:	ff 75 f4             	pushl  -0xc(%ebp)
  802836:	e8 f6 fb ff ff       	call   802431 <set_block_data>
  80283b:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80283e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802842:	75 17                	jne    80285b <alloc_block_FF+0x240>
  802844:	83 ec 04             	sub    $0x4,%esp
  802847:	68 00 42 80 00       	push   $0x804200
  80284c:	68 eb 00 00 00       	push   $0xeb
  802851:	68 57 41 80 00       	push   $0x804157
  802856:	e8 8c 0d 00 00       	call   8035e7 <_panic>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	74 10                	je     802874 <alloc_block_FF+0x259>
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286c:	8b 52 04             	mov    0x4(%edx),%edx
  80286f:	89 50 04             	mov    %edx,0x4(%eax)
  802872:	eb 0b                	jmp    80287f <alloc_block_FF+0x264>
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 04             	mov    0x4(%eax),%eax
  80287a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	85 c0                	test   %eax,%eax
  802887:	74 0f                	je     802898 <alloc_block_FF+0x27d>
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 40 04             	mov    0x4(%eax),%eax
  80288f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802892:	8b 12                	mov    (%edx),%edx
  802894:	89 10                	mov    %edx,(%eax)
  802896:	eb 0a                	jmp    8028a2 <alloc_block_FF+0x287>
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	a3 48 50 98 00       	mov    %eax,0x985048
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b5:	a1 54 50 98 00       	mov    0x985054,%eax
  8028ba:	48                   	dec    %eax
  8028bb:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	e9 88 01 00 00       	jmp    802a50 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8028c8:	a1 50 50 98 00       	mov    0x985050,%eax
  8028cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d4:	74 07                	je     8028dd <alloc_block_FF+0x2c2>
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	eb 05                	jmp    8028e2 <alloc_block_FF+0x2c7>
  8028dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e2:	a3 50 50 98 00       	mov    %eax,0x985050
  8028e7:	a1 50 50 98 00       	mov    0x985050,%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	0f 85 d9 fd ff ff    	jne    8026cd <alloc_block_FF+0xb2>
  8028f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f8:	0f 85 cf fd ff ff    	jne    8026cd <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8028fe:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802905:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802908:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80290b:	01 d0                	add    %edx,%eax
  80290d:	48                   	dec    %eax
  80290e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802911:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802914:	ba 00 00 00 00       	mov    $0x0,%edx
  802919:	f7 75 d8             	divl   -0x28(%ebp)
  80291c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80291f:	29 d0                	sub    %edx,%eax
  802921:	c1 e8 0c             	shr    $0xc,%eax
  802924:	83 ec 0c             	sub    $0xc,%esp
  802927:	50                   	push   %eax
  802928:	e8 20 eb ff ff       	call   80144d <sbrk>
  80292d:	83 c4 10             	add    $0x10,%esp
  802930:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802933:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802937:	75 0a                	jne    802943 <alloc_block_FF+0x328>
		return NULL;
  802939:	b8 00 00 00 00       	mov    $0x0,%eax
  80293e:	e9 0d 01 00 00       	jmp    802a50 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802943:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802946:	83 e8 04             	sub    $0x4,%eax
  802949:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  80294c:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802953:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802956:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802959:	01 d0                	add    %edx,%eax
  80295b:	48                   	dec    %eax
  80295c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80295f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802962:	ba 00 00 00 00       	mov    $0x0,%edx
  802967:	f7 75 c8             	divl   -0x38(%ebp)
  80296a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80296d:	29 d0                	sub    %edx,%eax
  80296f:	c1 e8 02             	shr    $0x2,%eax
  802972:	c1 e0 02             	shl    $0x2,%eax
  802975:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802978:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802981:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802984:	83 e8 08             	sub    $0x8,%eax
  802987:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80298a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	83 e0 fe             	and    $0xfffffffe,%eax
  802992:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802995:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802998:	f7 d8                	neg    %eax
  80299a:	89 c2                	mov    %eax,%edx
  80299c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80299f:	01 d0                	add    %edx,%eax
  8029a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8029a4:	83 ec 0c             	sub    $0xc,%esp
  8029a7:	ff 75 b8             	pushl  -0x48(%ebp)
  8029aa:	e8 1f f8 ff ff       	call   8021ce <is_free_block>
  8029af:	83 c4 10             	add    $0x10,%esp
  8029b2:	0f be c0             	movsbl %al,%eax
  8029b5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  8029b8:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8029bc:	74 42                	je     802a00 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8029be:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029cb:	01 d0                	add    %edx,%eax
  8029cd:	48                   	dec    %eax
  8029ce:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029d1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d9:	f7 75 b0             	divl   -0x50(%ebp)
  8029dc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029df:	29 d0                	sub    %edx,%eax
  8029e1:	89 c2                	mov    %eax,%edx
  8029e3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029e6:	01 d0                	add    %edx,%eax
  8029e8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	6a 00                	push   $0x0
  8029f0:	ff 75 a8             	pushl  -0x58(%ebp)
  8029f3:	ff 75 b8             	pushl  -0x48(%ebp)
  8029f6:	e8 36 fa ff ff       	call   802431 <set_block_data>
  8029fb:	83 c4 10             	add    $0x10,%esp
  8029fe:	eb 42                	jmp    802a42 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802a00:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802a07:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a0a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a0d:	01 d0                	add    %edx,%eax
  802a0f:	48                   	dec    %eax
  802a10:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802a13:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a16:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1b:	f7 75 a4             	divl   -0x5c(%ebp)
  802a1e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a21:	29 d0                	sub    %edx,%eax
  802a23:	83 ec 04             	sub    $0x4,%esp
  802a26:	6a 00                	push   $0x0
  802a28:	50                   	push   %eax
  802a29:	ff 75 d0             	pushl  -0x30(%ebp)
  802a2c:	e8 00 fa ff ff       	call   802431 <set_block_data>
  802a31:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802a34:	83 ec 0c             	sub    $0xc,%esp
  802a37:	ff 75 d0             	pushl  -0x30(%ebp)
  802a3a:	e8 49 fa ff ff       	call   802488 <insert_sorted_in_freeList>
  802a3f:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802a42:	83 ec 0c             	sub    $0xc,%esp
  802a45:	ff 75 08             	pushl  0x8(%ebp)
  802a48:	e8 ce fb ff ff       	call   80261b <alloc_block_FF>
  802a4d:	83 c4 10             	add    $0x10,%esp
}
  802a50:	c9                   	leave  
  802a51:	c3                   	ret    

00802a52 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a52:	55                   	push   %ebp
  802a53:	89 e5                	mov    %esp,%ebp
  802a55:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802a58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5c:	75 0a                	jne    802a68 <alloc_block_BF+0x16>
	{
		return NULL;
  802a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a63:	e9 7a 02 00 00       	jmp    802ce2 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	83 c0 08             	add    $0x8,%eax
  802a6e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802a71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802a78:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a7f:	a1 48 50 98 00       	mov    0x985048,%eax
  802a84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a87:	eb 32                	jmp    802abb <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802a89:	ff 75 ec             	pushl  -0x14(%ebp)
  802a8c:	e8 24 f7 ff ff       	call   8021b5 <get_block_size>
  802a91:	83 c4 04             	add    $0x4,%esp
  802a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802a97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a9a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a9d:	72 14                	jb     802ab3 <alloc_block_BF+0x61>
  802a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aa5:	73 0c                	jae    802ab3 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802aad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ab3:	a1 50 50 98 00       	mov    0x985050,%eax
  802ab8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802abb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802abf:	74 07                	je     802ac8 <alloc_block_BF+0x76>
  802ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	eb 05                	jmp    802acd <alloc_block_BF+0x7b>
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  802acd:	a3 50 50 98 00       	mov    %eax,0x985050
  802ad2:	a1 50 50 98 00       	mov    0x985050,%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	75 ae                	jne    802a89 <alloc_block_BF+0x37>
  802adb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802adf:	75 a8                	jne    802a89 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802ae1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae5:	75 22                	jne    802b09 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aea:	83 ec 0c             	sub    $0xc,%esp
  802aed:	50                   	push   %eax
  802aee:	e8 5a e9 ff ff       	call   80144d <sbrk>
  802af3:	83 c4 10             	add    $0x10,%esp
  802af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802af9:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802afd:	75 0a                	jne    802b09 <alloc_block_BF+0xb7>
			return NULL;
  802aff:	b8 00 00 00 00       	mov    $0x0,%eax
  802b04:	e9 d9 01 00 00       	jmp    802ce2 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0c:	83 c0 10             	add    $0x10,%eax
  802b0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b12:	0f 87 32 01 00 00    	ja     802c4a <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802b1e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b27:	01 d0                	add    %edx,%eax
  802b29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802b2c:	83 ec 04             	sub    $0x4,%esp
  802b2f:	6a 00                	push   $0x0
  802b31:	ff 75 dc             	pushl  -0x24(%ebp)
  802b34:	ff 75 d8             	pushl  -0x28(%ebp)
  802b37:	e8 f5 f8 ff ff       	call   802431 <set_block_data>
  802b3c:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802b3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b43:	74 06                	je     802b4b <alloc_block_BF+0xf9>
  802b45:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802b49:	75 17                	jne    802b62 <alloc_block_BF+0x110>
  802b4b:	83 ec 04             	sub    $0x4,%esp
  802b4e:	68 cc 41 80 00       	push   $0x8041cc
  802b53:	68 49 01 00 00       	push   $0x149
  802b58:	68 57 41 80 00       	push   $0x804157
  802b5d:	e8 85 0a 00 00       	call   8035e7 <_panic>
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 10                	mov    (%eax),%edx
  802b67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b6a:	89 10                	mov    %edx,(%eax)
  802b6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	74 0b                	je     802b80 <alloc_block_BF+0x12e>
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b7d:	89 50 04             	mov    %edx,0x4(%eax)
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8e:	89 50 04             	mov    %edx,0x4(%eax)
  802b91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	85 c0                	test   %eax,%eax
  802b98:	75 08                	jne    802ba2 <alloc_block_BF+0x150>
  802b9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b9d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ba2:	a1 54 50 98 00       	mov    0x985054,%eax
  802ba7:	40                   	inc    %eax
  802ba8:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	6a 01                	push   $0x1
  802bb2:	ff 75 e8             	pushl  -0x18(%ebp)
  802bb5:	ff 75 f4             	pushl  -0xc(%ebp)
  802bb8:	e8 74 f8 ff ff       	call   802431 <set_block_data>
  802bbd:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc4:	75 17                	jne    802bdd <alloc_block_BF+0x18b>
  802bc6:	83 ec 04             	sub    $0x4,%esp
  802bc9:	68 00 42 80 00       	push   $0x804200
  802bce:	68 4e 01 00 00       	push   $0x14e
  802bd3:	68 57 41 80 00       	push   $0x804157
  802bd8:	e8 0a 0a 00 00       	call   8035e7 <_panic>
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	74 10                	je     802bf6 <alloc_block_BF+0x1a4>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bee:	8b 52 04             	mov    0x4(%edx),%edx
  802bf1:	89 50 04             	mov    %edx,0x4(%eax)
  802bf4:	eb 0b                	jmp    802c01 <alloc_block_BF+0x1af>
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 0f                	je     802c1a <alloc_block_BF+0x1c8>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c14:	8b 12                	mov    (%edx),%edx
  802c16:	89 10                	mov    %edx,(%eax)
  802c18:	eb 0a                	jmp    802c24 <alloc_block_BF+0x1d2>
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	a3 48 50 98 00       	mov    %eax,0x985048
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c37:	a1 54 50 98 00       	mov    0x985054,%eax
  802c3c:	48                   	dec    %eax
  802c3d:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	e9 98 00 00 00       	jmp    802ce2 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802c4a:	83 ec 04             	sub    $0x4,%esp
  802c4d:	6a 01                	push   $0x1
  802c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  802c52:	ff 75 f4             	pushl  -0xc(%ebp)
  802c55:	e8 d7 f7 ff ff       	call   802431 <set_block_data>
  802c5a:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c61:	75 17                	jne    802c7a <alloc_block_BF+0x228>
  802c63:	83 ec 04             	sub    $0x4,%esp
  802c66:	68 00 42 80 00       	push   $0x804200
  802c6b:	68 56 01 00 00       	push   $0x156
  802c70:	68 57 41 80 00       	push   $0x804157
  802c75:	e8 6d 09 00 00       	call   8035e7 <_panic>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	74 10                	je     802c93 <alloc_block_BF+0x241>
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8b:	8b 52 04             	mov    0x4(%edx),%edx
  802c8e:	89 50 04             	mov    %edx,0x4(%eax)
  802c91:	eb 0b                	jmp    802c9e <alloc_block_BF+0x24c>
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 40 04             	mov    0x4(%eax),%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	74 0f                	je     802cb7 <alloc_block_BF+0x265>
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 40 04             	mov    0x4(%eax),%eax
  802cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb1:	8b 12                	mov    (%edx),%edx
  802cb3:	89 10                	mov    %edx,(%eax)
  802cb5:	eb 0a                	jmp    802cc1 <alloc_block_BF+0x26f>
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	a3 48 50 98 00       	mov    %eax,0x985048
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd4:	a1 54 50 98 00       	mov    0x985054,%eax
  802cd9:	48                   	dec    %eax
  802cda:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802ce2:	c9                   	leave  
  802ce3:	c3                   	ret    

00802ce4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802ce4:	55                   	push   %ebp
  802ce5:	89 e5                	mov    %esp,%ebp
  802ce7:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802cea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cee:	0f 84 6a 02 00 00    	je     802f5e <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802cf4:	ff 75 08             	pushl  0x8(%ebp)
  802cf7:	e8 b9 f4 ff ff       	call   8021b5 <get_block_size>
  802cfc:	83 c4 04             	add    $0x4,%esp
  802cff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	83 e8 08             	sub    $0x8,%eax
  802d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	83 e0 fe             	and    $0xfffffffe,%eax
  802d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d19:	f7 d8                	neg    %eax
  802d1b:	89 c2                	mov    %eax,%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	01 d0                	add    %edx,%eax
  802d22:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802d25:	ff 75 e8             	pushl  -0x18(%ebp)
  802d28:	e8 a1 f4 ff ff       	call   8021ce <is_free_block>
  802d2d:	83 c4 04             	add    $0x4,%esp
  802d30:	0f be c0             	movsbl %al,%eax
  802d33:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802d36:	8b 55 08             	mov    0x8(%ebp),%edx
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	01 d0                	add    %edx,%eax
  802d3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802d41:	ff 75 e0             	pushl  -0x20(%ebp)
  802d44:	e8 85 f4 ff ff       	call   8021ce <is_free_block>
  802d49:	83 c4 04             	add    $0x4,%esp
  802d4c:	0f be c0             	movsbl %al,%eax
  802d4f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802d52:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802d56:	75 34                	jne    802d8c <free_block+0xa8>
  802d58:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d5c:	75 2e                	jne    802d8c <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802d5e:	ff 75 e8             	pushl  -0x18(%ebp)
  802d61:	e8 4f f4 ff ff       	call   8021b5 <get_block_size>
  802d66:	83 c4 04             	add    $0x4,%esp
  802d69:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d72:	01 d0                	add    %edx,%eax
  802d74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802d77:	6a 00                	push   $0x0
  802d79:	ff 75 d4             	pushl  -0x2c(%ebp)
  802d7c:	ff 75 e8             	pushl  -0x18(%ebp)
  802d7f:	e8 ad f6 ff ff       	call   802431 <set_block_data>
  802d84:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802d87:	e9 d3 01 00 00       	jmp    802f5f <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802d8c:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802d90:	0f 85 c8 00 00 00    	jne    802e5e <free_block+0x17a>
  802d96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d9a:	0f 85 be 00 00 00    	jne    802e5e <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802da0:	ff 75 e0             	pushl  -0x20(%ebp)
  802da3:	e8 0d f4 ff ff       	call   8021b5 <get_block_size>
  802da8:	83 c4 04             	add    $0x4,%esp
  802dab:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802db4:	01 d0                	add    %edx,%eax
  802db6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802db9:	6a 00                	push   $0x0
  802dbb:	ff 75 cc             	pushl  -0x34(%ebp)
  802dbe:	ff 75 08             	pushl  0x8(%ebp)
  802dc1:	e8 6b f6 ff ff       	call   802431 <set_block_data>
  802dc6:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802dc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dcd:	75 17                	jne    802de6 <free_block+0x102>
  802dcf:	83 ec 04             	sub    $0x4,%esp
  802dd2:	68 00 42 80 00       	push   $0x804200
  802dd7:	68 87 01 00 00       	push   $0x187
  802ddc:	68 57 41 80 00       	push   $0x804157
  802de1:	e8 01 08 00 00       	call   8035e7 <_panic>
  802de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	74 10                	je     802dff <free_block+0x11b>
  802def:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802df7:	8b 52 04             	mov    0x4(%edx),%edx
  802dfa:	89 50 04             	mov    %edx,0x4(%eax)
  802dfd:	eb 0b                	jmp    802e0a <free_block+0x126>
  802dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e02:	8b 40 04             	mov    0x4(%eax),%eax
  802e05:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	74 0f                	je     802e23 <free_block+0x13f>
  802e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e1d:	8b 12                	mov    (%edx),%edx
  802e1f:	89 10                	mov    %edx,(%eax)
  802e21:	eb 0a                	jmp    802e2d <free_block+0x149>
  802e23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	a3 48 50 98 00       	mov    %eax,0x985048
  802e2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e40:	a1 54 50 98 00       	mov    0x985054,%eax
  802e45:	48                   	dec    %eax
  802e46:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	ff 75 08             	pushl  0x8(%ebp)
  802e51:	e8 32 f6 ff ff       	call   802488 <insert_sorted_in_freeList>
  802e56:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802e59:	e9 01 01 00 00       	jmp    802f5f <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802e5e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e62:	0f 85 d3 00 00 00    	jne    802f3b <free_block+0x257>
  802e68:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e6c:	0f 85 c9 00 00 00    	jne    802f3b <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802e72:	83 ec 0c             	sub    $0xc,%esp
  802e75:	ff 75 e8             	pushl  -0x18(%ebp)
  802e78:	e8 38 f3 ff ff       	call   8021b5 <get_block_size>
  802e7d:	83 c4 10             	add    $0x10,%esp
  802e80:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802e83:	83 ec 0c             	sub    $0xc,%esp
  802e86:	ff 75 e0             	pushl  -0x20(%ebp)
  802e89:	e8 27 f3 ff ff       	call   8021b5 <get_block_size>
  802e8e:	83 c4 10             	add    $0x10,%esp
  802e91:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e97:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e9a:	01 c2                	add    %eax,%edx
  802e9c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e9f:	01 d0                	add    %edx,%eax
  802ea1:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802ea4:	83 ec 04             	sub    $0x4,%esp
  802ea7:	6a 00                	push   $0x0
  802ea9:	ff 75 c0             	pushl  -0x40(%ebp)
  802eac:	ff 75 e8             	pushl  -0x18(%ebp)
  802eaf:	e8 7d f5 ff ff       	call   802431 <set_block_data>
  802eb4:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802eb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ebb:	75 17                	jne    802ed4 <free_block+0x1f0>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 00 42 80 00       	push   $0x804200
  802ec5:	68 94 01 00 00       	push   $0x194
  802eca:	68 57 41 80 00       	push   $0x804157
  802ecf:	e8 13 07 00 00       	call   8035e7 <_panic>
  802ed4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 10                	je     802eed <free_block+0x209>
  802edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ee5:	8b 52 04             	mov    0x4(%edx),%edx
  802ee8:	89 50 04             	mov    %edx,0x4(%eax)
  802eeb:	eb 0b                	jmp    802ef8 <free_block+0x214>
  802eed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef0:	8b 40 04             	mov    0x4(%eax),%eax
  802ef3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 0f                	je     802f11 <free_block+0x22d>
  802f02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f0b:	8b 12                	mov    (%edx),%edx
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	eb 0a                	jmp    802f1b <free_block+0x237>
  802f11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	a3 48 50 98 00       	mov    %eax,0x985048
  802f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2e:	a1 54 50 98 00       	mov    0x985054,%eax
  802f33:	48                   	dec    %eax
  802f34:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802f39:	eb 24                	jmp    802f5f <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802f3b:	83 ec 04             	sub    $0x4,%esp
  802f3e:	6a 00                	push   $0x0
  802f40:	ff 75 f4             	pushl  -0xc(%ebp)
  802f43:	ff 75 08             	pushl  0x8(%ebp)
  802f46:	e8 e6 f4 ff ff       	call   802431 <set_block_data>
  802f4b:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802f4e:	83 ec 0c             	sub    $0xc,%esp
  802f51:	ff 75 08             	pushl  0x8(%ebp)
  802f54:	e8 2f f5 ff ff       	call   802488 <insert_sorted_in_freeList>
  802f59:	83 c4 10             	add    $0x10,%esp
  802f5c:	eb 01                	jmp    802f5f <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802f5e:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802f5f:	c9                   	leave  
  802f60:	c3                   	ret    

00802f61 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802f61:	55                   	push   %ebp
  802f62:	89 e5                	mov    %esp,%ebp
  802f64:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802f67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6b:	75 10                	jne    802f7d <realloc_block_FF+0x1c>
  802f6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f71:	75 0a                	jne    802f7d <realloc_block_FF+0x1c>
	{
		return NULL;
  802f73:	b8 00 00 00 00       	mov    $0x0,%eax
  802f78:	e9 8b 04 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802f7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f81:	75 18                	jne    802f9b <realloc_block_FF+0x3a>
	{
		free_block(va);
  802f83:	83 ec 0c             	sub    $0xc,%esp
  802f86:	ff 75 08             	pushl  0x8(%ebp)
  802f89:	e8 56 fd ff ff       	call   802ce4 <free_block>
  802f8e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f91:	b8 00 00 00 00       	mov    $0x0,%eax
  802f96:	e9 6d 04 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802f9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9f:	75 13                	jne    802fb4 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802fa1:	83 ec 0c             	sub    $0xc,%esp
  802fa4:	ff 75 0c             	pushl  0xc(%ebp)
  802fa7:	e8 6f f6 ff ff       	call   80261b <alloc_block_FF>
  802fac:	83 c4 10             	add    $0x10,%esp
  802faf:	e9 54 04 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb7:	83 e0 01             	and    $0x1,%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 03                	je     802fc1 <realloc_block_FF+0x60>
	{
		new_size++;
  802fbe:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802fc1:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fc5:	77 07                	ja     802fce <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802fc7:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802fce:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802fd2:	83 ec 0c             	sub    $0xc,%esp
  802fd5:	ff 75 08             	pushl  0x8(%ebp)
  802fd8:	e8 d8 f1 ff ff       	call   8021b5 <get_block_size>
  802fdd:	83 c4 10             	add    $0x10,%esp
  802fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fe9:	75 08                	jne    802ff3 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	e9 15 04 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	01 d0                	add    %edx,%eax
  802ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802ffe:	83 ec 0c             	sub    $0xc,%esp
  803001:	ff 75 f0             	pushl  -0x10(%ebp)
  803004:	e8 c5 f1 ff ff       	call   8021ce <is_free_block>
  803009:	83 c4 10             	add    $0x10,%esp
  80300c:	0f be c0             	movsbl %al,%eax
  80300f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803012:	83 ec 0c             	sub    $0xc,%esp
  803015:	ff 75 f0             	pushl  -0x10(%ebp)
  803018:	e8 98 f1 ff ff       	call   8021b5 <get_block_size>
  80301d:	83 c4 10             	add    $0x10,%esp
  803020:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803023:	8b 45 0c             	mov    0xc(%ebp),%eax
  803026:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803029:	0f 86 a7 02 00 00    	jbe    8032d6 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  80302f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803033:	0f 84 86 02 00 00    	je     8032bf <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803039:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303f:	01 d0                	add    %edx,%eax
  803041:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803044:	0f 85 b2 00 00 00    	jne    8030fc <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80304a:	83 ec 0c             	sub    $0xc,%esp
  80304d:	ff 75 08             	pushl  0x8(%ebp)
  803050:	e8 79 f1 ff ff       	call   8021ce <is_free_block>
  803055:	83 c4 10             	add    $0x10,%esp
  803058:	84 c0                	test   %al,%al
  80305a:	0f 94 c0             	sete   %al
  80305d:	0f b6 c0             	movzbl %al,%eax
  803060:	83 ec 04             	sub    $0x4,%esp
  803063:	50                   	push   %eax
  803064:	ff 75 0c             	pushl  0xc(%ebp)
  803067:	ff 75 08             	pushl  0x8(%ebp)
  80306a:	e8 c2 f3 ff ff       	call   802431 <set_block_data>
  80306f:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803072:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803076:	75 17                	jne    80308f <realloc_block_FF+0x12e>
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	68 00 42 80 00       	push   $0x804200
  803080:	68 db 01 00 00       	push   $0x1db
  803085:	68 57 41 80 00       	push   $0x804157
  80308a:	e8 58 05 00 00       	call   8035e7 <_panic>
  80308f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	74 10                	je     8030a8 <realloc_block_FF+0x147>
  803098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a0:	8b 52 04             	mov    0x4(%edx),%edx
  8030a3:	89 50 04             	mov    %edx,0x4(%eax)
  8030a6:	eb 0b                	jmp    8030b3 <realloc_block_FF+0x152>
  8030a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ab:	8b 40 04             	mov    0x4(%eax),%eax
  8030ae:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b6:	8b 40 04             	mov    0x4(%eax),%eax
  8030b9:	85 c0                	test   %eax,%eax
  8030bb:	74 0f                	je     8030cc <realloc_block_FF+0x16b>
  8030bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c0:	8b 40 04             	mov    0x4(%eax),%eax
  8030c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c6:	8b 12                	mov    (%edx),%edx
  8030c8:	89 10                	mov    %edx,(%eax)
  8030ca:	eb 0a                	jmp    8030d6 <realloc_block_FF+0x175>
  8030cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	a3 48 50 98 00       	mov    %eax,0x985048
  8030d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e9:	a1 54 50 98 00       	mov    0x985054,%eax
  8030ee:	48                   	dec    %eax
  8030ef:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	e9 0c 03 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8030fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	01 d0                	add    %edx,%eax
  803104:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803107:	0f 86 b2 01 00 00    	jbe    8032bf <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  80310d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803110:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803113:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803116:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803119:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80311c:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  80311f:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803123:	0f 87 b8 00 00 00    	ja     8031e1 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803129:	83 ec 0c             	sub    $0xc,%esp
  80312c:	ff 75 08             	pushl  0x8(%ebp)
  80312f:	e8 9a f0 ff ff       	call   8021ce <is_free_block>
  803134:	83 c4 10             	add    $0x10,%esp
  803137:	84 c0                	test   %al,%al
  803139:	0f 94 c0             	sete   %al
  80313c:	0f b6 c0             	movzbl %al,%eax
  80313f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803145:	01 ca                	add    %ecx,%edx
  803147:	83 ec 04             	sub    $0x4,%esp
  80314a:	50                   	push   %eax
  80314b:	52                   	push   %edx
  80314c:	ff 75 08             	pushl  0x8(%ebp)
  80314f:	e8 dd f2 ff ff       	call   802431 <set_block_data>
  803154:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803157:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80315b:	75 17                	jne    803174 <realloc_block_FF+0x213>
  80315d:	83 ec 04             	sub    $0x4,%esp
  803160:	68 00 42 80 00       	push   $0x804200
  803165:	68 e8 01 00 00       	push   $0x1e8
  80316a:	68 57 41 80 00       	push   $0x804157
  80316f:	e8 73 04 00 00       	call   8035e7 <_panic>
  803174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	85 c0                	test   %eax,%eax
  80317b:	74 10                	je     80318d <realloc_block_FF+0x22c>
  80317d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803180:	8b 00                	mov    (%eax),%eax
  803182:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803185:	8b 52 04             	mov    0x4(%edx),%edx
  803188:	89 50 04             	mov    %edx,0x4(%eax)
  80318b:	eb 0b                	jmp    803198 <realloc_block_FF+0x237>
  80318d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803190:	8b 40 04             	mov    0x4(%eax),%eax
  803193:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319b:	8b 40 04             	mov    0x4(%eax),%eax
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	74 0f                	je     8031b1 <realloc_block_FF+0x250>
  8031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a5:	8b 40 04             	mov    0x4(%eax),%eax
  8031a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ab:	8b 12                	mov    (%edx),%edx
  8031ad:	89 10                	mov    %edx,(%eax)
  8031af:	eb 0a                	jmp    8031bb <realloc_block_FF+0x25a>
  8031b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	a3 48 50 98 00       	mov    %eax,0x985048
  8031bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ce:	a1 54 50 98 00       	mov    0x985054,%eax
  8031d3:	48                   	dec    %eax
  8031d4:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	e9 27 02 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8031e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e5:	75 17                	jne    8031fe <realloc_block_FF+0x29d>
  8031e7:	83 ec 04             	sub    $0x4,%esp
  8031ea:	68 00 42 80 00       	push   $0x804200
  8031ef:	68 ed 01 00 00       	push   $0x1ed
  8031f4:	68 57 41 80 00       	push   $0x804157
  8031f9:	e8 e9 03 00 00       	call   8035e7 <_panic>
  8031fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	85 c0                	test   %eax,%eax
  803205:	74 10                	je     803217 <realloc_block_FF+0x2b6>
  803207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320f:	8b 52 04             	mov    0x4(%edx),%edx
  803212:	89 50 04             	mov    %edx,0x4(%eax)
  803215:	eb 0b                	jmp    803222 <realloc_block_FF+0x2c1>
  803217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321a:	8b 40 04             	mov    0x4(%eax),%eax
  80321d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803225:	8b 40 04             	mov    0x4(%eax),%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	74 0f                	je     80323b <realloc_block_FF+0x2da>
  80322c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322f:	8b 40 04             	mov    0x4(%eax),%eax
  803232:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803235:	8b 12                	mov    (%edx),%edx
  803237:	89 10                	mov    %edx,(%eax)
  803239:	eb 0a                	jmp    803245 <realloc_block_FF+0x2e4>
  80323b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	a3 48 50 98 00       	mov    %eax,0x985048
  803245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803248:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803251:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803258:	a1 54 50 98 00       	mov    0x985054,%eax
  80325d:	48                   	dec    %eax
  80325e:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803263:	8b 55 08             	mov    0x8(%ebp),%edx
  803266:	8b 45 0c             	mov    0xc(%ebp),%eax
  803269:	01 d0                	add    %edx,%eax
  80326b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  80326e:	83 ec 04             	sub    $0x4,%esp
  803271:	6a 00                	push   $0x0
  803273:	ff 75 e0             	pushl  -0x20(%ebp)
  803276:	ff 75 f0             	pushl  -0x10(%ebp)
  803279:	e8 b3 f1 ff ff       	call   802431 <set_block_data>
  80327e:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803281:	83 ec 0c             	sub    $0xc,%esp
  803284:	ff 75 08             	pushl  0x8(%ebp)
  803287:	e8 42 ef ff ff       	call   8021ce <is_free_block>
  80328c:	83 c4 10             	add    $0x10,%esp
  80328f:	84 c0                	test   %al,%al
  803291:	0f 94 c0             	sete   %al
  803294:	0f b6 c0             	movzbl %al,%eax
  803297:	83 ec 04             	sub    $0x4,%esp
  80329a:	50                   	push   %eax
  80329b:	ff 75 0c             	pushl  0xc(%ebp)
  80329e:	ff 75 08             	pushl  0x8(%ebp)
  8032a1:	e8 8b f1 ff ff       	call   802431 <set_block_data>
  8032a6:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8032a9:	83 ec 0c             	sub    $0xc,%esp
  8032ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8032af:	e8 d4 f1 ff ff       	call   802488 <insert_sorted_in_freeList>
  8032b4:	83 c4 10             	add    $0x10,%esp
					return va;
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	e9 49 01 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8032bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c2:	83 e8 08             	sub    $0x8,%eax
  8032c5:	83 ec 0c             	sub    $0xc,%esp
  8032c8:	50                   	push   %eax
  8032c9:	e8 4d f3 ff ff       	call   80261b <alloc_block_FF>
  8032ce:	83 c4 10             	add    $0x10,%esp
  8032d1:	e9 32 01 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8032d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032dc:	0f 83 21 01 00 00    	jae    803403 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032e8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8032eb:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8032ef:	77 0e                	ja     8032ff <realloc_block_FF+0x39e>
  8032f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032f5:	75 08                	jne    8032ff <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	e9 09 01 00 00       	jmp    803408 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803305:	83 ec 0c             	sub    $0xc,%esp
  803308:	ff 75 08             	pushl  0x8(%ebp)
  80330b:	e8 be ee ff ff       	call   8021ce <is_free_block>
  803310:	83 c4 10             	add    $0x10,%esp
  803313:	84 c0                	test   %al,%al
  803315:	0f 94 c0             	sete   %al
  803318:	0f b6 c0             	movzbl %al,%eax
  80331b:	83 ec 04             	sub    $0x4,%esp
  80331e:	50                   	push   %eax
  80331f:	ff 75 0c             	pushl  0xc(%ebp)
  803322:	ff 75 d8             	pushl  -0x28(%ebp)
  803325:	e8 07 f1 ff ff       	call   802431 <set_block_data>
  80332a:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  80332d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803330:	8b 45 0c             	mov    0xc(%ebp),%eax
  803333:	01 d0                	add    %edx,%eax
  803335:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803338:	83 ec 04             	sub    $0x4,%esp
  80333b:	6a 00                	push   $0x0
  80333d:	ff 75 dc             	pushl  -0x24(%ebp)
  803340:	ff 75 d4             	pushl  -0x2c(%ebp)
  803343:	e8 e9 f0 ff ff       	call   802431 <set_block_data>
  803348:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80334b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80334f:	0f 84 9b 00 00 00    	je     8033f0 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803355:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	01 d0                	add    %edx,%eax
  80335d:	83 ec 04             	sub    $0x4,%esp
  803360:	6a 00                	push   $0x0
  803362:	50                   	push   %eax
  803363:	ff 75 d4             	pushl  -0x2c(%ebp)
  803366:	e8 c6 f0 ff ff       	call   802431 <set_block_data>
  80336b:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  80336e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803372:	75 17                	jne    80338b <realloc_block_FF+0x42a>
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	68 00 42 80 00       	push   $0x804200
  80337c:	68 10 02 00 00       	push   $0x210
  803381:	68 57 41 80 00       	push   $0x804157
  803386:	e8 5c 02 00 00       	call   8035e7 <_panic>
  80338b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	85 c0                	test   %eax,%eax
  803392:	74 10                	je     8033a4 <realloc_block_FF+0x443>
  803394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339c:	8b 52 04             	mov    0x4(%edx),%edx
  80339f:	89 50 04             	mov    %edx,0x4(%eax)
  8033a2:	eb 0b                	jmp    8033af <realloc_block_FF+0x44e>
  8033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a7:	8b 40 04             	mov    0x4(%eax),%eax
  8033aa:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b2:	8b 40 04             	mov    0x4(%eax),%eax
  8033b5:	85 c0                	test   %eax,%eax
  8033b7:	74 0f                	je     8033c8 <realloc_block_FF+0x467>
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	8b 40 04             	mov    0x4(%eax),%eax
  8033bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033c2:	8b 12                	mov    (%edx),%edx
  8033c4:	89 10                	mov    %edx,(%eax)
  8033c6:	eb 0a                	jmp    8033d2 <realloc_block_FF+0x471>
  8033c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cb:	8b 00                	mov    (%eax),%eax
  8033cd:	a3 48 50 98 00       	mov    %eax,0x985048
  8033d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e5:	a1 54 50 98 00       	mov    0x985054,%eax
  8033ea:	48                   	dec    %eax
  8033eb:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8033f0:	83 ec 0c             	sub    $0xc,%esp
  8033f3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033f6:	e8 8d f0 ff ff       	call   802488 <insert_sorted_in_freeList>
  8033fb:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8033fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803401:	eb 05                	jmp    803408 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803403:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803408:	c9                   	leave  
  803409:	c3                   	ret    

0080340a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80340a:	55                   	push   %ebp
  80340b:	89 e5                	mov    %esp,%ebp
  80340d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803410:	83 ec 04             	sub    $0x4,%esp
  803413:	68 20 42 80 00       	push   $0x804220
  803418:	68 20 02 00 00       	push   $0x220
  80341d:	68 57 41 80 00       	push   $0x804157
  803422:	e8 c0 01 00 00       	call   8035e7 <_panic>

00803427 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803427:	55                   	push   %ebp
  803428:	89 e5                	mov    %esp,%ebp
  80342a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	68 48 42 80 00       	push   $0x804248
  803435:	68 28 02 00 00       	push   $0x228
  80343a:	68 57 41 80 00       	push   $0x804157
  80343f:	e8 a3 01 00 00       	call   8035e7 <_panic>

00803444 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803444:	55                   	push   %ebp
  803445:	89 e5                	mov    %esp,%ebp
  803447:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  80344a:	83 ec 04             	sub    $0x4,%esp
  80344d:	6a 01                	push   $0x1
  80344f:	6a 58                	push   $0x58
  803451:	ff 75 0c             	pushl  0xc(%ebp)
  803454:	e8 c1 e2 ff ff       	call   80171a <smalloc>
  803459:	83 c4 10             	add    $0x10,%esp
  80345c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  80345f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803463:	75 14                	jne    803479 <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  803465:	83 ec 04             	sub    $0x4,%esp
  803468:	68 70 42 80 00       	push   $0x804270
  80346d:	6a 10                	push   $0x10
  80346f:	68 9e 42 80 00       	push   $0x80429e
  803474:	e8 6e 01 00 00       	call   8035e7 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347c:	83 ec 0c             	sub    $0xc,%esp
  80347f:	50                   	push   %eax
  803480:	e8 bc ec ff ff       	call   802141 <sys_init_queue>
  803485:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  803488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	83 c0 18             	add    $0x18,%eax
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	6a 40                	push   $0x40
  80349d:	ff 75 0c             	pushl  0xc(%ebp)
  8034a0:	50                   	push   %eax
  8034a1:	e8 1e d9 ff ff       	call   800dc4 <strncpy>
  8034a6:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  8034a9:	8b 55 10             	mov    0x10(%ebp),%edx
  8034ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034af:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034be:	89 10                	mov    %edx,(%eax)
}
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	c9                   	leave  
  8034c4:	c2 04 00             	ret    $0x4

008034c7 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8034c7:	55                   	push   %ebp
  8034c8:	89 e5                	mov    %esp,%ebp
  8034ca:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  8034cd:	83 ec 08             	sub    $0x8,%esp
  8034d0:	ff 75 10             	pushl  0x10(%ebp)
  8034d3:	ff 75 0c             	pushl  0xc(%ebp)
  8034d6:	e8 da e3 ff ff       	call   8018b5 <sget>
  8034db:	83 c4 10             	add    $0x10,%esp
  8034de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8034e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e5:	75 14                	jne    8034fb <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  8034e7:	83 ec 04             	sub    $0x4,%esp
  8034ea:	68 b0 42 80 00       	push   $0x8042b0
  8034ef:	6a 2c                	push   $0x2c
  8034f1:	68 9e 42 80 00       	push   $0x80429e
  8034f6:	e8 ec 00 00 00       	call   8035e7 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803507:	89 10                	mov    %edx,(%eax)
}
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	c9                   	leave  
  80350d:	c2 04 00             	ret    $0x4

00803510 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803510:	55                   	push   %ebp
  803511:	89 e5                	mov    %esp,%ebp
  803513:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803516:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	8b 40 14             	mov    0x14(%eax),%eax
  803523:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803526:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803529:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80352c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803532:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803535:	f0 87 02             	lock xchg %eax,(%edx)
  803538:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	85 c0                	test   %eax,%eax
  803540:	75 db                	jne    80351d <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	8b 50 10             	mov    0x10(%eax),%edx
  803548:	4a                   	dec    %edx
  803549:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	8b 40 10             	mov    0x10(%eax),%eax
  803552:	85 c0                	test   %eax,%eax
  803554:	79 18                	jns    80356e <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	8d 50 14             	lea    0x14(%eax),%edx
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	83 ec 08             	sub    $0x8,%esp
  803562:	52                   	push   %edx
  803563:	50                   	push   %eax
  803564:	e8 f4 eb ff ff       	call   80215d <sys_block_process>
  803569:	83 c4 10             	add    $0x10,%esp
  80356c:	eb 0a                	jmp    803578 <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803578:	c9                   	leave  
  803579:	c3                   	ret    

0080357a <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  80357a:	55                   	push   %ebp
  80357b:	89 e5                	mov    %esp,%ebp
  80357d:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803580:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	8b 40 14             	mov    0x14(%eax),%eax
  80358d:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803590:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803593:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80359f:	f0 87 02             	lock xchg %eax,(%edx)
  8035a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  8035a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	75 db                	jne    803587 <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	8b 50 10             	mov    0x10(%eax),%edx
  8035b2:	42                   	inc    %edx
  8035b3:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	8b 40 10             	mov    0x10(%eax),%eax
  8035bc:	85 c0                	test   %eax,%eax
  8035be:	7f 0f                	jg     8035cf <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	83 ec 0c             	sub    $0xc,%esp
  8035c6:	50                   	push   %eax
  8035c7:	e8 af eb ff ff       	call   80217b <sys_unblock_process>
  8035cc:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8035d9:	90                   	nop
  8035da:	c9                   	leave  
  8035db:	c3                   	ret    

008035dc <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  8035dc:	55                   	push   %ebp
  8035dd:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 40 10             	mov    0x10(%eax),%eax
}
  8035e5:	5d                   	pop    %ebp
  8035e6:	c3                   	ret    

008035e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8035e7:	55                   	push   %ebp
  8035e8:	89 e5                	mov    %esp,%ebp
  8035ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8035ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8035f0:	83 c0 04             	add    $0x4,%eax
  8035f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8035f6:	a1 60 50 98 00       	mov    0x985060,%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	74 16                	je     803615 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8035ff:	a1 60 50 98 00       	mov    0x985060,%eax
  803604:	83 ec 08             	sub    $0x8,%esp
  803607:	50                   	push   %eax
  803608:	68 d4 42 80 00       	push   $0x8042d4
  80360d:	e8 a1 d0 ff ff       	call   8006b3 <cprintf>
  803612:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803615:	a1 04 50 80 00       	mov    0x805004,%eax
  80361a:	ff 75 0c             	pushl  0xc(%ebp)
  80361d:	ff 75 08             	pushl  0x8(%ebp)
  803620:	50                   	push   %eax
  803621:	68 d9 42 80 00       	push   $0x8042d9
  803626:	e8 88 d0 ff ff       	call   8006b3 <cprintf>
  80362b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80362e:	8b 45 10             	mov    0x10(%ebp),%eax
  803631:	83 ec 08             	sub    $0x8,%esp
  803634:	ff 75 f4             	pushl  -0xc(%ebp)
  803637:	50                   	push   %eax
  803638:	e8 0b d0 ff ff       	call   800648 <vcprintf>
  80363d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803640:	83 ec 08             	sub    $0x8,%esp
  803643:	6a 00                	push   $0x0
  803645:	68 f5 42 80 00       	push   $0x8042f5
  80364a:	e8 f9 cf ff ff       	call   800648 <vcprintf>
  80364f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803652:	e8 7a cf ff ff       	call   8005d1 <exit>

	// should not return here
	while (1) ;
  803657:	eb fe                	jmp    803657 <_panic+0x70>

00803659 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803659:	55                   	push   %ebp
  80365a:	89 e5                	mov    %esp,%ebp
  80365c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80365f:	a1 20 50 80 00       	mov    0x805020,%eax
  803664:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80366a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366d:	39 c2                	cmp    %eax,%edx
  80366f:	74 14                	je     803685 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803671:	83 ec 04             	sub    $0x4,%esp
  803674:	68 f8 42 80 00       	push   $0x8042f8
  803679:	6a 26                	push   $0x26
  80367b:	68 44 43 80 00       	push   $0x804344
  803680:	e8 62 ff ff ff       	call   8035e7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803685:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80368c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803693:	e9 c5 00 00 00       	jmp    80375d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	01 d0                	add    %edx,%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	85 c0                	test   %eax,%eax
  8036ab:	75 08                	jne    8036b5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8036ad:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8036b0:	e9 a5 00 00 00       	jmp    80375a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8036b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8036c3:	eb 69                	jmp    80372e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8036c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ca:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8036d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036d3:	89 d0                	mov    %edx,%eax
  8036d5:	01 c0                	add    %eax,%eax
  8036d7:	01 d0                	add    %edx,%eax
  8036d9:	c1 e0 03             	shl    $0x3,%eax
  8036dc:	01 c8                	add    %ecx,%eax
  8036de:	8a 40 04             	mov    0x4(%eax),%al
  8036e1:	84 c0                	test   %al,%al
  8036e3:	75 46                	jne    80372b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8036e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ea:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8036f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f3:	89 d0                	mov    %edx,%eax
  8036f5:	01 c0                	add    %eax,%eax
  8036f7:	01 d0                	add    %edx,%eax
  8036f9:	c1 e0 03             	shl    $0x3,%eax
  8036fc:	01 c8                	add    %ecx,%eax
  8036fe:	8b 00                	mov    (%eax),%eax
  803700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803703:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803706:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80370b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80370d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803710:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	01 c8                	add    %ecx,%eax
  80371c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80371e:	39 c2                	cmp    %eax,%edx
  803720:	75 09                	jne    80372b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803722:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803729:	eb 15                	jmp    803740 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80372b:	ff 45 e8             	incl   -0x18(%ebp)
  80372e:	a1 20 50 80 00       	mov    0x805020,%eax
  803733:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803739:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373c:	39 c2                	cmp    %eax,%edx
  80373e:	77 85                	ja     8036c5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803740:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803744:	75 14                	jne    80375a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803746:	83 ec 04             	sub    $0x4,%esp
  803749:	68 50 43 80 00       	push   $0x804350
  80374e:	6a 3a                	push   $0x3a
  803750:	68 44 43 80 00       	push   $0x804344
  803755:	e8 8d fe ff ff       	call   8035e7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80375a:	ff 45 f0             	incl   -0x10(%ebp)
  80375d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803760:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803763:	0f 8c 2f ff ff ff    	jl     803698 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803769:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803770:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803777:	eb 26                	jmp    80379f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803779:	a1 20 50 80 00       	mov    0x805020,%eax
  80377e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803784:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803787:	89 d0                	mov    %edx,%eax
  803789:	01 c0                	add    %eax,%eax
  80378b:	01 d0                	add    %edx,%eax
  80378d:	c1 e0 03             	shl    $0x3,%eax
  803790:	01 c8                	add    %ecx,%eax
  803792:	8a 40 04             	mov    0x4(%eax),%al
  803795:	3c 01                	cmp    $0x1,%al
  803797:	75 03                	jne    80379c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803799:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80379c:	ff 45 e0             	incl   -0x20(%ebp)
  80379f:	a1 20 50 80 00       	mov    0x805020,%eax
  8037a4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8037aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ad:	39 c2                	cmp    %eax,%edx
  8037af:	77 c8                	ja     803779 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037b7:	74 14                	je     8037cd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8037b9:	83 ec 04             	sub    $0x4,%esp
  8037bc:	68 a4 43 80 00       	push   $0x8043a4
  8037c1:	6a 44                	push   $0x44
  8037c3:	68 44 43 80 00       	push   $0x804344
  8037c8:	e8 1a fe ff ff       	call   8035e7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8037cd:	90                   	nop
  8037ce:	c9                   	leave  
  8037cf:	c3                   	ret    

008037d0 <__udivdi3>:
  8037d0:	55                   	push   %ebp
  8037d1:	57                   	push   %edi
  8037d2:	56                   	push   %esi
  8037d3:	53                   	push   %ebx
  8037d4:	83 ec 1c             	sub    $0x1c,%esp
  8037d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037e7:	89 ca                	mov    %ecx,%edx
  8037e9:	89 f8                	mov    %edi,%eax
  8037eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037ef:	85 f6                	test   %esi,%esi
  8037f1:	75 2d                	jne    803820 <__udivdi3+0x50>
  8037f3:	39 cf                	cmp    %ecx,%edi
  8037f5:	77 65                	ja     80385c <__udivdi3+0x8c>
  8037f7:	89 fd                	mov    %edi,%ebp
  8037f9:	85 ff                	test   %edi,%edi
  8037fb:	75 0b                	jne    803808 <__udivdi3+0x38>
  8037fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803802:	31 d2                	xor    %edx,%edx
  803804:	f7 f7                	div    %edi
  803806:	89 c5                	mov    %eax,%ebp
  803808:	31 d2                	xor    %edx,%edx
  80380a:	89 c8                	mov    %ecx,%eax
  80380c:	f7 f5                	div    %ebp
  80380e:	89 c1                	mov    %eax,%ecx
  803810:	89 d8                	mov    %ebx,%eax
  803812:	f7 f5                	div    %ebp
  803814:	89 cf                	mov    %ecx,%edi
  803816:	89 fa                	mov    %edi,%edx
  803818:	83 c4 1c             	add    $0x1c,%esp
  80381b:	5b                   	pop    %ebx
  80381c:	5e                   	pop    %esi
  80381d:	5f                   	pop    %edi
  80381e:	5d                   	pop    %ebp
  80381f:	c3                   	ret    
  803820:	39 ce                	cmp    %ecx,%esi
  803822:	77 28                	ja     80384c <__udivdi3+0x7c>
  803824:	0f bd fe             	bsr    %esi,%edi
  803827:	83 f7 1f             	xor    $0x1f,%edi
  80382a:	75 40                	jne    80386c <__udivdi3+0x9c>
  80382c:	39 ce                	cmp    %ecx,%esi
  80382e:	72 0a                	jb     80383a <__udivdi3+0x6a>
  803830:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803834:	0f 87 9e 00 00 00    	ja     8038d8 <__udivdi3+0x108>
  80383a:	b8 01 00 00 00       	mov    $0x1,%eax
  80383f:	89 fa                	mov    %edi,%edx
  803841:	83 c4 1c             	add    $0x1c,%esp
  803844:	5b                   	pop    %ebx
  803845:	5e                   	pop    %esi
  803846:	5f                   	pop    %edi
  803847:	5d                   	pop    %ebp
  803848:	c3                   	ret    
  803849:	8d 76 00             	lea    0x0(%esi),%esi
  80384c:	31 ff                	xor    %edi,%edi
  80384e:	31 c0                	xor    %eax,%eax
  803850:	89 fa                	mov    %edi,%edx
  803852:	83 c4 1c             	add    $0x1c,%esp
  803855:	5b                   	pop    %ebx
  803856:	5e                   	pop    %esi
  803857:	5f                   	pop    %edi
  803858:	5d                   	pop    %ebp
  803859:	c3                   	ret    
  80385a:	66 90                	xchg   %ax,%ax
  80385c:	89 d8                	mov    %ebx,%eax
  80385e:	f7 f7                	div    %edi
  803860:	31 ff                	xor    %edi,%edi
  803862:	89 fa                	mov    %edi,%edx
  803864:	83 c4 1c             	add    $0x1c,%esp
  803867:	5b                   	pop    %ebx
  803868:	5e                   	pop    %esi
  803869:	5f                   	pop    %edi
  80386a:	5d                   	pop    %ebp
  80386b:	c3                   	ret    
  80386c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803871:	89 eb                	mov    %ebp,%ebx
  803873:	29 fb                	sub    %edi,%ebx
  803875:	89 f9                	mov    %edi,%ecx
  803877:	d3 e6                	shl    %cl,%esi
  803879:	89 c5                	mov    %eax,%ebp
  80387b:	88 d9                	mov    %bl,%cl
  80387d:	d3 ed                	shr    %cl,%ebp
  80387f:	89 e9                	mov    %ebp,%ecx
  803881:	09 f1                	or     %esi,%ecx
  803883:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803887:	89 f9                	mov    %edi,%ecx
  803889:	d3 e0                	shl    %cl,%eax
  80388b:	89 c5                	mov    %eax,%ebp
  80388d:	89 d6                	mov    %edx,%esi
  80388f:	88 d9                	mov    %bl,%cl
  803891:	d3 ee                	shr    %cl,%esi
  803893:	89 f9                	mov    %edi,%ecx
  803895:	d3 e2                	shl    %cl,%edx
  803897:	8b 44 24 08          	mov    0x8(%esp),%eax
  80389b:	88 d9                	mov    %bl,%cl
  80389d:	d3 e8                	shr    %cl,%eax
  80389f:	09 c2                	or     %eax,%edx
  8038a1:	89 d0                	mov    %edx,%eax
  8038a3:	89 f2                	mov    %esi,%edx
  8038a5:	f7 74 24 0c          	divl   0xc(%esp)
  8038a9:	89 d6                	mov    %edx,%esi
  8038ab:	89 c3                	mov    %eax,%ebx
  8038ad:	f7 e5                	mul    %ebp
  8038af:	39 d6                	cmp    %edx,%esi
  8038b1:	72 19                	jb     8038cc <__udivdi3+0xfc>
  8038b3:	74 0b                	je     8038c0 <__udivdi3+0xf0>
  8038b5:	89 d8                	mov    %ebx,%eax
  8038b7:	31 ff                	xor    %edi,%edi
  8038b9:	e9 58 ff ff ff       	jmp    803816 <__udivdi3+0x46>
  8038be:	66 90                	xchg   %ax,%ax
  8038c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038c4:	89 f9                	mov    %edi,%ecx
  8038c6:	d3 e2                	shl    %cl,%edx
  8038c8:	39 c2                	cmp    %eax,%edx
  8038ca:	73 e9                	jae    8038b5 <__udivdi3+0xe5>
  8038cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038cf:	31 ff                	xor    %edi,%edi
  8038d1:	e9 40 ff ff ff       	jmp    803816 <__udivdi3+0x46>
  8038d6:	66 90                	xchg   %ax,%ax
  8038d8:	31 c0                	xor    %eax,%eax
  8038da:	e9 37 ff ff ff       	jmp    803816 <__udivdi3+0x46>
  8038df:	90                   	nop

008038e0 <__umoddi3>:
  8038e0:	55                   	push   %ebp
  8038e1:	57                   	push   %edi
  8038e2:	56                   	push   %esi
  8038e3:	53                   	push   %ebx
  8038e4:	83 ec 1c             	sub    $0x1c,%esp
  8038e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038ff:	89 f3                	mov    %esi,%ebx
  803901:	89 fa                	mov    %edi,%edx
  803903:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803907:	89 34 24             	mov    %esi,(%esp)
  80390a:	85 c0                	test   %eax,%eax
  80390c:	75 1a                	jne    803928 <__umoddi3+0x48>
  80390e:	39 f7                	cmp    %esi,%edi
  803910:	0f 86 a2 00 00 00    	jbe    8039b8 <__umoddi3+0xd8>
  803916:	89 c8                	mov    %ecx,%eax
  803918:	89 f2                	mov    %esi,%edx
  80391a:	f7 f7                	div    %edi
  80391c:	89 d0                	mov    %edx,%eax
  80391e:	31 d2                	xor    %edx,%edx
  803920:	83 c4 1c             	add    $0x1c,%esp
  803923:	5b                   	pop    %ebx
  803924:	5e                   	pop    %esi
  803925:	5f                   	pop    %edi
  803926:	5d                   	pop    %ebp
  803927:	c3                   	ret    
  803928:	39 f0                	cmp    %esi,%eax
  80392a:	0f 87 ac 00 00 00    	ja     8039dc <__umoddi3+0xfc>
  803930:	0f bd e8             	bsr    %eax,%ebp
  803933:	83 f5 1f             	xor    $0x1f,%ebp
  803936:	0f 84 ac 00 00 00    	je     8039e8 <__umoddi3+0x108>
  80393c:	bf 20 00 00 00       	mov    $0x20,%edi
  803941:	29 ef                	sub    %ebp,%edi
  803943:	89 fe                	mov    %edi,%esi
  803945:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803949:	89 e9                	mov    %ebp,%ecx
  80394b:	d3 e0                	shl    %cl,%eax
  80394d:	89 d7                	mov    %edx,%edi
  80394f:	89 f1                	mov    %esi,%ecx
  803951:	d3 ef                	shr    %cl,%edi
  803953:	09 c7                	or     %eax,%edi
  803955:	89 e9                	mov    %ebp,%ecx
  803957:	d3 e2                	shl    %cl,%edx
  803959:	89 14 24             	mov    %edx,(%esp)
  80395c:	89 d8                	mov    %ebx,%eax
  80395e:	d3 e0                	shl    %cl,%eax
  803960:	89 c2                	mov    %eax,%edx
  803962:	8b 44 24 08          	mov    0x8(%esp),%eax
  803966:	d3 e0                	shl    %cl,%eax
  803968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80396c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803970:	89 f1                	mov    %esi,%ecx
  803972:	d3 e8                	shr    %cl,%eax
  803974:	09 d0                	or     %edx,%eax
  803976:	d3 eb                	shr    %cl,%ebx
  803978:	89 da                	mov    %ebx,%edx
  80397a:	f7 f7                	div    %edi
  80397c:	89 d3                	mov    %edx,%ebx
  80397e:	f7 24 24             	mull   (%esp)
  803981:	89 c6                	mov    %eax,%esi
  803983:	89 d1                	mov    %edx,%ecx
  803985:	39 d3                	cmp    %edx,%ebx
  803987:	0f 82 87 00 00 00    	jb     803a14 <__umoddi3+0x134>
  80398d:	0f 84 91 00 00 00    	je     803a24 <__umoddi3+0x144>
  803993:	8b 54 24 04          	mov    0x4(%esp),%edx
  803997:	29 f2                	sub    %esi,%edx
  803999:	19 cb                	sbb    %ecx,%ebx
  80399b:	89 d8                	mov    %ebx,%eax
  80399d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039a1:	d3 e0                	shl    %cl,%eax
  8039a3:	89 e9                	mov    %ebp,%ecx
  8039a5:	d3 ea                	shr    %cl,%edx
  8039a7:	09 d0                	or     %edx,%eax
  8039a9:	89 e9                	mov    %ebp,%ecx
  8039ab:	d3 eb                	shr    %cl,%ebx
  8039ad:	89 da                	mov    %ebx,%edx
  8039af:	83 c4 1c             	add    $0x1c,%esp
  8039b2:	5b                   	pop    %ebx
  8039b3:	5e                   	pop    %esi
  8039b4:	5f                   	pop    %edi
  8039b5:	5d                   	pop    %ebp
  8039b6:	c3                   	ret    
  8039b7:	90                   	nop
  8039b8:	89 fd                	mov    %edi,%ebp
  8039ba:	85 ff                	test   %edi,%edi
  8039bc:	75 0b                	jne    8039c9 <__umoddi3+0xe9>
  8039be:	b8 01 00 00 00       	mov    $0x1,%eax
  8039c3:	31 d2                	xor    %edx,%edx
  8039c5:	f7 f7                	div    %edi
  8039c7:	89 c5                	mov    %eax,%ebp
  8039c9:	89 f0                	mov    %esi,%eax
  8039cb:	31 d2                	xor    %edx,%edx
  8039cd:	f7 f5                	div    %ebp
  8039cf:	89 c8                	mov    %ecx,%eax
  8039d1:	f7 f5                	div    %ebp
  8039d3:	89 d0                	mov    %edx,%eax
  8039d5:	e9 44 ff ff ff       	jmp    80391e <__umoddi3+0x3e>
  8039da:	66 90                	xchg   %ax,%ax
  8039dc:	89 c8                	mov    %ecx,%eax
  8039de:	89 f2                	mov    %esi,%edx
  8039e0:	83 c4 1c             	add    $0x1c,%esp
  8039e3:	5b                   	pop    %ebx
  8039e4:	5e                   	pop    %esi
  8039e5:	5f                   	pop    %edi
  8039e6:	5d                   	pop    %ebp
  8039e7:	c3                   	ret    
  8039e8:	3b 04 24             	cmp    (%esp),%eax
  8039eb:	72 06                	jb     8039f3 <__umoddi3+0x113>
  8039ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039f1:	77 0f                	ja     803a02 <__umoddi3+0x122>
  8039f3:	89 f2                	mov    %esi,%edx
  8039f5:	29 f9                	sub    %edi,%ecx
  8039f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039fb:	89 14 24             	mov    %edx,(%esp)
  8039fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a06:	8b 14 24             	mov    (%esp),%edx
  803a09:	83 c4 1c             	add    $0x1c,%esp
  803a0c:	5b                   	pop    %ebx
  803a0d:	5e                   	pop    %esi
  803a0e:	5f                   	pop    %edi
  803a0f:	5d                   	pop    %ebp
  803a10:	c3                   	ret    
  803a11:	8d 76 00             	lea    0x0(%esi),%esi
  803a14:	2b 04 24             	sub    (%esp),%eax
  803a17:	19 fa                	sbb    %edi,%edx
  803a19:	89 d1                	mov    %edx,%ecx
  803a1b:	89 c6                	mov    %eax,%esi
  803a1d:	e9 71 ff ff ff       	jmp    803993 <__umoddi3+0xb3>
  803a22:	66 90                	xchg   %ax,%ax
  803a24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a28:	72 ea                	jb     803a14 <__umoddi3+0x134>
  803a2a:	89 d9                	mov    %ebx,%ecx
  803a2c:	e9 62 ff ff ff       	jmp    803993 <__umoddi3+0xb3>
