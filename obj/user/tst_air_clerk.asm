
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 5b 06 00 00       	call   800691 <libmain>
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
  80003e:	81 ec ac 01 00 00    	sub    $0x1ac,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 b1 21 00 00       	call   8021fa <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 75 3c 80 00       	mov    $0x803c75,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 7f 3c 80 00       	mov    $0x803c7f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 8b 3c 80 00       	mov    $0x803c8b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 9a 3c 80 00       	mov    $0x803c9a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb a9 3c 80 00       	mov    $0x803ca9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb be 3c 80 00       	mov    $0x803cbe,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb d3 3c 80 00       	mov    $0x803cd3,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb e4 3c 80 00       	mov    $0x803ce4,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb f5 3c 80 00       	mov    $0x803cf5,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 06 3d 80 00       	mov    $0x803d06,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 0f 3d 80 00       	mov    $0x803d0f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 19 3d 80 00       	mov    $0x803d19,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 24 3d 80 00       	mov    $0x803d24,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 30 3d 80 00       	mov    $0x803d30,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 3a 3d 80 00       	mov    $0x803d3a,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb 44 3d 80 00       	mov    $0x803d44,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 52 3d 80 00       	mov    $0x803d52,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 61 3d 80 00       	mov    $0x803d61,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 68 3d 80 00       	mov    $0x803d68,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 6b 1a 00 00       	call   801c95 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 56 1a 00 00       	call   801c95 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 41 1a 00 00       	call   801c95 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 29 1a 00 00       	call   801c95 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 11 1a 00 00       	call   801c95 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 f9 19 00 00       	call   801c95 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 e1 19 00 00       	call   801c95 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 c9 19 00 00       	call   801c95 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 b1 19 00 00       	call   801c95 <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
	//cprintf("address of queue_out = %d\n", queue_out);
	// *********************************************************************************

	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002ea:	8d 85 b4 fe ff ff    	lea    -0x14c(%ebp),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	8d 95 09 ff ff ff    	lea    -0xf7(%ebp),%edx
  8002f9:	52                   	push   %edx
  8002fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002fd:	50                   	push   %eax
  8002fe:	e8 a4 35 00 00       	call   8038a7 <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 88 35 00 00       	call   8038a7 <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 6c 35 00 00       	call   8038a7 <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 50 35 00 00       	call   8038a7 <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 34 35 00 00       	call   8038a7 <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 6c 35 00 00       	call   8038f0 <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 5b 35 00 00       	call   8038f0 <wait_semaphore>
  800395:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800398:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80039b:	8b 00                	mov    (%eax),%eax
  80039d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  8003ae:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	8d 50 01             	lea    0x1(%eax),%edx
  8003b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003b9:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  8003c4:	e8 91 35 00 00       	call   80395a <signal_semaphore>
  8003c9:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  8003cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	8b 00                	mov    (%eax),%eax
  8003dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  8003e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003e3:	83 f8 02             	cmp    $0x2,%eax
  8003e6:	0f 84 88 00 00 00    	je     800474 <_main+0x43c>
  8003ec:	83 f8 03             	cmp    $0x3,%eax
  8003ef:	0f 84 f5 00 00 00    	je     8004ea <_main+0x4b2>
  8003f5:	83 f8 01             	cmp    $0x1,%eax
  8003f8:	0f 85 d8 01 00 00    	jne    8005d6 <_main+0x59e>
		{
		case 1:
		{
			//Check and update Flight1
			wait_semaphore(flight1CS);
  8003fe:	83 ec 0c             	sub    $0xc,%esp
  800401:	ff b5 ac fe ff ff    	pushl  -0x154(%ebp)
  800407:	e8 e4 34 00 00       	call   8038f0 <wait_semaphore>
  80040c:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  80040f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	85 c0                	test   %eax,%eax
  800416:	7e 46                	jle    80045e <_main+0x426>
				{
					*flight1Counter = *flight1Counter - 1;
  800418:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800420:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800423:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800425:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800428:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80042f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  80043b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800447:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80044a:	01 c2                	add    %eax,%edx
  80044c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80044f:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  800451:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	8d 50 01             	lea    0x1(%eax),%edx
  800459:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80045c:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			signal_semaphore(flight1CS);
  80045e:	83 ec 0c             	sub    $0xc,%esp
  800461:	ff b5 ac fe ff ff    	pushl  -0x154(%ebp)
  800467:	e8 ee 34 00 00       	call   80395a <signal_semaphore>
  80046c:	83 c4 10             	add    $0x10,%esp
		}

		break;
  80046f:	e9 79 01 00 00       	jmp    8005ed <_main+0x5b5>
		case 2:
		{
			//Check and update Flight2
			wait_semaphore(flight2CS);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  80047d:	e8 6e 34 00 00       	call   8038f0 <wait_semaphore>
  800482:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800485:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	85 c0                	test   %eax,%eax
  80048c:	7e 46                	jle    8004d4 <_main+0x49c>
				{
					*flight2Counter = *flight2Counter - 1;
  80048e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	8d 50 ff             	lea    -0x1(%eax),%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  80049b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80049e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a8:	01 d0                	add    %edx,%eax
  8004aa:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  8004b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c0:	01 c2                	add    %eax,%edx
  8004c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004c5:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  8004c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	8d 50 01             	lea    0x1(%eax),%edx
  8004cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			signal_semaphore(flight2CS);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8004dd:	e8 78 34 00 00       	call   80395a <signal_semaphore>
  8004e2:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8004e5:	e9 03 01 00 00       	jmp    8005ed <_main+0x5b5>
		case 3:
		{
			//Check and update Both Flights
			wait_semaphore(flight1CS); wait_semaphore(flight2CS);
  8004ea:	83 ec 0c             	sub    $0xc,%esp
  8004ed:	ff b5 ac fe ff ff    	pushl  -0x154(%ebp)
  8004f3:	e8 f8 33 00 00       	call   8038f0 <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 e7 33 00 00       	call   8038f0 <wait_semaphore>
  800509:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  80050c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	85 c0                	test   %eax,%eax
  800513:	0f 8e 99 00 00 00    	jle    8005b2 <_main+0x57a>
  800519:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	85 c0                	test   %eax,%eax
  800520:	0f 8e 8c 00 00 00    	jle    8005b2 <_main+0x57a>
				{
					*flight1Counter = *flight1Counter - 1;
  800526:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80052e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800531:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800533:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800536:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800540:	01 d0                	add    %edx,%eax
  800542:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  800549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	01 c2                	add    %eax,%edx
  80055a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80055d:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  80055f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	8d 50 01             	lea    0x1(%eax),%edx
  800567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056a:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  80056c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	8d 50 ff             	lea    -0x1(%eax),%edx
  800574:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800577:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800579:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80057c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80058f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80059e:	01 c2                	add    %eax,%edx
  8005a0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8005a3:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  8005a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	8d 50 01             	lea    0x1(%eax),%edx
  8005ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			signal_semaphore(flight1CS); signal_semaphore(flight2CS);
  8005b2:	83 ec 0c             	sub    $0xc,%esp
  8005b5:	ff b5 ac fe ff ff    	pushl  -0x154(%ebp)
  8005bb:	e8 9a 33 00 00       	call   80395a <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 89 33 00 00       	call   80395a <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 40 3c 80 00       	push   $0x803c40
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 60 3c 80 00       	push   $0x803c60
  8005e8:	e8 e9 01 00 00       	call   8007d6 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb 6f 3d 80 00       	mov    $0x803d6f,%ebx
  8005f8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8005fd:	89 c7                	mov    %eax,%edi
  8005ff:	89 de                	mov    %ebx,%esi
  800601:	89 d1                	mov    %edx,%ecx
  800603:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800605:	8d 95 94 fe ff ff    	lea    -0x16c(%ebp),%edx
  80060b:	b9 04 00 00 00       	mov    $0x4,%ecx
  800610:	b8 00 00 00 00       	mov    $0x0,%eax
  800615:	89 d7                	mov    %edx,%edi
  800617:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	8d 85 81 fe ff ff    	lea    -0x17f(%ebp),%eax
  800622:	50                   	push   %eax
  800623:	ff 75 bc             	pushl  -0x44(%ebp)
  800626:	e8 a2 0f 00 00       	call   8015cd <ltostr>
  80062b:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80062e:	83 ec 04             	sub    $0x4,%esp
  800631:	8d 85 4a fe ff ff    	lea    -0x1b6(%ebp),%eax
  800637:	50                   	push   %eax
  800638:	8d 85 81 fe ff ff    	lea    -0x17f(%ebp),%eax
  80063e:	50                   	push   %eax
  80063f:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  800645:	50                   	push   %eax
  800646:	e8 5b 10 00 00       	call   8016a6 <strcconcat>
  80064b:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80064e:	8d 85 7c fe ff ff    	lea    -0x184(%ebp),%eax
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	8d 95 4a fe ff ff    	lea    -0x1b6(%ebp),%edx
  80065d:	52                   	push   %edx
  80065e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800661:	50                   	push   %eax
  800662:	e8 40 32 00 00       	call   8038a7 <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 e2 32 00 00       	call   80395a <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 d1 32 00 00       	call   80395a <signal_semaphore>
  800689:	83 c4 10             	add    $0x10,%esp
	}
  80068c:	e9 e5 fc ff ff       	jmp    800376 <_main+0x33e>

00800691 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800697:	e8 45 1b 00 00       	call   8021e1 <sys_getenvindex>
  80069c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80069f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a2:	89 d0                	mov    %edx,%eax
  8006a4:	c1 e0 02             	shl    $0x2,%eax
  8006a7:	01 d0                	add    %edx,%eax
  8006a9:	c1 e0 03             	shl    $0x3,%eax
  8006ac:	01 d0                	add    %edx,%eax
  8006ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8006b5:	01 d0                	add    %edx,%eax
  8006b7:	c1 e0 02             	shl    $0x2,%eax
  8006ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006bf:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c9:	8a 40 20             	mov    0x20(%eax),%al
  8006cc:	84 c0                	test   %al,%al
  8006ce:	74 0d                	je     8006dd <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8006d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d5:	83 c0 20             	add    $0x20,%eax
  8006d8:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006e1:	7e 0a                	jle    8006ed <libmain+0x5c>
		binaryname = argv[0];
  8006e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	ff 75 08             	pushl  0x8(%ebp)
  8006f6:	e8 3d f9 ff ff       	call   800038 <_main>
  8006fb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800703:	85 c0                	test   %eax,%eax
  800705:	0f 84 9f 00 00 00    	je     8007aa <libmain+0x119>
	{
		sys_lock_cons();
  80070b:	e8 55 18 00 00       	call   801f65 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800710:	83 ec 0c             	sub    $0xc,%esp
  800713:	68 a8 3d 80 00       	push   $0x803da8
  800718:	e8 76 03 00 00       	call   800a93 <cprintf>
  80071d:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800720:	a1 20 50 80 00       	mov    0x805020,%eax
  800725:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80072b:	a1 20 50 80 00       	mov    0x805020,%eax
  800730:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800736:	83 ec 04             	sub    $0x4,%esp
  800739:	52                   	push   %edx
  80073a:	50                   	push   %eax
  80073b:	68 d0 3d 80 00       	push   $0x803dd0
  800740:	e8 4e 03 00 00       	call   800a93 <cprintf>
  800745:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800748:	a1 20 50 80 00       	mov    0x805020,%eax
  80074d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800753:	a1 20 50 80 00       	mov    0x805020,%eax
  800758:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80075e:	a1 20 50 80 00       	mov    0x805020,%eax
  800763:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800769:	51                   	push   %ecx
  80076a:	52                   	push   %edx
  80076b:	50                   	push   %eax
  80076c:	68 f8 3d 80 00       	push   $0x803df8
  800771:	e8 1d 03 00 00       	call   800a93 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800779:	a1 20 50 80 00       	mov    0x805020,%eax
  80077e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	50                   	push   %eax
  800788:	68 50 3e 80 00       	push   $0x803e50
  80078d:	e8 01 03 00 00       	call   800a93 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	68 a8 3d 80 00       	push   $0x803da8
  80079d:	e8 f1 02 00 00       	call   800a93 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007a5:	e8 d5 17 00 00       	call   801f7f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007aa:	e8 19 00 00 00       	call   8007c8 <exit>
}
  8007af:	90                   	nop
  8007b0:	c9                   	leave  
  8007b1:	c3                   	ret    

008007b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007b8:	83 ec 0c             	sub    $0xc,%esp
  8007bb:	6a 00                	push   $0x0
  8007bd:	e8 eb 19 00 00       	call   8021ad <sys_destroy_env>
  8007c2:	83 c4 10             	add    $0x10,%esp
}
  8007c5:	90                   	nop
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    

008007c8 <exit>:

void
exit(void)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007ce:	e8 40 1a 00 00       	call   802213 <sys_exit_env>
}
  8007d3:	90                   	nop
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8007df:	83 c0 04             	add    $0x4,%eax
  8007e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007e5:	a1 60 50 98 00       	mov    0x985060,%eax
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	74 16                	je     800804 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007ee:	a1 60 50 98 00       	mov    0x985060,%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	50                   	push   %eax
  8007f7:	68 64 3e 80 00       	push   $0x803e64
  8007fc:	e8 92 02 00 00       	call   800a93 <cprintf>
  800801:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800804:	a1 04 50 80 00       	mov    0x805004,%eax
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	ff 75 08             	pushl  0x8(%ebp)
  80080f:	50                   	push   %eax
  800810:	68 69 3e 80 00       	push   $0x803e69
  800815:	e8 79 02 00 00       	call   800a93 <cprintf>
  80081a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 f4             	pushl  -0xc(%ebp)
  800826:	50                   	push   %eax
  800827:	e8 fc 01 00 00       	call   800a28 <vcprintf>
  80082c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	6a 00                	push   $0x0
  800834:	68 85 3e 80 00       	push   $0x803e85
  800839:	e8 ea 01 00 00       	call   800a28 <vcprintf>
  80083e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800841:	e8 82 ff ff ff       	call   8007c8 <exit>

	// should not return here
	while (1) ;
  800846:	eb fe                	jmp    800846 <_panic+0x70>

00800848 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80084e:	a1 20 50 80 00       	mov    0x805020,%eax
  800853:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800859:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085c:	39 c2                	cmp    %eax,%edx
  80085e:	74 14                	je     800874 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800860:	83 ec 04             	sub    $0x4,%esp
  800863:	68 88 3e 80 00       	push   $0x803e88
  800868:	6a 26                	push   $0x26
  80086a:	68 d4 3e 80 00       	push   $0x803ed4
  80086f:	e8 62 ff ff ff       	call   8007d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800874:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80087b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800882:	e9 c5 00 00 00       	jmp    80094c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	01 d0                	add    %edx,%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	85 c0                	test   %eax,%eax
  80089a:	75 08                	jne    8008a4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80089c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80089f:	e9 a5 00 00 00       	jmp    800949 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008b2:	eb 69                	jmp    80091d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8008b9:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8008bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c2:	89 d0                	mov    %edx,%eax
  8008c4:	01 c0                	add    %eax,%eax
  8008c6:	01 d0                	add    %edx,%eax
  8008c8:	c1 e0 03             	shl    $0x3,%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8a 40 04             	mov    0x4(%eax),%al
  8008d0:	84 c0                	test   %al,%al
  8008d2:	75 46                	jne    80091a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d9:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8008df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008e2:	89 d0                	mov    %edx,%eax
  8008e4:	01 c0                	add    %eax,%eax
  8008e6:	01 d0                	add    %edx,%eax
  8008e8:	c1 e0 03             	shl    $0x3,%eax
  8008eb:	01 c8                	add    %ecx,%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008fa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ff:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	01 c8                	add    %ecx,%eax
  80090b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80090d:	39 c2                	cmp    %eax,%edx
  80090f:	75 09                	jne    80091a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800911:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800918:	eb 15                	jmp    80092f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091a:	ff 45 e8             	incl   -0x18(%ebp)
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80092b:	39 c2                	cmp    %eax,%edx
  80092d:	77 85                	ja     8008b4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80092f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800933:	75 14                	jne    800949 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800935:	83 ec 04             	sub    $0x4,%esp
  800938:	68 e0 3e 80 00       	push   $0x803ee0
  80093d:	6a 3a                	push   $0x3a
  80093f:	68 d4 3e 80 00       	push   $0x803ed4
  800944:	e8 8d fe ff ff       	call   8007d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800949:	ff 45 f0             	incl   -0x10(%ebp)
  80094c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800952:	0f 8c 2f ff ff ff    	jl     800887 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800958:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80095f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800966:	eb 26                	jmp    80098e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800968:	a1 20 50 80 00       	mov    0x805020,%eax
  80096d:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800973:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800976:	89 d0                	mov    %edx,%eax
  800978:	01 c0                	add    %eax,%eax
  80097a:	01 d0                	add    %edx,%eax
  80097c:	c1 e0 03             	shl    $0x3,%eax
  80097f:	01 c8                	add    %ecx,%eax
  800981:	8a 40 04             	mov    0x4(%eax),%al
  800984:	3c 01                	cmp    $0x1,%al
  800986:	75 03                	jne    80098b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800988:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80098b:	ff 45 e0             	incl   -0x20(%ebp)
  80098e:	a1 20 50 80 00       	mov    0x805020,%eax
  800993:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80099c:	39 c2                	cmp    %eax,%edx
  80099e:	77 c8                	ja     800968 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009a6:	74 14                	je     8009bc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009a8:	83 ec 04             	sub    $0x4,%esp
  8009ab:	68 34 3f 80 00       	push   $0x803f34
  8009b0:	6a 44                	push   $0x44
  8009b2:	68 d4 3e 80 00       	push   $0x803ed4
  8009b7:	e8 1a fe ff ff       	call   8007d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009bc:	90                   	nop
  8009bd:	c9                   	leave  
  8009be:	c3                   	ret    

008009bf <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8009cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d0:	89 0a                	mov    %ecx,(%edx)
  8009d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d5:	88 d1                	mov    %dl,%cl
  8009d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009da:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009e8:	75 2c                	jne    800a16 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009ea:	a0 44 50 98 00       	mov    0x985044,%al
  8009ef:	0f b6 c0             	movzbl %al,%eax
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f5:	8b 12                	mov    (%edx),%edx
  8009f7:	89 d1                	mov    %edx,%ecx
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fc:	83 c2 08             	add    $0x8,%edx
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	50                   	push   %eax
  800a03:	51                   	push   %ecx
  800a04:	52                   	push   %edx
  800a05:	e8 19 15 00 00       	call   801f23 <sys_cputs>
  800a0a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a19:	8b 40 04             	mov    0x4(%eax),%eax
  800a1c:	8d 50 01             	lea    0x1(%eax),%edx
  800a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a22:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a25:	90                   	nop
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a31:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a38:	00 00 00 
	b.cnt = 0;
  800a3b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a42:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	ff 75 08             	pushl  0x8(%ebp)
  800a4b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a51:	50                   	push   %eax
  800a52:	68 bf 09 80 00       	push   $0x8009bf
  800a57:	e8 11 02 00 00       	call   800c6d <vprintfmt>
  800a5c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a5f:	a0 44 50 98 00       	mov    0x985044,%al
  800a64:	0f b6 c0             	movzbl %al,%eax
  800a67:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a6d:	83 ec 04             	sub    $0x4,%esp
  800a70:	50                   	push   %eax
  800a71:	52                   	push   %edx
  800a72:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a78:	83 c0 08             	add    $0x8,%eax
  800a7b:	50                   	push   %eax
  800a7c:	e8 a2 14 00 00       	call   801f23 <sys_cputs>
  800a81:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a84:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800a8b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a91:	c9                   	leave  
  800a92:	c3                   	ret    

00800a93 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a99:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800aa0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 f4             	pushl  -0xc(%ebp)
  800aaf:	50                   	push   %eax
  800ab0:	e8 73 ff ff ff       	call   800a28 <vcprintf>
  800ab5:	83 c4 10             	add    $0x10,%esp
  800ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800ac6:	e8 9a 14 00 00       	call   801f65 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800acb:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	83 ec 08             	sub    $0x8,%esp
  800ad7:	ff 75 f4             	pushl  -0xc(%ebp)
  800ada:	50                   	push   %eax
  800adb:	e8 48 ff ff ff       	call   800a28 <vcprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
  800ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ae6:	e8 94 14 00 00       	call   801f7f <sys_unlock_cons>
	return cnt;
  800aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	53                   	push   %ebx
  800af4:	83 ec 14             	sub    $0x14,%esp
  800af7:	8b 45 10             	mov    0x10(%ebp),%eax
  800afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afd:	8b 45 14             	mov    0x14(%ebp),%eax
  800b00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b03:	8b 45 18             	mov    0x18(%ebp),%eax
  800b06:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b0e:	77 55                	ja     800b65 <printnum+0x75>
  800b10:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b13:	72 05                	jb     800b1a <printnum+0x2a>
  800b15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b18:	77 4b                	ja     800b65 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b1a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b1d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b20:	8b 45 18             	mov    0x18(%ebp),%eax
  800b23:	ba 00 00 00 00       	mov    $0x0,%edx
  800b28:	52                   	push   %edx
  800b29:	50                   	push   %eax
  800b2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b30:	e8 93 2e 00 00       	call   8039c8 <__udivdi3>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	83 ec 04             	sub    $0x4,%esp
  800b3b:	ff 75 20             	pushl  0x20(%ebp)
  800b3e:	53                   	push   %ebx
  800b3f:	ff 75 18             	pushl  0x18(%ebp)
  800b42:	52                   	push   %edx
  800b43:	50                   	push   %eax
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	ff 75 08             	pushl  0x8(%ebp)
  800b4a:	e8 a1 ff ff ff       	call   800af0 <printnum>
  800b4f:	83 c4 20             	add    $0x20,%esp
  800b52:	eb 1a                	jmp    800b6e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	ff 75 20             	pushl  0x20(%ebp)
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b65:	ff 4d 1c             	decl   0x1c(%ebp)
  800b68:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b6c:	7f e6                	jg     800b54 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b6e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7c:	53                   	push   %ebx
  800b7d:	51                   	push   %ecx
  800b7e:	52                   	push   %edx
  800b7f:	50                   	push   %eax
  800b80:	e8 53 2f 00 00       	call   803ad8 <__umoddi3>
  800b85:	83 c4 10             	add    $0x10,%esp
  800b88:	05 94 41 80 00       	add    $0x804194,%eax
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	0f be c0             	movsbl %al,%eax
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
}
  800ba1:	90                   	nop
  800ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800baa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bae:	7e 1c                	jle    800bcc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8b 00                	mov    (%eax),%eax
  800bb5:	8d 50 08             	lea    0x8(%eax),%edx
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	89 10                	mov    %edx,(%eax)
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8b 00                	mov    (%eax),%eax
  800bc2:	83 e8 08             	sub    $0x8,%eax
  800bc5:	8b 50 04             	mov    0x4(%eax),%edx
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	eb 40                	jmp    800c0c <getuint+0x65>
	else if (lflag)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 1e                	je     800bf0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	8d 50 04             	lea    0x4(%eax),%edx
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	89 10                	mov    %edx,(%eax)
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	83 e8 04             	sub    $0x4,%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bee:	eb 1c                	jmp    800c0c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8b 00                	mov    (%eax),%eax
  800bf5:	8d 50 04             	lea    0x4(%eax),%edx
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	89 10                	mov    %edx,(%eax)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	83 e8 04             	sub    $0x4,%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c15:	7e 1c                	jle    800c33 <getint+0x25>
		return va_arg(*ap, long long);
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	8d 50 08             	lea    0x8(%eax),%edx
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	89 10                	mov    %edx,(%eax)
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8b 00                	mov    (%eax),%eax
  800c29:	83 e8 08             	sub    $0x8,%eax
  800c2c:	8b 50 04             	mov    0x4(%eax),%edx
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	eb 38                	jmp    800c6b <getint+0x5d>
	else if (lflag)
  800c33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c37:	74 1a                	je     800c53 <getint+0x45>
		return va_arg(*ap, long);
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	8d 50 04             	lea    0x4(%eax),%edx
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 10                	mov    %edx,(%eax)
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8b 00                	mov    (%eax),%eax
  800c4b:	83 e8 04             	sub    $0x4,%eax
  800c4e:	8b 00                	mov    (%eax),%eax
  800c50:	99                   	cltd   
  800c51:	eb 18                	jmp    800c6b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8b 00                	mov    (%eax),%eax
  800c58:	8d 50 04             	lea    0x4(%eax),%edx
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	89 10                	mov    %edx,(%eax)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8b 00                	mov    (%eax),%eax
  800c65:	83 e8 04             	sub    $0x4,%eax
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	99                   	cltd   
}
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c75:	eb 17                	jmp    800c8e <vprintfmt+0x21>
			if (ch == '\0')
  800c77:	85 db                	test   %ebx,%ebx
  800c79:	0f 84 c1 03 00 00    	je     801040 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	53                   	push   %ebx
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	89 55 10             	mov    %edx,0x10(%ebp)
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	0f b6 d8             	movzbl %al,%ebx
  800c9c:	83 fb 25             	cmp    $0x25,%ebx
  800c9f:	75 d6                	jne    800c77 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ca1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ca5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cb3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 01             	lea    0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 d8             	movzbl %al,%ebx
  800ccf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cd2:	83 f8 5b             	cmp    $0x5b,%eax
  800cd5:	0f 87 3d 03 00 00    	ja     801018 <vprintfmt+0x3ab>
  800cdb:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
  800ce2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ce4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ce8:	eb d7                	jmp    800cc1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cea:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cee:	eb d1                	jmp    800cc1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cf7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cfa:	89 d0                	mov    %edx,%eax
  800cfc:	c1 e0 02             	shl    $0x2,%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	01 c0                	add    %eax,%eax
  800d03:	01 d8                	add    %ebx,%eax
  800d05:	83 e8 30             	sub    $0x30,%eax
  800d08:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d13:	83 fb 2f             	cmp    $0x2f,%ebx
  800d16:	7e 3e                	jle    800d56 <vprintfmt+0xe9>
  800d18:	83 fb 39             	cmp    $0x39,%ebx
  800d1b:	7f 39                	jg     800d56 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d1d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d20:	eb d5                	jmp    800cf7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d22:	8b 45 14             	mov    0x14(%ebp),%eax
  800d25:	83 c0 04             	add    $0x4,%eax
  800d28:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2e:	83 e8 04             	sub    $0x4,%eax
  800d31:	8b 00                	mov    (%eax),%eax
  800d33:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d36:	eb 1f                	jmp    800d57 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3c:	79 83                	jns    800cc1 <vprintfmt+0x54>
				width = 0;
  800d3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d45:	e9 77 ff ff ff       	jmp    800cc1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d4a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d51:	e9 6b ff ff ff       	jmp    800cc1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d56:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5b:	0f 89 60 ff ff ff    	jns    800cc1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d67:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d6e:	e9 4e ff ff ff       	jmp    800cc1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d73:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d76:	e9 46 ff ff ff       	jmp    800cc1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7e:	83 c0 04             	add    $0x4,%eax
  800d81:	89 45 14             	mov    %eax,0x14(%ebp)
  800d84:	8b 45 14             	mov    0x14(%ebp),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	83 ec 08             	sub    $0x8,%esp
  800d8f:	ff 75 0c             	pushl  0xc(%ebp)
  800d92:	50                   	push   %eax
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	ff d0                	call   *%eax
  800d98:	83 c4 10             	add    $0x10,%esp
			break;
  800d9b:	e9 9b 02 00 00       	jmp    80103b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800da0:	8b 45 14             	mov    0x14(%ebp),%eax
  800da3:	83 c0 04             	add    $0x4,%eax
  800da6:	89 45 14             	mov    %eax,0x14(%ebp)
  800da9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dac:	83 e8 04             	sub    $0x4,%eax
  800daf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800db1:	85 db                	test   %ebx,%ebx
  800db3:	79 02                	jns    800db7 <vprintfmt+0x14a>
				err = -err;
  800db5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800db7:	83 fb 64             	cmp    $0x64,%ebx
  800dba:	7f 0b                	jg     800dc7 <vprintfmt+0x15a>
  800dbc:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  800dc3:	85 f6                	test   %esi,%esi
  800dc5:	75 19                	jne    800de0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dc7:	53                   	push   %ebx
  800dc8:	68 a5 41 80 00       	push   $0x8041a5
  800dcd:	ff 75 0c             	pushl  0xc(%ebp)
  800dd0:	ff 75 08             	pushl  0x8(%ebp)
  800dd3:	e8 70 02 00 00       	call   801048 <printfmt>
  800dd8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ddb:	e9 5b 02 00 00       	jmp    80103b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800de0:	56                   	push   %esi
  800de1:	68 ae 41 80 00       	push   $0x8041ae
  800de6:	ff 75 0c             	pushl  0xc(%ebp)
  800de9:	ff 75 08             	pushl  0x8(%ebp)
  800dec:	e8 57 02 00 00       	call   801048 <printfmt>
  800df1:	83 c4 10             	add    $0x10,%esp
			break;
  800df4:	e9 42 02 00 00       	jmp    80103b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800df9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 14             	mov    %eax,0x14(%ebp)
  800e02:	8b 45 14             	mov    0x14(%ebp),%eax
  800e05:	83 e8 04             	sub    $0x4,%eax
  800e08:	8b 30                	mov    (%eax),%esi
  800e0a:	85 f6                	test   %esi,%esi
  800e0c:	75 05                	jne    800e13 <vprintfmt+0x1a6>
				p = "(null)";
  800e0e:	be b1 41 80 00       	mov    $0x8041b1,%esi
			if (width > 0 && padc != '-')
  800e13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e17:	7e 6d                	jle    800e86 <vprintfmt+0x219>
  800e19:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e1d:	74 67                	je     800e86 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	83 ec 08             	sub    $0x8,%esp
  800e25:	50                   	push   %eax
  800e26:	56                   	push   %esi
  800e27:	e8 1e 03 00 00       	call   80114a <strnlen>
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e32:	eb 16                	jmp    800e4a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e34:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	50                   	push   %eax
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	ff d0                	call   *%eax
  800e44:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e47:	ff 4d e4             	decl   -0x1c(%ebp)
  800e4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e4e:	7f e4                	jg     800e34 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e50:	eb 34                	jmp    800e86 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e52:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e56:	74 1c                	je     800e74 <vprintfmt+0x207>
  800e58:	83 fb 1f             	cmp    $0x1f,%ebx
  800e5b:	7e 05                	jle    800e62 <vprintfmt+0x1f5>
  800e5d:	83 fb 7e             	cmp    $0x7e,%ebx
  800e60:	7e 12                	jle    800e74 <vprintfmt+0x207>
					putch('?', putdat);
  800e62:	83 ec 08             	sub    $0x8,%esp
  800e65:	ff 75 0c             	pushl  0xc(%ebp)
  800e68:	6a 3f                	push   $0x3f
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	ff d0                	call   *%eax
  800e6f:	83 c4 10             	add    $0x10,%esp
  800e72:	eb 0f                	jmp    800e83 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	53                   	push   %ebx
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	ff d0                	call   *%eax
  800e80:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e83:	ff 4d e4             	decl   -0x1c(%ebp)
  800e86:	89 f0                	mov    %esi,%eax
  800e88:	8d 70 01             	lea    0x1(%eax),%esi
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	0f be d8             	movsbl %al,%ebx
  800e90:	85 db                	test   %ebx,%ebx
  800e92:	74 24                	je     800eb8 <vprintfmt+0x24b>
  800e94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e98:	78 b8                	js     800e52 <vprintfmt+0x1e5>
  800e9a:	ff 4d e0             	decl   -0x20(%ebp)
  800e9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ea1:	79 af                	jns    800e52 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ea3:	eb 13                	jmp    800eb8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ea5:	83 ec 08             	sub    $0x8,%esp
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	6a 20                	push   $0x20
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	ff d0                	call   *%eax
  800eb2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eb5:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ebc:	7f e7                	jg     800ea5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ebe:	e9 78 01 00 00       	jmp    80103b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ec3:	83 ec 08             	sub    $0x8,%esp
  800ec6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ec9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecc:	50                   	push   %eax
  800ecd:	e8 3c fd ff ff       	call   800c0e <getint>
  800ed2:	83 c4 10             	add    $0x10,%esp
  800ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ede:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee1:	85 d2                	test   %edx,%edx
  800ee3:	79 23                	jns    800f08 <vprintfmt+0x29b>
				putch('-', putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	6a 2d                	push   $0x2d
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	ff d0                	call   *%eax
  800ef2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efb:	f7 d8                	neg    %eax
  800efd:	83 d2 00             	adc    $0x0,%edx
  800f00:	f7 da                	neg    %edx
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f0f:	e9 bc 00 00 00       	jmp    800fd0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 e8             	pushl  -0x18(%ebp)
  800f1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	e8 84 fc ff ff       	call   800ba7 <getuint>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f2c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f33:	e9 98 00 00 00       	jmp    800fd0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f38:	83 ec 08             	sub    $0x8,%esp
  800f3b:	ff 75 0c             	pushl  0xc(%ebp)
  800f3e:	6a 58                	push   $0x58
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	ff d0                	call   *%eax
  800f45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	ff 75 0c             	pushl  0xc(%ebp)
  800f4e:	6a 58                	push   $0x58
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	ff d0                	call   *%eax
  800f55:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f58:	83 ec 08             	sub    $0x8,%esp
  800f5b:	ff 75 0c             	pushl  0xc(%ebp)
  800f5e:	6a 58                	push   $0x58
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	ff d0                	call   *%eax
  800f65:	83 c4 10             	add    $0x10,%esp
			break;
  800f68:	e9 ce 00 00 00       	jmp    80103b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	6a 30                	push   $0x30
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	ff d0                	call   *%eax
  800f7a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f7d:	83 ec 08             	sub    $0x8,%esp
  800f80:	ff 75 0c             	pushl  0xc(%ebp)
  800f83:	6a 78                	push   $0x78
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	ff d0                	call   *%eax
  800f8a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f90:	83 c0 04             	add    $0x4,%eax
  800f93:	89 45 14             	mov    %eax,0x14(%ebp)
  800f96:	8b 45 14             	mov    0x14(%ebp),%eax
  800f99:	83 e8 04             	sub    $0x4,%eax
  800f9c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fa8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800faf:	eb 1f                	jmp    800fd0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800fb7:	8d 45 14             	lea    0x14(%ebp),%eax
  800fba:	50                   	push   %eax
  800fbb:	e8 e7 fb ff ff       	call   800ba7 <getuint>
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fc9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fd0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd7:	83 ec 04             	sub    $0x4,%esp
  800fda:	52                   	push   %edx
  800fdb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fde:	50                   	push   %eax
  800fdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe2:	ff 75 f0             	pushl  -0x10(%ebp)
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	ff 75 08             	pushl  0x8(%ebp)
  800feb:	e8 00 fb ff ff       	call   800af0 <printnum>
  800ff0:	83 c4 20             	add    $0x20,%esp
			break;
  800ff3:	eb 46                	jmp    80103b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ff5:	83 ec 08             	sub    $0x8,%esp
  800ff8:	ff 75 0c             	pushl  0xc(%ebp)
  800ffb:	53                   	push   %ebx
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	ff d0                	call   *%eax
  801001:	83 c4 10             	add    $0x10,%esp
			break;
  801004:	eb 35                	jmp    80103b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801006:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  80100d:	eb 2c                	jmp    80103b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80100f:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  801016:	eb 23                	jmp    80103b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801018:	83 ec 08             	sub    $0x8,%esp
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	6a 25                	push   $0x25
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	ff d0                	call   *%eax
  801025:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801028:	ff 4d 10             	decl   0x10(%ebp)
  80102b:	eb 03                	jmp    801030 <vprintfmt+0x3c3>
  80102d:	ff 4d 10             	decl   0x10(%ebp)
  801030:	8b 45 10             	mov    0x10(%ebp),%eax
  801033:	48                   	dec    %eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 25                	cmp    $0x25,%al
  801038:	75 f3                	jne    80102d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80103a:	90                   	nop
		}
	}
  80103b:	e9 35 fc ff ff       	jmp    800c75 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801040:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801041:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5d                   	pop    %ebp
  801047:	c3                   	ret    

00801048 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80104e:	8d 45 10             	lea    0x10(%ebp),%eax
  801051:	83 c0 04             	add    $0x4,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801057:	8b 45 10             	mov    0x10(%ebp),%eax
  80105a:	ff 75 f4             	pushl  -0xc(%ebp)
  80105d:	50                   	push   %eax
  80105e:	ff 75 0c             	pushl  0xc(%ebp)
  801061:	ff 75 08             	pushl  0x8(%ebp)
  801064:	e8 04 fc ff ff       	call   800c6d <vprintfmt>
  801069:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80106c:	90                   	nop
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	8b 40 08             	mov    0x8(%eax),%eax
  801078:	8d 50 01             	lea    0x1(%eax),%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	8b 10                	mov    (%eax),%edx
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	8b 40 04             	mov    0x4(%eax),%eax
  80108c:	39 c2                	cmp    %eax,%edx
  80108e:	73 12                	jae    8010a2 <sprintputch+0x33>
		*b->buf++ = ch;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 00                	mov    (%eax),%eax
  801095:	8d 48 01             	lea    0x1(%eax),%ecx
  801098:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109b:	89 0a                	mov    %ecx,(%edx)
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	88 10                	mov    %dl,(%eax)
}
  8010a2:	90                   	nop
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 d0                	add    %edx,%eax
  8010bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ca:	74 06                	je     8010d2 <vsnprintf+0x2d>
  8010cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d0:	7f 07                	jg     8010d9 <vsnprintf+0x34>
		return -E_INVAL;
  8010d2:	b8 03 00 00 00       	mov    $0x3,%eax
  8010d7:	eb 20                	jmp    8010f9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010d9:	ff 75 14             	pushl  0x14(%ebp)
  8010dc:	ff 75 10             	pushl  0x10(%ebp)
  8010df:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010e2:	50                   	push   %eax
  8010e3:	68 6f 10 80 00       	push   $0x80106f
  8010e8:	e8 80 fb ff ff       	call   800c6d <vprintfmt>
  8010ed:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801101:	8d 45 10             	lea    0x10(%ebp),%eax
  801104:	83 c0 04             	add    $0x4,%eax
  801107:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80110a:	8b 45 10             	mov    0x10(%ebp),%eax
  80110d:	ff 75 f4             	pushl  -0xc(%ebp)
  801110:	50                   	push   %eax
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	ff 75 08             	pushl  0x8(%ebp)
  801117:	e8 89 ff ff ff       	call   8010a5 <vsnprintf>
  80111c:	83 c4 10             	add    $0x10,%esp
  80111f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801122:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80112d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801134:	eb 06                	jmp    80113c <strlen+0x15>
		n++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801139:	ff 45 08             	incl   0x8(%ebp)
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	84 c0                	test   %al,%al
  801143:	75 f1                	jne    801136 <strlen+0xf>
		n++;
	return n;
  801145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801157:	eb 09                	jmp    801162 <strnlen+0x18>
		n++;
  801159:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80115c:	ff 45 08             	incl   0x8(%ebp)
  80115f:	ff 4d 0c             	decl   0xc(%ebp)
  801162:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801166:	74 09                	je     801171 <strnlen+0x27>
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	84 c0                	test   %al,%al
  80116f:	75 e8                	jne    801159 <strnlen+0xf>
		n++;
	return n;
  801171:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801182:	90                   	nop
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8d 50 01             	lea    0x1(%eax),%edx
  801189:	89 55 08             	mov    %edx,0x8(%ebp)
  80118c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801192:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801195:	8a 12                	mov    (%edx),%dl
  801197:	88 10                	mov    %dl,(%eax)
  801199:	8a 00                	mov    (%eax),%al
  80119b:	84 c0                	test   %al,%al
  80119d:	75 e4                	jne    801183 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b7:	eb 1f                	jmp    8011d8 <strncpy+0x34>
		*dst++ = *src;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8d 50 01             	lea    0x1(%eax),%edx
  8011bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c5:	8a 12                	mov    (%edx),%dl
  8011c7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	74 03                	je     8011d5 <strncpy+0x31>
			src++;
  8011d2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011d5:	ff 45 fc             	incl   -0x4(%ebp)
  8011d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011db:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011de:	72 d9                	jb     8011b9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f5:	74 30                	je     801227 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011f7:	eb 16                	jmp    80120f <strlcpy+0x2a>
			*dst++ = *src++;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8d 50 01             	lea    0x1(%eax),%edx
  8011ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801202:	8b 55 0c             	mov    0xc(%ebp),%edx
  801205:	8d 4a 01             	lea    0x1(%edx),%ecx
  801208:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80120b:	8a 12                	mov    (%edx),%dl
  80120d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80120f:	ff 4d 10             	decl   0x10(%ebp)
  801212:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801216:	74 09                	je     801221 <strlcpy+0x3c>
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	84 c0                	test   %al,%al
  80121f:	75 d8                	jne    8011f9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801227:	8b 55 08             	mov    0x8(%ebp),%edx
  80122a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122d:	29 c2                	sub    %eax,%edx
  80122f:	89 d0                	mov    %edx,%eax
}
  801231:	c9                   	leave  
  801232:	c3                   	ret    

00801233 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801236:	eb 06                	jmp    80123e <strcmp+0xb>
		p++, q++;
  801238:	ff 45 08             	incl   0x8(%ebp)
  80123b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 0e                	je     801255 <strcmp+0x22>
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 10                	mov    (%eax),%dl
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	38 c2                	cmp    %al,%dl
  801253:	74 e3                	je     801238 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 d0             	movzbl %al,%edx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f b6 c0             	movzbl %al,%eax
  801265:	29 c2                	sub    %eax,%edx
  801267:	89 d0                	mov    %edx,%eax
}
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    

0080126b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80126e:	eb 09                	jmp    801279 <strncmp+0xe>
		n--, p++, q++;
  801270:	ff 4d 10             	decl   0x10(%ebp)
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801279:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127d:	74 17                	je     801296 <strncmp+0x2b>
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	84 c0                	test   %al,%al
  801286:	74 0e                	je     801296 <strncmp+0x2b>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 10                	mov    (%eax),%dl
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	38 c2                	cmp    %al,%dl
  801294:	74 da                	je     801270 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801296:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80129a:	75 07                	jne    8012a3 <strncmp+0x38>
		return 0;
  80129c:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a1:	eb 14                	jmp    8012b7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	0f b6 d0             	movzbl %al,%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	0f b6 c0             	movzbl %al,%eax
  8012b3:	29 c2                	sub    %eax,%edx
  8012b5:	89 d0                	mov    %edx,%eax
}
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    

008012b9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c5:	eb 12                	jmp    8012d9 <strchr+0x20>
		if (*s == c)
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012cf:	75 05                	jne    8012d6 <strchr+0x1d>
			return (char *) s;
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	eb 11                	jmp    8012e7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012d6:	ff 45 08             	incl   0x8(%ebp)
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	84 c0                	test   %al,%al
  8012e0:	75 e5                	jne    8012c7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012f5:	eb 0d                	jmp    801304 <strfind+0x1b>
		if (*s == c)
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ff:	74 0e                	je     80130f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801301:	ff 45 08             	incl   0x8(%ebp)
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	75 ea                	jne    8012f7 <strfind+0xe>
  80130d:	eb 01                	jmp    801310 <strfind+0x27>
		if (*s == c)
			break;
  80130f:	90                   	nop
	return (char *) s;
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801321:	8b 45 10             	mov    0x10(%ebp),%eax
  801324:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801327:	eb 0e                	jmp    801337 <memset+0x22>
		*p++ = c;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801337:	ff 4d f8             	decl   -0x8(%ebp)
  80133a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80133e:	79 e9                	jns    801329 <memset+0x14>
		*p++ = c;

	return v;
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80134b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801357:	eb 16                	jmp    80136f <memcpy+0x2a>
		*d++ = *s++;
  801359:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135c:	8d 50 01             	lea    0x1(%eax),%edx
  80135f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801362:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801365:	8d 4a 01             	lea    0x1(%edx),%ecx
  801368:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80136f:	8b 45 10             	mov    0x10(%ebp),%eax
  801372:	8d 50 ff             	lea    -0x1(%eax),%edx
  801375:	89 55 10             	mov    %edx,0x10(%ebp)
  801378:	85 c0                	test   %eax,%eax
  80137a:	75 dd                	jne    801359 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801393:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801396:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801399:	73 50                	jae    8013eb <memmove+0x6a>
  80139b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139e:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a1:	01 d0                	add    %edx,%eax
  8013a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013a6:	76 43                	jbe    8013eb <memmove+0x6a>
		s += n;
  8013a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ab:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013b4:	eb 10                	jmp    8013c6 <memmove+0x45>
			*--d = *--s;
  8013b6:	ff 4d f8             	decl   -0x8(%ebp)
  8013b9:	ff 4d fc             	decl   -0x4(%ebp)
  8013bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bf:	8a 10                	mov    (%eax),%dl
  8013c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	75 e3                	jne    8013b6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013d3:	eb 23                	jmp    8013f8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d8:	8d 50 01             	lea    0x1(%eax),%edx
  8013db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013e4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013e7:	8a 12                	mov    (%edx),%dl
  8013e9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	75 dd                	jne    8013d5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80140f:	eb 2a                	jmp    80143b <memcmp+0x3e>
		if (*s1 != *s2)
  801411:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801414:	8a 10                	mov    (%eax),%dl
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	38 c2                	cmp    %al,%dl
  80141d:	74 16                	je     801435 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80141f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	0f b6 d0             	movzbl %al,%edx
  801427:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	0f b6 c0             	movzbl %al,%eax
  80142f:	29 c2                	sub    %eax,%edx
  801431:	89 d0                	mov    %edx,%eax
  801433:	eb 18                	jmp    80144d <memcmp+0x50>
		s1++, s2++;
  801435:	ff 45 fc             	incl   -0x4(%ebp)
  801438:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80143b:	8b 45 10             	mov    0x10(%ebp),%eax
  80143e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801441:	89 55 10             	mov    %edx,0x10(%ebp)
  801444:	85 c0                	test   %eax,%eax
  801446:	75 c9                	jne    801411 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801455:	8b 55 08             	mov    0x8(%ebp),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801460:	eb 15                	jmp    801477 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	0f b6 d0             	movzbl %al,%edx
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	0f b6 c0             	movzbl %al,%eax
  801470:	39 c2                	cmp    %eax,%edx
  801472:	74 0d                	je     801481 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801474:	ff 45 08             	incl   0x8(%ebp)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80147d:	72 e3                	jb     801462 <memfind+0x13>
  80147f:	eb 01                	jmp    801482 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801481:	90                   	nop
	return (void *) s;
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80148d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801494:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80149b:	eb 03                	jmp    8014a0 <strtol+0x19>
		s++;
  80149d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	3c 20                	cmp    $0x20,%al
  8014a7:	74 f4                	je     80149d <strtol+0x16>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	3c 09                	cmp    $0x9,%al
  8014b0:	74 eb                	je     80149d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	3c 2b                	cmp    $0x2b,%al
  8014b9:	75 05                	jne    8014c0 <strtol+0x39>
		s++;
  8014bb:	ff 45 08             	incl   0x8(%ebp)
  8014be:	eb 13                	jmp    8014d3 <strtol+0x4c>
	else if (*s == '-')
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8a 00                	mov    (%eax),%al
  8014c5:	3c 2d                	cmp    $0x2d,%al
  8014c7:	75 0a                	jne    8014d3 <strtol+0x4c>
		s++, neg = 1;
  8014c9:	ff 45 08             	incl   0x8(%ebp)
  8014cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d7:	74 06                	je     8014df <strtol+0x58>
  8014d9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014dd:	75 20                	jne    8014ff <strtol+0x78>
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	3c 30                	cmp    $0x30,%al
  8014e6:	75 17                	jne    8014ff <strtol+0x78>
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	40                   	inc    %eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	3c 78                	cmp    $0x78,%al
  8014f0:	75 0d                	jne    8014ff <strtol+0x78>
		s += 2, base = 16;
  8014f2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014f6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014fd:	eb 28                	jmp    801527 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801503:	75 15                	jne    80151a <strtol+0x93>
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	3c 30                	cmp    $0x30,%al
  80150c:	75 0c                	jne    80151a <strtol+0x93>
		s++, base = 8;
  80150e:	ff 45 08             	incl   0x8(%ebp)
  801511:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801518:	eb 0d                	jmp    801527 <strtol+0xa0>
	else if (base == 0)
  80151a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80151e:	75 07                	jne    801527 <strtol+0xa0>
		base = 10;
  801520:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	3c 2f                	cmp    $0x2f,%al
  80152e:	7e 19                	jle    801549 <strtol+0xc2>
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	3c 39                	cmp    $0x39,%al
  801537:	7f 10                	jg     801549 <strtol+0xc2>
			dig = *s - '0';
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	0f be c0             	movsbl %al,%eax
  801541:	83 e8 30             	sub    $0x30,%eax
  801544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801547:	eb 42                	jmp    80158b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	3c 60                	cmp    $0x60,%al
  801550:	7e 19                	jle    80156b <strtol+0xe4>
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	8a 00                	mov    (%eax),%al
  801557:	3c 7a                	cmp    $0x7a,%al
  801559:	7f 10                	jg     80156b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	0f be c0             	movsbl %al,%eax
  801563:	83 e8 57             	sub    $0x57,%eax
  801566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801569:	eb 20                	jmp    80158b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	3c 40                	cmp    $0x40,%al
  801572:	7e 39                	jle    8015ad <strtol+0x126>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	3c 5a                	cmp    $0x5a,%al
  80157b:	7f 30                	jg     8015ad <strtol+0x126>
			dig = *s - 'A' + 10;
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f be c0             	movsbl %al,%eax
  801585:	83 e8 37             	sub    $0x37,%eax
  801588:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80158b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801591:	7d 19                	jge    8015ac <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801593:	ff 45 08             	incl   0x8(%ebp)
  801596:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801599:	0f af 45 10          	imul   0x10(%ebp),%eax
  80159d:	89 c2                	mov    %eax,%edx
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	01 d0                	add    %edx,%eax
  8015a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015a7:	e9 7b ff ff ff       	jmp    801527 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015ac:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b1:	74 08                	je     8015bb <strtol+0x134>
		*endptr = (char *) s;
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015bf:	74 07                	je     8015c8 <strtol+0x141>
  8015c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c4:	f7 d8                	neg    %eax
  8015c6:	eb 03                	jmp    8015cb <strtol+0x144>
  8015c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <ltostr>:

void
ltostr(long value, char *str)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e5:	79 13                	jns    8015fa <ltostr+0x2d>
	{
		neg = 1;
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015f4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015f7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801602:	99                   	cltd   
  801603:	f7 f9                	idiv   %ecx
  801605:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801608:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160b:	8d 50 01             	lea    0x1(%eax),%edx
  80160e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801611:	89 c2                	mov    %eax,%edx
  801613:	8b 45 0c             	mov    0xc(%ebp),%eax
  801616:	01 d0                	add    %edx,%eax
  801618:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80161b:	83 c2 30             	add    $0x30,%edx
  80161e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801620:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801623:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801628:	f7 e9                	imul   %ecx
  80162a:	c1 fa 02             	sar    $0x2,%edx
  80162d:	89 c8                	mov    %ecx,%eax
  80162f:	c1 f8 1f             	sar    $0x1f,%eax
  801632:	29 c2                	sub    %eax,%edx
  801634:	89 d0                	mov    %edx,%eax
  801636:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801639:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80163d:	75 bb                	jne    8015fa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80163f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801646:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801649:	48                   	dec    %eax
  80164a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80164d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801651:	74 3d                	je     801690 <ltostr+0xc3>
		start = 1 ;
  801653:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80165a:	eb 34                	jmp    801690 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80165c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	01 d0                	add    %edx,%eax
  801664:	8a 00                	mov    (%eax),%al
  801666:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801669:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166f:	01 c2                	add    %eax,%edx
  801671:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	01 c8                	add    %ecx,%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80167d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801680:	8b 45 0c             	mov    0xc(%ebp),%eax
  801683:	01 c2                	add    %eax,%edx
  801685:	8a 45 eb             	mov    -0x15(%ebp),%al
  801688:	88 02                	mov    %al,(%edx)
		start++ ;
  80168a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80168d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801696:	7c c4                	jl     80165c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801698:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80169b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169e:	01 d0                	add    %edx,%eax
  8016a0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016a3:	90                   	nop
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016ac:	ff 75 08             	pushl  0x8(%ebp)
  8016af:	e8 73 fa ff ff       	call   801127 <strlen>
  8016b4:	83 c4 04             	add    $0x4,%esp
  8016b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	e8 65 fa ff ff       	call   801127 <strlen>
  8016c2:	83 c4 04             	add    $0x4,%esp
  8016c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016d6:	eb 17                	jmp    8016ef <strcconcat+0x49>
		final[s] = str1[s] ;
  8016d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016ec:	ff 45 fc             	incl   -0x4(%ebp)
  8016ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016f5:	7c e1                	jl     8016d8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801705:	eb 1f                	jmp    801726 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801707:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170a:	8d 50 01             	lea    0x1(%eax),%edx
  80170d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801710:	89 c2                	mov    %eax,%edx
  801712:	8b 45 10             	mov    0x10(%ebp),%eax
  801715:	01 c2                	add    %eax,%edx
  801717:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	01 c8                	add    %ecx,%eax
  80171f:	8a 00                	mov    (%eax),%al
  801721:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801723:	ff 45 f8             	incl   -0x8(%ebp)
  801726:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801729:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80172c:	7c d9                	jl     801707 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80172e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	01 d0                	add    %edx,%eax
  801736:	c6 00 00             	movb   $0x0,(%eax)
}
  801739:	90                   	nop
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80173f:	8b 45 14             	mov    0x14(%ebp),%eax
  801742:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801748:	8b 45 14             	mov    0x14(%ebp),%eax
  80174b:	8b 00                	mov    (%eax),%eax
  80174d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	01 d0                	add    %edx,%eax
  801759:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80175f:	eb 0c                	jmp    80176d <strsplit+0x31>
			*string++ = 0;
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8d 50 01             	lea    0x1(%eax),%edx
  801767:	89 55 08             	mov    %edx,0x8(%ebp)
  80176a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	84 c0                	test   %al,%al
  801774:	74 18                	je     80178e <strsplit+0x52>
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	0f be c0             	movsbl %al,%eax
  80177e:	50                   	push   %eax
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	e8 32 fb ff ff       	call   8012b9 <strchr>
  801787:	83 c4 08             	add    $0x8,%esp
  80178a:	85 c0                	test   %eax,%eax
  80178c:	75 d3                	jne    801761 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	84 c0                	test   %al,%al
  801795:	74 5a                	je     8017f1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801797:	8b 45 14             	mov    0x14(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	83 f8 0f             	cmp    $0xf,%eax
  80179f:	75 07                	jne    8017a8 <strsplit+0x6c>
		{
			return 0;
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a6:	eb 66                	jmp    80180e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ab:	8b 00                	mov    (%eax),%eax
  8017ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8017b0:	8b 55 14             	mov    0x14(%ebp),%edx
  8017b3:	89 0a                	mov    %ecx,(%edx)
  8017b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	01 c2                	add    %eax,%edx
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017c6:	eb 03                	jmp    8017cb <strsplit+0x8f>
			string++;
  8017c8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	84 c0                	test   %al,%al
  8017d2:	74 8b                	je     80175f <strsplit+0x23>
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	50                   	push   %eax
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	e8 d4 fa ff ff       	call   8012b9 <strchr>
  8017e5:	83 c4 08             	add    $0x8,%esp
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	74 dc                	je     8017c8 <strsplit+0x8c>
			string++;
	}
  8017ec:	e9 6e ff ff ff       	jmp    80175f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017f1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f5:	8b 00                	mov    (%eax),%eax
  8017f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801801:	01 d0                	add    %edx,%eax
  801803:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801809:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	68 28 43 80 00       	push   $0x804328
  80181e:	68 3f 01 00 00       	push   $0x13f
  801823:	68 4a 43 80 00       	push   $0x80434a
  801828:	e8 a9 ef ff ff       	call   8007d6 <_panic>

0080182d <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801833:	83 ec 0c             	sub    $0xc,%esp
  801836:	ff 75 08             	pushl  0x8(%ebp)
  801839:	e8 90 0c 00 00       	call   8024ce <sys_sbrk>
  80183e:	83 c4 10             	add    $0x10,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801849:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80184d:	75 0a                	jne    801859 <malloc+0x16>
		return NULL;
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
  801854:	e9 9e 01 00 00       	jmp    8019f7 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801859:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801860:	77 2c                	ja     80188e <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801862:	e8 eb 0a 00 00       	call   802352 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801867:	85 c0                	test   %eax,%eax
  801869:	74 19                	je     801884 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80186b:	83 ec 0c             	sub    $0xc,%esp
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	e8 85 11 00 00       	call   8029fb <alloc_block_FF>
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80187c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187f:	e9 73 01 00 00       	jmp    8019f7 <malloc+0x1b4>
		} else {
			return NULL;
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
  801889:	e9 69 01 00 00       	jmp    8019f7 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80188e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801895:	8b 55 08             	mov    0x8(%ebp),%edx
  801898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189b:	01 d0                	add    %edx,%eax
  80189d:	48                   	dec    %eax
  80189e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a9:	f7 75 e0             	divl   -0x20(%ebp)
  8018ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018af:	29 d0                	sub    %edx,%eax
  8018b1:	c1 e8 0c             	shr    $0xc,%eax
  8018b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8018b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8018be:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8018c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8018ca:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018cd:	05 00 10 00 00       	add    $0x1000,%eax
  8018d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8018d5:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8018da:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018dd:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8018e0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8018e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018ed:	01 d0                	add    %edx,%eax
  8018ef:	48                   	dec    %eax
  8018f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8018f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fb:	f7 75 cc             	divl   -0x34(%ebp)
  8018fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801901:	29 d0                	sub    %edx,%eax
  801903:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801906:	76 0a                	jbe    801912 <malloc+0xcf>
		return NULL;
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
  80190d:	e9 e5 00 00 00       	jmp    8019f7 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801912:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801915:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801918:	eb 48                	jmp    801962 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80191a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801920:	c1 e8 0c             	shr    $0xc,%eax
  801923:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801926:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801929:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801930:	85 c0                	test   %eax,%eax
  801932:	75 11                	jne    801945 <malloc+0x102>
			freePagesCount++;
  801934:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801937:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80193b:	75 16                	jne    801953 <malloc+0x110>
				start = i;
  80193d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801940:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801943:	eb 0e                	jmp    801953 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80194c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801956:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801959:	74 12                	je     80196d <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80195b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801962:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801969:	76 af                	jbe    80191a <malloc+0xd7>
  80196b:	eb 01                	jmp    80196e <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80196d:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80196e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801972:	74 08                	je     80197c <malloc+0x139>
  801974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801977:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80197a:	74 07                	je     801983 <malloc+0x140>
		return NULL;
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
  801981:	eb 74                	jmp    8019f7 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801986:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801989:	c1 e8 0c             	shr    $0xc,%eax
  80198c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  80198f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801992:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801995:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80199c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80199f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019a2:	eb 11                	jmp    8019b5 <malloc+0x172>
		markedPages[i] = 1;
  8019a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019a7:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8019ae:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8019b2:	ff 45 e8             	incl   -0x18(%ebp)
  8019b5:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8019b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019bb:	01 d0                	add    %edx,%eax
  8019bd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019c0:	77 e2                	ja     8019a4 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8019c2:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8019c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8019cf:	01 d0                	add    %edx,%eax
  8019d1:	48                   	dec    %eax
  8019d2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8019d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dd:	f7 75 bc             	divl   -0x44(%ebp)
  8019e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019e3:	29 d0                	sub    %edx,%eax
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	50                   	push   %eax
  8019e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ec:	e8 14 0b 00 00       	call   802505 <sys_allocate_user_mem>
  8019f1:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8019f4:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8019ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a03:	0f 84 ee 00 00 00    	je     801af7 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801a09:	a1 20 50 80 00       	mov    0x805020,%eax
  801a0e:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801a11:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a14:	77 09                	ja     801a1f <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801a16:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801a1d:	76 14                	jbe    801a33 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801a1f:	83 ec 04             	sub    $0x4,%esp
  801a22:	68 58 43 80 00       	push   $0x804358
  801a27:	6a 68                	push   $0x68
  801a29:	68 72 43 80 00       	push   $0x804372
  801a2e:	e8 a3 ed ff ff       	call   8007d6 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801a33:	a1 20 50 80 00       	mov    0x805020,%eax
  801a38:	8b 40 74             	mov    0x74(%eax),%eax
  801a3b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a3e:	77 20                	ja     801a60 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801a40:	a1 20 50 80 00       	mov    0x805020,%eax
  801a45:	8b 40 78             	mov    0x78(%eax),%eax
  801a48:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a4b:	76 13                	jbe    801a60 <free+0x67>
		free_block(virtual_address);
  801a4d:	83 ec 0c             	sub    $0xc,%esp
  801a50:	ff 75 08             	pushl  0x8(%ebp)
  801a53:	e8 6c 16 00 00       	call   8030c4 <free_block>
  801a58:	83 c4 10             	add    $0x10,%esp
		return;
  801a5b:	e9 98 00 00 00       	jmp    801af8 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801a60:	8b 55 08             	mov    0x8(%ebp),%edx
  801a63:	a1 20 50 80 00       	mov    0x805020,%eax
  801a68:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a6b:	29 c2                	sub    %eax,%edx
  801a6d:	89 d0                	mov    %edx,%eax
  801a6f:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801a74:	c1 e8 0c             	shr    $0xc,%eax
  801a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801a7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801a81:	eb 16                	jmp    801a99 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a89:	01 d0                	add    %edx,%eax
  801a8b:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801a92:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801a96:	ff 45 f4             	incl   -0xc(%ebp)
  801a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9c:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801aa3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801aa6:	7f db                	jg     801a83 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aab:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801ab2:	c1 e0 0c             	shl    $0xc,%eax
  801ab5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801abe:	eb 1a                	jmp    801ada <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	68 00 10 00 00       	push   $0x1000
  801ac8:	ff 75 f0             	pushl  -0x10(%ebp)
  801acb:	e8 19 0a 00 00       	call   8024e9 <sys_free_user_mem>
  801ad0:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801ad3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801ada:	8b 55 08             	mov    0x8(%ebp),%edx
  801add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae0:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801ae2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ae5:	77 d9                	ja     801ac0 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aea:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801af1:	00 00 00 00 
  801af5:	eb 01                	jmp    801af8 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801af7:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 58             	sub    $0x58,%esp
  801b00:	8b 45 10             	mov    0x10(%ebp),%eax
  801b03:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801b06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b0a:	75 0a                	jne    801b16 <smalloc+0x1c>
		return NULL;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b11:	e9 7d 01 00 00       	jmp    801c93 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801b16:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
  801b25:	48                   	dec    %eax
  801b26:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b31:	f7 75 e4             	divl   -0x1c(%ebp)
  801b34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b37:	29 d0                	sub    %edx,%eax
  801b39:	c1 e8 0c             	shr    $0xc,%eax
  801b3c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801b46:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801b4d:	a1 20 50 80 00       	mov    0x805020,%eax
  801b52:	8b 40 7c             	mov    0x7c(%eax),%eax
  801b55:	05 00 10 00 00       	add    $0x1000,%eax
  801b5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801b5d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801b62:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801b65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801b68:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b72:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b75:	01 d0                	add    %edx,%eax
  801b77:	48                   	dec    %eax
  801b78:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801b7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b83:	f7 75 d0             	divl   -0x30(%ebp)
  801b86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b89:	29 d0                	sub    %edx,%eax
  801b8b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b8e:	76 0a                	jbe    801b9a <smalloc+0xa0>
		return NULL;
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
  801b95:	e9 f9 00 00 00       	jmp    801c93 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801b9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ba0:	eb 48                	jmp    801bea <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ba8:	c1 e8 0c             	shr    $0xc,%eax
  801bab:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801bae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bb1:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	75 11                	jne    801bcd <smalloc+0xd3>
			freePagesCount++;
  801bbc:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801bbf:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801bc3:	75 16                	jne    801bdb <smalloc+0xe1>
				start = s;
  801bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bcb:	eb 0e                	jmp    801bdb <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801bd4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801be1:	74 12                	je     801bf5 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801be3:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801bea:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801bf1:	76 af                	jbe    801ba2 <smalloc+0xa8>
  801bf3:	eb 01                	jmp    801bf6 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801bf5:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801bf6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801bfa:	74 08                	je     801c04 <smalloc+0x10a>
  801bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801c02:	74 0a                	je     801c0e <smalloc+0x114>
		return NULL;
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
  801c09:	e9 85 00 00 00       	jmp    801c93 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c11:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801c14:	c1 e8 0c             	shr    $0xc,%eax
  801c17:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801c1a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c1d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c20:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801c27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c2d:	eb 11                	jmp    801c40 <smalloc+0x146>
		markedPages[s] = 1;
  801c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c32:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801c39:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801c3d:	ff 45 e8             	incl   -0x18(%ebp)
  801c40:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801c43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c46:	01 d0                	add    %edx,%eax
  801c48:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c4b:	77 e2                	ja     801c2f <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c50:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801c54:	52                   	push   %edx
  801c55:	50                   	push   %eax
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	ff 75 08             	pushl  0x8(%ebp)
  801c5c:	e8 8f 04 00 00       	call   8020f0 <sys_createSharedObject>
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801c67:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801c6b:	78 12                	js     801c7f <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801c6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c70:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801c73:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7d:	eb 14                	jmp    801c93 <smalloc+0x199>
	}
	free((void*) start);
  801c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c82:	83 ec 0c             	sub    $0xc,%esp
  801c85:	50                   	push   %eax
  801c86:	e8 6e fd ff ff       	call   8019f9 <free>
  801c8b:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801c9b:	83 ec 08             	sub    $0x8,%esp
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	ff 75 08             	pushl  0x8(%ebp)
  801ca4:	e8 71 04 00 00       	call   80211a <sys_getSizeOfSharedObject>
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801caf:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801cb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cbc:	01 d0                	add    %edx,%eax
  801cbe:	48                   	dec    %eax
  801cbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801cca:	f7 75 e0             	divl   -0x20(%ebp)
  801ccd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cd0:	29 d0                	sub    %edx,%eax
  801cd2:	c1 e8 0c             	shr    $0xc,%eax
  801cd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801cdf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801ce6:	a1 20 50 80 00       	mov    0x805020,%eax
  801ceb:	8b 40 7c             	mov    0x7c(%eax),%eax
  801cee:	05 00 10 00 00       	add    $0x1000,%eax
  801cf3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801cf6:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801cfb:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801cfe:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801d01:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801d08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d0e:	01 d0                	add    %edx,%eax
  801d10:	48                   	dec    %eax
  801d11:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801d14:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d17:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1c:	f7 75 cc             	divl   -0x34(%ebp)
  801d1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d22:	29 d0                	sub    %edx,%eax
  801d24:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d27:	76 0a                	jbe    801d33 <sget+0x9e>
		return NULL;
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2e:	e9 f7 00 00 00       	jmp    801e2a <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801d33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d39:	eb 48                	jmp    801d83 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d41:	c1 e8 0c             	shr    $0xc,%eax
  801d44:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801d47:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d4a:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801d51:	85 c0                	test   %eax,%eax
  801d53:	75 11                	jne    801d66 <sget+0xd1>
			free_Pages_Count++;
  801d55:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801d58:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d5c:	75 16                	jne    801d74 <sget+0xdf>
				start = s;
  801d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d64:	eb 0e                	jmp    801d74 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801d66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801d6d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d77:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d7a:	74 12                	je     801d8e <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801d7c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801d83:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d8a:	76 af                	jbe    801d3b <sget+0xa6>
  801d8c:	eb 01                	jmp    801d8f <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801d8e:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801d8f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d93:	74 08                	je     801d9d <sget+0x108>
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d9b:	74 0a                	je     801da7 <sget+0x112>
		return NULL;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801da2:	e9 83 00 00 00       	jmp    801e2a <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801daa:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801dad:	c1 e8 0c             	shr    $0xc,%eax
  801db0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801db3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801db6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801db9:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801dc0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801dc6:	eb 11                	jmp    801dd9 <sget+0x144>
		markedPages[k] = 1;
  801dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dcb:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801dd2:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801dd6:	ff 45 e8             	incl   -0x18(%ebp)
  801dd9:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801ddc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ddf:	01 d0                	add    %edx,%eax
  801de1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801de4:	77 e2                	ja     801dc8 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de9:	83 ec 04             	sub    $0x4,%esp
  801dec:	50                   	push   %eax
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	e8 3f 03 00 00       	call   802137 <sys_getSharedObject>
  801df8:	83 c4 10             	add    $0x10,%esp
  801dfb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801dfe:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801e02:	78 12                	js     801e16 <sget+0x181>
		shardIDs[startPage] = ss;
  801e04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e07:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e0a:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e14:	eb 14                	jmp    801e2a <sget+0x195>
	}
	free((void*) start);
  801e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	50                   	push   %eax
  801e1d:	e8 d7 fb ff ff       	call   8019f9 <free>
  801e22:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801e32:	8b 55 08             	mov    0x8(%ebp),%edx
  801e35:	a1 20 50 80 00       	mov    0x805020,%eax
  801e3a:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e3d:	29 c2                	sub    %eax,%edx
  801e3f:	89 d0                	mov    %edx,%eax
  801e41:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801e46:	c1 e8 0c             	shr    $0xc,%eax
  801e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801e56:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801e59:	83 ec 08             	sub    $0x8,%esp
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e62:	e8 ef 02 00 00       	call   802156 <sys_freeSharedObject>
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801e6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e71:	75 0e                	jne    801e81 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801e7d:	ff ff ff ff 
	}

}
  801e81:	90                   	nop
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e8a:	83 ec 04             	sub    $0x4,%esp
  801e8d:	68 80 43 80 00       	push   $0x804380
  801e92:	68 19 01 00 00       	push   $0x119
  801e97:	68 72 43 80 00       	push   $0x804372
  801e9c:	e8 35 e9 ff ff       	call   8007d6 <_panic>

00801ea1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	68 a6 43 80 00       	push   $0x8043a6
  801eaf:	68 23 01 00 00       	push   $0x123
  801eb4:	68 72 43 80 00       	push   $0x804372
  801eb9:	e8 18 e9 ff ff       	call   8007d6 <_panic>

00801ebe <shrink>:

}
void shrink(uint32 newSize) {
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	68 a6 43 80 00       	push   $0x8043a6
  801ecc:	68 27 01 00 00       	push   $0x127
  801ed1:	68 72 43 80 00       	push   $0x804372
  801ed6:	e8 fb e8 ff ff       	call   8007d6 <_panic>

00801edb <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	68 a6 43 80 00       	push   $0x8043a6
  801ee9:	68 2b 01 00 00       	push   $0x12b
  801eee:	68 72 43 80 00       	push   $0x804372
  801ef3:	e8 de e8 ff ff       	call   8007d6 <_panic>

00801ef8 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	57                   	push   %edi
  801efc:	56                   	push   %esi
  801efd:	53                   	push   %ebx
  801efe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f0d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f10:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f13:	cd 30                	int    $0x30
  801f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	5b                   	pop    %ebx
  801f1f:	5e                   	pop    %esi
  801f20:	5f                   	pop    %edi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801f2f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	52                   	push   %edx
  801f3b:	ff 75 0c             	pushl  0xc(%ebp)
  801f3e:	50                   	push   %eax
  801f3f:	6a 00                	push   $0x0
  801f41:	e8 b2 ff ff ff       	call   801ef8 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	90                   	nop
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_cgetc>:

int sys_cgetc(void) {
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 02                	push   $0x2
  801f5b:	e8 98 ff ff ff       	call   801ef8 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_lock_cons>:

void sys_lock_cons(void) {
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 03                	push   $0x3
  801f74:	e8 7f ff ff ff       	call   801ef8 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	90                   	nop
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 04                	push   $0x4
  801f8e:	e8 65 ff ff ff       	call   801ef8 <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	90                   	nop
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	6a 08                	push   $0x8
  801fac:	e8 47 ff ff ff       	call   801ef8 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	56                   	push   %esi
  801fba:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801fbb:	8b 75 18             	mov    0x18(%ebp),%esi
  801fbe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	51                   	push   %ecx
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	6a 09                	push   $0x9
  801fd1:	e8 22 ff ff ff       	call   801ef8 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801fd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdc:	5b                   	pop    %ebx
  801fdd:	5e                   	pop    %esi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	52                   	push   %edx
  801ff0:	50                   	push   %eax
  801ff1:	6a 0a                	push   $0xa
  801ff3:	e8 00 ff ff ff       	call   801ef8 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	ff 75 0c             	pushl  0xc(%ebp)
  802009:	ff 75 08             	pushl  0x8(%ebp)
  80200c:	6a 0b                	push   $0xb
  80200e:	e8 e5 fe ff ff       	call   801ef8 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 0c                	push   $0xc
  802027:	e8 cc fe ff ff       	call   801ef8 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 0d                	push   $0xd
  802040:	e8 b3 fe ff ff       	call   801ef8 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 0e                	push   $0xe
  802059:	e8 9a fe ff ff       	call   801ef8 <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 0f                	push   $0xf
  802072:	e8 81 fe ff ff       	call   801ef8 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	ff 75 08             	pushl  0x8(%ebp)
  80208a:	6a 10                	push   $0x10
  80208c:	e8 67 fe ff ff       	call   801ef8 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_scarce_memory>:

void sys_scarce_memory() {
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 11                	push   $0x11
  8020a5:	e8 4e fe ff ff       	call   801ef8 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
}
  8020ad:	90                   	nop
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <sys_cputc>:

void sys_cputc(const char c) {
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	50                   	push   %eax
  8020c9:	6a 01                	push   $0x1
  8020cb:	e8 28 fe ff ff       	call   801ef8 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	90                   	nop
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 14                	push   $0x14
  8020e5:	e8 0e fe ff ff       	call   801ef8 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 04             	sub    $0x4,%esp
  8020f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8020fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	6a 00                	push   $0x0
  802108:	51                   	push   %ecx
  802109:	52                   	push   %edx
  80210a:	ff 75 0c             	pushl  0xc(%ebp)
  80210d:	50                   	push   %eax
  80210e:	6a 15                	push   $0x15
  802110:	e8 e3 fd ff ff       	call   801ef8 <syscall>
  802115:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80211d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	52                   	push   %edx
  80212a:	50                   	push   %eax
  80212b:	6a 16                	push   $0x16
  80212d:	e8 c6 fd ff ff       	call   801ef8 <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80213a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	51                   	push   %ecx
  802148:	52                   	push   %edx
  802149:	50                   	push   %eax
  80214a:	6a 17                	push   $0x17
  80214c:	e8 a7 fd ff ff       	call   801ef8 <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	52                   	push   %edx
  802166:	50                   	push   %eax
  802167:	6a 18                	push   $0x18
  802169:	e8 8a fd ff ff       	call   801ef8 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	6a 00                	push   $0x0
  80217b:	ff 75 14             	pushl  0x14(%ebp)
  80217e:	ff 75 10             	pushl  0x10(%ebp)
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	50                   	push   %eax
  802185:	6a 19                	push   $0x19
  802187:	e8 6c fd ff ff       	call   801ef8 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <sys_run_env>:

void sys_run_env(int32 envId) {
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	50                   	push   %eax
  8021a0:	6a 1a                	push   $0x1a
  8021a2:	e8 51 fd ff ff       	call   801ef8 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	90                   	nop
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	50                   	push   %eax
  8021bc:	6a 1b                	push   $0x1b
  8021be:	e8 35 fd ff ff       	call   801ef8 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_getenvid>:

int32 sys_getenvid(void) {
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 05                	push   $0x5
  8021d7:	e8 1c fd ff ff       	call   801ef8 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 06                	push   $0x6
  8021f0:	e8 03 fd ff ff       	call   801ef8 <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 07                	push   $0x7
  802209:	e8 ea fc ff ff       	call   801ef8 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_exit_env>:

void sys_exit_env(void) {
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 1c                	push   $0x1c
  802222:	e8 d1 fc ff ff       	call   801ef8 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	90                   	nop
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  802233:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802236:	8d 50 04             	lea    0x4(%eax),%edx
  802239:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	52                   	push   %edx
  802243:	50                   	push   %eax
  802244:	6a 1d                	push   $0x1d
  802246:	e8 ad fc ff ff       	call   801ef8 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80224e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802251:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802254:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802257:	89 01                	mov    %eax,(%ecx)
  802259:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	c9                   	leave  
  802260:	c2 04 00             	ret    $0x4

00802263 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	ff 75 10             	pushl  0x10(%ebp)
  80226d:	ff 75 0c             	pushl  0xc(%ebp)
  802270:	ff 75 08             	pushl  0x8(%ebp)
  802273:	6a 13                	push   $0x13
  802275:	e8 7e fc ff ff       	call   801ef8 <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80227d:	90                   	nop
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_rcr2>:
uint32 sys_rcr2() {
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 1e                	push   $0x1e
  80228f:	e8 64 fc ff ff       	call   801ef8 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022a5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	50                   	push   %eax
  8022b2:	6a 1f                	push   $0x1f
  8022b4:	e8 3f fc ff ff       	call   801ef8 <syscall>
  8022b9:	83 c4 18             	add    $0x18,%esp
	return;
  8022bc:	90                   	nop
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <rsttst>:
void rsttst() {
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 21                	push   $0x21
  8022ce:	e8 25 fc ff ff       	call   801ef8 <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
	return;
  8022d6:	90                   	nop
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022e5:	8b 55 18             	mov    0x18(%ebp),%edx
  8022e8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022ec:	52                   	push   %edx
  8022ed:	50                   	push   %eax
  8022ee:	ff 75 10             	pushl  0x10(%ebp)
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	6a 20                	push   $0x20
  8022f9:	e8 fa fb ff ff       	call   801ef8 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
	return;
  802301:	90                   	nop
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <chktst>:
void chktst(uint32 n) {
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	ff 75 08             	pushl  0x8(%ebp)
  802312:	6a 22                	push   $0x22
  802314:	e8 df fb ff ff       	call   801ef8 <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
	return;
  80231c:	90                   	nop
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <inctst>:

void inctst() {
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 23                	push   $0x23
  80232e:	e8 c5 fb ff ff       	call   801ef8 <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
	return;
  802336:	90                   	nop
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <gettst>:
uint32 gettst() {
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 24                	push   $0x24
  802348:	e8 ab fb ff ff       	call   801ef8 <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 25                	push   $0x25
  802364:	e8 8f fb ff ff       	call   801ef8 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
  80236c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80236f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802373:	75 07                	jne    80237c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802375:	b8 01 00 00 00       	mov    $0x1,%eax
  80237a:	eb 05                	jmp    802381 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 25                	push   $0x25
  802395:	e8 5e fb ff ff       	call   801ef8 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
  80239d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023a0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023a4:	75 07                	jne    8023ad <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	eb 05                	jmp    8023b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 25                	push   $0x25
  8023c6:	e8 2d fb ff ff       	call   801ef8 <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
  8023ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023d1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023d5:	75 07                	jne    8023de <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023dc:	eb 05                	jmp    8023e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 25                	push   $0x25
  8023f7:	e8 fc fa ff ff       	call   801ef8 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
  8023ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802402:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802406:	75 07                	jne    80240f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802408:	b8 01 00 00 00       	mov    $0x1,%eax
  80240d:	eb 05                	jmp    802414 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	ff 75 08             	pushl  0x8(%ebp)
  802424:	6a 26                	push   $0x26
  802426:	e8 cd fa ff ff       	call   801ef8 <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
	return;
  80242e:	90                   	nop
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802435:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802438:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80243b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	6a 00                	push   $0x0
  802443:	53                   	push   %ebx
  802444:	51                   	push   %ecx
  802445:	52                   	push   %edx
  802446:	50                   	push   %eax
  802447:	6a 27                	push   $0x27
  802449:	e8 aa fa ff ff       	call   801ef8 <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802451:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	52                   	push   %edx
  802466:	50                   	push   %eax
  802467:	6a 28                	push   $0x28
  802469:	e8 8a fa ff ff       	call   801ef8 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802476:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	6a 00                	push   $0x0
  802481:	51                   	push   %ecx
  802482:	ff 75 10             	pushl  0x10(%ebp)
  802485:	52                   	push   %edx
  802486:	50                   	push   %eax
  802487:	6a 29                	push   $0x29
  802489:	e8 6a fa ff ff       	call   801ef8 <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	ff 75 10             	pushl  0x10(%ebp)
  80249d:	ff 75 0c             	pushl  0xc(%ebp)
  8024a0:	ff 75 08             	pushl  0x8(%ebp)
  8024a3:	6a 12                	push   $0x12
  8024a5:	e8 4e fa ff ff       	call   801ef8 <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
	return;
  8024ad:	90                   	nop
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8024b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	52                   	push   %edx
  8024c0:	50                   	push   %eax
  8024c1:	6a 2a                	push   $0x2a
  8024c3:	e8 30 fa ff ff       	call   801ef8 <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
	return;
  8024cb:	90                   	nop
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	50                   	push   %eax
  8024dd:	6a 2b                	push   $0x2b
  8024df:	e8 14 fa ff ff       	call   801ef8 <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	ff 75 0c             	pushl  0xc(%ebp)
  8024f5:	ff 75 08             	pushl  0x8(%ebp)
  8024f8:	6a 2c                	push   $0x2c
  8024fa:	e8 f9 f9 ff ff       	call   801ef8 <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
	return;
  802502:	90                   	nop
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	ff 75 0c             	pushl  0xc(%ebp)
  802511:	ff 75 08             	pushl  0x8(%ebp)
  802514:	6a 2d                	push   $0x2d
  802516:	e8 dd f9 ff ff       	call   801ef8 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
	return;
  80251e:	90                   	nop
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802524:	8b 45 08             	mov    0x8(%ebp),%eax
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	50                   	push   %eax
  802530:	6a 2f                	push   $0x2f
  802532:	e8 c1 f9 ff ff       	call   801ef8 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
	return;
  80253a:	90                   	nop
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802540:	8b 55 0c             	mov    0xc(%ebp),%edx
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	52                   	push   %edx
  80254d:	50                   	push   %eax
  80254e:	6a 30                	push   $0x30
  802550:	e8 a3 f9 ff ff       	call   801ef8 <syscall>
  802555:	83 c4 18             	add    $0x18,%esp
	return;
  802558:	90                   	nop
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	50                   	push   %eax
  80256a:	6a 31                	push   $0x31
  80256c:	e8 87 f9 ff ff       	call   801ef8 <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
	return;
  802574:	90                   	nop
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80257a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	52                   	push   %edx
  802587:	50                   	push   %eax
  802588:	6a 2e                	push   $0x2e
  80258a:	e8 69 f9 ff ff       	call   801ef8 <syscall>
  80258f:	83 c4 18             	add    $0x18,%esp
    return;
  802592:	90                   	nop
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	83 e8 04             	sub    $0x4,%eax
  8025a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	83 e8 04             	sub    $0x4,%eax
  8025ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	83 e0 01             	and    $0x1,%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	0f 94 c0             	sete   %al
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025dc:	83 f8 02             	cmp    $0x2,%eax
  8025df:	74 2b                	je     80260c <alloc_block+0x40>
  8025e1:	83 f8 02             	cmp    $0x2,%eax
  8025e4:	7f 07                	jg     8025ed <alloc_block+0x21>
  8025e6:	83 f8 01             	cmp    $0x1,%eax
  8025e9:	74 0e                	je     8025f9 <alloc_block+0x2d>
  8025eb:	eb 58                	jmp    802645 <alloc_block+0x79>
  8025ed:	83 f8 03             	cmp    $0x3,%eax
  8025f0:	74 2d                	je     80261f <alloc_block+0x53>
  8025f2:	83 f8 04             	cmp    $0x4,%eax
  8025f5:	74 3b                	je     802632 <alloc_block+0x66>
  8025f7:	eb 4c                	jmp    802645 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025f9:	83 ec 0c             	sub    $0xc,%esp
  8025fc:	ff 75 08             	pushl  0x8(%ebp)
  8025ff:	e8 f7 03 00 00       	call   8029fb <alloc_block_FF>
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80260a:	eb 4a                	jmp    802656 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80260c:	83 ec 0c             	sub    $0xc,%esp
  80260f:	ff 75 08             	pushl  0x8(%ebp)
  802612:	e8 f0 11 00 00       	call   803807 <alloc_block_NF>
  802617:	83 c4 10             	add    $0x10,%esp
  80261a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80261d:	eb 37                	jmp    802656 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80261f:	83 ec 0c             	sub    $0xc,%esp
  802622:	ff 75 08             	pushl  0x8(%ebp)
  802625:	e8 08 08 00 00       	call   802e32 <alloc_block_BF>
  80262a:	83 c4 10             	add    $0x10,%esp
  80262d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802630:	eb 24                	jmp    802656 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802632:	83 ec 0c             	sub    $0xc,%esp
  802635:	ff 75 08             	pushl  0x8(%ebp)
  802638:	e8 ad 11 00 00       	call   8037ea <alloc_block_WF>
  80263d:	83 c4 10             	add    $0x10,%esp
  802640:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802643:	eb 11                	jmp    802656 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802645:	83 ec 0c             	sub    $0xc,%esp
  802648:	68 b8 43 80 00       	push   $0x8043b8
  80264d:	e8 41 e4 ff ff       	call   800a93 <cprintf>
  802652:	83 c4 10             	add    $0x10,%esp
		break;
  802655:	90                   	nop
	}
	return va;
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	53                   	push   %ebx
  80265f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802662:	83 ec 0c             	sub    $0xc,%esp
  802665:	68 d8 43 80 00       	push   $0x8043d8
  80266a:	e8 24 e4 ff ff       	call   800a93 <cprintf>
  80266f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	68 03 44 80 00       	push   $0x804403
  80267a:	e8 14 e4 ff ff       	call   800a93 <cprintf>
  80267f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802688:	eb 37                	jmp    8026c1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80268a:	83 ec 0c             	sub    $0xc,%esp
  80268d:	ff 75 f4             	pushl  -0xc(%ebp)
  802690:	e8 19 ff ff ff       	call   8025ae <is_free_block>
  802695:	83 c4 10             	add    $0x10,%esp
  802698:	0f be d8             	movsbl %al,%ebx
  80269b:	83 ec 0c             	sub    $0xc,%esp
  80269e:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a1:	e8 ef fe ff ff       	call   802595 <get_block_size>
  8026a6:	83 c4 10             	add    $0x10,%esp
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	53                   	push   %ebx
  8026ad:	50                   	push   %eax
  8026ae:	68 1b 44 80 00       	push   $0x80441b
  8026b3:	e8 db e3 ff ff       	call   800a93 <cprintf>
  8026b8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8026be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c5:	74 07                	je     8026ce <print_blocks_list+0x73>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	eb 05                	jmp    8026d3 <print_blocks_list+0x78>
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d3:	89 45 10             	mov    %eax,0x10(%ebp)
  8026d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	75 ad                	jne    80268a <print_blocks_list+0x2f>
  8026dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e1:	75 a7                	jne    80268a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026e3:	83 ec 0c             	sub    $0xc,%esp
  8026e6:	68 d8 43 80 00       	push   $0x8043d8
  8026eb:	e8 a3 e3 ff ff       	call   800a93 <cprintf>
  8026f0:	83 c4 10             	add    $0x10,%esp

}
  8026f3:	90                   	nop
  8026f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802702:	83 e0 01             	and    $0x1,%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	74 03                	je     80270c <initialize_dynamic_allocator+0x13>
  802709:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80270c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802710:	0f 84 f8 00 00 00    	je     80280e <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802716:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  80271d:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802720:	a1 40 50 98 00       	mov    0x985040,%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	0f 84 e2 00 00 00    	je     80280f <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80273c:	8b 55 08             	mov    0x8(%ebp),%edx
  80273f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802742:	01 d0                	add    %edx,%eax
  802744:	83 e8 04             	sub    $0x4,%eax
  802747:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	83 c0 08             	add    $0x8,%eax
  802759:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80275c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275f:	83 e8 08             	sub    $0x8,%eax
  802762:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802765:	83 ec 04             	sub    $0x4,%esp
  802768:	6a 00                	push   $0x0
  80276a:	ff 75 e8             	pushl  -0x18(%ebp)
  80276d:	ff 75 ec             	pushl  -0x14(%ebp)
  802770:	e8 9c 00 00 00       	call   802811 <set_block_data>
  802775:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802784:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80278b:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802792:	00 00 00 
  802795:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  80279c:	00 00 00 
  80279f:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  8027a6:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8027a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ad:	75 17                	jne    8027c6 <initialize_dynamic_allocator+0xcd>
  8027af:	83 ec 04             	sub    $0x4,%esp
  8027b2:	68 34 44 80 00       	push   $0x804434
  8027b7:	68 80 00 00 00       	push   $0x80
  8027bc:	68 57 44 80 00       	push   $0x804457
  8027c1:	e8 10 e0 ff ff       	call   8007d6 <_panic>
  8027c6:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8027cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cf:	89 10                	mov    %edx,(%eax)
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	8b 00                	mov    (%eax),%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	74 0d                	je     8027e7 <initialize_dynamic_allocator+0xee>
  8027da:	a1 48 50 98 00       	mov    0x985048,%eax
  8027df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e2:	89 50 04             	mov    %edx,0x4(%eax)
  8027e5:	eb 08                	jmp    8027ef <initialize_dynamic_allocator+0xf6>
  8027e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ea:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	a3 48 50 98 00       	mov    %eax,0x985048
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802801:	a1 54 50 98 00       	mov    0x985054,%eax
  802806:	40                   	inc    %eax
  802807:	a3 54 50 98 00       	mov    %eax,0x985054
  80280c:	eb 01                	jmp    80280f <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80280e:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
  802814:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80281a:	83 e0 01             	and    $0x1,%eax
  80281d:	85 c0                	test   %eax,%eax
  80281f:	74 03                	je     802824 <set_block_data+0x13>
	{
		totalSize++;
  802821:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	83 e8 04             	sub    $0x4,%eax
  80282a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  80282d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802830:	83 e0 fe             	and    $0xfffffffe,%eax
  802833:	89 c2                	mov    %eax,%edx
  802835:	8b 45 10             	mov    0x10(%ebp),%eax
  802838:	83 e0 01             	and    $0x1,%eax
  80283b:	09 c2                	or     %eax,%edx
  80283d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802840:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802842:	8b 45 0c             	mov    0xc(%ebp),%eax
  802845:	8d 50 f8             	lea    -0x8(%eax),%edx
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	01 d0                	add    %edx,%eax
  80284d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802850:	8b 45 0c             	mov    0xc(%ebp),%eax
  802853:	83 e0 fe             	and    $0xfffffffe,%eax
  802856:	89 c2                	mov    %eax,%edx
  802858:	8b 45 10             	mov    0x10(%ebp),%eax
  80285b:	83 e0 01             	and    $0x1,%eax
  80285e:	09 c2                	or     %eax,%edx
  802860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802863:	89 10                	mov    %edx,(%eax)
}
  802865:	90                   	nop
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
  80286b:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80286e:	a1 48 50 98 00       	mov    0x985048,%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	75 68                	jne    8028df <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802877:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80287b:	75 17                	jne    802894 <insert_sorted_in_freeList+0x2c>
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 34 44 80 00       	push   $0x804434
  802885:	68 9d 00 00 00       	push   $0x9d
  80288a:	68 57 44 80 00       	push   $0x804457
  80288f:	e8 42 df ff ff       	call   8007d6 <_panic>
  802894:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	89 10                	mov    %edx,(%eax)
  80289f:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 0d                	je     8028b5 <insert_sorted_in_freeList+0x4d>
  8028a8:	a1 48 50 98 00       	mov    0x985048,%eax
  8028ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b0:	89 50 04             	mov    %edx,0x4(%eax)
  8028b3:	eb 08                	jmp    8028bd <insert_sorted_in_freeList+0x55>
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	a3 48 50 98 00       	mov    %eax,0x985048
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cf:	a1 54 50 98 00       	mov    0x985054,%eax
  8028d4:	40                   	inc    %eax
  8028d5:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8028da:	e9 1a 01 00 00       	jmp    8029f9 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8028df:	a1 48 50 98 00       	mov    0x985048,%eax
  8028e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e7:	eb 7f                	jmp    802968 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ef:	76 6f                	jbe    802960 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8028f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f5:	74 06                	je     8028fd <insert_sorted_in_freeList+0x95>
  8028f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028fb:	75 17                	jne    802914 <insert_sorted_in_freeList+0xac>
  8028fd:	83 ec 04             	sub    $0x4,%esp
  802900:	68 70 44 80 00       	push   $0x804470
  802905:	68 a6 00 00 00       	push   $0xa6
  80290a:	68 57 44 80 00       	push   $0x804457
  80290f:	e8 c2 de ff ff       	call   8007d6 <_panic>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 50 04             	mov    0x4(%eax),%edx
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	89 50 04             	mov    %edx,0x4(%eax)
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802926:	89 10                	mov    %edx,(%eax)
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	85 c0                	test   %eax,%eax
  802930:	74 0d                	je     80293f <insert_sorted_in_freeList+0xd7>
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 40 04             	mov    0x4(%eax),%eax
  802938:	8b 55 08             	mov    0x8(%ebp),%edx
  80293b:	89 10                	mov    %edx,(%eax)
  80293d:	eb 08                	jmp    802947 <insert_sorted_in_freeList+0xdf>
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	a3 48 50 98 00       	mov    %eax,0x985048
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 55 08             	mov    0x8(%ebp),%edx
  80294d:	89 50 04             	mov    %edx,0x4(%eax)
  802950:	a1 54 50 98 00       	mov    0x985054,%eax
  802955:	40                   	inc    %eax
  802956:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  80295b:	e9 99 00 00 00       	jmp    8029f9 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802960:	a1 50 50 98 00       	mov    0x985050,%eax
  802965:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296c:	74 07                	je     802975 <insert_sorted_in_freeList+0x10d>
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	eb 05                	jmp    80297a <insert_sorted_in_freeList+0x112>
  802975:	b8 00 00 00 00       	mov    $0x0,%eax
  80297a:	a3 50 50 98 00       	mov    %eax,0x985050
  80297f:	a1 50 50 98 00       	mov    0x985050,%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	0f 85 5d ff ff ff    	jne    8028e9 <insert_sorted_in_freeList+0x81>
  80298c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802990:	0f 85 53 ff ff ff    	jne    8028e9 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802996:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80299a:	75 17                	jne    8029b3 <insert_sorted_in_freeList+0x14b>
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	68 a8 44 80 00       	push   $0x8044a8
  8029a4:	68 ab 00 00 00       	push   $0xab
  8029a9:	68 57 44 80 00       	push   $0x804457
  8029ae:	e8 23 de ff ff       	call   8007d6 <_panic>
  8029b3:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	89 50 04             	mov    %edx,0x4(%eax)
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	8b 40 04             	mov    0x4(%eax),%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	74 0c                	je     8029d5 <insert_sorted_in_freeList+0x16d>
  8029c9:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8029ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d1:	89 10                	mov    %edx,(%eax)
  8029d3:	eb 08                	jmp    8029dd <insert_sorted_in_freeList+0x175>
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	a3 48 50 98 00       	mov    %eax,0x985048
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ee:	a1 54 50 98 00       	mov    0x985054,%eax
  8029f3:	40                   	inc    %eax
  8029f4:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
  8029fe:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	83 e0 01             	and    $0x1,%eax
  802a07:	85 c0                	test   %eax,%eax
  802a09:	74 03                	je     802a0e <alloc_block_FF+0x13>
  802a0b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a0e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a12:	77 07                	ja     802a1b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a14:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a1b:	a1 40 50 98 00       	mov    0x985040,%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	75 63                	jne    802a87 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	83 c0 10             	add    $0x10,%eax
  802a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a2d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3a:	01 d0                	add    %edx,%eax
  802a3c:	48                   	dec    %eax
  802a3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a43:	ba 00 00 00 00       	mov    $0x0,%edx
  802a48:	f7 75 ec             	divl   -0x14(%ebp)
  802a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4e:	29 d0                	sub    %edx,%eax
  802a50:	c1 e8 0c             	shr    $0xc,%eax
  802a53:	83 ec 0c             	sub    $0xc,%esp
  802a56:	50                   	push   %eax
  802a57:	e8 d1 ed ff ff       	call   80182d <sbrk>
  802a5c:	83 c4 10             	add    $0x10,%esp
  802a5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a62:	83 ec 0c             	sub    $0xc,%esp
  802a65:	6a 00                	push   $0x0
  802a67:	e8 c1 ed ff ff       	call   80182d <sbrk>
  802a6c:	83 c4 10             	add    $0x10,%esp
  802a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a75:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a78:	83 ec 08             	sub    $0x8,%esp
  802a7b:	50                   	push   %eax
  802a7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a7f:	e8 75 fc ff ff       	call   8026f9 <initialize_dynamic_allocator>
  802a84:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8b:	75 0a                	jne    802a97 <alloc_block_FF+0x9c>
	{
		return NULL;
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a92:	e9 99 03 00 00       	jmp    802e30 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	83 c0 08             	add    $0x8,%eax
  802a9d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802aa0:	a1 48 50 98 00       	mov    0x985048,%eax
  802aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa8:	e9 03 02 00 00       	jmp    802cb0 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802aad:	83 ec 0c             	sub    $0xc,%esp
  802ab0:	ff 75 f4             	pushl  -0xc(%ebp)
  802ab3:	e8 dd fa ff ff       	call   802595 <get_block_size>
  802ab8:	83 c4 10             	add    $0x10,%esp
  802abb:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802abe:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802ac1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802ac4:	0f 82 de 01 00 00    	jb     802ca8 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802aca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802acd:	83 c0 10             	add    $0x10,%eax
  802ad0:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802ad3:	0f 87 32 01 00 00    	ja     802c0b <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802ad9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802adc:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802adf:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ae8:	01 d0                	add    %edx,%eax
  802aea:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802aed:	83 ec 04             	sub    $0x4,%esp
  802af0:	6a 00                	push   $0x0
  802af2:	ff 75 98             	pushl  -0x68(%ebp)
  802af5:	ff 75 94             	pushl  -0x6c(%ebp)
  802af8:	e8 14 fd ff ff       	call   802811 <set_block_data>
  802afd:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802b00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b04:	74 06                	je     802b0c <alloc_block_FF+0x111>
  802b06:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802b0a:	75 17                	jne    802b23 <alloc_block_FF+0x128>
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 cc 44 80 00       	push   $0x8044cc
  802b14:	68 de 00 00 00       	push   $0xde
  802b19:	68 57 44 80 00       	push   $0x804457
  802b1e:	e8 b3 dc ff ff       	call   8007d6 <_panic>
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 10                	mov    (%eax),%edx
  802b28:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b2b:	89 10                	mov    %edx,(%eax)
  802b2d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	74 0b                	je     802b41 <alloc_block_FF+0x146>
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802b3e:	89 50 04             	mov    %edx,0x4(%eax)
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802b47:	89 10                	mov    %edx,(%eax)
  802b49:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	75 08                	jne    802b63 <alloc_block_FF+0x168>
  802b5b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b5e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b63:	a1 54 50 98 00       	mov    0x985054,%eax
  802b68:	40                   	inc    %eax
  802b69:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	6a 01                	push   $0x1
  802b73:	ff 75 dc             	pushl  -0x24(%ebp)
  802b76:	ff 75 f4             	pushl  -0xc(%ebp)
  802b79:	e8 93 fc ff ff       	call   802811 <set_block_data>
  802b7e:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b85:	75 17                	jne    802b9e <alloc_block_FF+0x1a3>
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	68 00 45 80 00       	push   $0x804500
  802b8f:	68 e3 00 00 00       	push   $0xe3
  802b94:	68 57 44 80 00       	push   $0x804457
  802b99:	e8 38 dc ff ff       	call   8007d6 <_panic>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	74 10                	je     802bb7 <alloc_block_FF+0x1bc>
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802baf:	8b 52 04             	mov    0x4(%edx),%edx
  802bb2:	89 50 04             	mov    %edx,0x4(%eax)
  802bb5:	eb 0b                	jmp    802bc2 <alloc_block_FF+0x1c7>
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 40 04             	mov    0x4(%eax),%eax
  802bbd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 04             	mov    0x4(%eax),%eax
  802bc8:	85 c0                	test   %eax,%eax
  802bca:	74 0f                	je     802bdb <alloc_block_FF+0x1e0>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 04             	mov    0x4(%eax),%eax
  802bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd5:	8b 12                	mov    (%edx),%edx
  802bd7:	89 10                	mov    %edx,(%eax)
  802bd9:	eb 0a                	jmp    802be5 <alloc_block_FF+0x1ea>
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	a3 48 50 98 00       	mov    %eax,0x985048
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf8:	a1 54 50 98 00       	mov    0x985054,%eax
  802bfd:	48                   	dec    %eax
  802bfe:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	e9 25 02 00 00       	jmp    802e30 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802c0b:	83 ec 04             	sub    $0x4,%esp
  802c0e:	6a 01                	push   $0x1
  802c10:	ff 75 9c             	pushl  -0x64(%ebp)
  802c13:	ff 75 f4             	pushl  -0xc(%ebp)
  802c16:	e8 f6 fb ff ff       	call   802811 <set_block_data>
  802c1b:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c22:	75 17                	jne    802c3b <alloc_block_FF+0x240>
  802c24:	83 ec 04             	sub    $0x4,%esp
  802c27:	68 00 45 80 00       	push   $0x804500
  802c2c:	68 eb 00 00 00       	push   $0xeb
  802c31:	68 57 44 80 00       	push   $0x804457
  802c36:	e8 9b db ff ff       	call   8007d6 <_panic>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 10                	je     802c54 <alloc_block_FF+0x259>
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4c:	8b 52 04             	mov    0x4(%edx),%edx
  802c4f:	89 50 04             	mov    %edx,0x4(%eax)
  802c52:	eb 0b                	jmp    802c5f <alloc_block_FF+0x264>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 04             	mov    0x4(%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 0f                	je     802c78 <alloc_block_FF+0x27d>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c72:	8b 12                	mov    (%edx),%edx
  802c74:	89 10                	mov    %edx,(%eax)
  802c76:	eb 0a                	jmp    802c82 <alloc_block_FF+0x287>
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	a3 48 50 98 00       	mov    %eax,0x985048
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c95:	a1 54 50 98 00       	mov    0x985054,%eax
  802c9a:	48                   	dec    %eax
  802c9b:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	e9 88 01 00 00       	jmp    802e30 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ca8:	a1 50 50 98 00       	mov    0x985050,%eax
  802cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb4:	74 07                	je     802cbd <alloc_block_FF+0x2c2>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	eb 05                	jmp    802cc2 <alloc_block_FF+0x2c7>
  802cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc2:	a3 50 50 98 00       	mov    %eax,0x985050
  802cc7:	a1 50 50 98 00       	mov    0x985050,%eax
  802ccc:	85 c0                	test   %eax,%eax
  802cce:	0f 85 d9 fd ff ff    	jne    802aad <alloc_block_FF+0xb2>
  802cd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd8:	0f 85 cf fd ff ff    	jne    802aad <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802cde:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ce5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ce8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ceb:	01 d0                	add    %edx,%eax
  802ced:	48                   	dec    %eax
  802cee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802cf1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf9:	f7 75 d8             	divl   -0x28(%ebp)
  802cfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cff:	29 d0                	sub    %edx,%eax
  802d01:	c1 e8 0c             	shr    $0xc,%eax
  802d04:	83 ec 0c             	sub    $0xc,%esp
  802d07:	50                   	push   %eax
  802d08:	e8 20 eb ff ff       	call   80182d <sbrk>
  802d0d:	83 c4 10             	add    $0x10,%esp
  802d10:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802d13:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d17:	75 0a                	jne    802d23 <alloc_block_FF+0x328>
		return NULL;
  802d19:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1e:	e9 0d 01 00 00       	jmp    802e30 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802d23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d26:	83 e8 04             	sub    $0x4,%eax
  802d29:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802d2c:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802d33:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d36:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d39:	01 d0                	add    %edx,%eax
  802d3b:	48                   	dec    %eax
  802d3c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802d3f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d42:	ba 00 00 00 00       	mov    $0x0,%edx
  802d47:	f7 75 c8             	divl   -0x38(%ebp)
  802d4a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d4d:	29 d0                	sub    %edx,%eax
  802d4f:	c1 e8 02             	shr    $0x2,%eax
  802d52:	c1 e0 02             	shl    $0x2,%eax
  802d55:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802d58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d5b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802d61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d64:	83 e8 08             	sub    $0x8,%eax
  802d67:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802d6a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	83 e0 fe             	and    $0xfffffffe,%eax
  802d72:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802d75:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d78:	f7 d8                	neg    %eax
  802d7a:	89 c2                	mov    %eax,%edx
  802d7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d7f:	01 d0                	add    %edx,%eax
  802d81:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802d84:	83 ec 0c             	sub    $0xc,%esp
  802d87:	ff 75 b8             	pushl  -0x48(%ebp)
  802d8a:	e8 1f f8 ff ff       	call   8025ae <is_free_block>
  802d8f:	83 c4 10             	add    $0x10,%esp
  802d92:	0f be c0             	movsbl %al,%eax
  802d95:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802d98:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802d9c:	74 42                	je     802de0 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802d9e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802da5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dab:	01 d0                	add    %edx,%eax
  802dad:	48                   	dec    %eax
  802dae:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802db1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802db4:	ba 00 00 00 00       	mov    $0x0,%edx
  802db9:	f7 75 b0             	divl   -0x50(%ebp)
  802dbc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dbf:	29 d0                	sub    %edx,%eax
  802dc1:	89 c2                	mov    %eax,%edx
  802dc3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dc6:	01 d0                	add    %edx,%eax
  802dc8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	6a 00                	push   $0x0
  802dd0:	ff 75 a8             	pushl  -0x58(%ebp)
  802dd3:	ff 75 b8             	pushl  -0x48(%ebp)
  802dd6:	e8 36 fa ff ff       	call   802811 <set_block_data>
  802ddb:	83 c4 10             	add    $0x10,%esp
  802dde:	eb 42                	jmp    802e22 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802de0:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802de7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dea:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ded:	01 d0                	add    %edx,%eax
  802def:	48                   	dec    %eax
  802df0:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802df3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802df6:	ba 00 00 00 00       	mov    $0x0,%edx
  802dfb:	f7 75 a4             	divl   -0x5c(%ebp)
  802dfe:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802e01:	29 d0                	sub    %edx,%eax
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	6a 00                	push   $0x0
  802e08:	50                   	push   %eax
  802e09:	ff 75 d0             	pushl  -0x30(%ebp)
  802e0c:	e8 00 fa ff ff       	call   802811 <set_block_data>
  802e11:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802e14:	83 ec 0c             	sub    $0xc,%esp
  802e17:	ff 75 d0             	pushl  -0x30(%ebp)
  802e1a:	e8 49 fa ff ff       	call   802868 <insert_sorted_in_freeList>
  802e1f:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802e22:	83 ec 0c             	sub    $0xc,%esp
  802e25:	ff 75 08             	pushl  0x8(%ebp)
  802e28:	e8 ce fb ff ff       	call   8029fb <alloc_block_FF>
  802e2d:	83 c4 10             	add    $0x10,%esp
}
  802e30:	c9                   	leave  
  802e31:	c3                   	ret    

00802e32 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e32:	55                   	push   %ebp
  802e33:	89 e5                	mov    %esp,%ebp
  802e35:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802e38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3c:	75 0a                	jne    802e48 <alloc_block_BF+0x16>
	{
		return NULL;
  802e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e43:	e9 7a 02 00 00       	jmp    8030c2 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	83 c0 08             	add    $0x8,%eax
  802e4e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802e51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802e58:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e5f:	a1 48 50 98 00       	mov    0x985048,%eax
  802e64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e67:	eb 32                	jmp    802e9b <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802e69:	ff 75 ec             	pushl  -0x14(%ebp)
  802e6c:	e8 24 f7 ff ff       	call   802595 <get_block_size>
  802e71:	83 c4 04             	add    $0x4,%esp
  802e74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e7d:	72 14                	jb     802e93 <alloc_block_BF+0x61>
  802e7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e85:	73 0c                	jae    802e93 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e93:	a1 50 50 98 00       	mov    0x985050,%eax
  802e98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e9f:	74 07                	je     802ea8 <alloc_block_BF+0x76>
  802ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	eb 05                	jmp    802ead <alloc_block_BF+0x7b>
  802ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ead:	a3 50 50 98 00       	mov    %eax,0x985050
  802eb2:	a1 50 50 98 00       	mov    0x985050,%eax
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	75 ae                	jne    802e69 <alloc_block_BF+0x37>
  802ebb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ebf:	75 a8                	jne    802e69 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802ec1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec5:	75 22                	jne    802ee9 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eca:	83 ec 0c             	sub    $0xc,%esp
  802ecd:	50                   	push   %eax
  802ece:	e8 5a e9 ff ff       	call   80182d <sbrk>
  802ed3:	83 c4 10             	add    $0x10,%esp
  802ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802ed9:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802edd:	75 0a                	jne    802ee9 <alloc_block_BF+0xb7>
			return NULL;
  802edf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee4:	e9 d9 01 00 00       	jmp    8030c2 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802ee9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eec:	83 c0 10             	add    $0x10,%eax
  802eef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ef2:	0f 87 32 01 00 00    	ja     80302a <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802efe:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f07:	01 d0                	add    %edx,%eax
  802f09:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	6a 00                	push   $0x0
  802f11:	ff 75 dc             	pushl  -0x24(%ebp)
  802f14:	ff 75 d8             	pushl  -0x28(%ebp)
  802f17:	e8 f5 f8 ff ff       	call   802811 <set_block_data>
  802f1c:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802f1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f23:	74 06                	je     802f2b <alloc_block_BF+0xf9>
  802f25:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802f29:	75 17                	jne    802f42 <alloc_block_BF+0x110>
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	68 cc 44 80 00       	push   $0x8044cc
  802f33:	68 49 01 00 00       	push   $0x149
  802f38:	68 57 44 80 00       	push   $0x804457
  802f3d:	e8 94 d8 ff ff       	call   8007d6 <_panic>
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 10                	mov    (%eax),%edx
  802f47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f4a:	89 10                	mov    %edx,(%eax)
  802f4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 0b                	je     802f60 <alloc_block_BF+0x12e>
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f5d:	89 50 04             	mov    %edx,0x4(%eax)
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f66:	89 10                	mov    %edx,(%eax)
  802f68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f6e:	89 50 04             	mov    %edx,0x4(%eax)
  802f71:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f74:	8b 00                	mov    (%eax),%eax
  802f76:	85 c0                	test   %eax,%eax
  802f78:	75 08                	jne    802f82 <alloc_block_BF+0x150>
  802f7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f7d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f82:	a1 54 50 98 00       	mov    0x985054,%eax
  802f87:	40                   	inc    %eax
  802f88:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802f8d:	83 ec 04             	sub    $0x4,%esp
  802f90:	6a 01                	push   $0x1
  802f92:	ff 75 e8             	pushl  -0x18(%ebp)
  802f95:	ff 75 f4             	pushl  -0xc(%ebp)
  802f98:	e8 74 f8 ff ff       	call   802811 <set_block_data>
  802f9d:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802fa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa4:	75 17                	jne    802fbd <alloc_block_BF+0x18b>
  802fa6:	83 ec 04             	sub    $0x4,%esp
  802fa9:	68 00 45 80 00       	push   $0x804500
  802fae:	68 4e 01 00 00       	push   $0x14e
  802fb3:	68 57 44 80 00       	push   $0x804457
  802fb8:	e8 19 d8 ff ff       	call   8007d6 <_panic>
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 00                	mov    (%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 10                	je     802fd6 <alloc_block_BF+0x1a4>
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 00                	mov    (%eax),%eax
  802fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fce:	8b 52 04             	mov    0x4(%edx),%edx
  802fd1:	89 50 04             	mov    %edx,0x4(%eax)
  802fd4:	eb 0b                	jmp    802fe1 <alloc_block_BF+0x1af>
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	74 0f                	je     802ffa <alloc_block_BF+0x1c8>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 40 04             	mov    0x4(%eax),%eax
  802ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff4:	8b 12                	mov    (%edx),%edx
  802ff6:	89 10                	mov    %edx,(%eax)
  802ff8:	eb 0a                	jmp    803004 <alloc_block_BF+0x1d2>
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	a3 48 50 98 00       	mov    %eax,0x985048
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803017:	a1 54 50 98 00       	mov    0x985054,%eax
  80301c:	48                   	dec    %eax
  80301d:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	e9 98 00 00 00       	jmp    8030c2 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  80302a:	83 ec 04             	sub    $0x4,%esp
  80302d:	6a 01                	push   $0x1
  80302f:	ff 75 f0             	pushl  -0x10(%ebp)
  803032:	ff 75 f4             	pushl  -0xc(%ebp)
  803035:	e8 d7 f7 ff ff       	call   802811 <set_block_data>
  80303a:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  80303d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803041:	75 17                	jne    80305a <alloc_block_BF+0x228>
  803043:	83 ec 04             	sub    $0x4,%esp
  803046:	68 00 45 80 00       	push   $0x804500
  80304b:	68 56 01 00 00       	push   $0x156
  803050:	68 57 44 80 00       	push   $0x804457
  803055:	e8 7c d7 ff ff       	call   8007d6 <_panic>
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	85 c0                	test   %eax,%eax
  803061:	74 10                	je     803073 <alloc_block_BF+0x241>
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306b:	8b 52 04             	mov    0x4(%edx),%edx
  80306e:	89 50 04             	mov    %edx,0x4(%eax)
  803071:	eb 0b                	jmp    80307e <alloc_block_BF+0x24c>
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	85 c0                	test   %eax,%eax
  803086:	74 0f                	je     803097 <alloc_block_BF+0x265>
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803091:	8b 12                	mov    (%edx),%edx
  803093:	89 10                	mov    %edx,(%eax)
  803095:	eb 0a                	jmp    8030a1 <alloc_block_BF+0x26f>
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	a3 48 50 98 00       	mov    %eax,0x985048
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b4:	a1 54 50 98 00       	mov    0x985054,%eax
  8030b9:	48                   	dec    %eax
  8030ba:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  8030ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ce:	0f 84 6a 02 00 00    	je     80333e <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  8030d4:	ff 75 08             	pushl  0x8(%ebp)
  8030d7:	e8 b9 f4 ff ff       	call   802595 <get_block_size>
  8030dc:	83 c4 04             	add    $0x4,%esp
  8030df:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	83 e8 08             	sub    $0x8,%eax
  8030e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8030eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	83 e0 fe             	and    $0xfffffffe,%eax
  8030f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8030f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f9:	f7 d8                	neg    %eax
  8030fb:	89 c2                	mov    %eax,%edx
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	01 d0                	add    %edx,%eax
  803102:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  803105:	ff 75 e8             	pushl  -0x18(%ebp)
  803108:	e8 a1 f4 ff ff       	call   8025ae <is_free_block>
  80310d:	83 c4 04             	add    $0x4,%esp
  803110:	0f be c0             	movsbl %al,%eax
  803113:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  803116:	8b 55 08             	mov    0x8(%ebp),%edx
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	01 d0                	add    %edx,%eax
  80311e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803121:	ff 75 e0             	pushl  -0x20(%ebp)
  803124:	e8 85 f4 ff ff       	call   8025ae <is_free_block>
  803129:	83 c4 04             	add    $0x4,%esp
  80312c:	0f be c0             	movsbl %al,%eax
  80312f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  803132:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803136:	75 34                	jne    80316c <free_block+0xa8>
  803138:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80313c:	75 2e                	jne    80316c <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  80313e:	ff 75 e8             	pushl  -0x18(%ebp)
  803141:	e8 4f f4 ff ff       	call   802595 <get_block_size>
  803146:	83 c4 04             	add    $0x4,%esp
  803149:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  80314c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803152:	01 d0                	add    %edx,%eax
  803154:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803157:	6a 00                	push   $0x0
  803159:	ff 75 d4             	pushl  -0x2c(%ebp)
  80315c:	ff 75 e8             	pushl  -0x18(%ebp)
  80315f:	e8 ad f6 ff ff       	call   802811 <set_block_data>
  803164:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803167:	e9 d3 01 00 00       	jmp    80333f <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  80316c:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803170:	0f 85 c8 00 00 00    	jne    80323e <free_block+0x17a>
  803176:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80317a:	0f 85 be 00 00 00    	jne    80323e <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803180:	ff 75 e0             	pushl  -0x20(%ebp)
  803183:	e8 0d f4 ff ff       	call   802595 <get_block_size>
  803188:	83 c4 04             	add    $0x4,%esp
  80318b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  80318e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803191:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803194:	01 d0                	add    %edx,%eax
  803196:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803199:	6a 00                	push   $0x0
  80319b:	ff 75 cc             	pushl  -0x34(%ebp)
  80319e:	ff 75 08             	pushl  0x8(%ebp)
  8031a1:	e8 6b f6 ff ff       	call   802811 <set_block_data>
  8031a6:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  8031a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031ad:	75 17                	jne    8031c6 <free_block+0x102>
  8031af:	83 ec 04             	sub    $0x4,%esp
  8031b2:	68 00 45 80 00       	push   $0x804500
  8031b7:	68 87 01 00 00       	push   $0x187
  8031bc:	68 57 44 80 00       	push   $0x804457
  8031c1:	e8 10 d6 ff ff       	call   8007d6 <_panic>
  8031c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 10                	je     8031df <free_block+0x11b>
  8031cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031d7:	8b 52 04             	mov    0x4(%edx),%edx
  8031da:	89 50 04             	mov    %edx,0x4(%eax)
  8031dd:	eb 0b                	jmp    8031ea <free_block+0x126>
  8031df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e2:	8b 40 04             	mov    0x4(%eax),%eax
  8031e5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	74 0f                	je     803203 <free_block+0x13f>
  8031f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f7:	8b 40 04             	mov    0x4(%eax),%eax
  8031fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031fd:	8b 12                	mov    (%edx),%edx
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	eb 0a                	jmp    80320d <free_block+0x149>
  803203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	a3 48 50 98 00       	mov    %eax,0x985048
  80320d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803216:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803219:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803220:	a1 54 50 98 00       	mov    0x985054,%eax
  803225:	48                   	dec    %eax
  803226:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  80322b:	83 ec 0c             	sub    $0xc,%esp
  80322e:	ff 75 08             	pushl  0x8(%ebp)
  803231:	e8 32 f6 ff ff       	call   802868 <insert_sorted_in_freeList>
  803236:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803239:	e9 01 01 00 00       	jmp    80333f <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  80323e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803242:	0f 85 d3 00 00 00    	jne    80331b <free_block+0x257>
  803248:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80324c:	0f 85 c9 00 00 00    	jne    80331b <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803252:	83 ec 0c             	sub    $0xc,%esp
  803255:	ff 75 e8             	pushl  -0x18(%ebp)
  803258:	e8 38 f3 ff ff       	call   802595 <get_block_size>
  80325d:	83 c4 10             	add    $0x10,%esp
  803260:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803263:	83 ec 0c             	sub    $0xc,%esp
  803266:	ff 75 e0             	pushl  -0x20(%ebp)
  803269:	e8 27 f3 ff ff       	call   802595 <get_block_size>
  80326e:	83 c4 10             	add    $0x10,%esp
  803271:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803277:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80327a:	01 c2                	add    %eax,%edx
  80327c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80327f:	01 d0                	add    %edx,%eax
  803281:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803284:	83 ec 04             	sub    $0x4,%esp
  803287:	6a 00                	push   $0x0
  803289:	ff 75 c0             	pushl  -0x40(%ebp)
  80328c:	ff 75 e8             	pushl  -0x18(%ebp)
  80328f:	e8 7d f5 ff ff       	call   802811 <set_block_data>
  803294:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803297:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80329b:	75 17                	jne    8032b4 <free_block+0x1f0>
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	68 00 45 80 00       	push   $0x804500
  8032a5:	68 94 01 00 00       	push   $0x194
  8032aa:	68 57 44 80 00       	push   $0x804457
  8032af:	e8 22 d5 ff ff       	call   8007d6 <_panic>
  8032b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	85 c0                	test   %eax,%eax
  8032bb:	74 10                	je     8032cd <free_block+0x209>
  8032bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032c5:	8b 52 04             	mov    0x4(%edx),%edx
  8032c8:	89 50 04             	mov    %edx,0x4(%eax)
  8032cb:	eb 0b                	jmp    8032d8 <free_block+0x214>
  8032cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d0:	8b 40 04             	mov    0x4(%eax),%eax
  8032d3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	74 0f                	je     8032f1 <free_block+0x22d>
  8032e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032eb:	8b 12                	mov    (%edx),%edx
  8032ed:	89 10                	mov    %edx,(%eax)
  8032ef:	eb 0a                	jmp    8032fb <free_block+0x237>
  8032f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	a3 48 50 98 00       	mov    %eax,0x985048
  8032fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803304:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803307:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330e:	a1 54 50 98 00       	mov    0x985054,%eax
  803313:	48                   	dec    %eax
  803314:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803319:	eb 24                	jmp    80333f <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  80331b:	83 ec 04             	sub    $0x4,%esp
  80331e:	6a 00                	push   $0x0
  803320:	ff 75 f4             	pushl  -0xc(%ebp)
  803323:	ff 75 08             	pushl  0x8(%ebp)
  803326:	e8 e6 f4 ff ff       	call   802811 <set_block_data>
  80332b:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  80332e:	83 ec 0c             	sub    $0xc,%esp
  803331:	ff 75 08             	pushl  0x8(%ebp)
  803334:	e8 2f f5 ff ff       	call   802868 <insert_sorted_in_freeList>
  803339:	83 c4 10             	add    $0x10,%esp
  80333c:	eb 01                	jmp    80333f <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  80333e:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  80333f:	c9                   	leave  
  803340:	c3                   	ret    

00803341 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803341:	55                   	push   %ebp
  803342:	89 e5                	mov    %esp,%ebp
  803344:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803347:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334b:	75 10                	jne    80335d <realloc_block_FF+0x1c>
  80334d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803351:	75 0a                	jne    80335d <realloc_block_FF+0x1c>
	{
		return NULL;
  803353:	b8 00 00 00 00       	mov    $0x0,%eax
  803358:	e9 8b 04 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  80335d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803361:	75 18                	jne    80337b <realloc_block_FF+0x3a>
	{
		free_block(va);
  803363:	83 ec 0c             	sub    $0xc,%esp
  803366:	ff 75 08             	pushl  0x8(%ebp)
  803369:	e8 56 fd ff ff       	call   8030c4 <free_block>
  80336e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803371:	b8 00 00 00 00       	mov    $0x0,%eax
  803376:	e9 6d 04 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  80337b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80337f:	75 13                	jne    803394 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803381:	83 ec 0c             	sub    $0xc,%esp
  803384:	ff 75 0c             	pushl  0xc(%ebp)
  803387:	e8 6f f6 ff ff       	call   8029fb <alloc_block_FF>
  80338c:	83 c4 10             	add    $0x10,%esp
  80338f:	e9 54 04 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803394:	8b 45 0c             	mov    0xc(%ebp),%eax
  803397:	83 e0 01             	and    $0x1,%eax
  80339a:	85 c0                	test   %eax,%eax
  80339c:	74 03                	je     8033a1 <realloc_block_FF+0x60>
	{
		new_size++;
  80339e:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  8033a1:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033a5:	77 07                	ja     8033ae <realloc_block_FF+0x6d>
	{
		new_size = 8;
  8033a7:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  8033ae:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  8033b2:	83 ec 0c             	sub    $0xc,%esp
  8033b5:	ff 75 08             	pushl  0x8(%ebp)
  8033b8:	e8 d8 f1 ff ff       	call   802595 <get_block_size>
  8033bd:	83 c4 10             	add    $0x10,%esp
  8033c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033c9:	75 08                	jne    8033d3 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	e9 15 04 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8033d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d9:	01 d0                	add    %edx,%eax
  8033db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8033de:	83 ec 0c             	sub    $0xc,%esp
  8033e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8033e4:	e8 c5 f1 ff ff       	call   8025ae <is_free_block>
  8033e9:	83 c4 10             	add    $0x10,%esp
  8033ec:	0f be c0             	movsbl %al,%eax
  8033ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8033f2:	83 ec 0c             	sub    $0xc,%esp
  8033f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8033f8:	e8 98 f1 ff ff       	call   802595 <get_block_size>
  8033fd:	83 c4 10             	add    $0x10,%esp
  803400:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803403:	8b 45 0c             	mov    0xc(%ebp),%eax
  803406:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803409:	0f 86 a7 02 00 00    	jbe    8036b6 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  80340f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803413:	0f 84 86 02 00 00    	je     80369f <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803419:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	01 d0                	add    %edx,%eax
  803421:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803424:	0f 85 b2 00 00 00    	jne    8034dc <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80342a:	83 ec 0c             	sub    $0xc,%esp
  80342d:	ff 75 08             	pushl  0x8(%ebp)
  803430:	e8 79 f1 ff ff       	call   8025ae <is_free_block>
  803435:	83 c4 10             	add    $0x10,%esp
  803438:	84 c0                	test   %al,%al
  80343a:	0f 94 c0             	sete   %al
  80343d:	0f b6 c0             	movzbl %al,%eax
  803440:	83 ec 04             	sub    $0x4,%esp
  803443:	50                   	push   %eax
  803444:	ff 75 0c             	pushl  0xc(%ebp)
  803447:	ff 75 08             	pushl  0x8(%ebp)
  80344a:	e8 c2 f3 ff ff       	call   802811 <set_block_data>
  80344f:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803456:	75 17                	jne    80346f <realloc_block_FF+0x12e>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 00 45 80 00       	push   $0x804500
  803460:	68 db 01 00 00       	push   $0x1db
  803465:	68 57 44 80 00       	push   $0x804457
  80346a:	e8 67 d3 ff ff       	call   8007d6 <_panic>
  80346f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	85 c0                	test   %eax,%eax
  803476:	74 10                	je     803488 <realloc_block_FF+0x147>
  803478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347b:	8b 00                	mov    (%eax),%eax
  80347d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803480:	8b 52 04             	mov    0x4(%edx),%edx
  803483:	89 50 04             	mov    %edx,0x4(%eax)
  803486:	eb 0b                	jmp    803493 <realloc_block_FF+0x152>
  803488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348b:	8b 40 04             	mov    0x4(%eax),%eax
  80348e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803496:	8b 40 04             	mov    0x4(%eax),%eax
  803499:	85 c0                	test   %eax,%eax
  80349b:	74 0f                	je     8034ac <realloc_block_FF+0x16b>
  80349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a6:	8b 12                	mov    (%edx),%edx
  8034a8:	89 10                	mov    %edx,(%eax)
  8034aa:	eb 0a                	jmp    8034b6 <realloc_block_FF+0x175>
  8034ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	a3 48 50 98 00       	mov    %eax,0x985048
  8034b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c9:	a1 54 50 98 00       	mov    0x985054,%eax
  8034ce:	48                   	dec    %eax
  8034cf:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8034d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d7:	e9 0c 03 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8034dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e2:	01 d0                	add    %edx,%eax
  8034e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034e7:	0f 86 b2 01 00 00    	jbe    80369f <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8034ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8034f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8034f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8034fc:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8034ff:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803503:	0f 87 b8 00 00 00    	ja     8035c1 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803509:	83 ec 0c             	sub    $0xc,%esp
  80350c:	ff 75 08             	pushl  0x8(%ebp)
  80350f:	e8 9a f0 ff ff       	call   8025ae <is_free_block>
  803514:	83 c4 10             	add    $0x10,%esp
  803517:	84 c0                	test   %al,%al
  803519:	0f 94 c0             	sete   %al
  80351c:	0f b6 c0             	movzbl %al,%eax
  80351f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803522:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803525:	01 ca                	add    %ecx,%edx
  803527:	83 ec 04             	sub    $0x4,%esp
  80352a:	50                   	push   %eax
  80352b:	52                   	push   %edx
  80352c:	ff 75 08             	pushl  0x8(%ebp)
  80352f:	e8 dd f2 ff ff       	call   802811 <set_block_data>
  803534:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803537:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80353b:	75 17                	jne    803554 <realloc_block_FF+0x213>
  80353d:	83 ec 04             	sub    $0x4,%esp
  803540:	68 00 45 80 00       	push   $0x804500
  803545:	68 e8 01 00 00       	push   $0x1e8
  80354a:	68 57 44 80 00       	push   $0x804457
  80354f:	e8 82 d2 ff ff       	call   8007d6 <_panic>
  803554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803557:	8b 00                	mov    (%eax),%eax
  803559:	85 c0                	test   %eax,%eax
  80355b:	74 10                	je     80356d <realloc_block_FF+0x22c>
  80355d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803560:	8b 00                	mov    (%eax),%eax
  803562:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803565:	8b 52 04             	mov    0x4(%edx),%edx
  803568:	89 50 04             	mov    %edx,0x4(%eax)
  80356b:	eb 0b                	jmp    803578 <realloc_block_FF+0x237>
  80356d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803570:	8b 40 04             	mov    0x4(%eax),%eax
  803573:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357b:	8b 40 04             	mov    0x4(%eax),%eax
  80357e:	85 c0                	test   %eax,%eax
  803580:	74 0f                	je     803591 <realloc_block_FF+0x250>
  803582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803585:	8b 40 04             	mov    0x4(%eax),%eax
  803588:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80358b:	8b 12                	mov    (%edx),%edx
  80358d:	89 10                	mov    %edx,(%eax)
  80358f:	eb 0a                	jmp    80359b <realloc_block_FF+0x25a>
  803591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803594:	8b 00                	mov    (%eax),%eax
  803596:	a3 48 50 98 00       	mov    %eax,0x985048
  80359b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ae:	a1 54 50 98 00       	mov    0x985054,%eax
  8035b3:	48                   	dec    %eax
  8035b4:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	e9 27 02 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8035c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035c5:	75 17                	jne    8035de <realloc_block_FF+0x29d>
  8035c7:	83 ec 04             	sub    $0x4,%esp
  8035ca:	68 00 45 80 00       	push   $0x804500
  8035cf:	68 ed 01 00 00       	push   $0x1ed
  8035d4:	68 57 44 80 00       	push   $0x804457
  8035d9:	e8 f8 d1 ff ff       	call   8007d6 <_panic>
  8035de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e1:	8b 00                	mov    (%eax),%eax
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	74 10                	je     8035f7 <realloc_block_FF+0x2b6>
  8035e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ea:	8b 00                	mov    (%eax),%eax
  8035ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ef:	8b 52 04             	mov    0x4(%edx),%edx
  8035f2:	89 50 04             	mov    %edx,0x4(%eax)
  8035f5:	eb 0b                	jmp    803602 <realloc_block_FF+0x2c1>
  8035f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fa:	8b 40 04             	mov    0x4(%eax),%eax
  8035fd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803605:	8b 40 04             	mov    0x4(%eax),%eax
  803608:	85 c0                	test   %eax,%eax
  80360a:	74 0f                	je     80361b <realloc_block_FF+0x2da>
  80360c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360f:	8b 40 04             	mov    0x4(%eax),%eax
  803612:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803615:	8b 12                	mov    (%edx),%edx
  803617:	89 10                	mov    %edx,(%eax)
  803619:	eb 0a                	jmp    803625 <realloc_block_FF+0x2e4>
  80361b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	a3 48 50 98 00       	mov    %eax,0x985048
  803625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803628:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803631:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803638:	a1 54 50 98 00       	mov    0x985054,%eax
  80363d:	48                   	dec    %eax
  80363e:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803643:	8b 55 08             	mov    0x8(%ebp),%edx
  803646:	8b 45 0c             	mov    0xc(%ebp),%eax
  803649:	01 d0                	add    %edx,%eax
  80364b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  80364e:	83 ec 04             	sub    $0x4,%esp
  803651:	6a 00                	push   $0x0
  803653:	ff 75 e0             	pushl  -0x20(%ebp)
  803656:	ff 75 f0             	pushl  -0x10(%ebp)
  803659:	e8 b3 f1 ff ff       	call   802811 <set_block_data>
  80365e:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803661:	83 ec 0c             	sub    $0xc,%esp
  803664:	ff 75 08             	pushl  0x8(%ebp)
  803667:	e8 42 ef ff ff       	call   8025ae <is_free_block>
  80366c:	83 c4 10             	add    $0x10,%esp
  80366f:	84 c0                	test   %al,%al
  803671:	0f 94 c0             	sete   %al
  803674:	0f b6 c0             	movzbl %al,%eax
  803677:	83 ec 04             	sub    $0x4,%esp
  80367a:	50                   	push   %eax
  80367b:	ff 75 0c             	pushl  0xc(%ebp)
  80367e:	ff 75 08             	pushl  0x8(%ebp)
  803681:	e8 8b f1 ff ff       	call   802811 <set_block_data>
  803686:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803689:	83 ec 0c             	sub    $0xc,%esp
  80368c:	ff 75 f0             	pushl  -0x10(%ebp)
  80368f:	e8 d4 f1 ff ff       	call   802868 <insert_sorted_in_freeList>
  803694:	83 c4 10             	add    $0x10,%esp
					return va;
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	e9 49 01 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  80369f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a2:	83 e8 08             	sub    $0x8,%eax
  8036a5:	83 ec 0c             	sub    $0xc,%esp
  8036a8:	50                   	push   %eax
  8036a9:	e8 4d f3 ff ff       	call   8029fb <alloc_block_FF>
  8036ae:	83 c4 10             	add    $0x10,%esp
  8036b1:	e9 32 01 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8036b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8036bc:	0f 83 21 01 00 00    	jae    8037e3 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036c8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8036cb:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8036cf:	77 0e                	ja     8036df <realloc_block_FF+0x39e>
  8036d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036d5:	75 08                	jne    8036df <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	e9 09 01 00 00       	jmp    8037e8 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8036e5:	83 ec 0c             	sub    $0xc,%esp
  8036e8:	ff 75 08             	pushl  0x8(%ebp)
  8036eb:	e8 be ee ff ff       	call   8025ae <is_free_block>
  8036f0:	83 c4 10             	add    $0x10,%esp
  8036f3:	84 c0                	test   %al,%al
  8036f5:	0f 94 c0             	sete   %al
  8036f8:	0f b6 c0             	movzbl %al,%eax
  8036fb:	83 ec 04             	sub    $0x4,%esp
  8036fe:	50                   	push   %eax
  8036ff:	ff 75 0c             	pushl  0xc(%ebp)
  803702:	ff 75 d8             	pushl  -0x28(%ebp)
  803705:	e8 07 f1 ff ff       	call   802811 <set_block_data>
  80370a:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  80370d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803710:	8b 45 0c             	mov    0xc(%ebp),%eax
  803713:	01 d0                	add    %edx,%eax
  803715:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	6a 00                	push   $0x0
  80371d:	ff 75 dc             	pushl  -0x24(%ebp)
  803720:	ff 75 d4             	pushl  -0x2c(%ebp)
  803723:	e8 e9 f0 ff ff       	call   802811 <set_block_data>
  803728:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80372b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80372f:	0f 84 9b 00 00 00    	je     8037d0 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803735:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373b:	01 d0                	add    %edx,%eax
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	6a 00                	push   $0x0
  803742:	50                   	push   %eax
  803743:	ff 75 d4             	pushl  -0x2c(%ebp)
  803746:	e8 c6 f0 ff ff       	call   802811 <set_block_data>
  80374b:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  80374e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803752:	75 17                	jne    80376b <realloc_block_FF+0x42a>
  803754:	83 ec 04             	sub    $0x4,%esp
  803757:	68 00 45 80 00       	push   $0x804500
  80375c:	68 10 02 00 00       	push   $0x210
  803761:	68 57 44 80 00       	push   $0x804457
  803766:	e8 6b d0 ff ff       	call   8007d6 <_panic>
  80376b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376e:	8b 00                	mov    (%eax),%eax
  803770:	85 c0                	test   %eax,%eax
  803772:	74 10                	je     803784 <realloc_block_FF+0x443>
  803774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80377c:	8b 52 04             	mov    0x4(%edx),%edx
  80377f:	89 50 04             	mov    %edx,0x4(%eax)
  803782:	eb 0b                	jmp    80378f <realloc_block_FF+0x44e>
  803784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803787:	8b 40 04             	mov    0x4(%eax),%eax
  80378a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80378f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803792:	8b 40 04             	mov    0x4(%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 0f                	je     8037a8 <realloc_block_FF+0x467>
  803799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037a2:	8b 12                	mov    (%edx),%edx
  8037a4:	89 10                	mov    %edx,(%eax)
  8037a6:	eb 0a                	jmp    8037b2 <realloc_block_FF+0x471>
  8037a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	a3 48 50 98 00       	mov    %eax,0x985048
  8037b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c5:	a1 54 50 98 00       	mov    0x985054,%eax
  8037ca:	48                   	dec    %eax
  8037cb:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8037d0:	83 ec 0c             	sub    $0xc,%esp
  8037d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037d6:	e8 8d f0 ff ff       	call   802868 <insert_sorted_in_freeList>
  8037db:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8037de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037e1:	eb 05                	jmp    8037e8 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8037e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037e8:	c9                   	leave  
  8037e9:	c3                   	ret    

008037ea <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037ea:	55                   	push   %ebp
  8037eb:	89 e5                	mov    %esp,%ebp
  8037ed:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037f0:	83 ec 04             	sub    $0x4,%esp
  8037f3:	68 20 45 80 00       	push   $0x804520
  8037f8:	68 20 02 00 00       	push   $0x220
  8037fd:	68 57 44 80 00       	push   $0x804457
  803802:	e8 cf cf ff ff       	call   8007d6 <_panic>

00803807 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803807:	55                   	push   %ebp
  803808:	89 e5                	mov    %esp,%ebp
  80380a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80380d:	83 ec 04             	sub    $0x4,%esp
  803810:	68 48 45 80 00       	push   $0x804548
  803815:	68 28 02 00 00       	push   $0x228
  80381a:	68 57 44 80 00       	push   $0x804457
  80381f:	e8 b2 cf ff ff       	call   8007d6 <_panic>

00803824 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803824:	55                   	push   %ebp
  803825:	89 e5                	mov    %esp,%ebp
  803827:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  80382a:	83 ec 04             	sub    $0x4,%esp
  80382d:	6a 01                	push   $0x1
  80382f:	6a 58                	push   $0x58
  803831:	ff 75 0c             	pushl  0xc(%ebp)
  803834:	e8 c1 e2 ff ff       	call   801afa <smalloc>
  803839:	83 c4 10             	add    $0x10,%esp
  80383c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  80383f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803843:	75 14                	jne    803859 <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  803845:	83 ec 04             	sub    $0x4,%esp
  803848:	68 70 45 80 00       	push   $0x804570
  80384d:	6a 10                	push   $0x10
  80384f:	68 9e 45 80 00       	push   $0x80459e
  803854:	e8 7d cf ff ff       	call   8007d6 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  803859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385c:	83 ec 0c             	sub    $0xc,%esp
  80385f:	50                   	push   %eax
  803860:	e8 bc ec ff ff       	call   802521 <sys_init_queue>
  803865:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  803868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  803872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803875:	83 c0 18             	add    $0x18,%eax
  803878:	83 ec 04             	sub    $0x4,%esp
  80387b:	6a 40                	push   $0x40
  80387d:	ff 75 0c             	pushl  0xc(%ebp)
  803880:	50                   	push   %eax
  803881:	e8 1e d9 ff ff       	call   8011a4 <strncpy>
  803886:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  803889:	8b 55 10             	mov    0x10(%ebp),%edx
  80388c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388f:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80389e:	89 10                	mov    %edx,(%eax)
}
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	c9                   	leave  
  8038a4:	c2 04 00             	ret    $0x4

008038a7 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8038a7:	55                   	push   %ebp
  8038a8:	89 e5                	mov    %esp,%ebp
  8038aa:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  8038ad:	83 ec 08             	sub    $0x8,%esp
  8038b0:	ff 75 10             	pushl  0x10(%ebp)
  8038b3:	ff 75 0c             	pushl  0xc(%ebp)
  8038b6:	e8 da e3 ff ff       	call   801c95 <sget>
  8038bb:	83 c4 10             	add    $0x10,%esp
  8038be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8038c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c5:	75 14                	jne    8038db <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  8038c7:	83 ec 04             	sub    $0x4,%esp
  8038ca:	68 b0 45 80 00       	push   $0x8045b0
  8038cf:	6a 2c                	push   $0x2c
  8038d1:	68 9e 45 80 00       	push   $0x80459e
  8038d6:	e8 fb ce ff ff       	call   8007d6 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  8038db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e7:	89 10                	mov    %edx,(%eax)
}
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	c9                   	leave  
  8038ed:	c2 04 00             	ret    $0x4

008038f0 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  8038f0:	55                   	push   %ebp
  8038f1:	89 e5                	mov    %esp,%ebp
  8038f3:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  8038f6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	8b 40 14             	mov    0x14(%eax),%eax
  803903:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803906:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803909:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80390c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80390f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803912:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803915:	f0 87 02             	lock xchg %eax,(%edx)
  803918:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  80391b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391e:	85 c0                	test   %eax,%eax
  803920:	75 db                	jne    8038fd <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	8b 50 10             	mov    0x10(%eax),%edx
  803928:	4a                   	dec    %edx
  803929:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	8b 40 10             	mov    0x10(%eax),%eax
  803932:	85 c0                	test   %eax,%eax
  803934:	79 18                	jns    80394e <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  803936:	8b 45 08             	mov    0x8(%ebp),%eax
  803939:	8d 50 14             	lea    0x14(%eax),%edx
  80393c:	8b 45 08             	mov    0x8(%ebp),%eax
  80393f:	83 ec 08             	sub    $0x8,%esp
  803942:	52                   	push   %edx
  803943:	50                   	push   %eax
  803944:	e8 f4 eb ff ff       	call   80253d <sys_block_process>
  803949:	83 c4 10             	add    $0x10,%esp
  80394c:	eb 0a                	jmp    803958 <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  80394e:	8b 45 08             	mov    0x8(%ebp),%eax
  803951:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803958:	c9                   	leave  
  803959:	c3                   	ret    

0080395a <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  80395a:	55                   	push   %ebp
  80395b:	89 e5                	mov    %esp,%ebp
  80395d:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803960:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803967:	8b 45 08             	mov    0x8(%ebp),%eax
  80396a:	8b 40 14             	mov    0x14(%eax),%eax
  80396d:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803970:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80397c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80397f:	f0 87 02             	lock xchg %eax,(%edx)
  803982:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803988:	85 c0                	test   %eax,%eax
  80398a:	75 db                	jne    803967 <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  80398c:	8b 45 08             	mov    0x8(%ebp),%eax
  80398f:	8b 50 10             	mov    0x10(%eax),%edx
  803992:	42                   	inc    %edx
  803993:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  803996:	8b 45 08             	mov    0x8(%ebp),%eax
  803999:	8b 40 10             	mov    0x10(%eax),%eax
  80399c:	85 c0                	test   %eax,%eax
  80399e:	7f 0f                	jg     8039af <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  8039a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a3:	83 ec 0c             	sub    $0xc,%esp
  8039a6:	50                   	push   %eax
  8039a7:	e8 af eb ff ff       	call   80255b <sys_unblock_process>
  8039ac:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  8039af:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8039b9:	90                   	nop
  8039ba:	c9                   	leave  
  8039bb:	c3                   	ret    

008039bc <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  8039bc:	55                   	push   %ebp
  8039bd:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8039bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c2:	8b 40 10             	mov    0x10(%eax),%eax
}
  8039c5:	5d                   	pop    %ebp
  8039c6:	c3                   	ret    
  8039c7:	90                   	nop

008039c8 <__udivdi3>:
  8039c8:	55                   	push   %ebp
  8039c9:	57                   	push   %edi
  8039ca:	56                   	push   %esi
  8039cb:	53                   	push   %ebx
  8039cc:	83 ec 1c             	sub    $0x1c,%esp
  8039cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039df:	89 ca                	mov    %ecx,%edx
  8039e1:	89 f8                	mov    %edi,%eax
  8039e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039e7:	85 f6                	test   %esi,%esi
  8039e9:	75 2d                	jne    803a18 <__udivdi3+0x50>
  8039eb:	39 cf                	cmp    %ecx,%edi
  8039ed:	77 65                	ja     803a54 <__udivdi3+0x8c>
  8039ef:	89 fd                	mov    %edi,%ebp
  8039f1:	85 ff                	test   %edi,%edi
  8039f3:	75 0b                	jne    803a00 <__udivdi3+0x38>
  8039f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8039fa:	31 d2                	xor    %edx,%edx
  8039fc:	f7 f7                	div    %edi
  8039fe:	89 c5                	mov    %eax,%ebp
  803a00:	31 d2                	xor    %edx,%edx
  803a02:	89 c8                	mov    %ecx,%eax
  803a04:	f7 f5                	div    %ebp
  803a06:	89 c1                	mov    %eax,%ecx
  803a08:	89 d8                	mov    %ebx,%eax
  803a0a:	f7 f5                	div    %ebp
  803a0c:	89 cf                	mov    %ecx,%edi
  803a0e:	89 fa                	mov    %edi,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	39 ce                	cmp    %ecx,%esi
  803a1a:	77 28                	ja     803a44 <__udivdi3+0x7c>
  803a1c:	0f bd fe             	bsr    %esi,%edi
  803a1f:	83 f7 1f             	xor    $0x1f,%edi
  803a22:	75 40                	jne    803a64 <__udivdi3+0x9c>
  803a24:	39 ce                	cmp    %ecx,%esi
  803a26:	72 0a                	jb     803a32 <__udivdi3+0x6a>
  803a28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a2c:	0f 87 9e 00 00 00    	ja     803ad0 <__udivdi3+0x108>
  803a32:	b8 01 00 00 00       	mov    $0x1,%eax
  803a37:	89 fa                	mov    %edi,%edx
  803a39:	83 c4 1c             	add    $0x1c,%esp
  803a3c:	5b                   	pop    %ebx
  803a3d:	5e                   	pop    %esi
  803a3e:	5f                   	pop    %edi
  803a3f:	5d                   	pop    %ebp
  803a40:	c3                   	ret    
  803a41:	8d 76 00             	lea    0x0(%esi),%esi
  803a44:	31 ff                	xor    %edi,%edi
  803a46:	31 c0                	xor    %eax,%eax
  803a48:	89 fa                	mov    %edi,%edx
  803a4a:	83 c4 1c             	add    $0x1c,%esp
  803a4d:	5b                   	pop    %ebx
  803a4e:	5e                   	pop    %esi
  803a4f:	5f                   	pop    %edi
  803a50:	5d                   	pop    %ebp
  803a51:	c3                   	ret    
  803a52:	66 90                	xchg   %ax,%ax
  803a54:	89 d8                	mov    %ebx,%eax
  803a56:	f7 f7                	div    %edi
  803a58:	31 ff                	xor    %edi,%edi
  803a5a:	89 fa                	mov    %edi,%edx
  803a5c:	83 c4 1c             	add    $0x1c,%esp
  803a5f:	5b                   	pop    %ebx
  803a60:	5e                   	pop    %esi
  803a61:	5f                   	pop    %edi
  803a62:	5d                   	pop    %ebp
  803a63:	c3                   	ret    
  803a64:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a69:	89 eb                	mov    %ebp,%ebx
  803a6b:	29 fb                	sub    %edi,%ebx
  803a6d:	89 f9                	mov    %edi,%ecx
  803a6f:	d3 e6                	shl    %cl,%esi
  803a71:	89 c5                	mov    %eax,%ebp
  803a73:	88 d9                	mov    %bl,%cl
  803a75:	d3 ed                	shr    %cl,%ebp
  803a77:	89 e9                	mov    %ebp,%ecx
  803a79:	09 f1                	or     %esi,%ecx
  803a7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a7f:	89 f9                	mov    %edi,%ecx
  803a81:	d3 e0                	shl    %cl,%eax
  803a83:	89 c5                	mov    %eax,%ebp
  803a85:	89 d6                	mov    %edx,%esi
  803a87:	88 d9                	mov    %bl,%cl
  803a89:	d3 ee                	shr    %cl,%esi
  803a8b:	89 f9                	mov    %edi,%ecx
  803a8d:	d3 e2                	shl    %cl,%edx
  803a8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a93:	88 d9                	mov    %bl,%cl
  803a95:	d3 e8                	shr    %cl,%eax
  803a97:	09 c2                	or     %eax,%edx
  803a99:	89 d0                	mov    %edx,%eax
  803a9b:	89 f2                	mov    %esi,%edx
  803a9d:	f7 74 24 0c          	divl   0xc(%esp)
  803aa1:	89 d6                	mov    %edx,%esi
  803aa3:	89 c3                	mov    %eax,%ebx
  803aa5:	f7 e5                	mul    %ebp
  803aa7:	39 d6                	cmp    %edx,%esi
  803aa9:	72 19                	jb     803ac4 <__udivdi3+0xfc>
  803aab:	74 0b                	je     803ab8 <__udivdi3+0xf0>
  803aad:	89 d8                	mov    %ebx,%eax
  803aaf:	31 ff                	xor    %edi,%edi
  803ab1:	e9 58 ff ff ff       	jmp    803a0e <__udivdi3+0x46>
  803ab6:	66 90                	xchg   %ax,%ax
  803ab8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803abc:	89 f9                	mov    %edi,%ecx
  803abe:	d3 e2                	shl    %cl,%edx
  803ac0:	39 c2                	cmp    %eax,%edx
  803ac2:	73 e9                	jae    803aad <__udivdi3+0xe5>
  803ac4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ac7:	31 ff                	xor    %edi,%edi
  803ac9:	e9 40 ff ff ff       	jmp    803a0e <__udivdi3+0x46>
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	31 c0                	xor    %eax,%eax
  803ad2:	e9 37 ff ff ff       	jmp    803a0e <__udivdi3+0x46>
  803ad7:	90                   	nop

00803ad8 <__umoddi3>:
  803ad8:	55                   	push   %ebp
  803ad9:	57                   	push   %edi
  803ada:	56                   	push   %esi
  803adb:	53                   	push   %ebx
  803adc:	83 ec 1c             	sub    $0x1c,%esp
  803adf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ae3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ae7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803af3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803af7:	89 f3                	mov    %esi,%ebx
  803af9:	89 fa                	mov    %edi,%edx
  803afb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aff:	89 34 24             	mov    %esi,(%esp)
  803b02:	85 c0                	test   %eax,%eax
  803b04:	75 1a                	jne    803b20 <__umoddi3+0x48>
  803b06:	39 f7                	cmp    %esi,%edi
  803b08:	0f 86 a2 00 00 00    	jbe    803bb0 <__umoddi3+0xd8>
  803b0e:	89 c8                	mov    %ecx,%eax
  803b10:	89 f2                	mov    %esi,%edx
  803b12:	f7 f7                	div    %edi
  803b14:	89 d0                	mov    %edx,%eax
  803b16:	31 d2                	xor    %edx,%edx
  803b18:	83 c4 1c             	add    $0x1c,%esp
  803b1b:	5b                   	pop    %ebx
  803b1c:	5e                   	pop    %esi
  803b1d:	5f                   	pop    %edi
  803b1e:	5d                   	pop    %ebp
  803b1f:	c3                   	ret    
  803b20:	39 f0                	cmp    %esi,%eax
  803b22:	0f 87 ac 00 00 00    	ja     803bd4 <__umoddi3+0xfc>
  803b28:	0f bd e8             	bsr    %eax,%ebp
  803b2b:	83 f5 1f             	xor    $0x1f,%ebp
  803b2e:	0f 84 ac 00 00 00    	je     803be0 <__umoddi3+0x108>
  803b34:	bf 20 00 00 00       	mov    $0x20,%edi
  803b39:	29 ef                	sub    %ebp,%edi
  803b3b:	89 fe                	mov    %edi,%esi
  803b3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b41:	89 e9                	mov    %ebp,%ecx
  803b43:	d3 e0                	shl    %cl,%eax
  803b45:	89 d7                	mov    %edx,%edi
  803b47:	89 f1                	mov    %esi,%ecx
  803b49:	d3 ef                	shr    %cl,%edi
  803b4b:	09 c7                	or     %eax,%edi
  803b4d:	89 e9                	mov    %ebp,%ecx
  803b4f:	d3 e2                	shl    %cl,%edx
  803b51:	89 14 24             	mov    %edx,(%esp)
  803b54:	89 d8                	mov    %ebx,%eax
  803b56:	d3 e0                	shl    %cl,%eax
  803b58:	89 c2                	mov    %eax,%edx
  803b5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b5e:	d3 e0                	shl    %cl,%eax
  803b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b64:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b68:	89 f1                	mov    %esi,%ecx
  803b6a:	d3 e8                	shr    %cl,%eax
  803b6c:	09 d0                	or     %edx,%eax
  803b6e:	d3 eb                	shr    %cl,%ebx
  803b70:	89 da                	mov    %ebx,%edx
  803b72:	f7 f7                	div    %edi
  803b74:	89 d3                	mov    %edx,%ebx
  803b76:	f7 24 24             	mull   (%esp)
  803b79:	89 c6                	mov    %eax,%esi
  803b7b:	89 d1                	mov    %edx,%ecx
  803b7d:	39 d3                	cmp    %edx,%ebx
  803b7f:	0f 82 87 00 00 00    	jb     803c0c <__umoddi3+0x134>
  803b85:	0f 84 91 00 00 00    	je     803c1c <__umoddi3+0x144>
  803b8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b8f:	29 f2                	sub    %esi,%edx
  803b91:	19 cb                	sbb    %ecx,%ebx
  803b93:	89 d8                	mov    %ebx,%eax
  803b95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b99:	d3 e0                	shl    %cl,%eax
  803b9b:	89 e9                	mov    %ebp,%ecx
  803b9d:	d3 ea                	shr    %cl,%edx
  803b9f:	09 d0                	or     %edx,%eax
  803ba1:	89 e9                	mov    %ebp,%ecx
  803ba3:	d3 eb                	shr    %cl,%ebx
  803ba5:	89 da                	mov    %ebx,%edx
  803ba7:	83 c4 1c             	add    $0x1c,%esp
  803baa:	5b                   	pop    %ebx
  803bab:	5e                   	pop    %esi
  803bac:	5f                   	pop    %edi
  803bad:	5d                   	pop    %ebp
  803bae:	c3                   	ret    
  803baf:	90                   	nop
  803bb0:	89 fd                	mov    %edi,%ebp
  803bb2:	85 ff                	test   %edi,%edi
  803bb4:	75 0b                	jne    803bc1 <__umoddi3+0xe9>
  803bb6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bbb:	31 d2                	xor    %edx,%edx
  803bbd:	f7 f7                	div    %edi
  803bbf:	89 c5                	mov    %eax,%ebp
  803bc1:	89 f0                	mov    %esi,%eax
  803bc3:	31 d2                	xor    %edx,%edx
  803bc5:	f7 f5                	div    %ebp
  803bc7:	89 c8                	mov    %ecx,%eax
  803bc9:	f7 f5                	div    %ebp
  803bcb:	89 d0                	mov    %edx,%eax
  803bcd:	e9 44 ff ff ff       	jmp    803b16 <__umoddi3+0x3e>
  803bd2:	66 90                	xchg   %ax,%ax
  803bd4:	89 c8                	mov    %ecx,%eax
  803bd6:	89 f2                	mov    %esi,%edx
  803bd8:	83 c4 1c             	add    $0x1c,%esp
  803bdb:	5b                   	pop    %ebx
  803bdc:	5e                   	pop    %esi
  803bdd:	5f                   	pop    %edi
  803bde:	5d                   	pop    %ebp
  803bdf:	c3                   	ret    
  803be0:	3b 04 24             	cmp    (%esp),%eax
  803be3:	72 06                	jb     803beb <__umoddi3+0x113>
  803be5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803be9:	77 0f                	ja     803bfa <__umoddi3+0x122>
  803beb:	89 f2                	mov    %esi,%edx
  803bed:	29 f9                	sub    %edi,%ecx
  803bef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bf3:	89 14 24             	mov    %edx,(%esp)
  803bf6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bfa:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bfe:	8b 14 24             	mov    (%esp),%edx
  803c01:	83 c4 1c             	add    $0x1c,%esp
  803c04:	5b                   	pop    %ebx
  803c05:	5e                   	pop    %esi
  803c06:	5f                   	pop    %edi
  803c07:	5d                   	pop    %ebp
  803c08:	c3                   	ret    
  803c09:	8d 76 00             	lea    0x0(%esi),%esi
  803c0c:	2b 04 24             	sub    (%esp),%eax
  803c0f:	19 fa                	sbb    %edi,%edx
  803c11:	89 d1                	mov    %edx,%ecx
  803c13:	89 c6                	mov    %eax,%esi
  803c15:	e9 71 ff ff ff       	jmp    803b8b <__umoddi3+0xb3>
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c20:	72 ea                	jb     803c0c <__umoddi3+0x134>
  803c22:	89 d9                	mov    %ebx,%ecx
  803c24:	e9 62 ff ff ff       	jmp    803b8b <__umoddi3+0xb3>
