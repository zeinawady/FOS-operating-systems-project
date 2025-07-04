
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 1c 0b 00 00       	call   800b52 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
	int envID = sys_getenvid();
  800044:	e8 40 26 00 00       	call   802689 <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 66 ff ff ff    	lea    -0x9a(%ebp),%eax
  80007c:	bb 12 44 80 00       	mov    $0x804412,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb 1c 44 80 00       	mov    $0x80441c,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb 28 44 80 00       	mov    $0x804428,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb 37 44 80 00       	mov    $0x804437,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb 46 44 80 00       	mov    $0x804446,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb 5b 44 80 00       	mov    $0x80445b,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb 70 44 80 00       	mov    $0x804470,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb 81 44 80 00       	mov    $0x804481,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb 92 44 80 00       	mov    $0x804492,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb a3 44 80 00       	mov    $0x8044a3,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb ac 44 80 00       	mov    $0x8044ac,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb b6 44 80 00       	mov    $0x8044b6,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb c1 44 80 00       	mov    $0x8044c1,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb cd 44 80 00       	mov    $0x8044cd,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb d7 44 80 00       	mov    $0x8044d7,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9b fe ff ff 63 	movl   $0x72656c63,-0x165(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 9f fe ff ff 	movw   $0x6b,-0x161(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 8d fe ff ff    	lea    -0x173(%ebp),%eax
  8001f7:	bb e1 44 80 00       	mov    $0x8044e1,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb ef 44 80 00       	mov    $0x8044ef,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb fe 44 80 00       	mov    $0x8044fe,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb 05 45 80 00       	mov    $0x804505,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 66 ff ff ff    	lea    -0x9a(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 52 1d 00 00       	call   801fbb <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 74 1c 00 00       	call   801fbb <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 52 1c 00 00       	call   801fbb <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 31 1c 00 00       	call   801fbb <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 10 1c 00 00       	call   801fbb <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 ee 1b 00 00       	call   801fbb <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 c7 1b 00 00       	call   801fbb <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 a9 1b 00 00       	call   801fbb <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 8b 1b 00 00       	call   801fbb <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 72 1b 00 00       	call   801fbb <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 4a 1b 00 00       	call   801fbb <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************

	struct semaphore flight1CS = create_semaphore(_flight1CS, 1);
  800486:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  80048c:	83 ec 04             	sub    $0x4,%esp
  80048f:	6a 01                	push   $0x1
  800491:	8d 95 ab fe ff ff    	lea    -0x155(%ebp),%edx
  800497:	52                   	push   %edx
  800498:	50                   	push   %eax
  800499:	e8 47 38 00 00       	call   803ce5 <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 2c 38 00 00       	call   803ce5 <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 11 38 00 00       	call   803ce5 <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 f6 37 00 00       	call   803ce5 <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 db 37 00 00       	call   803ce5 <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 c0 37 00 00       	call   803ce5 <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 a5 37 00 00       	call   803ce5 <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 a0 41 80 00       	push   $0x8041a0
  800554:	e8 62 1a 00 00       	call   801fbb <smalloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	int s=0;
  800562:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800569:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800570:	e9 9a 00 00 00       	jmp    80060f <_main+0x5d7>
	{
		char prefix[30]="cust_finished";
  800575:	8d 85 36 fe ff ff    	lea    -0x1ca(%ebp),%eax
  80057b:	bb 0c 45 80 00       	mov    $0x80450c,%ebx
  800580:	ba 0e 00 00 00       	mov    $0xe,%edx
  800585:	89 c7                	mov    %eax,%edi
  800587:	89 de                	mov    %ebx,%esi
  800589:	89 d1                	mov    %edx,%ecx
  80058b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80058d:	8d 95 44 fe ff ff    	lea    -0x1bc(%ebp),%edx
  800593:	b9 04 00 00 00       	mov    $0x4,%ecx
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 d7                	mov    %edx,%edi
  80059f:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	8d 85 31 fe ff ff    	lea    -0x1cf(%ebp),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ae:	e8 db 14 00 00       	call   801a8e <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ff fd ff ff    	lea    -0x201(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 31 fe ff ff    	lea    -0x1cf(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 36 fe ff ff    	lea    -0x1ca(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 94 15 00 00       	call   801b67 <strcconcat>
  8005d3:	83 c4 10             	add    $0x10,%esp
		//sys_createSemaphore(sname, 0);
		cust_finished[s] = create_semaphore(sname, 0);
  8005d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8005e9:	8d 85 f4 fd ff ff    	lea    -0x20c(%ebp),%eax
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	6a 00                	push   $0x0
  8005f4:	8d 95 ff fd ff ff    	lea    -0x201(%ebp),%edx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 e4 36 00 00       	call   803ce5 <create_semaphore>
  800601:	83 c4 0c             	add    $0xc,%esp
  800604:	8b 85 f4 fd ff ff    	mov    -0x20c(%ebp),%eax
  80060a:	89 03                	mov    %eax,(%ebx)
	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  80060c:	ff 45 d8             	incl   -0x28(%ebp)
  80060f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800612:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800615:	0f 8c 5a ff ff ff    	jl     800575 <_main+0x53d>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80061b:	a1 20 50 80 00       	mov    0x805020,%eax
  800620:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800626:	a1 20 50 80 00       	mov    0x805020,%eax
  80062b:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800631:	89 c1                	mov    %eax,%ecx
  800633:	a1 20 50 80 00       	mov    0x805020,%eax
  800638:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80063e:	52                   	push   %edx
  80063f:	51                   	push   %ecx
  800640:	50                   	push   %eax
  800641:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800647:	50                   	push   %eax
  800648:	e8 e7 1f 00 00       	call   802634 <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 ed 1f 00 00       	call   802652 <sys_run_env>
  800665:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800668:	a1 20 50 80 00       	mov    0x805020,%eax
  80066d:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800673:	a1 20 50 80 00       	mov    0x805020,%eax
  800678:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80067e:	89 c1                	mov    %eax,%ecx
  800680:	a1 20 50 80 00       	mov    0x805020,%eax
  800685:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80068b:	52                   	push   %edx
  80068c:	51                   	push   %ecx
  80068d:	50                   	push   %eax
  80068e:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800694:	50                   	push   %eax
  800695:	e8 9a 1f 00 00       	call   802634 <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 a0 1f 00 00       	call   802652 <sys_run_env>
  8006b2:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8006b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ba:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8006c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c5:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8006cb:	89 c1                	mov    %eax,%ecx
  8006cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8006d8:	52                   	push   %edx
  8006d9:	51                   	push   %ecx
  8006da:	50                   	push   %eax
  8006db:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	e8 4d 1f 00 00       	call   802634 <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 53 1f 00 00       	call   802652 <sys_run_env>
  8006ff:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800702:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800709:	eb 70                	jmp    80077b <_main+0x743>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80070b:	a1 20 50 80 00       	mov    0x805020,%eax
  800710:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800716:	a1 20 50 80 00       	mov    0x805020,%eax
  80071b:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	a1 20 50 80 00       	mov    0x805020,%eax
  800728:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80072e:	52                   	push   %edx
  80072f:	51                   	push   %ecx
  800730:	50                   	push   %eax
  800731:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	e8 f7 1e 00 00       	call   802634 <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 b4 41 80 00       	push   $0x8041b4
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 fa 41 80 00       	push   $0x8041fa
  800761:	e8 31 05 00 00       	call   800c97 <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 dd 1e 00 00       	call   802652 <sys_run_env>
  800775:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800778:	ff 45 d4             	incl   -0x2c(%ebp)
  80077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800781:	7c 88                	jl     80070b <_main+0x6d3>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  800783:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80078a:	eb 14                	jmp    8007a0 <_main+0x768>
	{
		wait_semaphore(custTerminated);
  80078c:	83 ec 0c             	sub    $0xc,%esp
  80078f:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800795:	e8 17 36 00 00       	call   803db1 <wait_semaphore>
  80079a:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80079d:	ff 45 d4             	incl   -0x2c(%ebp)
  8007a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007a3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8007a6:	7c e4                	jl     80078c <_main+0x754>
	{
		wait_semaphore(custTerminated);
	}

	env_sleep(1500);
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	68 dc 05 00 00       	push   $0x5dc
  8007b0:	e8 d3 36 00 00       	call   803e88 <env_sleep>
  8007b5:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  8007b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8007bf:	eb 45                	jmp    800806 <_main+0x7ce>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  8007c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007cb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007d9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007ea:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ed:	01 c8                	add    %ecx,%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	83 ec 04             	sub    $0x4,%esp
  8007f4:	52                   	push   %edx
  8007f5:	50                   	push   %eax
  8007f6:	68 0c 42 80 00       	push   $0x80420c
  8007fb:	e8 54 07 00 00       	call   800f54 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800803:	ff 45 d0             	incl   -0x30(%ebp)
  800806:	8b 45 90             	mov    -0x70(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80080e:	7f b1                	jg     8007c1 <_main+0x789>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800810:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800817:	eb 45                	jmp    80085e <_main+0x826>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800823:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800826:	01 d0                	add    %edx,%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800831:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800834:	01 d0                	add    %edx,%eax
  800836:	8b 10                	mov    (%eax),%edx
  800838:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80083b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800842:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800845:	01 c8                	add    %ecx,%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	83 ec 04             	sub    $0x4,%esp
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	68 3c 42 80 00       	push   $0x80423c
  800853:	e8 fc 06 00 00       	call   800f54 <cprintf>
  800858:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80085b:	ff 45 d0             	incl   -0x30(%ebp)
  80085e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800866:	7f b1                	jg     800819 <_main+0x7e1>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  800868:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  80086f:	eb 33                	jmp    8008a4 <_main+0x86c>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  800871:	83 ec 04             	sub    $0x4,%esp
  800874:	ff 75 cc             	pushl  -0x34(%ebp)
  800877:	ff 75 a8             	pushl  -0x58(%ebp)
  80087a:	ff 75 88             	pushl  -0x78(%ebp)
  80087d:	e8 8b 02 00 00       	call   800b0d <find>
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	83 f8 01             	cmp    $0x1,%eax
  800888:	74 17                	je     8008a1 <_main+0x869>
			{
				panic("Error, wrong booking for user %d\n", f1);
  80088a:	ff 75 cc             	pushl  -0x34(%ebp)
  80088d:	68 6c 42 80 00       	push   $0x80426c
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 fa 41 80 00       	push   $0x8041fa
  80089c:	e8 f6 03 00 00       	call   800c97 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8008a1:	ff 45 cc             	incl   -0x34(%ebp)
  8008a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008a7:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8008aa:	7c c5                	jl     800871 <_main+0x839>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  8008ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008af:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8008b2:	eb 33                	jmp    8008e7 <_main+0x8af>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	ff 75 c8             	pushl  -0x38(%ebp)
  8008ba:	ff 75 a4             	pushl  -0x5c(%ebp)
  8008bd:	ff 75 84             	pushl  -0x7c(%ebp)
  8008c0:	e8 48 02 00 00       	call   800b0d <find>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	83 f8 01             	cmp    $0x1,%eax
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
			{
				panic("Error, wrong booking for user %d\n", f2);
  8008cd:	ff 75 c8             	pushl  -0x38(%ebp)
  8008d0:	68 6c 42 80 00       	push   $0x80426c
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 fa 41 80 00       	push   $0x8041fa
  8008df:	e8 b3 03 00 00       	call   800c97 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8008e4:	ff 45 c8             	incl   -0x38(%ebp)
  8008e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8008ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008ed:	01 d0                	add    %edx,%eax
  8008ef:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8008f2:	7f c0                	jg     8008b4 <_main+0x87c>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  8008f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008f7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8008fa:	eb 4c                	jmp    800948 <_main+0x910>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  8008fc:	83 ec 04             	sub    $0x4,%esp
  8008ff:	ff 75 c4             	pushl  -0x3c(%ebp)
  800902:	ff 75 a8             	pushl  -0x58(%ebp)
  800905:	ff 75 88             	pushl  -0x78(%ebp)
  800908:	e8 00 02 00 00       	call   800b0d <find>
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	83 f8 01             	cmp    $0x1,%eax
  800913:	75 19                	jne    80092e <_main+0x8f6>
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	ff 75 c4             	pushl  -0x3c(%ebp)
  80091b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80091e:	ff 75 84             	pushl  -0x7c(%ebp)
  800921:	e8 e7 01 00 00       	call   800b0d <find>
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	83 f8 01             	cmp    $0x1,%eax
  80092c:	74 17                	je     800945 <_main+0x90d>
			{
				panic("Error, wrong booking for user %d\n", f3);
  80092e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800931:	68 6c 42 80 00       	push   $0x80426c
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 fa 41 80 00       	push   $0x8041fa
  800940:	e8 52 03 00 00       	call   800c97 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800945:	ff 45 c4             	incl   -0x3c(%ebp)
  800948:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80094b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80094e:	01 d0                	add    %edx,%eax
  800950:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800953:	7f a7                	jg     8008fc <_main+0x8c4>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(semaphore_count(flight1CS) == 1);
  800955:	83 ec 0c             	sub    $0xc,%esp
  800958:	ff b5 6c fe ff ff    	pushl  -0x194(%ebp)
  80095e:	e8 1a 35 00 00       	call   803e7d <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 90 42 80 00       	push   $0x804290
  800970:	68 b0 42 80 00       	push   $0x8042b0
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 fa 41 80 00       	push   $0x8041fa
  80097f:	e8 13 03 00 00       	call   800c97 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 eb 34 00 00       	call   803e7d <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 c8 42 80 00       	push   $0x8042c8
  80099f:	68 b0 42 80 00       	push   $0x8042b0
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 fa 41 80 00       	push   $0x8041fa
  8009ae:	e8 e4 02 00 00       	call   800c97 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 bc 34 00 00       	call   803e7d <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 e8 42 80 00       	push   $0x8042e8
  8009ce:	68 b0 42 80 00       	push   $0x8042b0
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 fa 41 80 00       	push   $0x8041fa
  8009dd:	e8 b5 02 00 00       	call   800c97 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 8d 34 00 00       	call   803e7d <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 0c 43 80 00       	push   $0x80430c
  8009fd:	68 b0 42 80 00       	push   $0x8042b0
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 fa 41 80 00       	push   $0x8041fa
  800a0c:	e8 86 02 00 00       	call   800c97 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 5e 34 00 00       	call   803e7d <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 2e 43 80 00       	push   $0x80432e
  800a2c:	68 b0 42 80 00       	push   $0x8042b0
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 fa 41 80 00       	push   $0x8041fa
  800a3b:	e8 57 02 00 00       	call   800c97 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 2f 34 00 00       	call   803e7d <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 4c 43 80 00       	push   $0x80434c
  800a5b:	68 b0 42 80 00       	push   $0x8042b0
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 fa 41 80 00       	push   $0x8041fa
  800a6a:	e8 28 02 00 00       	call   800c97 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 00 34 00 00       	call   803e7d <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 70 43 80 00       	push   $0x804370
  800a89:	68 b0 42 80 00       	push   $0x8042b0
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 fa 41 80 00       	push   $0x8041fa
  800a98:	e8 fa 01 00 00       	call   800c97 <_panic>

		int s=0;
  800a9d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800aa4:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800aab:	eb 3f                	jmp    800aec <_main+0xab4>
//			char prefix[30]="cust_finished";
//			char id[5]; char cust_finishedSemaphoreName[50];
//			ltostr(s, id);
//			strcconcat(prefix, id, cust_finishedSemaphoreName);
//			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
			assert(semaphore_count(cust_finished[s]) ==  0);
  800aad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ab0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ab7:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800abd:	01 d0                	add    %edx,%eax
  800abf:	83 ec 0c             	sub    $0xc,%esp
  800ac2:	ff 30                	pushl  (%eax)
  800ac4:	e8 b4 33 00 00       	call   803e7d <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 98 43 80 00       	push   $0x804398
  800ad5:	68 b0 42 80 00       	push   $0x8042b0
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 fa 41 80 00       	push   $0x8041fa
  800ae4:	e8 ae 01 00 00       	call   800c97 <_panic>
		assert(semaphore_count(cust_ready) == -3);

		assert(semaphore_count(custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ae9:	ff 45 c0             	incl   -0x40(%ebp)
  800aec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aef:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800af2:	7c b9                	jl     800aad <_main+0xa75>
//			strcconcat(prefix, id, cust_finishedSemaphoreName);
//			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
			assert(semaphore_count(cust_finished[s]) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800af4:	83 ec 0c             	sub    $0xc,%esp
  800af7:	68 c0 43 80 00       	push   $0x8043c0
  800afc:	e8 53 04 00 00       	call   800f54 <cprintf>
  800b01:	83 c4 10             	add    $0x10,%esp
	}

}
  800b04:	90                   	nop
  800b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5f                   	pop    %edi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <find>:


int find(int* arr, int size, int val)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b21:	eb 22                	jmp    800b45 <find+0x38>
	{
		if(arr[i] == val)
  800b23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	01 d0                	add    %edx,%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b37:	75 09                	jne    800b42 <find+0x35>
		{
			result = 1;
  800b39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b40:	eb 0b                	jmp    800b4d <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b42:	ff 45 f8             	incl   -0x8(%ebp)
  800b45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b4b:	7c d6                	jl     800b23 <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800b58:	e8 45 1b 00 00       	call   8026a2 <sys_getenvindex>
  800b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b63:	89 d0                	mov    %edx,%eax
  800b65:	c1 e0 02             	shl    $0x2,%eax
  800b68:	01 d0                	add    %edx,%eax
  800b6a:	c1 e0 03             	shl    $0x3,%eax
  800b6d:	01 d0                	add    %edx,%eax
  800b6f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b76:	01 d0                	add    %edx,%eax
  800b78:	c1 e0 02             	shl    $0x2,%eax
  800b7b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b80:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b85:	a1 20 50 80 00       	mov    0x805020,%eax
  800b8a:	8a 40 20             	mov    0x20(%eax),%al
  800b8d:	84 c0                	test   %al,%al
  800b8f:	74 0d                	je     800b9e <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800b91:	a1 20 50 80 00       	mov    0x805020,%eax
  800b96:	83 c0 20             	add    $0x20,%eax
  800b99:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba2:	7e 0a                	jle    800bae <libmain+0x5c>
		binaryname = argv[0];
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	ff 75 08             	pushl  0x8(%ebp)
  800bb7:	e8 7c f4 ff ff       	call   800038 <_main>
  800bbc:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800bbf:	a1 00 50 80 00       	mov    0x805000,%eax
  800bc4:	85 c0                	test   %eax,%eax
  800bc6:	0f 84 9f 00 00 00    	je     800c6b <libmain+0x119>
	{
		sys_lock_cons();
  800bcc:	e8 55 18 00 00       	call   802426 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800bd1:	83 ec 0c             	sub    $0xc,%esp
  800bd4:	68 44 45 80 00       	push   $0x804544
  800bd9:	e8 76 03 00 00       	call   800f54 <cprintf>
  800bde:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800be1:	a1 20 50 80 00       	mov    0x805020,%eax
  800be6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800bec:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800bf7:	83 ec 04             	sub    $0x4,%esp
  800bfa:	52                   	push   %edx
  800bfb:	50                   	push   %eax
  800bfc:	68 6c 45 80 00       	push   $0x80456c
  800c01:	e8 4e 03 00 00       	call   800f54 <cprintf>
  800c06:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c09:	a1 20 50 80 00       	mov    0x805020,%eax
  800c0e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800c14:	a1 20 50 80 00       	mov    0x805020,%eax
  800c19:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800c1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c24:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800c2a:	51                   	push   %ecx
  800c2b:	52                   	push   %edx
  800c2c:	50                   	push   %eax
  800c2d:	68 94 45 80 00       	push   $0x804594
  800c32:	e8 1d 03 00 00       	call   800f54 <cprintf>
  800c37:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c3f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	50                   	push   %eax
  800c49:	68 ec 45 80 00       	push   $0x8045ec
  800c4e:	e8 01 03 00 00       	call   800f54 <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	68 44 45 80 00       	push   $0x804544
  800c5e:	e8 f1 02 00 00       	call   800f54 <cprintf>
  800c63:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800c66:	e8 d5 17 00 00       	call   802440 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800c6b:	e8 19 00 00 00       	call   800c89 <exit>
}
  800c70:	90                   	nop
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c79:	83 ec 0c             	sub    $0xc,%esp
  800c7c:	6a 00                	push   $0x0
  800c7e:	e8 eb 19 00 00       	call   80266e <sys_destroy_env>
  800c83:	83 c4 10             	add    $0x10,%esp
}
  800c86:	90                   	nop
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <exit>:

void
exit(void)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c8f:	e8 40 1a 00 00       	call   8026d4 <sys_exit_env>
}
  800c94:	90                   	nop
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c9d:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca0:	83 c0 04             	add    $0x4,%eax
  800ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ca6:	a1 60 50 98 00       	mov    0x985060,%eax
  800cab:	85 c0                	test   %eax,%eax
  800cad:	74 16                	je     800cc5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800caf:	a1 60 50 98 00       	mov    0x985060,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	50                   	push   %eax
  800cb8:	68 00 46 80 00       	push   $0x804600
  800cbd:	e8 92 02 00 00       	call   800f54 <cprintf>
  800cc2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cc5:	a1 04 50 80 00       	mov    0x805004,%eax
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	ff 75 08             	pushl  0x8(%ebp)
  800cd0:	50                   	push   %eax
  800cd1:	68 05 46 80 00       	push   $0x804605
  800cd6:	e8 79 02 00 00       	call   800f54 <cprintf>
  800cdb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	83 ec 08             	sub    $0x8,%esp
  800ce4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce7:	50                   	push   %eax
  800ce8:	e8 fc 01 00 00       	call   800ee9 <vcprintf>
  800ced:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	6a 00                	push   $0x0
  800cf5:	68 21 46 80 00       	push   $0x804621
  800cfa:	e8 ea 01 00 00       	call   800ee9 <vcprintf>
  800cff:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d02:	e8 82 ff ff ff       	call   800c89 <exit>

	// should not return here
	while (1) ;
  800d07:	eb fe                	jmp    800d07 <_panic+0x70>

00800d09 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d14:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	39 c2                	cmp    %eax,%edx
  800d1f:	74 14                	je     800d35 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d21:	83 ec 04             	sub    $0x4,%esp
  800d24:	68 24 46 80 00       	push   $0x804624
  800d29:	6a 26                	push   $0x26
  800d2b:	68 70 46 80 00       	push   $0x804670
  800d30:	e8 62 ff ff ff       	call   800c97 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d3c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d43:	e9 c5 00 00 00       	jmp    800e0d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	01 d0                	add    %edx,%eax
  800d57:	8b 00                	mov    (%eax),%eax
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	75 08                	jne    800d65 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800d5d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d60:	e9 a5 00 00 00       	jmp    800e0a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800d65:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d6c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d73:	eb 69                	jmp    800dde <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d75:	a1 20 50 80 00       	mov    0x805020,%eax
  800d7a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800d80:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d83:	89 d0                	mov    %edx,%eax
  800d85:	01 c0                	add    %eax,%eax
  800d87:	01 d0                	add    %edx,%eax
  800d89:	c1 e0 03             	shl    $0x3,%eax
  800d8c:	01 c8                	add    %ecx,%eax
  800d8e:	8a 40 04             	mov    0x4(%eax),%al
  800d91:	84 c0                	test   %al,%al
  800d93:	75 46                	jne    800ddb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d95:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800da0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800da3:	89 d0                	mov    %edx,%eax
  800da5:	01 c0                	add    %eax,%eax
  800da7:	01 d0                	add    %edx,%eax
  800da9:	c1 e0 03             	shl    $0x3,%eax
  800dac:	01 c8                	add    %ecx,%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800db3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800db6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dbb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	01 c8                	add    %ecx,%eax
  800dcc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dce:	39 c2                	cmp    %eax,%edx
  800dd0:	75 09                	jne    800ddb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800dd2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dd9:	eb 15                	jmp    800df0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ddb:	ff 45 e8             	incl   -0x18(%ebp)
  800dde:	a1 20 50 80 00       	mov    0x805020,%eax
  800de3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dec:	39 c2                	cmp    %eax,%edx
  800dee:	77 85                	ja     800d75 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800df0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800df4:	75 14                	jne    800e0a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800df6:	83 ec 04             	sub    $0x4,%esp
  800df9:	68 7c 46 80 00       	push   $0x80467c
  800dfe:	6a 3a                	push   $0x3a
  800e00:	68 70 46 80 00       	push   $0x804670
  800e05:	e8 8d fe ff ff       	call   800c97 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e0a:	ff 45 f0             	incl   -0x10(%ebp)
  800e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e13:	0f 8c 2f ff ff ff    	jl     800d48 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e27:	eb 26                	jmp    800e4f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e29:	a1 20 50 80 00       	mov    0x805020,%eax
  800e2e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800e34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e37:	89 d0                	mov    %edx,%eax
  800e39:	01 c0                	add    %eax,%eax
  800e3b:	01 d0                	add    %edx,%eax
  800e3d:	c1 e0 03             	shl    $0x3,%eax
  800e40:	01 c8                	add    %ecx,%eax
  800e42:	8a 40 04             	mov    0x4(%eax),%al
  800e45:	3c 01                	cmp    $0x1,%al
  800e47:	75 03                	jne    800e4c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800e49:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e4c:	ff 45 e0             	incl   -0x20(%ebp)
  800e4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800e54:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800e5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5d:	39 c2                	cmp    %eax,%edx
  800e5f:	77 c8                	ja     800e29 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e67:	74 14                	je     800e7d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	68 d0 46 80 00       	push   $0x8046d0
  800e71:	6a 44                	push   $0x44
  800e73:	68 70 46 80 00       	push   $0x804670
  800e78:	e8 1a fe ff ff       	call   800c97 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e7d:	90                   	nop
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	8d 48 01             	lea    0x1(%eax),%ecx
  800e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e91:	89 0a                	mov    %ecx,(%edx)
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	88 d1                	mov    %dl,%cl
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	8b 00                	mov    (%eax),%eax
  800ea4:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ea9:	75 2c                	jne    800ed7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eab:	a0 44 50 98 00       	mov    0x985044,%al
  800eb0:	0f b6 c0             	movzbl %al,%eax
  800eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb6:	8b 12                	mov    (%edx),%edx
  800eb8:	89 d1                	mov    %edx,%ecx
  800eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebd:	83 c2 08             	add    $0x8,%edx
  800ec0:	83 ec 04             	sub    $0x4,%esp
  800ec3:	50                   	push   %eax
  800ec4:	51                   	push   %ecx
  800ec5:	52                   	push   %edx
  800ec6:	e8 19 15 00 00       	call   8023e4 <sys_cputs>
  800ecb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	8b 40 04             	mov    0x4(%eax),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ee6:	90                   	nop
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ef2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ef9:	00 00 00 
	b.cnt = 0;
  800efc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f03:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f06:	ff 75 0c             	pushl  0xc(%ebp)
  800f09:	ff 75 08             	pushl  0x8(%ebp)
  800f0c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f12:	50                   	push   %eax
  800f13:	68 80 0e 80 00       	push   $0x800e80
  800f18:	e8 11 02 00 00       	call   80112e <vprintfmt>
  800f1d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f20:	a0 44 50 98 00       	mov    0x985044,%al
  800f25:	0f b6 c0             	movzbl %al,%eax
  800f28:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f2e:	83 ec 04             	sub    $0x4,%esp
  800f31:	50                   	push   %eax
  800f32:	52                   	push   %edx
  800f33:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f39:	83 c0 08             	add    $0x8,%eax
  800f3c:	50                   	push   %eax
  800f3d:	e8 a2 14 00 00       	call   8023e4 <sys_cputs>
  800f42:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f45:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800f4c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    

00800f54 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f5a:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800f61:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	83 ec 08             	sub    $0x8,%esp
  800f6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f70:	50                   	push   %eax
  800f71:	e8 73 ff ff ff       	call   800ee9 <vcprintf>
  800f76:	83 c4 10             	add    $0x10,%esp
  800f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800f87:	e8 9a 14 00 00       	call   802426 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800f8c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	83 ec 08             	sub    $0x8,%esp
  800f98:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9b:	50                   	push   %eax
  800f9c:	e8 48 ff ff ff       	call   800ee9 <vcprintf>
  800fa1:	83 c4 10             	add    $0x10,%esp
  800fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800fa7:	e8 94 14 00 00       	call   802440 <sys_unlock_cons>
	return cnt;
  800fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	53                   	push   %ebx
  800fb5:	83 ec 14             	sub    $0x14,%esp
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fc4:	8b 45 18             	mov    0x18(%ebp),%eax
  800fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fcf:	77 55                	ja     801026 <printnum+0x75>
  800fd1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd4:	72 05                	jb     800fdb <printnum+0x2a>
  800fd6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fd9:	77 4b                	ja     801026 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fdb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fde:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fe1:	8b 45 18             	mov    0x18(%ebp),%eax
  800fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe9:	52                   	push   %edx
  800fea:	50                   	push   %eax
  800feb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fee:	ff 75 f0             	pushl  -0x10(%ebp)
  800ff1:	e8 46 2f 00 00       	call   803f3c <__udivdi3>
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	83 ec 04             	sub    $0x4,%esp
  800ffc:	ff 75 20             	pushl  0x20(%ebp)
  800fff:	53                   	push   %ebx
  801000:	ff 75 18             	pushl  0x18(%ebp)
  801003:	52                   	push   %edx
  801004:	50                   	push   %eax
  801005:	ff 75 0c             	pushl  0xc(%ebp)
  801008:	ff 75 08             	pushl  0x8(%ebp)
  80100b:	e8 a1 ff ff ff       	call   800fb1 <printnum>
  801010:	83 c4 20             	add    $0x20,%esp
  801013:	eb 1a                	jmp    80102f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801015:	83 ec 08             	sub    $0x8,%esp
  801018:	ff 75 0c             	pushl  0xc(%ebp)
  80101b:	ff 75 20             	pushl  0x20(%ebp)
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801026:	ff 4d 1c             	decl   0x1c(%ebp)
  801029:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80102d:	7f e6                	jg     801015 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80102f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801032:	bb 00 00 00 00       	mov    $0x0,%ebx
  801037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103d:	53                   	push   %ebx
  80103e:	51                   	push   %ecx
  80103f:	52                   	push   %edx
  801040:	50                   	push   %eax
  801041:	e8 06 30 00 00       	call   80404c <__umoddi3>
  801046:	83 c4 10             	add    $0x10,%esp
  801049:	05 34 49 80 00       	add    $0x804934,%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be c0             	movsbl %al,%eax
  801053:	83 ec 08             	sub    $0x8,%esp
  801056:	ff 75 0c             	pushl  0xc(%ebp)
  801059:	50                   	push   %eax
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	ff d0                	call   *%eax
  80105f:	83 c4 10             	add    $0x10,%esp
}
  801062:	90                   	nop
  801063:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80106b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80106f:	7e 1c                	jle    80108d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8b 00                	mov    (%eax),%eax
  801076:	8d 50 08             	lea    0x8(%eax),%edx
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 10                	mov    %edx,(%eax)
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8b 00                	mov    (%eax),%eax
  801083:	83 e8 08             	sub    $0x8,%eax
  801086:	8b 50 04             	mov    0x4(%eax),%edx
  801089:	8b 00                	mov    (%eax),%eax
  80108b:	eb 40                	jmp    8010cd <getuint+0x65>
	else if (lflag)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 1e                	je     8010b1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8b 00                	mov    (%eax),%eax
  801098:	8d 50 04             	lea    0x4(%eax),%edx
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 10                	mov    %edx,(%eax)
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8b 00                	mov    (%eax),%eax
  8010a5:	83 e8 04             	sub    $0x4,%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8010af:	eb 1c                	jmp    8010cd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8b 00                	mov    (%eax),%eax
  8010b6:	8d 50 04             	lea    0x4(%eax),%edx
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 10                	mov    %edx,(%eax)
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8b 00                	mov    (%eax),%eax
  8010c3:	83 e8 04             	sub    $0x4,%eax
  8010c6:	8b 00                	mov    (%eax),%eax
  8010c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    

008010cf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010d6:	7e 1c                	jle    8010f4 <getint+0x25>
		return va_arg(*ap, long long);
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8b 00                	mov    (%eax),%eax
  8010dd:	8d 50 08             	lea    0x8(%eax),%edx
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 10                	mov    %edx,(%eax)
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8b 00                	mov    (%eax),%eax
  8010ea:	83 e8 08             	sub    $0x8,%eax
  8010ed:	8b 50 04             	mov    0x4(%eax),%edx
  8010f0:	8b 00                	mov    (%eax),%eax
  8010f2:	eb 38                	jmp    80112c <getint+0x5d>
	else if (lflag)
  8010f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f8:	74 1a                	je     801114 <getint+0x45>
		return va_arg(*ap, long);
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8b 00                	mov    (%eax),%eax
  8010ff:	8d 50 04             	lea    0x4(%eax),%edx
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	89 10                	mov    %edx,(%eax)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8b 00                	mov    (%eax),%eax
  80110c:	83 e8 04             	sub    $0x4,%eax
  80110f:	8b 00                	mov    (%eax),%eax
  801111:	99                   	cltd   
  801112:	eb 18                	jmp    80112c <getint+0x5d>
	else
		return va_arg(*ap, int);
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8b 00                	mov    (%eax),%eax
  801119:	8d 50 04             	lea    0x4(%eax),%edx
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	89 10                	mov    %edx,(%eax)
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8b 00                	mov    (%eax),%eax
  801126:	83 e8 04             	sub    $0x4,%eax
  801129:	8b 00                	mov    (%eax),%eax
  80112b:	99                   	cltd   
}
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	56                   	push   %esi
  801132:	53                   	push   %ebx
  801133:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	eb 17                	jmp    80114f <vprintfmt+0x21>
			if (ch == '\0')
  801138:	85 db                	test   %ebx,%ebx
  80113a:	0f 84 c1 03 00 00    	je     801501 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	53                   	push   %ebx
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	ff d0                	call   *%eax
  80114c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	8d 50 01             	lea    0x1(%eax),%edx
  801155:	89 55 10             	mov    %edx,0x10(%ebp)
  801158:	8a 00                	mov    (%eax),%al
  80115a:	0f b6 d8             	movzbl %al,%ebx
  80115d:	83 fb 25             	cmp    $0x25,%ebx
  801160:	75 d6                	jne    801138 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801162:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801166:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80116d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801174:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80117b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	8d 50 01             	lea    0x1(%eax),%edx
  801188:	89 55 10             	mov    %edx,0x10(%ebp)
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f b6 d8             	movzbl %al,%ebx
  801190:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801193:	83 f8 5b             	cmp    $0x5b,%eax
  801196:	0f 87 3d 03 00 00    	ja     8014d9 <vprintfmt+0x3ab>
  80119c:	8b 04 85 58 49 80 00 	mov    0x804958(,%eax,4),%eax
  8011a3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011a5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011a9:	eb d7                	jmp    801182 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011ab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011af:	eb d1                	jmp    801182 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011bb:	89 d0                	mov    %edx,%eax
  8011bd:	c1 e0 02             	shl    $0x2,%eax
  8011c0:	01 d0                	add    %edx,%eax
  8011c2:	01 c0                	add    %eax,%eax
  8011c4:	01 d8                	add    %ebx,%eax
  8011c6:	83 e8 30             	sub    $0x30,%eax
  8011c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011d4:	83 fb 2f             	cmp    $0x2f,%ebx
  8011d7:	7e 3e                	jle    801217 <vprintfmt+0xe9>
  8011d9:	83 fb 39             	cmp    $0x39,%ebx
  8011dc:	7f 39                	jg     801217 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011de:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011e1:	eb d5                	jmp    8011b8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e6:	83 c0 04             	add    $0x4,%eax
  8011e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	83 e8 04             	sub    $0x4,%eax
  8011f2:	8b 00                	mov    (%eax),%eax
  8011f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011f7:	eb 1f                	jmp    801218 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011fd:	79 83                	jns    801182 <vprintfmt+0x54>
				width = 0;
  8011ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801206:	e9 77 ff ff ff       	jmp    801182 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80120b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801212:	e9 6b ff ff ff       	jmp    801182 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801217:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801218:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80121c:	0f 89 60 ff ff ff    	jns    801182 <vprintfmt+0x54>
				width = precision, precision = -1;
  801222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801225:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801228:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80122f:	e9 4e ff ff ff       	jmp    801182 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801234:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801237:	e9 46 ff ff ff       	jmp    801182 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	83 c0 04             	add    $0x4,%eax
  801242:	89 45 14             	mov    %eax,0x14(%ebp)
  801245:	8b 45 14             	mov    0x14(%ebp),%eax
  801248:	83 e8 04             	sub    $0x4,%eax
  80124b:	8b 00                	mov    (%eax),%eax
  80124d:	83 ec 08             	sub    $0x8,%esp
  801250:	ff 75 0c             	pushl  0xc(%ebp)
  801253:	50                   	push   %eax
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	ff d0                	call   *%eax
  801259:	83 c4 10             	add    $0x10,%esp
			break;
  80125c:	e9 9b 02 00 00       	jmp    8014fc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801261:	8b 45 14             	mov    0x14(%ebp),%eax
  801264:	83 c0 04             	add    $0x4,%eax
  801267:	89 45 14             	mov    %eax,0x14(%ebp)
  80126a:	8b 45 14             	mov    0x14(%ebp),%eax
  80126d:	83 e8 04             	sub    $0x4,%eax
  801270:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801272:	85 db                	test   %ebx,%ebx
  801274:	79 02                	jns    801278 <vprintfmt+0x14a>
				err = -err;
  801276:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801278:	83 fb 64             	cmp    $0x64,%ebx
  80127b:	7f 0b                	jg     801288 <vprintfmt+0x15a>
  80127d:	8b 34 9d a0 47 80 00 	mov    0x8047a0(,%ebx,4),%esi
  801284:	85 f6                	test   %esi,%esi
  801286:	75 19                	jne    8012a1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801288:	53                   	push   %ebx
  801289:	68 45 49 80 00       	push   $0x804945
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 70 02 00 00       	call   801509 <printfmt>
  801299:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80129c:	e9 5b 02 00 00       	jmp    8014fc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012a1:	56                   	push   %esi
  8012a2:	68 4e 49 80 00       	push   $0x80494e
  8012a7:	ff 75 0c             	pushl  0xc(%ebp)
  8012aa:	ff 75 08             	pushl  0x8(%ebp)
  8012ad:	e8 57 02 00 00       	call   801509 <printfmt>
  8012b2:	83 c4 10             	add    $0x10,%esp
			break;
  8012b5:	e9 42 02 00 00       	jmp    8014fc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bd:	83 c0 04             	add    $0x4,%eax
  8012c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8012c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c6:	83 e8 04             	sub    $0x4,%eax
  8012c9:	8b 30                	mov    (%eax),%esi
  8012cb:	85 f6                	test   %esi,%esi
  8012cd:	75 05                	jne    8012d4 <vprintfmt+0x1a6>
				p = "(null)";
  8012cf:	be 51 49 80 00       	mov    $0x804951,%esi
			if (width > 0 && padc != '-')
  8012d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012d8:	7e 6d                	jle    801347 <vprintfmt+0x219>
  8012da:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012de:	74 67                	je     801347 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e3:	83 ec 08             	sub    $0x8,%esp
  8012e6:	50                   	push   %eax
  8012e7:	56                   	push   %esi
  8012e8:	e8 1e 03 00 00       	call   80160b <strnlen>
  8012ed:	83 c4 10             	add    $0x10,%esp
  8012f0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012f3:	eb 16                	jmp    80130b <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012f5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012f9:	83 ec 08             	sub    $0x8,%esp
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	50                   	push   %eax
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	ff d0                	call   *%eax
  801305:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801308:	ff 4d e4             	decl   -0x1c(%ebp)
  80130b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80130f:	7f e4                	jg     8012f5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801311:	eb 34                	jmp    801347 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801313:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801317:	74 1c                	je     801335 <vprintfmt+0x207>
  801319:	83 fb 1f             	cmp    $0x1f,%ebx
  80131c:	7e 05                	jle    801323 <vprintfmt+0x1f5>
  80131e:	83 fb 7e             	cmp    $0x7e,%ebx
  801321:	7e 12                	jle    801335 <vprintfmt+0x207>
					putch('?', putdat);
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	ff 75 0c             	pushl  0xc(%ebp)
  801329:	6a 3f                	push   $0x3f
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	ff d0                	call   *%eax
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	eb 0f                	jmp    801344 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	53                   	push   %ebx
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	ff d0                	call   *%eax
  801341:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801344:	ff 4d e4             	decl   -0x1c(%ebp)
  801347:	89 f0                	mov    %esi,%eax
  801349:	8d 70 01             	lea    0x1(%eax),%esi
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	0f be d8             	movsbl %al,%ebx
  801351:	85 db                	test   %ebx,%ebx
  801353:	74 24                	je     801379 <vprintfmt+0x24b>
  801355:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801359:	78 b8                	js     801313 <vprintfmt+0x1e5>
  80135b:	ff 4d e0             	decl   -0x20(%ebp)
  80135e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801362:	79 af                	jns    801313 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801364:	eb 13                	jmp    801379 <vprintfmt+0x24b>
				putch(' ', putdat);
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	ff 75 0c             	pushl  0xc(%ebp)
  80136c:	6a 20                	push   $0x20
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	ff d0                	call   *%eax
  801373:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801376:	ff 4d e4             	decl   -0x1c(%ebp)
  801379:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80137d:	7f e7                	jg     801366 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80137f:	e9 78 01 00 00       	jmp    8014fc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 e8             	pushl  -0x18(%ebp)
  80138a:	8d 45 14             	lea    0x14(%ebp),%eax
  80138d:	50                   	push   %eax
  80138e:	e8 3c fd ff ff       	call   8010cf <getint>
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801399:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80139c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a2:	85 d2                	test   %edx,%edx
  8013a4:	79 23                	jns    8013c9 <vprintfmt+0x29b>
				putch('-', putdat);
  8013a6:	83 ec 08             	sub    $0x8,%esp
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	6a 2d                	push   $0x2d
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	ff d0                	call   *%eax
  8013b3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bc:	f7 d8                	neg    %eax
  8013be:	83 d2 00             	adc    $0x0,%edx
  8013c1:	f7 da                	neg    %edx
  8013c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013c9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013d0:	e9 bc 00 00 00       	jmp    801491 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013d5:	83 ec 08             	sub    $0x8,%esp
  8013d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8013db:	8d 45 14             	lea    0x14(%ebp),%eax
  8013de:	50                   	push   %eax
  8013df:	e8 84 fc ff ff       	call   801068 <getuint>
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013f4:	e9 98 00 00 00       	jmp    801491 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	ff 75 0c             	pushl  0xc(%ebp)
  8013ff:	6a 58                	push   $0x58
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	ff d0                	call   *%eax
  801406:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	ff 75 0c             	pushl  0xc(%ebp)
  80140f:	6a 58                	push   $0x58
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	ff d0                	call   *%eax
  801416:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	ff 75 0c             	pushl  0xc(%ebp)
  80141f:	6a 58                	push   $0x58
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	ff d0                	call   *%eax
  801426:	83 c4 10             	add    $0x10,%esp
			break;
  801429:	e9 ce 00 00 00       	jmp    8014fc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	6a 30                	push   $0x30
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	ff 75 0c             	pushl  0xc(%ebp)
  801444:	6a 78                	push   $0x78
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	ff d0                	call   *%eax
  80144b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	83 c0 04             	add    $0x4,%eax
  801454:	89 45 14             	mov    %eax,0x14(%ebp)
  801457:	8b 45 14             	mov    0x14(%ebp),%eax
  80145a:	83 e8 04             	sub    $0x4,%eax
  80145d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80145f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801469:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801470:	eb 1f                	jmp    801491 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	ff 75 e8             	pushl  -0x18(%ebp)
  801478:	8d 45 14             	lea    0x14(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	e8 e7 fb ff ff       	call   801068 <getuint>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801487:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80148a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801491:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801498:	83 ec 04             	sub    $0x4,%esp
  80149b:	52                   	push   %edx
  80149c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80149f:	50                   	push   %eax
  8014a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	ff 75 08             	pushl  0x8(%ebp)
  8014ac:	e8 00 fb ff ff       	call   800fb1 <printnum>
  8014b1:	83 c4 20             	add    $0x20,%esp
			break;
  8014b4:	eb 46                	jmp    8014fc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	53                   	push   %ebx
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	ff d0                	call   *%eax
  8014c2:	83 c4 10             	add    $0x10,%esp
			break;
  8014c5:	eb 35                	jmp    8014fc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8014c7:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  8014ce:	eb 2c                	jmp    8014fc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8014d0:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  8014d7:	eb 23                	jmp    8014fc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d9:	83 ec 08             	sub    $0x8,%esp
  8014dc:	ff 75 0c             	pushl  0xc(%ebp)
  8014df:	6a 25                	push   $0x25
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	ff d0                	call   *%eax
  8014e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e9:	ff 4d 10             	decl   0x10(%ebp)
  8014ec:	eb 03                	jmp    8014f1 <vprintfmt+0x3c3>
  8014ee:	ff 4d 10             	decl   0x10(%ebp)
  8014f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f4:	48                   	dec    %eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	3c 25                	cmp    $0x25,%al
  8014f9:	75 f3                	jne    8014ee <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8014fb:	90                   	nop
		}
	}
  8014fc:	e9 35 fc ff ff       	jmp    801136 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801501:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801502:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801505:	5b                   	pop    %ebx
  801506:	5e                   	pop    %esi
  801507:	5d                   	pop    %ebp
  801508:	c3                   	ret    

00801509 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80150f:	8d 45 10             	lea    0x10(%ebp),%eax
  801512:	83 c0 04             	add    $0x4,%eax
  801515:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801518:	8b 45 10             	mov    0x10(%ebp),%eax
  80151b:	ff 75 f4             	pushl  -0xc(%ebp)
  80151e:	50                   	push   %eax
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	ff 75 08             	pushl  0x8(%ebp)
  801525:	e8 04 fc ff ff       	call   80112e <vprintfmt>
  80152a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80152d:	90                   	nop
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	8b 40 08             	mov    0x8(%eax),%eax
  801539:	8d 50 01             	lea    0x1(%eax),%edx
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801542:	8b 45 0c             	mov    0xc(%ebp),%eax
  801545:	8b 10                	mov    (%eax),%edx
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8b 40 04             	mov    0x4(%eax),%eax
  80154d:	39 c2                	cmp    %eax,%edx
  80154f:	73 12                	jae    801563 <sprintputch+0x33>
		*b->buf++ = ch;
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8b 00                	mov    (%eax),%eax
  801556:	8d 48 01             	lea    0x1(%eax),%ecx
  801559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155c:	89 0a                	mov    %ecx,(%edx)
  80155e:	8b 55 08             	mov    0x8(%ebp),%edx
  801561:	88 10                	mov    %dl,(%eax)
}
  801563:	90                   	nop
  801564:	5d                   	pop    %ebp
  801565:	c3                   	ret    

00801566 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	8d 50 ff             	lea    -0x1(%eax),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	01 d0                	add    %edx,%eax
  80157d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801587:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158b:	74 06                	je     801593 <vsnprintf+0x2d>
  80158d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801591:	7f 07                	jg     80159a <vsnprintf+0x34>
		return -E_INVAL;
  801593:	b8 03 00 00 00       	mov    $0x3,%eax
  801598:	eb 20                	jmp    8015ba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80159a:	ff 75 14             	pushl  0x14(%ebp)
  80159d:	ff 75 10             	pushl  0x10(%ebp)
  8015a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	68 30 15 80 00       	push   $0x801530
  8015a9:	e8 80 fb ff ff       	call   80112e <vprintfmt>
  8015ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8015c5:	83 c0 04             	add    $0x4,%eax
  8015c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d1:	50                   	push   %eax
  8015d2:	ff 75 0c             	pushl  0xc(%ebp)
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	e8 89 ff ff ff       	call   801566 <vsnprintf>
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f5:	eb 06                	jmp    8015fd <strlen+0x15>
		n++;
  8015f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015fa:	ff 45 08             	incl   0x8(%ebp)
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	84 c0                	test   %al,%al
  801604:	75 f1                	jne    8015f7 <strlen+0xf>
		n++;
	return n;
  801606:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801611:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801618:	eb 09                	jmp    801623 <strnlen+0x18>
		n++;
  80161a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80161d:	ff 45 08             	incl   0x8(%ebp)
  801620:	ff 4d 0c             	decl   0xc(%ebp)
  801623:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801627:	74 09                	je     801632 <strnlen+0x27>
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	84 c0                	test   %al,%al
  801630:	75 e8                	jne    80161a <strnlen+0xf>
		n++;
	return n;
  801632:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801643:	90                   	nop
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	8d 50 01             	lea    0x1(%eax),%edx
  80164a:	89 55 08             	mov    %edx,0x8(%ebp)
  80164d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801650:	8d 4a 01             	lea    0x1(%edx),%ecx
  801653:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801656:	8a 12                	mov    (%edx),%dl
  801658:	88 10                	mov    %dl,(%eax)
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	84 c0                	test   %al,%al
  80165e:	75 e4                	jne    801644 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801660:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801671:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801678:	eb 1f                	jmp    801699 <strncpy+0x34>
		*dst++ = *src;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8d 50 01             	lea    0x1(%eax),%edx
  801680:	89 55 08             	mov    %edx,0x8(%ebp)
  801683:	8b 55 0c             	mov    0xc(%ebp),%edx
  801686:	8a 12                	mov    (%edx),%dl
  801688:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80168a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168d:	8a 00                	mov    (%eax),%al
  80168f:	84 c0                	test   %al,%al
  801691:	74 03                	je     801696 <strncpy+0x31>
			src++;
  801693:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801696:	ff 45 fc             	incl   -0x4(%ebp)
  801699:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80169f:	72 d9                	jb     80167a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8016a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b6:	74 30                	je     8016e8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b8:	eb 16                	jmp    8016d0 <strlcpy+0x2a>
			*dst++ = *src++;
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016d0:	ff 4d 10             	decl   0x10(%ebp)
  8016d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d7:	74 09                	je     8016e2 <strlcpy+0x3c>
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	84 c0                	test   %al,%al
  8016e0:	75 d8                	jne    8016ba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ee:	29 c2                	sub    %eax,%edx
  8016f0:	89 d0                	mov    %edx,%eax
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016f7:	eb 06                	jmp    8016ff <strcmp+0xb>
		p++, q++;
  8016f9:	ff 45 08             	incl   0x8(%ebp)
  8016fc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8a 00                	mov    (%eax),%al
  801704:	84 c0                	test   %al,%al
  801706:	74 0e                	je     801716 <strcmp+0x22>
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	8a 10                	mov    (%eax),%dl
  80170d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	38 c2                	cmp    %al,%dl
  801714:	74 e3                	je     8016f9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 d0             	movzbl %al,%edx
  80171e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	0f b6 c0             	movzbl %al,%eax
  801726:	29 c2                	sub    %eax,%edx
  801728:	89 d0                	mov    %edx,%eax
}
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80172f:	eb 09                	jmp    80173a <strncmp+0xe>
		n--, p++, q++;
  801731:	ff 4d 10             	decl   0x10(%ebp)
  801734:	ff 45 08             	incl   0x8(%ebp)
  801737:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80173a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173e:	74 17                	je     801757 <strncmp+0x2b>
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	8a 00                	mov    (%eax),%al
  801745:	84 c0                	test   %al,%al
  801747:	74 0e                	je     801757 <strncmp+0x2b>
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 10                	mov    (%eax),%dl
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	38 c2                	cmp    %al,%dl
  801755:	74 da                	je     801731 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801757:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80175b:	75 07                	jne    801764 <strncmp+0x38>
		return 0;
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
  801762:	eb 14                	jmp    801778 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f b6 d0             	movzbl %al,%edx
  80176c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176f:	8a 00                	mov    (%eax),%al
  801771:	0f b6 c0             	movzbl %al,%eax
  801774:	29 c2                	sub    %eax,%edx
  801776:	89 d0                	mov    %edx,%eax
}
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    

0080177a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801786:	eb 12                	jmp    80179a <strchr+0x20>
		if (*s == c)
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801790:	75 05                	jne    801797 <strchr+0x1d>
			return (char *) s;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	eb 11                	jmp    8017a8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	84 c0                	test   %al,%al
  8017a1:	75 e5                	jne    801788 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017b6:	eb 0d                	jmp    8017c5 <strfind+0x1b>
		if (*s == c)
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017c0:	74 0e                	je     8017d0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017c2:	ff 45 08             	incl   0x8(%ebp)
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8a 00                	mov    (%eax),%al
  8017ca:	84 c0                	test   %al,%al
  8017cc:	75 ea                	jne    8017b8 <strfind+0xe>
  8017ce:	eb 01                	jmp    8017d1 <strfind+0x27>
		if (*s == c)
			break;
  8017d0:	90                   	nop
	return (char *) s;
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e8:	eb 0e                	jmp    8017f8 <memset+0x22>
		*p++ = c;
  8017ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017ed:	8d 50 01             	lea    0x1(%eax),%edx
  8017f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f8:	ff 4d f8             	decl   -0x8(%ebp)
  8017fb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017ff:	79 e9                	jns    8017ea <memset+0x14>
		*p++ = c;

	return v;
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80180c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801818:	eb 16                	jmp    801830 <memcpy+0x2a>
		*d++ = *s++;
  80181a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80181d:	8d 50 01             	lea    0x1(%eax),%edx
  801820:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801823:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801826:	8d 4a 01             	lea    0x1(%edx),%ecx
  801829:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80182c:	8a 12                	mov    (%edx),%dl
  80182e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801830:	8b 45 10             	mov    0x10(%ebp),%eax
  801833:	8d 50 ff             	lea    -0x1(%eax),%edx
  801836:	89 55 10             	mov    %edx,0x10(%ebp)
  801839:	85 c0                	test   %eax,%eax
  80183b:	75 dd                	jne    80181a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801854:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801857:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185a:	73 50                	jae    8018ac <memmove+0x6a>
  80185c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80185f:	8b 45 10             	mov    0x10(%ebp),%eax
  801862:	01 d0                	add    %edx,%eax
  801864:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801867:	76 43                	jbe    8018ac <memmove+0x6a>
		s += n;
  801869:	8b 45 10             	mov    0x10(%ebp),%eax
  80186c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80186f:	8b 45 10             	mov    0x10(%ebp),%eax
  801872:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801875:	eb 10                	jmp    801887 <memmove+0x45>
			*--d = *--s;
  801877:	ff 4d f8             	decl   -0x8(%ebp)
  80187a:	ff 4d fc             	decl   -0x4(%ebp)
  80187d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801880:	8a 10                	mov    (%eax),%dl
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801887:	8b 45 10             	mov    0x10(%ebp),%eax
  80188a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80188d:	89 55 10             	mov    %edx,0x10(%ebp)
  801890:	85 c0                	test   %eax,%eax
  801892:	75 e3                	jne    801877 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801894:	eb 23                	jmp    8018b9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801896:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801899:	8d 50 01             	lea    0x1(%eax),%edx
  80189c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80189f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018a5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a8:	8a 12                	mov    (%edx),%dl
  8018aa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8018af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	75 dd                	jne    801896 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018d0:	eb 2a                	jmp    8018fc <memcmp+0x3e>
		if (*s1 != *s2)
  8018d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d5:	8a 10                	mov    (%eax),%dl
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	8a 00                	mov    (%eax),%al
  8018dc:	38 c2                	cmp    %al,%dl
  8018de:	74 16                	je     8018f6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f b6 d0             	movzbl %al,%edx
  8018e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	0f b6 c0             	movzbl %al,%eax
  8018f0:	29 c2                	sub    %eax,%edx
  8018f2:	89 d0                	mov    %edx,%eax
  8018f4:	eb 18                	jmp    80190e <memcmp+0x50>
		s1++, s2++;
  8018f6:	ff 45 fc             	incl   -0x4(%ebp)
  8018f9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801902:	89 55 10             	mov    %edx,0x10(%ebp)
  801905:	85 c0                	test   %eax,%eax
  801907:	75 c9                	jne    8018d2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801909:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801916:	8b 55 08             	mov    0x8(%ebp),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801921:	eb 15                	jmp    801938 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	0f b6 d0             	movzbl %al,%edx
  80192b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192e:	0f b6 c0             	movzbl %al,%eax
  801931:	39 c2                	cmp    %eax,%edx
  801933:	74 0d                	je     801942 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801935:	ff 45 08             	incl   0x8(%ebp)
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80193e:	72 e3                	jb     801923 <memfind+0x13>
  801940:	eb 01                	jmp    801943 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801942:	90                   	nop
	return (void *) s;
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80194e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801955:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80195c:	eb 03                	jmp    801961 <strtol+0x19>
		s++;
  80195e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	8a 00                	mov    (%eax),%al
  801966:	3c 20                	cmp    $0x20,%al
  801968:	74 f4                	je     80195e <strtol+0x16>
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	8a 00                	mov    (%eax),%al
  80196f:	3c 09                	cmp    $0x9,%al
  801971:	74 eb                	je     80195e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	8a 00                	mov    (%eax),%al
  801978:	3c 2b                	cmp    $0x2b,%al
  80197a:	75 05                	jne    801981 <strtol+0x39>
		s++;
  80197c:	ff 45 08             	incl   0x8(%ebp)
  80197f:	eb 13                	jmp    801994 <strtol+0x4c>
	else if (*s == '-')
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	3c 2d                	cmp    $0x2d,%al
  801988:	75 0a                	jne    801994 <strtol+0x4c>
		s++, neg = 1;
  80198a:	ff 45 08             	incl   0x8(%ebp)
  80198d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801994:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801998:	74 06                	je     8019a0 <strtol+0x58>
  80199a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80199e:	75 20                	jne    8019c0 <strtol+0x78>
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8a 00                	mov    (%eax),%al
  8019a5:	3c 30                	cmp    $0x30,%al
  8019a7:	75 17                	jne    8019c0 <strtol+0x78>
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	40                   	inc    %eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	3c 78                	cmp    $0x78,%al
  8019b1:	75 0d                	jne    8019c0 <strtol+0x78>
		s += 2, base = 16;
  8019b3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019b7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019be:	eb 28                	jmp    8019e8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c4:	75 15                	jne    8019db <strtol+0x93>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 30                	cmp    $0x30,%al
  8019cd:	75 0c                	jne    8019db <strtol+0x93>
		s++, base = 8;
  8019cf:	ff 45 08             	incl   0x8(%ebp)
  8019d2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d9:	eb 0d                	jmp    8019e8 <strtol+0xa0>
	else if (base == 0)
  8019db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019df:	75 07                	jne    8019e8 <strtol+0xa0>
		base = 10;
  8019e1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 2f                	cmp    $0x2f,%al
  8019ef:	7e 19                	jle    801a0a <strtol+0xc2>
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	3c 39                	cmp    $0x39,%al
  8019f8:	7f 10                	jg     801a0a <strtol+0xc2>
			dig = *s - '0';
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8a 00                	mov    (%eax),%al
  8019ff:	0f be c0             	movsbl %al,%eax
  801a02:	83 e8 30             	sub    $0x30,%eax
  801a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a08:	eb 42                	jmp    801a4c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 60                	cmp    $0x60,%al
  801a11:	7e 19                	jle    801a2c <strtol+0xe4>
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	3c 7a                	cmp    $0x7a,%al
  801a1a:	7f 10                	jg     801a2c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	8a 00                	mov    (%eax),%al
  801a21:	0f be c0             	movsbl %al,%eax
  801a24:	83 e8 57             	sub    $0x57,%eax
  801a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a2a:	eb 20                	jmp    801a4c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	8a 00                	mov    (%eax),%al
  801a31:	3c 40                	cmp    $0x40,%al
  801a33:	7e 39                	jle    801a6e <strtol+0x126>
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	8a 00                	mov    (%eax),%al
  801a3a:	3c 5a                	cmp    $0x5a,%al
  801a3c:	7f 30                	jg     801a6e <strtol+0x126>
			dig = *s - 'A' + 10;
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	0f be c0             	movsbl %al,%eax
  801a46:	83 e8 37             	sub    $0x37,%eax
  801a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a52:	7d 19                	jge    801a6d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a54:	ff 45 08             	incl   0x8(%ebp)
  801a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a5e:	89 c2                	mov    %eax,%edx
  801a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a63:	01 d0                	add    %edx,%eax
  801a65:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a68:	e9 7b ff ff ff       	jmp    8019e8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a6d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a72:	74 08                	je     801a7c <strtol+0x134>
		*endptr = (char *) s;
  801a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a77:	8b 55 08             	mov    0x8(%ebp),%edx
  801a7a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a80:	74 07                	je     801a89 <strtol+0x141>
  801a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a85:	f7 d8                	neg    %eax
  801a87:	eb 03                	jmp    801a8c <strtol+0x144>
  801a89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <ltostr>:

void
ltostr(long value, char *str)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801aa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aa6:	79 13                	jns    801abb <ltostr+0x2d>
	{
		neg = 1;
  801aa8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801ab5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801ac3:	99                   	cltd   
  801ac4:	f7 f9                	idiv   %ecx
  801ac6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801acc:	8d 50 01             	lea    0x1(%eax),%edx
  801acf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ad2:	89 c2                	mov    %eax,%edx
  801ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad7:	01 d0                	add    %edx,%eax
  801ad9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801adc:	83 c2 30             	add    $0x30,%edx
  801adf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ae1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae9:	f7 e9                	imul   %ecx
  801aeb:	c1 fa 02             	sar    $0x2,%edx
  801aee:	89 c8                	mov    %ecx,%eax
  801af0:	c1 f8 1f             	sar    $0x1f,%eax
  801af3:	29 c2                	sub    %eax,%edx
  801af5:	89 d0                	mov    %edx,%eax
  801af7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801afa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801afe:	75 bb                	jne    801abb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0a:	48                   	dec    %eax
  801b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b12:	74 3d                	je     801b51 <ltostr+0xc3>
		start = 1 ;
  801b14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b1b:	eb 34                	jmp    801b51 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
  801b25:	8a 00                	mov    (%eax),%al
  801b27:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b30:	01 c2                	add    %eax,%edx
  801b32:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c8                	add    %ecx,%eax
  801b3a:	8a 00                	mov    (%eax),%al
  801b3c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	01 c2                	add    %eax,%edx
  801b46:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b49:	88 02                	mov    %al,(%edx)
		start++ ;
  801b4b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b4e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b57:	7c c4                	jl     801b1d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b59:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5f:	01 d0                	add    %edx,%eax
  801b61:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	e8 73 fa ff ff       	call   8015e8 <strlen>
  801b75:	83 c4 04             	add    $0x4,%esp
  801b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	e8 65 fa ff ff       	call   8015e8 <strlen>
  801b83:	83 c4 04             	add    $0x4,%esp
  801b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b97:	eb 17                	jmp    801bb0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9f:	01 c2                	add    %eax,%edx
  801ba1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	01 c8                	add    %ecx,%eax
  801ba9:	8a 00                	mov    (%eax),%al
  801bab:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bad:	ff 45 fc             	incl   -0x4(%ebp)
  801bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bb3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bb6:	7c e1                	jl     801b99 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bbf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bc6:	eb 1f                	jmp    801be7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bcb:	8d 50 01             	lea    0x1(%eax),%edx
  801bce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bd1:	89 c2                	mov    %eax,%edx
  801bd3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd6:	01 c2                	add    %eax,%edx
  801bd8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bde:	01 c8                	add    %ecx,%eax
  801be0:	8a 00                	mov    (%eax),%al
  801be2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801be4:	ff 45 f8             	incl   -0x8(%ebp)
  801be7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bed:	7c d9                	jl     801bc8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801bef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bf2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf5:	01 d0                	add    %edx,%eax
  801bf7:	c6 00 00             	movb   $0x0,(%eax)
}
  801bfa:	90                   	nop
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c00:	8b 45 14             	mov    0x14(%ebp),%eax
  801c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c15:	8b 45 10             	mov    0x10(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c20:	eb 0c                	jmp    801c2e <strsplit+0x31>
			*string++ = 0;
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8d 50 01             	lea    0x1(%eax),%edx
  801c28:	89 55 08             	mov    %edx,0x8(%ebp)
  801c2b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	8a 00                	mov    (%eax),%al
  801c33:	84 c0                	test   %al,%al
  801c35:	74 18                	je     801c4f <strsplit+0x52>
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	0f be c0             	movsbl %al,%eax
  801c3f:	50                   	push   %eax
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	e8 32 fb ff ff       	call   80177a <strchr>
  801c48:	83 c4 08             	add    $0x8,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	75 d3                	jne    801c22 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	84 c0                	test   %al,%al
  801c56:	74 5a                	je     801cb2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c58:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5b:	8b 00                	mov    (%eax),%eax
  801c5d:	83 f8 0f             	cmp    $0xf,%eax
  801c60:	75 07                	jne    801c69 <strsplit+0x6c>
		{
			return 0;
  801c62:	b8 00 00 00 00       	mov    $0x0,%eax
  801c67:	eb 66                	jmp    801ccf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c69:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	8d 48 01             	lea    0x1(%eax),%ecx
  801c71:	8b 55 14             	mov    0x14(%ebp),%edx
  801c74:	89 0a                	mov    %ecx,(%edx)
  801c76:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c80:	01 c2                	add    %eax,%edx
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c87:	eb 03                	jmp    801c8c <strsplit+0x8f>
			string++;
  801c89:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	8a 00                	mov    (%eax),%al
  801c91:	84 c0                	test   %al,%al
  801c93:	74 8b                	je     801c20 <strsplit+0x23>
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	8a 00                	mov    (%eax),%al
  801c9a:	0f be c0             	movsbl %al,%eax
  801c9d:	50                   	push   %eax
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	e8 d4 fa ff ff       	call   80177a <strchr>
  801ca6:	83 c4 08             	add    $0x8,%esp
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	74 dc                	je     801c89 <strsplit+0x8c>
			string++;
	}
  801cad:	e9 6e ff ff ff       	jmp    801c20 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cb2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb6:	8b 00                	mov    (%eax),%eax
  801cb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc2:	01 d0                	add    %edx,%eax
  801cc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cca:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	68 c8 4a 80 00       	push   $0x804ac8
  801cdf:	68 3f 01 00 00       	push   $0x13f
  801ce4:	68 ea 4a 80 00       	push   $0x804aea
  801ce9:	e8 a9 ef ff ff       	call   800c97 <_panic>

00801cee <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801cf4:	83 ec 0c             	sub    $0xc,%esp
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	e8 90 0c 00 00       	call   80298f <sys_sbrk>
  801cff:	83 c4 10             	add    $0x10,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801d0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d0e:	75 0a                	jne    801d1a <malloc+0x16>
		return NULL;
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
  801d15:	e9 9e 01 00 00       	jmp    801eb8 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801d1a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d21:	77 2c                	ja     801d4f <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801d23:	e8 eb 0a 00 00       	call   802813 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	74 19                	je     801d45 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	e8 85 11 00 00       	call   802ebc <alloc_block_FF>
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d40:	e9 73 01 00 00       	jmp    801eb8 <malloc+0x1b4>
		} else {
			return NULL;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4a:	e9 69 01 00 00       	jmp    801eb8 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801d4f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801d56:	8b 55 08             	mov    0x8(%ebp),%edx
  801d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d5c:	01 d0                	add    %edx,%eax
  801d5e:	48                   	dec    %eax
  801d5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d65:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6a:	f7 75 e0             	divl   -0x20(%ebp)
  801d6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d70:	29 d0                	sub    %edx,%eax
  801d72:	c1 e8 0c             	shr    $0xc,%eax
  801d75:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801d78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801d7f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801d86:	a1 20 50 80 00       	mov    0x805020,%eax
  801d8b:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d8e:	05 00 10 00 00       	add    $0x1000,%eax
  801d93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801d96:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801d9b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d9e:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801da1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801da8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801dae:	01 d0                	add    %edx,%eax
  801db0:	48                   	dec    %eax
  801db1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801db4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801db7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbc:	f7 75 cc             	divl   -0x34(%ebp)
  801dbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dc2:	29 d0                	sub    %edx,%eax
  801dc4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801dc7:	76 0a                	jbe    801dd3 <malloc+0xcf>
		return NULL;
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	e9 e5 00 00 00       	jmp    801eb8 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801dd3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dd9:	eb 48                	jmp    801e23 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dde:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801de1:	c1 e8 0c             	shr    $0xc,%eax
  801de4:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801de7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801dea:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801df1:	85 c0                	test   %eax,%eax
  801df3:	75 11                	jne    801e06 <malloc+0x102>
			freePagesCount++;
  801df5:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801df8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801dfc:	75 16                	jne    801e14 <malloc+0x110>
				start = i;
  801dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e04:	eb 0e                	jmp    801e14 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801e06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801e0d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801e1a:	74 12                	je     801e2e <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801e1c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801e23:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801e2a:	76 af                	jbe    801ddb <malloc+0xd7>
  801e2c:	eb 01                	jmp    801e2f <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801e2e:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801e2f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e33:	74 08                	je     801e3d <malloc+0x139>
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801e3b:	74 07                	je     801e44 <malloc+0x140>
		return NULL;
  801e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e42:	eb 74                	jmp    801eb8 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e47:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e4a:	c1 e8 0c             	shr    $0xc,%eax
  801e4d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801e50:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e56:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801e5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e60:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e63:	eb 11                	jmp    801e76 <malloc+0x172>
		markedPages[i] = 1;
  801e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e68:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801e6f:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801e73:	ff 45 e8             	incl   -0x18(%ebp)
  801e76:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801e79:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e7c:	01 d0                	add    %edx,%eax
  801e7e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e81:	77 e2                	ja     801e65 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801e83:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e90:	01 d0                	add    %edx,%eax
  801e92:	48                   	dec    %eax
  801e93:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e96:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e99:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9e:	f7 75 bc             	divl   -0x44(%ebp)
  801ea1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ea4:	29 d0                	sub    %edx,%eax
  801ea6:	83 ec 08             	sub    $0x8,%esp
  801ea9:	50                   	push   %eax
  801eaa:	ff 75 f0             	pushl  -0x10(%ebp)
  801ead:	e8 14 0b 00 00       	call   8029c6 <sys_allocate_user_mem>
  801eb2:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801ec0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ec4:	0f 84 ee 00 00 00    	je     801fb8 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801eca:	a1 20 50 80 00       	mov    0x805020,%eax
  801ecf:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801ed2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ed5:	77 09                	ja     801ee0 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801ed7:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801ede:	76 14                	jbe    801ef4 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	68 f8 4a 80 00       	push   $0x804af8
  801ee8:	6a 68                	push   $0x68
  801eea:	68 12 4b 80 00       	push   $0x804b12
  801eef:	e8 a3 ed ff ff       	call   800c97 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801ef4:	a1 20 50 80 00       	mov    0x805020,%eax
  801ef9:	8b 40 74             	mov    0x74(%eax),%eax
  801efc:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eff:	77 20                	ja     801f21 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801f01:	a1 20 50 80 00       	mov    0x805020,%eax
  801f06:	8b 40 78             	mov    0x78(%eax),%eax
  801f09:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f0c:	76 13                	jbe    801f21 <free+0x67>
		free_block(virtual_address);
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	ff 75 08             	pushl  0x8(%ebp)
  801f14:	e8 6c 16 00 00       	call   803585 <free_block>
  801f19:	83 c4 10             	add    $0x10,%esp
		return;
  801f1c:	e9 98 00 00 00       	jmp    801fb9 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801f21:	8b 55 08             	mov    0x8(%ebp),%edx
  801f24:	a1 20 50 80 00       	mov    0x805020,%eax
  801f29:	8b 40 7c             	mov    0x7c(%eax),%eax
  801f2c:	29 c2                	sub    %eax,%edx
  801f2e:	89 d0                	mov    %edx,%eax
  801f30:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801f35:	c1 e8 0c             	shr    $0xc,%eax
  801f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801f3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f42:	eb 16                	jmp    801f5a <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801f44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4a:	01 d0                	add    %edx,%eax
  801f4c:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801f53:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801f57:	ff 45 f4             	incl   -0xc(%ebp)
  801f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5d:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801f64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f67:	7f db                	jg     801f44 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6c:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801f73:	c1 e0 0c             	shl    $0xc,%eax
  801f76:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f7f:	eb 1a                	jmp    801f9b <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801f81:	83 ec 08             	sub    $0x8,%esp
  801f84:	68 00 10 00 00       	push   $0x1000
  801f89:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8c:	e8 19 0a 00 00       	call   8029aa <sys_free_user_mem>
  801f91:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801f94:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa1:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801fa3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801fa6:	77 d9                	ja     801f81 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fab:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801fb2:	00 00 00 00 
  801fb6:	eb 01                	jmp    801fb9 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801fb8:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 58             	sub    $0x58,%esp
  801fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc4:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801fc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fcb:	75 0a                	jne    801fd7 <smalloc+0x1c>
		return NULL;
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	e9 7d 01 00 00       	jmp    802154 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801fd7:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801fde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fe4:	01 d0                	add    %edx,%eax
  801fe6:	48                   	dec    %eax
  801fe7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fed:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff2:	f7 75 e4             	divl   -0x1c(%ebp)
  801ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff8:	29 d0                	sub    %edx,%eax
  801ffa:	c1 e8 0c             	shr    $0xc,%eax
  801ffd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  802000:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802007:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80200e:	a1 20 50 80 00       	mov    0x805020,%eax
  802013:	8b 40 7c             	mov    0x7c(%eax),%eax
  802016:	05 00 10 00 00       	add    $0x1000,%eax
  80201b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80201e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802023:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802026:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802029:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802030:	8b 55 0c             	mov    0xc(%ebp),%edx
  802033:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802036:	01 d0                	add    %edx,%eax
  802038:	48                   	dec    %eax
  802039:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80203c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80203f:	ba 00 00 00 00       	mov    $0x0,%edx
  802044:	f7 75 d0             	divl   -0x30(%ebp)
  802047:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80204a:	29 d0                	sub    %edx,%eax
  80204c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80204f:	76 0a                	jbe    80205b <smalloc+0xa0>
		return NULL;
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
  802056:	e9 f9 00 00 00       	jmp    802154 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80205b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80205e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802061:	eb 48                	jmp    8020ab <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  802063:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802066:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802069:	c1 e8 0c             	shr    $0xc,%eax
  80206c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  80206f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802072:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  802079:	85 c0                	test   %eax,%eax
  80207b:	75 11                	jne    80208e <smalloc+0xd3>
			freePagesCount++;
  80207d:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802080:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802084:	75 16                	jne    80209c <smalloc+0xe1>
				start = s;
  802086:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80208c:	eb 0e                	jmp    80209c <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80208e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802095:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8020a2:	74 12                	je     8020b6 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8020a4:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8020ab:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8020b2:	76 af                	jbe    802063 <smalloc+0xa8>
  8020b4:	eb 01                	jmp    8020b7 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8020b6:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8020b7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020bb:	74 08                	je     8020c5 <smalloc+0x10a>
  8020bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8020c3:	74 0a                	je     8020cf <smalloc+0x114>
		return NULL;
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ca:	e9 85 00 00 00       	jmp    802154 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8020cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8020d5:	c1 e8 0c             	shr    $0xc,%eax
  8020d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8020db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8020de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020e1:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8020e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020ee:	eb 11                	jmp    802101 <smalloc+0x146>
		markedPages[s] = 1;
  8020f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f3:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8020fa:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8020fe:	ff 45 e8             	incl   -0x18(%ebp)
  802101:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802104:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802107:	01 d0                	add    %edx,%eax
  802109:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80210c:	77 e2                	ja     8020f0 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  80210e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802111:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  802115:	52                   	push   %edx
  802116:	50                   	push   %eax
  802117:	ff 75 0c             	pushl  0xc(%ebp)
  80211a:	ff 75 08             	pushl  0x8(%ebp)
  80211d:	e8 8f 04 00 00       	call   8025b1 <sys_createSharedObject>
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  802128:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80212c:	78 12                	js     802140 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  80212e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802131:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802134:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  80213b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213e:	eb 14                	jmp    802154 <smalloc+0x199>
	}
	free((void*) start);
  802140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802143:	83 ec 0c             	sub    $0xc,%esp
  802146:	50                   	push   %eax
  802147:	e8 6e fd ff ff       	call   801eba <free>
  80214c:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80215c:	83 ec 08             	sub    $0x8,%esp
  80215f:	ff 75 0c             	pushl  0xc(%ebp)
  802162:	ff 75 08             	pushl  0x8(%ebp)
  802165:	e8 71 04 00 00       	call   8025db <sys_getSizeOfSharedObject>
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802170:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802177:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80217a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80217d:	01 d0                	add    %edx,%eax
  80217f:	48                   	dec    %eax
  802180:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802183:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802186:	ba 00 00 00 00       	mov    $0x0,%edx
  80218b:	f7 75 e0             	divl   -0x20(%ebp)
  80218e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802191:	29 d0                	sub    %edx,%eax
  802193:	c1 e8 0c             	shr    $0xc,%eax
  802196:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  802199:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8021a0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  8021a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8021ac:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021af:	05 00 10 00 00       	add    $0x1000,%eax
  8021b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8021b7:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8021bc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8021bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8021c2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8021c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021cf:	01 d0                	add    %edx,%eax
  8021d1:	48                   	dec    %eax
  8021d2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8021d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8021d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021dd:	f7 75 cc             	divl   -0x34(%ebp)
  8021e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8021e3:	29 d0                	sub    %edx,%eax
  8021e5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8021e8:	76 0a                	jbe    8021f4 <sget+0x9e>
		return NULL;
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ef:	e9 f7 00 00 00       	jmp    8022eb <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8021f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021fa:	eb 48                	jmp    802244 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8021fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ff:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802202:	c1 e8 0c             	shr    $0xc,%eax
  802205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  802208:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80220b:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  802212:	85 c0                	test   %eax,%eax
  802214:	75 11                	jne    802227 <sget+0xd1>
			free_Pages_Count++;
  802216:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802219:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80221d:	75 16                	jne    802235 <sget+0xdf>
				start = s;
  80221f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802222:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802225:	eb 0e                	jmp    802235 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80222e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80223b:	74 12                	je     80224f <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80223d:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802244:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80224b:	76 af                	jbe    8021fc <sget+0xa6>
  80224d:	eb 01                	jmp    802250 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80224f:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802250:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802254:	74 08                	je     80225e <sget+0x108>
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80225c:	74 0a                	je     802268 <sget+0x112>
		return NULL;
  80225e:	b8 00 00 00 00       	mov    $0x0,%eax
  802263:	e9 83 00 00 00       	jmp    8022eb <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80226e:	c1 e8 0c             	shr    $0xc,%eax
  802271:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802274:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802277:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80227a:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802281:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802284:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802287:	eb 11                	jmp    80229a <sget+0x144>
		markedPages[k] = 1;
  802289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80228c:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802293:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802297:	ff 45 e8             	incl   -0x18(%ebp)
  80229a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80229d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022a0:	01 d0                	add    %edx,%eax
  8022a2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8022a5:	77 e2                	ja     802289 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8022a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022aa:	83 ec 04             	sub    $0x4,%esp
  8022ad:	50                   	push   %eax
  8022ae:	ff 75 0c             	pushl  0xc(%ebp)
  8022b1:	ff 75 08             	pushl  0x8(%ebp)
  8022b4:	e8 3f 03 00 00       	call   8025f8 <sys_getSharedObject>
  8022b9:	83 c4 10             	add    $0x10,%esp
  8022bc:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8022bf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8022c3:	78 12                	js     8022d7 <sget+0x181>
		shardIDs[startPage] = ss;
  8022c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8022c8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8022cb:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8022d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d5:	eb 14                	jmp    8022eb <sget+0x195>
	}
	free((void*) start);
  8022d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022da:	83 ec 0c             	sub    $0xc,%esp
  8022dd:	50                   	push   %eax
  8022de:	e8 d7 fb ff ff       	call   801eba <free>
  8022e3:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8022f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8022fb:	8b 40 7c             	mov    0x7c(%eax),%eax
  8022fe:	29 c2                	sub    %eax,%edx
  802300:	89 d0                	mov    %edx,%eax
  802302:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  802307:	c1 e8 0c             	shr    $0xc,%eax
  80230a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  802317:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80231a:	83 ec 08             	sub    $0x8,%esp
  80231d:	ff 75 08             	pushl  0x8(%ebp)
  802320:	ff 75 f0             	pushl  -0x10(%ebp)
  802323:	e8 ef 02 00 00       	call   802617 <sys_freeSharedObject>
  802328:	83 c4 10             	add    $0x10,%esp
  80232b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80232e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802332:	75 0e                	jne    802342 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  80233e:	ff ff ff ff 
	}

}
  802342:	90                   	nop
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	68 20 4b 80 00       	push   $0x804b20
  802353:	68 19 01 00 00       	push   $0x119
  802358:	68 12 4b 80 00       	push   $0x804b12
  80235d:	e8 35 e9 ff ff       	call   800c97 <_panic>

00802362 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802368:	83 ec 04             	sub    $0x4,%esp
  80236b:	68 46 4b 80 00       	push   $0x804b46
  802370:	68 23 01 00 00       	push   $0x123
  802375:	68 12 4b 80 00       	push   $0x804b12
  80237a:	e8 18 e9 ff ff       	call   800c97 <_panic>

0080237f <shrink>:

}
void shrink(uint32 newSize) {
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802385:	83 ec 04             	sub    $0x4,%esp
  802388:	68 46 4b 80 00       	push   $0x804b46
  80238d:	68 27 01 00 00       	push   $0x127
  802392:	68 12 4b 80 00       	push   $0x804b12
  802397:	e8 fb e8 ff ff       	call   800c97 <_panic>

0080239c <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023a2:	83 ec 04             	sub    $0x4,%esp
  8023a5:	68 46 4b 80 00       	push   $0x804b46
  8023aa:	68 2b 01 00 00       	push   $0x12b
  8023af:	68 12 4b 80 00       	push   $0x804b12
  8023b4:	e8 de e8 ff ff       	call   800c97 <_panic>

008023b9 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	57                   	push   %edi
  8023bd:	56                   	push   %esi
  8023be:	53                   	push   %ebx
  8023bf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023ce:	8b 7d 18             	mov    0x18(%ebp),%edi
  8023d1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8023d4:	cd 30                	int    $0x30
  8023d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8023d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023dc:	83 c4 10             	add    $0x10,%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8023f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	52                   	push   %edx
  8023fc:	ff 75 0c             	pushl  0xc(%ebp)
  8023ff:	50                   	push   %eax
  802400:	6a 00                	push   $0x0
  802402:	e8 b2 ff ff ff       	call   8023b9 <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
}
  80240a:	90                   	nop
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_cgetc>:

int sys_cgetc(void) {
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 02                	push   $0x2
  80241c:	e8 98 ff ff ff       	call   8023b9 <syscall>
  802421:	83 c4 18             	add    $0x18,%esp
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <sys_lock_cons>:

void sys_lock_cons(void) {
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 03                	push   $0x3
  802435:	e8 7f ff ff ff       	call   8023b9 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	90                   	nop
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 04                	push   $0x4
  80244f:	e8 65 ff ff ff       	call   8023b9 <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	90                   	nop
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80245d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	52                   	push   %edx
  80246a:	50                   	push   %eax
  80246b:	6a 08                	push   $0x8
  80246d:	e8 47 ff ff ff       	call   8023b9 <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	56                   	push   %esi
  80247b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80247c:	8b 75 18             	mov    0x18(%ebp),%esi
  80247f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802482:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802485:	8b 55 0c             	mov    0xc(%ebp),%edx
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	56                   	push   %esi
  80248c:	53                   	push   %ebx
  80248d:	51                   	push   %ecx
  80248e:	52                   	push   %edx
  80248f:	50                   	push   %eax
  802490:	6a 09                	push   $0x9
  802492:	e8 22 ff ff ff       	call   8023b9 <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80249a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5e                   	pop    %esi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    

008024a1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	52                   	push   %edx
  8024b1:	50                   	push   %eax
  8024b2:	6a 0a                	push   $0xa
  8024b4:	e8 00 ff ff ff       	call   8023b9 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ca:	ff 75 08             	pushl  0x8(%ebp)
  8024cd:	6a 0b                	push   $0xb
  8024cf:	e8 e5 fe ff ff       	call   8023b9 <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 0c                	push   $0xc
  8024e8:	e8 cc fe ff ff       	call   8023b9 <syscall>
  8024ed:	83 c4 18             	add    $0x18,%esp
}
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 0d                	push   $0xd
  802501:	e8 b3 fe ff ff       	call   8023b9 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 0e                	push   $0xe
  80251a:	e8 9a fe ff ff       	call   8023b9 <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 0f                	push   $0xf
  802533:	e8 81 fe ff ff       	call   8023b9 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	ff 75 08             	pushl  0x8(%ebp)
  80254b:	6a 10                	push   $0x10
  80254d:	e8 67 fe ff ff       	call   8023b9 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <sys_scarce_memory>:

void sys_scarce_memory() {
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 11                	push   $0x11
  802566:	e8 4e fe ff ff       	call   8023b9 <syscall>
  80256b:	83 c4 18             	add    $0x18,%esp
}
  80256e:	90                   	nop
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <sys_cputc>:

void sys_cputc(const char c) {
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80257d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	50                   	push   %eax
  80258a:	6a 01                	push   $0x1
  80258c:	e8 28 fe ff ff       	call   8023b9 <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
}
  802594:	90                   	nop
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 14                	push   $0x14
  8025a6:	e8 0e fe ff ff       	call   8023b9 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
}
  8025ae:	90                   	nop
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8025bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025c0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	6a 00                	push   $0x0
  8025c9:	51                   	push   %ecx
  8025ca:	52                   	push   %edx
  8025cb:	ff 75 0c             	pushl  0xc(%ebp)
  8025ce:	50                   	push   %eax
  8025cf:	6a 15                	push   $0x15
  8025d1:	e8 e3 fd ff ff       	call   8023b9 <syscall>
  8025d6:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8025de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	52                   	push   %edx
  8025eb:	50                   	push   %eax
  8025ec:	6a 16                	push   $0x16
  8025ee:	e8 c6 fd ff ff       	call   8023b9 <syscall>
  8025f3:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8025fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	51                   	push   %ecx
  802609:	52                   	push   %edx
  80260a:	50                   	push   %eax
  80260b:	6a 17                	push   $0x17
  80260d:	e8 a7 fd ff ff       	call   8023b9 <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  80261a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	52                   	push   %edx
  802627:	50                   	push   %eax
  802628:	6a 18                	push   $0x18
  80262a:	e8 8a fd ff ff       	call   8023b9 <syscall>
  80262f:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  802632:	c9                   	leave  
  802633:	c3                   	ret    

00802634 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	6a 00                	push   $0x0
  80263c:	ff 75 14             	pushl  0x14(%ebp)
  80263f:	ff 75 10             	pushl  0x10(%ebp)
  802642:	ff 75 0c             	pushl  0xc(%ebp)
  802645:	50                   	push   %eax
  802646:	6a 19                	push   $0x19
  802648:	e8 6c fd ff ff       	call   8023b9 <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <sys_run_env>:

void sys_run_env(int32 envId) {
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	50                   	push   %eax
  802661:	6a 1a                	push   $0x1a
  802663:	e8 51 fd ff ff       	call   8023b9 <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
}
  80266b:	90                   	nop
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	50                   	push   %eax
  80267d:	6a 1b                	push   $0x1b
  80267f:	e8 35 fd ff ff       	call   8023b9 <syscall>
  802684:	83 c4 18             	add    $0x18,%esp
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_getenvid>:

int32 sys_getenvid(void) {
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 05                	push   $0x5
  802698:	e8 1c fd ff ff       	call   8023b9 <syscall>
  80269d:	83 c4 18             	add    $0x18,%esp
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 06                	push   $0x6
  8026b1:	e8 03 fd ff ff       	call   8023b9 <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 07                	push   $0x7
  8026ca:	e8 ea fc ff ff       	call   8023b9 <syscall>
  8026cf:	83 c4 18             	add    $0x18,%esp
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <sys_exit_env>:

void sys_exit_env(void) {
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 1c                	push   $0x1c
  8026e3:	e8 d1 fc ff ff       	call   8023b9 <syscall>
  8026e8:	83 c4 18             	add    $0x18,%esp
}
  8026eb:	90                   	nop
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8026f4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026f7:	8d 50 04             	lea    0x4(%eax),%edx
  8026fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	52                   	push   %edx
  802704:	50                   	push   %eax
  802705:	6a 1d                	push   $0x1d
  802707:	e8 ad fc ff ff       	call   8023b9 <syscall>
  80270c:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80270f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802712:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802715:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802718:	89 01                	mov    %eax,(%ecx)
  80271a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	c9                   	leave  
  802721:	c2 04 00             	ret    $0x4

00802724 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	ff 75 10             	pushl  0x10(%ebp)
  80272e:	ff 75 0c             	pushl  0xc(%ebp)
  802731:	ff 75 08             	pushl  0x8(%ebp)
  802734:	6a 13                	push   $0x13
  802736:	e8 7e fc ff ff       	call   8023b9 <syscall>
  80273b:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80273e:	90                   	nop
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_rcr2>:
uint32 sys_rcr2() {
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 1e                	push   $0x1e
  802750:	e8 64 fc ff ff       	call   8023b9 <syscall>
  802755:	83 c4 18             	add    $0x18,%esp
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    

0080275a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802766:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	50                   	push   %eax
  802773:	6a 1f                	push   $0x1f
  802775:	e8 3f fc ff ff       	call   8023b9 <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
	return;
  80277d:	90                   	nop
}
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <rsttst>:
void rsttst() {
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 21                	push   $0x21
  80278f:	e8 25 fc ff ff       	call   8023b9 <syscall>
  802794:	83 c4 18             	add    $0x18,%esp
	return;
  802797:	90                   	nop
}
  802798:	c9                   	leave  
  802799:	c3                   	ret    

0080279a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	83 ec 04             	sub    $0x4,%esp
  8027a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8027a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027a6:	8b 55 18             	mov    0x18(%ebp),%edx
  8027a9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027ad:	52                   	push   %edx
  8027ae:	50                   	push   %eax
  8027af:	ff 75 10             	pushl  0x10(%ebp)
  8027b2:	ff 75 0c             	pushl  0xc(%ebp)
  8027b5:	ff 75 08             	pushl  0x8(%ebp)
  8027b8:	6a 20                	push   $0x20
  8027ba:	e8 fa fb ff ff       	call   8023b9 <syscall>
  8027bf:	83 c4 18             	add    $0x18,%esp
	return;
  8027c2:	90                   	nop
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <chktst>:
void chktst(uint32 n) {
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	ff 75 08             	pushl  0x8(%ebp)
  8027d3:	6a 22                	push   $0x22
  8027d5:	e8 df fb ff ff       	call   8023b9 <syscall>
  8027da:	83 c4 18             	add    $0x18,%esp
	return;
  8027dd:	90                   	nop
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <inctst>:

void inctst() {
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 23                	push   $0x23
  8027ef:	e8 c5 fb ff ff       	call   8023b9 <syscall>
  8027f4:	83 c4 18             	add    $0x18,%esp
	return;
  8027f7:	90                   	nop
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <gettst>:
uint32 gettst() {
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 24                	push   $0x24
  802809:	e8 ab fb ff ff       	call   8023b9 <syscall>
  80280e:	83 c4 18             	add    $0x18,%esp
}
  802811:	c9                   	leave  
  802812:	c3                   	ret    

00802813 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802813:	55                   	push   %ebp
  802814:	89 e5                	mov    %esp,%ebp
  802816:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 25                	push   $0x25
  802825:	e8 8f fb ff ff       	call   8023b9 <syscall>
  80282a:	83 c4 18             	add    $0x18,%esp
  80282d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802830:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802834:	75 07                	jne    80283d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802836:	b8 01 00 00 00       	mov    $0x1,%eax
  80283b:	eb 05                	jmp    802842 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802842:	c9                   	leave  
  802843:	c3                   	ret    

00802844 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802844:	55                   	push   %ebp
  802845:	89 e5                	mov    %esp,%ebp
  802847:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80284a:	6a 00                	push   $0x0
  80284c:	6a 00                	push   $0x0
  80284e:	6a 00                	push   $0x0
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	6a 25                	push   $0x25
  802856:	e8 5e fb ff ff       	call   8023b9 <syscall>
  80285b:	83 c4 18             	add    $0x18,%esp
  80285e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802861:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802865:	75 07                	jne    80286e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802867:	b8 01 00 00 00       	mov    $0x1,%eax
  80286c:	eb 05                	jmp    802873 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80286e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 25                	push   $0x25
  802887:	e8 2d fb ff ff       	call   8023b9 <syscall>
  80288c:	83 c4 18             	add    $0x18,%esp
  80288f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802892:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802896:	75 07                	jne    80289f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802898:	b8 01 00 00 00       	mov    $0x1,%eax
  80289d:	eb 05                	jmp    8028a4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a4:	c9                   	leave  
  8028a5:	c3                   	ret    

008028a6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8028a6:	55                   	push   %ebp
  8028a7:	89 e5                	mov    %esp,%ebp
  8028a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 25                	push   $0x25
  8028b8:	e8 fc fa ff ff       	call   8023b9 <syscall>
  8028bd:	83 c4 18             	add    $0x18,%esp
  8028c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8028c3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028c7:	75 07                	jne    8028d0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8028c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ce:	eb 05                	jmp    8028d5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d5:	c9                   	leave  
  8028d6:	c3                   	ret    

008028d7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 00                	push   $0x0
  8028e0:	6a 00                	push   $0x0
  8028e2:	ff 75 08             	pushl  0x8(%ebp)
  8028e5:	6a 26                	push   $0x26
  8028e7:	e8 cd fa ff ff       	call   8023b9 <syscall>
  8028ec:	83 c4 18             	add    $0x18,%esp
	return;
  8028ef:	90                   	nop
}
  8028f0:	c9                   	leave  
  8028f1:	c3                   	ret    

008028f2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8028f2:	55                   	push   %ebp
  8028f3:	89 e5                	mov    %esp,%ebp
  8028f5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8028f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	6a 00                	push   $0x0
  802904:	53                   	push   %ebx
  802905:	51                   	push   %ecx
  802906:	52                   	push   %edx
  802907:	50                   	push   %eax
  802908:	6a 27                	push   $0x27
  80290a:	e8 aa fa ff ff       	call   8023b9 <syscall>
  80290f:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802915:	c9                   	leave  
  802916:	c3                   	ret    

00802917 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80291a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	52                   	push   %edx
  802927:	50                   	push   %eax
  802928:	6a 28                	push   $0x28
  80292a:	e8 8a fa ff ff       	call   8023b9 <syscall>
  80292f:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802937:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80293a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	6a 00                	push   $0x0
  802942:	51                   	push   %ecx
  802943:	ff 75 10             	pushl  0x10(%ebp)
  802946:	52                   	push   %edx
  802947:	50                   	push   %eax
  802948:	6a 29                	push   $0x29
  80294a:	e8 6a fa ff ff       	call   8023b9 <syscall>
  80294f:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	ff 75 10             	pushl  0x10(%ebp)
  80295e:	ff 75 0c             	pushl  0xc(%ebp)
  802961:	ff 75 08             	pushl  0x8(%ebp)
  802964:	6a 12                	push   $0x12
  802966:	e8 4e fa ff ff       	call   8023b9 <syscall>
  80296b:	83 c4 18             	add    $0x18,%esp
	return;
  80296e:	90                   	nop
}
  80296f:	c9                   	leave  
  802970:	c3                   	ret    

00802971 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802971:	55                   	push   %ebp
  802972:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802974:	8b 55 0c             	mov    0xc(%ebp),%edx
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	52                   	push   %edx
  802981:	50                   	push   %eax
  802982:	6a 2a                	push   $0x2a
  802984:	e8 30 fa ff ff       	call   8023b9 <syscall>
  802989:	83 c4 18             	add    $0x18,%esp
	return;
  80298c:	90                   	nop
}
  80298d:	c9                   	leave  
  80298e:	c3                   	ret    

0080298f <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80298f:	55                   	push   %ebp
  802990:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	50                   	push   %eax
  80299e:	6a 2b                	push   $0x2b
  8029a0:	e8 14 fa ff ff       	call   8023b9 <syscall>
  8029a5:	83 c4 18             	add    $0x18,%esp
}
  8029a8:	c9                   	leave  
  8029a9:	c3                   	ret    

008029aa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8029aa:	55                   	push   %ebp
  8029ab:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8029ad:	6a 00                	push   $0x0
  8029af:	6a 00                	push   $0x0
  8029b1:	6a 00                	push   $0x0
  8029b3:	ff 75 0c             	pushl  0xc(%ebp)
  8029b6:	ff 75 08             	pushl  0x8(%ebp)
  8029b9:	6a 2c                	push   $0x2c
  8029bb:	e8 f9 f9 ff ff       	call   8023b9 <syscall>
  8029c0:	83 c4 18             	add    $0x18,%esp
	return;
  8029c3:	90                   	nop
}
  8029c4:	c9                   	leave  
  8029c5:	c3                   	ret    

008029c6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8029c6:	55                   	push   %ebp
  8029c7:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	ff 75 0c             	pushl  0xc(%ebp)
  8029d2:	ff 75 08             	pushl  0x8(%ebp)
  8029d5:	6a 2d                	push   $0x2d
  8029d7:	e8 dd f9 ff ff       	call   8023b9 <syscall>
  8029dc:	83 c4 18             	add    $0x18,%esp
	return;
  8029df:	90                   	nop
}
  8029e0:	c9                   	leave  
  8029e1:	c3                   	ret    

008029e2 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8029e2:	55                   	push   %ebp
  8029e3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	50                   	push   %eax
  8029f1:	6a 2f                	push   $0x2f
  8029f3:	e8 c1 f9 ff ff       	call   8023b9 <syscall>
  8029f8:	83 c4 18             	add    $0x18,%esp
	return;
  8029fb:	90                   	nop
}
  8029fc:	c9                   	leave  
  8029fd:	c3                   	ret    

008029fe <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	6a 00                	push   $0x0
  802a09:	6a 00                	push   $0x0
  802a0b:	6a 00                	push   $0x0
  802a0d:	52                   	push   %edx
  802a0e:	50                   	push   %eax
  802a0f:	6a 30                	push   $0x30
  802a11:	e8 a3 f9 ff ff       	call   8023b9 <syscall>
  802a16:	83 c4 18             	add    $0x18,%esp
	return;
  802a19:	90                   	nop
}
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    

00802a1c <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	6a 00                	push   $0x0
  802a24:	6a 00                	push   $0x0
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	50                   	push   %eax
  802a2b:	6a 31                	push   $0x31
  802a2d:	e8 87 f9 ff ff       	call   8023b9 <syscall>
  802a32:	83 c4 18             	add    $0x18,%esp
	return;
  802a35:	90                   	nop
}
  802a36:	c9                   	leave  
  802a37:	c3                   	ret    

00802a38 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	52                   	push   %edx
  802a48:	50                   	push   %eax
  802a49:	6a 2e                	push   $0x2e
  802a4b:	e8 69 f9 ff ff       	call   8023b9 <syscall>
  802a50:	83 c4 18             	add    $0x18,%esp
    return;
  802a53:	90                   	nop
}
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	83 e8 04             	sub    $0x4,%eax
  802a62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802a6d:	c9                   	leave  
  802a6e:	c3                   	ret    

00802a6f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802a6f:	55                   	push   %ebp
  802a70:	89 e5                	mov    %esp,%ebp
  802a72:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	83 e8 04             	sub    $0x4,%eax
  802a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	83 e0 01             	and    $0x1,%eax
  802a86:	85 c0                	test   %eax,%eax
  802a88:	0f 94 c0             	sete   %al
}
  802a8b:	c9                   	leave  
  802a8c:	c3                   	ret    

00802a8d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
  802a90:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a9d:	83 f8 02             	cmp    $0x2,%eax
  802aa0:	74 2b                	je     802acd <alloc_block+0x40>
  802aa2:	83 f8 02             	cmp    $0x2,%eax
  802aa5:	7f 07                	jg     802aae <alloc_block+0x21>
  802aa7:	83 f8 01             	cmp    $0x1,%eax
  802aaa:	74 0e                	je     802aba <alloc_block+0x2d>
  802aac:	eb 58                	jmp    802b06 <alloc_block+0x79>
  802aae:	83 f8 03             	cmp    $0x3,%eax
  802ab1:	74 2d                	je     802ae0 <alloc_block+0x53>
  802ab3:	83 f8 04             	cmp    $0x4,%eax
  802ab6:	74 3b                	je     802af3 <alloc_block+0x66>
  802ab8:	eb 4c                	jmp    802b06 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802aba:	83 ec 0c             	sub    $0xc,%esp
  802abd:	ff 75 08             	pushl  0x8(%ebp)
  802ac0:	e8 f7 03 00 00       	call   802ebc <alloc_block_FF>
  802ac5:	83 c4 10             	add    $0x10,%esp
  802ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802acb:	eb 4a                	jmp    802b17 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802acd:	83 ec 0c             	sub    $0xc,%esp
  802ad0:	ff 75 08             	pushl  0x8(%ebp)
  802ad3:	e8 f0 11 00 00       	call   803cc8 <alloc_block_NF>
  802ad8:	83 c4 10             	add    $0x10,%esp
  802adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ade:	eb 37                	jmp    802b17 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802ae0:	83 ec 0c             	sub    $0xc,%esp
  802ae3:	ff 75 08             	pushl  0x8(%ebp)
  802ae6:	e8 08 08 00 00       	call   8032f3 <alloc_block_BF>
  802aeb:	83 c4 10             	add    $0x10,%esp
  802aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802af1:	eb 24                	jmp    802b17 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802af3:	83 ec 0c             	sub    $0xc,%esp
  802af6:	ff 75 08             	pushl  0x8(%ebp)
  802af9:	e8 ad 11 00 00       	call   803cab <alloc_block_WF>
  802afe:	83 c4 10             	add    $0x10,%esp
  802b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b04:	eb 11                	jmp    802b17 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802b06:	83 ec 0c             	sub    $0xc,%esp
  802b09:	68 58 4b 80 00       	push   $0x804b58
  802b0e:	e8 41 e4 ff ff       	call   800f54 <cprintf>
  802b13:	83 c4 10             	add    $0x10,%esp
		break;
  802b16:	90                   	nop
	}
	return va;
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802b1a:	c9                   	leave  
  802b1b:	c3                   	ret    

00802b1c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802b1c:	55                   	push   %ebp
  802b1d:	89 e5                	mov    %esp,%ebp
  802b1f:	53                   	push   %ebx
  802b20:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802b23:	83 ec 0c             	sub    $0xc,%esp
  802b26:	68 78 4b 80 00       	push   $0x804b78
  802b2b:	e8 24 e4 ff ff       	call   800f54 <cprintf>
  802b30:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802b33:	83 ec 0c             	sub    $0xc,%esp
  802b36:	68 a3 4b 80 00       	push   $0x804ba3
  802b3b:	e8 14 e4 ff ff       	call   800f54 <cprintf>
  802b40:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b49:	eb 37                	jmp    802b82 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802b4b:	83 ec 0c             	sub    $0xc,%esp
  802b4e:	ff 75 f4             	pushl  -0xc(%ebp)
  802b51:	e8 19 ff ff ff       	call   802a6f <is_free_block>
  802b56:	83 c4 10             	add    $0x10,%esp
  802b59:	0f be d8             	movsbl %al,%ebx
  802b5c:	83 ec 0c             	sub    $0xc,%esp
  802b5f:	ff 75 f4             	pushl  -0xc(%ebp)
  802b62:	e8 ef fe ff ff       	call   802a56 <get_block_size>
  802b67:	83 c4 10             	add    $0x10,%esp
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	53                   	push   %ebx
  802b6e:	50                   	push   %eax
  802b6f:	68 bb 4b 80 00       	push   $0x804bbb
  802b74:	e8 db e3 ff ff       	call   800f54 <cprintf>
  802b79:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  802b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b86:	74 07                	je     802b8f <print_blocks_list+0x73>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	eb 05                	jmp    802b94 <print_blocks_list+0x78>
  802b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b94:	89 45 10             	mov    %eax,0x10(%ebp)
  802b97:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	75 ad                	jne    802b4b <print_blocks_list+0x2f>
  802b9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba2:	75 a7                	jne    802b4b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802ba4:	83 ec 0c             	sub    $0xc,%esp
  802ba7:	68 78 4b 80 00       	push   $0x804b78
  802bac:	e8 a3 e3 ff ff       	call   800f54 <cprintf>
  802bb1:	83 c4 10             	add    $0x10,%esp

}
  802bb4:	90                   	nop
  802bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bb8:	c9                   	leave  
  802bb9:	c3                   	ret    

00802bba <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
  802bbd:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc3:	83 e0 01             	and    $0x1,%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 03                	je     802bcd <initialize_dynamic_allocator+0x13>
  802bca:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802bcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bd1:	0f 84 f8 00 00 00    	je     802ccf <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802bd7:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802bde:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802be1:	a1 40 50 98 00       	mov    0x985040,%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	0f 84 e2 00 00 00    	je     802cd0 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c03:	01 d0                	add    %edx,%eax
  802c05:	83 e8 04             	sub    $0x4,%eax
  802c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	83 c0 08             	add    $0x8,%eax
  802c1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c20:	83 e8 08             	sub    $0x8,%eax
  802c23:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802c26:	83 ec 04             	sub    $0x4,%esp
  802c29:	6a 00                	push   $0x0
  802c2b:	ff 75 e8             	pushl  -0x18(%ebp)
  802c2e:	ff 75 ec             	pushl  -0x14(%ebp)
  802c31:	e8 9c 00 00 00       	call   802cd2 <set_block_data>
  802c36:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802c4c:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802c53:	00 00 00 
  802c56:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802c5d:	00 00 00 
  802c60:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802c67:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802c6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c6e:	75 17                	jne    802c87 <initialize_dynamic_allocator+0xcd>
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	68 d4 4b 80 00       	push   $0x804bd4
  802c78:	68 80 00 00 00       	push   $0x80
  802c7d:	68 f7 4b 80 00       	push   $0x804bf7
  802c82:	e8 10 e0 ff ff       	call   800c97 <_panic>
  802c87:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	89 10                	mov    %edx,(%eax)
  802c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c95:	8b 00                	mov    (%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 0d                	je     802ca8 <initialize_dynamic_allocator+0xee>
  802c9b:	a1 48 50 98 00       	mov    0x985048,%eax
  802ca0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ca3:	89 50 04             	mov    %edx,0x4(%eax)
  802ca6:	eb 08                	jmp    802cb0 <initialize_dynamic_allocator+0xf6>
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb3:	a3 48 50 98 00       	mov    %eax,0x985048
  802cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc2:	a1 54 50 98 00       	mov    0x985054,%eax
  802cc7:	40                   	inc    %eax
  802cc8:	a3 54 50 98 00       	mov    %eax,0x985054
  802ccd:	eb 01                	jmp    802cd0 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802ccf:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802cd2:	55                   	push   %ebp
  802cd3:	89 e5                	mov    %esp,%ebp
  802cd5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdb:	83 e0 01             	and    $0x1,%eax
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	74 03                	je     802ce5 <set_block_data+0x13>
	{
		totalSize++;
  802ce2:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	83 e8 04             	sub    $0x4,%eax
  802ceb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf1:	83 e0 fe             	and    $0xfffffffe,%eax
  802cf4:	89 c2                	mov    %eax,%edx
  802cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  802cf9:	83 e0 01             	and    $0x1,%eax
  802cfc:	09 c2                	or     %eax,%edx
  802cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d01:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d06:	8d 50 f8             	lea    -0x8(%eax),%edx
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	01 d0                	add    %edx,%eax
  802d0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d14:	83 e0 fe             	and    $0xfffffffe,%eax
  802d17:	89 c2                	mov    %eax,%edx
  802d19:	8b 45 10             	mov    0x10(%ebp),%eax
  802d1c:	83 e0 01             	and    $0x1,%eax
  802d1f:	09 c2                	or     %eax,%edx
  802d21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802d24:	89 10                	mov    %edx,(%eax)
}
  802d26:	90                   	nop
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
  802d2c:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802d2f:	a1 48 50 98 00       	mov    0x985048,%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	75 68                	jne    802da0 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3c:	75 17                	jne    802d55 <insert_sorted_in_freeList+0x2c>
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 d4 4b 80 00       	push   $0x804bd4
  802d46:	68 9d 00 00 00       	push   $0x9d
  802d4b:	68 f7 4b 80 00       	push   $0x804bf7
  802d50:	e8 42 df ff ff       	call   800c97 <_panic>
  802d55:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	89 10                	mov    %edx,(%eax)
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	8b 00                	mov    (%eax),%eax
  802d65:	85 c0                	test   %eax,%eax
  802d67:	74 0d                	je     802d76 <insert_sorted_in_freeList+0x4d>
  802d69:	a1 48 50 98 00       	mov    0x985048,%eax
  802d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	eb 08                	jmp    802d7e <insert_sorted_in_freeList+0x55>
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	a3 48 50 98 00       	mov    %eax,0x985048
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d90:	a1 54 50 98 00       	mov    0x985054,%eax
  802d95:	40                   	inc    %eax
  802d96:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802d9b:	e9 1a 01 00 00       	jmp    802eba <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802da0:	a1 48 50 98 00       	mov    0x985048,%eax
  802da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da8:	eb 7f                	jmp    802e29 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db0:	76 6f                	jbe    802e21 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db6:	74 06                	je     802dbe <insert_sorted_in_freeList+0x95>
  802db8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbc:	75 17                	jne    802dd5 <insert_sorted_in_freeList+0xac>
  802dbe:	83 ec 04             	sub    $0x4,%esp
  802dc1:	68 10 4c 80 00       	push   $0x804c10
  802dc6:	68 a6 00 00 00       	push   $0xa6
  802dcb:	68 f7 4b 80 00       	push   $0x804bf7
  802dd0:	e8 c2 de ff ff       	call   800c97 <_panic>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 50 04             	mov    0x4(%eax),%edx
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	89 50 04             	mov    %edx,0x4(%eax)
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de7:	89 10                	mov    %edx,(%eax)
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	74 0d                	je     802e00 <insert_sorted_in_freeList+0xd7>
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 40 04             	mov    0x4(%eax),%eax
  802df9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	eb 08                	jmp    802e08 <insert_sorted_in_freeList+0xdf>
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	a3 48 50 98 00       	mov    %eax,0x985048
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0e:	89 50 04             	mov    %edx,0x4(%eax)
  802e11:	a1 54 50 98 00       	mov    0x985054,%eax
  802e16:	40                   	inc    %eax
  802e17:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802e1c:	e9 99 00 00 00       	jmp    802eba <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802e21:	a1 50 50 98 00       	mov    0x985050,%eax
  802e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2d:	74 07                	je     802e36 <insert_sorted_in_freeList+0x10d>
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	eb 05                	jmp    802e3b <insert_sorted_in_freeList+0x112>
  802e36:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3b:	a3 50 50 98 00       	mov    %eax,0x985050
  802e40:	a1 50 50 98 00       	mov    0x985050,%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	0f 85 5d ff ff ff    	jne    802daa <insert_sorted_in_freeList+0x81>
  802e4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e51:	0f 85 53 ff ff ff    	jne    802daa <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802e57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5b:	75 17                	jne    802e74 <insert_sorted_in_freeList+0x14b>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 48 4c 80 00       	push   $0x804c48
  802e65:	68 ab 00 00 00       	push   $0xab
  802e6a:	68 f7 4b 80 00       	push   $0x804bf7
  802e6f:	e8 23 de ff ff       	call   800c97 <_panic>
  802e74:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	89 50 04             	mov    %edx,0x4(%eax)
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	85 c0                	test   %eax,%eax
  802e88:	74 0c                	je     802e96 <insert_sorted_in_freeList+0x16d>
  802e8a:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	eb 08                	jmp    802e9e <insert_sorted_in_freeList+0x175>
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	a3 48 50 98 00       	mov    %eax,0x985048
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eaf:	a1 54 50 98 00       	mov    0x985054,%eax
  802eb4:	40                   	inc    %eax
  802eb5:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802eba:	c9                   	leave  
  802ebb:	c3                   	ret    

00802ebc <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802ebc:	55                   	push   %ebp
  802ebd:	89 e5                	mov    %esp,%ebp
  802ebf:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	83 e0 01             	and    $0x1,%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 03                	je     802ecf <alloc_block_FF+0x13>
  802ecc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ecf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ed3:	77 07                	ja     802edc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ed5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802edc:	a1 40 50 98 00       	mov    0x985040,%eax
  802ee1:	85 c0                	test   %eax,%eax
  802ee3:	75 63                	jne    802f48 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	83 c0 10             	add    $0x10,%eax
  802eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802eee:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ef5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	01 d0                	add    %edx,%eax
  802efd:	48                   	dec    %eax
  802efe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802f01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f04:	ba 00 00 00 00       	mov    $0x0,%edx
  802f09:	f7 75 ec             	divl   -0x14(%ebp)
  802f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0f:	29 d0                	sub    %edx,%eax
  802f11:	c1 e8 0c             	shr    $0xc,%eax
  802f14:	83 ec 0c             	sub    $0xc,%esp
  802f17:	50                   	push   %eax
  802f18:	e8 d1 ed ff ff       	call   801cee <sbrk>
  802f1d:	83 c4 10             	add    $0x10,%esp
  802f20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f23:	83 ec 0c             	sub    $0xc,%esp
  802f26:	6a 00                	push   $0x0
  802f28:	e8 c1 ed ff ff       	call   801cee <sbrk>
  802f2d:	83 c4 10             	add    $0x10,%esp
  802f30:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f36:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802f39:	83 ec 08             	sub    $0x8,%esp
  802f3c:	50                   	push   %eax
  802f3d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f40:	e8 75 fc ff ff       	call   802bba <initialize_dynamic_allocator>
  802f45:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802f48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4c:	75 0a                	jne    802f58 <alloc_block_FF+0x9c>
	{
		return NULL;
  802f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f53:	e9 99 03 00 00       	jmp    8032f1 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	83 c0 08             	add    $0x8,%eax
  802f5e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802f61:	a1 48 50 98 00       	mov    0x985048,%eax
  802f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f69:	e9 03 02 00 00       	jmp    803171 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802f6e:	83 ec 0c             	sub    $0xc,%esp
  802f71:	ff 75 f4             	pushl  -0xc(%ebp)
  802f74:	e8 dd fa ff ff       	call   802a56 <get_block_size>
  802f79:	83 c4 10             	add    $0x10,%esp
  802f7c:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802f7f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802f82:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802f85:	0f 82 de 01 00 00    	jb     803169 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802f8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8e:	83 c0 10             	add    $0x10,%eax
  802f91:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802f94:	0f 87 32 01 00 00    	ja     8030cc <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802f9a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802f9d:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802fa0:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802fa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa9:	01 d0                	add    %edx,%eax
  802fab:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	6a 00                	push   $0x0
  802fb3:	ff 75 98             	pushl  -0x68(%ebp)
  802fb6:	ff 75 94             	pushl  -0x6c(%ebp)
  802fb9:	e8 14 fd ff ff       	call   802cd2 <set_block_data>
  802fbe:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802fc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc5:	74 06                	je     802fcd <alloc_block_FF+0x111>
  802fc7:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802fcb:	75 17                	jne    802fe4 <alloc_block_FF+0x128>
  802fcd:	83 ec 04             	sub    $0x4,%esp
  802fd0:	68 6c 4c 80 00       	push   $0x804c6c
  802fd5:	68 de 00 00 00       	push   $0xde
  802fda:	68 f7 4b 80 00       	push   $0x804bf7
  802fdf:	e8 b3 dc ff ff       	call   800c97 <_panic>
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 10                	mov    (%eax),%edx
  802fe9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802fec:	89 10                	mov    %edx,(%eax)
  802fee:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ff1:	8b 00                	mov    (%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	74 0b                	je     803002 <alloc_block_FF+0x146>
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802fff:	89 50 04             	mov    %edx,0x4(%eax)
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 55 94             	mov    -0x6c(%ebp),%edx
  803008:	89 10                	mov    %edx,(%eax)
  80300a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80300d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803010:	89 50 04             	mov    %edx,0x4(%eax)
  803013:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	75 08                	jne    803024 <alloc_block_FF+0x168>
  80301c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80301f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803024:	a1 54 50 98 00       	mov    0x985054,%eax
  803029:	40                   	inc    %eax
  80302a:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  80302f:	83 ec 04             	sub    $0x4,%esp
  803032:	6a 01                	push   $0x1
  803034:	ff 75 dc             	pushl  -0x24(%ebp)
  803037:	ff 75 f4             	pushl  -0xc(%ebp)
  80303a:	e8 93 fc ff ff       	call   802cd2 <set_block_data>
  80303f:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803046:	75 17                	jne    80305f <alloc_block_FF+0x1a3>
  803048:	83 ec 04             	sub    $0x4,%esp
  80304b:	68 a0 4c 80 00       	push   $0x804ca0
  803050:	68 e3 00 00 00       	push   $0xe3
  803055:	68 f7 4b 80 00       	push   $0x804bf7
  80305a:	e8 38 dc ff ff       	call   800c97 <_panic>
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	74 10                	je     803078 <alloc_block_FF+0x1bc>
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803070:	8b 52 04             	mov    0x4(%edx),%edx
  803073:	89 50 04             	mov    %edx,0x4(%eax)
  803076:	eb 0b                	jmp    803083 <alloc_block_FF+0x1c7>
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	8b 40 04             	mov    0x4(%eax),%eax
  80307e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 40 04             	mov    0x4(%eax),%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	74 0f                	je     80309c <alloc_block_FF+0x1e0>
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	8b 40 04             	mov    0x4(%eax),%eax
  803093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803096:	8b 12                	mov    (%edx),%edx
  803098:	89 10                	mov    %edx,(%eax)
  80309a:	eb 0a                	jmp    8030a6 <alloc_block_FF+0x1ea>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	a3 48 50 98 00       	mov    %eax,0x985048
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b9:	a1 54 50 98 00       	mov    0x985054,%eax
  8030be:	48                   	dec    %eax
  8030bf:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	e9 25 02 00 00       	jmp    8032f1 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8030cc:	83 ec 04             	sub    $0x4,%esp
  8030cf:	6a 01                	push   $0x1
  8030d1:	ff 75 9c             	pushl  -0x64(%ebp)
  8030d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8030d7:	e8 f6 fb ff ff       	call   802cd2 <set_block_data>
  8030dc:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8030df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e3:	75 17                	jne    8030fc <alloc_block_FF+0x240>
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	68 a0 4c 80 00       	push   $0x804ca0
  8030ed:	68 eb 00 00 00       	push   $0xeb
  8030f2:	68 f7 4b 80 00       	push   $0x804bf7
  8030f7:	e8 9b db ff ff       	call   800c97 <_panic>
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	74 10                	je     803115 <alloc_block_FF+0x259>
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310d:	8b 52 04             	mov    0x4(%edx),%edx
  803110:	89 50 04             	mov    %edx,0x4(%eax)
  803113:	eb 0b                	jmp    803120 <alloc_block_FF+0x264>
  803115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803118:	8b 40 04             	mov    0x4(%eax),%eax
  80311b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	74 0f                	je     803139 <alloc_block_FF+0x27d>
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	8b 40 04             	mov    0x4(%eax),%eax
  803130:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803133:	8b 12                	mov    (%edx),%edx
  803135:	89 10                	mov    %edx,(%eax)
  803137:	eb 0a                	jmp    803143 <alloc_block_FF+0x287>
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	a3 48 50 98 00       	mov    %eax,0x985048
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803156:	a1 54 50 98 00       	mov    0x985054,%eax
  80315b:	48                   	dec    %eax
  80315c:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	e9 88 01 00 00       	jmp    8032f1 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803169:	a1 50 50 98 00       	mov    0x985050,%eax
  80316e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803171:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803175:	74 07                	je     80317e <alloc_block_FF+0x2c2>
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	eb 05                	jmp    803183 <alloc_block_FF+0x2c7>
  80317e:	b8 00 00 00 00       	mov    $0x0,%eax
  803183:	a3 50 50 98 00       	mov    %eax,0x985050
  803188:	a1 50 50 98 00       	mov    0x985050,%eax
  80318d:	85 c0                	test   %eax,%eax
  80318f:	0f 85 d9 fd ff ff    	jne    802f6e <alloc_block_FF+0xb2>
  803195:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803199:	0f 85 cf fd ff ff    	jne    802f6e <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80319f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8031a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031ac:	01 d0                	add    %edx,%eax
  8031ae:	48                   	dec    %eax
  8031af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8031b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ba:	f7 75 d8             	divl   -0x28(%ebp)
  8031bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031c0:	29 d0                	sub    %edx,%eax
  8031c2:	c1 e8 0c             	shr    $0xc,%eax
  8031c5:	83 ec 0c             	sub    $0xc,%esp
  8031c8:	50                   	push   %eax
  8031c9:	e8 20 eb ff ff       	call   801cee <sbrk>
  8031ce:	83 c4 10             	add    $0x10,%esp
  8031d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8031d4:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8031d8:	75 0a                	jne    8031e4 <alloc_block_FF+0x328>
		return NULL;
  8031da:	b8 00 00 00 00       	mov    $0x0,%eax
  8031df:	e9 0d 01 00 00       	jmp    8032f1 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8031e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031e7:	83 e8 04             	sub    $0x4,%eax
  8031ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8031ed:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8031f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031fa:	01 d0                	add    %edx,%eax
  8031fc:	48                   	dec    %eax
  8031fd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  803200:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803203:	ba 00 00 00 00       	mov    $0x0,%edx
  803208:	f7 75 c8             	divl   -0x38(%ebp)
  80320b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80320e:	29 d0                	sub    %edx,%eax
  803210:	c1 e8 02             	shr    $0x2,%eax
  803213:	c1 e0 02             	shl    $0x2,%eax
  803216:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  803219:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  803222:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803225:	83 e8 08             	sub    $0x8,%eax
  803228:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80322b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	83 e0 fe             	and    $0xfffffffe,%eax
  803233:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  803236:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803239:	f7 d8                	neg    %eax
  80323b:	89 c2                	mov    %eax,%edx
  80323d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803240:	01 d0                	add    %edx,%eax
  803242:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  803245:	83 ec 0c             	sub    $0xc,%esp
  803248:	ff 75 b8             	pushl  -0x48(%ebp)
  80324b:	e8 1f f8 ff ff       	call   802a6f <is_free_block>
  803250:	83 c4 10             	add    $0x10,%esp
  803253:	0f be c0             	movsbl %al,%eax
  803256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803259:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80325d:	74 42                	je     8032a1 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80325f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803266:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803269:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80326c:	01 d0                	add    %edx,%eax
  80326e:	48                   	dec    %eax
  80326f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803272:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803275:	ba 00 00 00 00       	mov    $0x0,%edx
  80327a:	f7 75 b0             	divl   -0x50(%ebp)
  80327d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803280:	29 d0                	sub    %edx,%eax
  803282:	89 c2                	mov    %eax,%edx
  803284:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803287:	01 d0                	add    %edx,%eax
  803289:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  80328c:	83 ec 04             	sub    $0x4,%esp
  80328f:	6a 00                	push   $0x0
  803291:	ff 75 a8             	pushl  -0x58(%ebp)
  803294:	ff 75 b8             	pushl  -0x48(%ebp)
  803297:	e8 36 fa ff ff       	call   802cd2 <set_block_data>
  80329c:	83 c4 10             	add    $0x10,%esp
  80329f:	eb 42                	jmp    8032e3 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  8032a1:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8032a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8032ae:	01 d0                	add    %edx,%eax
  8032b0:	48                   	dec    %eax
  8032b1:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8032b4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8032b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8032bc:	f7 75 a4             	divl   -0x5c(%ebp)
  8032bf:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8032c2:	29 d0                	sub    %edx,%eax
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	6a 00                	push   $0x0
  8032c9:	50                   	push   %eax
  8032ca:	ff 75 d0             	pushl  -0x30(%ebp)
  8032cd:	e8 00 fa ff ff       	call   802cd2 <set_block_data>
  8032d2:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8032d5:	83 ec 0c             	sub    $0xc,%esp
  8032d8:	ff 75 d0             	pushl  -0x30(%ebp)
  8032db:	e8 49 fa ff ff       	call   802d29 <insert_sorted_in_freeList>
  8032e0:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8032e3:	83 ec 0c             	sub    $0xc,%esp
  8032e6:	ff 75 08             	pushl  0x8(%ebp)
  8032e9:	e8 ce fb ff ff       	call   802ebc <alloc_block_FF>
  8032ee:	83 c4 10             	add    $0x10,%esp
}
  8032f1:	c9                   	leave  
  8032f2:	c3                   	ret    

008032f3 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8032f3:	55                   	push   %ebp
  8032f4:	89 e5                	mov    %esp,%ebp
  8032f6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8032f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032fd:	75 0a                	jne    803309 <alloc_block_BF+0x16>
	{
		return NULL;
  8032ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803304:	e9 7a 02 00 00       	jmp    803583 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	83 c0 08             	add    $0x8,%eax
  80330f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  803312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803319:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803320:	a1 48 50 98 00       	mov    0x985048,%eax
  803325:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803328:	eb 32                	jmp    80335c <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  80332a:	ff 75 ec             	pushl  -0x14(%ebp)
  80332d:	e8 24 f7 ff ff       	call   802a56 <get_block_size>
  803332:	83 c4 04             	add    $0x4,%esp
  803335:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80333e:	72 14                	jb     803354 <alloc_block_BF+0x61>
  803340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803343:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803346:	73 0c                	jae    803354 <alloc_block_BF+0x61>
		{
			minBlk = block;
  803348:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80334e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803351:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803354:	a1 50 50 98 00       	mov    0x985050,%eax
  803359:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80335c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803360:	74 07                	je     803369 <alloc_block_BF+0x76>
  803362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	eb 05                	jmp    80336e <alloc_block_BF+0x7b>
  803369:	b8 00 00 00 00       	mov    $0x0,%eax
  80336e:	a3 50 50 98 00       	mov    %eax,0x985050
  803373:	a1 50 50 98 00       	mov    0x985050,%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	75 ae                	jne    80332a <alloc_block_BF+0x37>
  80337c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803380:	75 a8                	jne    80332a <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803386:	75 22                	jne    8033aa <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338b:	83 ec 0c             	sub    $0xc,%esp
  80338e:	50                   	push   %eax
  80338f:	e8 5a e9 ff ff       	call   801cee <sbrk>
  803394:	83 c4 10             	add    $0x10,%esp
  803397:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80339a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80339e:	75 0a                	jne    8033aa <alloc_block_BF+0xb7>
			return NULL;
  8033a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a5:	e9 d9 01 00 00       	jmp    803583 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  8033aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ad:	83 c0 10             	add    $0x10,%eax
  8033b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033b3:	0f 87 32 01 00 00    	ja     8034eb <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8033bf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8033c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c8:	01 d0                	add    %edx,%eax
  8033ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8033cd:	83 ec 04             	sub    $0x4,%esp
  8033d0:	6a 00                	push   $0x0
  8033d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8033d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8033d8:	e8 f5 f8 ff ff       	call   802cd2 <set_block_data>
  8033dd:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8033e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e4:	74 06                	je     8033ec <alloc_block_BF+0xf9>
  8033e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8033ea:	75 17                	jne    803403 <alloc_block_BF+0x110>
  8033ec:	83 ec 04             	sub    $0x4,%esp
  8033ef:	68 6c 4c 80 00       	push   $0x804c6c
  8033f4:	68 49 01 00 00       	push   $0x149
  8033f9:	68 f7 4b 80 00       	push   $0x804bf7
  8033fe:	e8 94 d8 ff ff       	call   800c97 <_panic>
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 10                	mov    (%eax),%edx
  803408:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80340b:	89 10                	mov    %edx,(%eax)
  80340d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	74 0b                	je     803421 <alloc_block_BF+0x12e>
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80341e:	89 50 04             	mov    %edx,0x4(%eax)
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803427:	89 10                	mov    %edx,(%eax)
  803429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80342c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342f:	89 50 04             	mov    %edx,0x4(%eax)
  803432:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	85 c0                	test   %eax,%eax
  803439:	75 08                	jne    803443 <alloc_block_BF+0x150>
  80343b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80343e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803443:	a1 54 50 98 00       	mov    0x985054,%eax
  803448:	40                   	inc    %eax
  803449:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  80344e:	83 ec 04             	sub    $0x4,%esp
  803451:	6a 01                	push   $0x1
  803453:	ff 75 e8             	pushl  -0x18(%ebp)
  803456:	ff 75 f4             	pushl  -0xc(%ebp)
  803459:	e8 74 f8 ff ff       	call   802cd2 <set_block_data>
  80345e:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803465:	75 17                	jne    80347e <alloc_block_BF+0x18b>
  803467:	83 ec 04             	sub    $0x4,%esp
  80346a:	68 a0 4c 80 00       	push   $0x804ca0
  80346f:	68 4e 01 00 00       	push   $0x14e
  803474:	68 f7 4b 80 00       	push   $0x804bf7
  803479:	e8 19 d8 ff ff       	call   800c97 <_panic>
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	85 c0                	test   %eax,%eax
  803485:	74 10                	je     803497 <alloc_block_BF+0x1a4>
  803487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348a:	8b 00                	mov    (%eax),%eax
  80348c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80348f:	8b 52 04             	mov    0x4(%edx),%edx
  803492:	89 50 04             	mov    %edx,0x4(%eax)
  803495:	eb 0b                	jmp    8034a2 <alloc_block_BF+0x1af>
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	8b 40 04             	mov    0x4(%eax),%eax
  80349d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	74 0f                	je     8034bb <alloc_block_BF+0x1c8>
  8034ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034af:	8b 40 04             	mov    0x4(%eax),%eax
  8034b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b5:	8b 12                	mov    (%edx),%edx
  8034b7:	89 10                	mov    %edx,(%eax)
  8034b9:	eb 0a                	jmp    8034c5 <alloc_block_BF+0x1d2>
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	a3 48 50 98 00       	mov    %eax,0x985048
  8034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d8:	a1 54 50 98 00       	mov    0x985054,%eax
  8034dd:	48                   	dec    %eax
  8034de:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e6:	e9 98 00 00 00       	jmp    803583 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8034eb:	83 ec 04             	sub    $0x4,%esp
  8034ee:	6a 01                	push   $0x1
  8034f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8034f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8034f6:	e8 d7 f7 ff ff       	call   802cd2 <set_block_data>
  8034fb:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8034fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803502:	75 17                	jne    80351b <alloc_block_BF+0x228>
  803504:	83 ec 04             	sub    $0x4,%esp
  803507:	68 a0 4c 80 00       	push   $0x804ca0
  80350c:	68 56 01 00 00       	push   $0x156
  803511:	68 f7 4b 80 00       	push   $0x804bf7
  803516:	e8 7c d7 ff ff       	call   800c97 <_panic>
  80351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	85 c0                	test   %eax,%eax
  803522:	74 10                	je     803534 <alloc_block_BF+0x241>
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	8b 00                	mov    (%eax),%eax
  803529:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352c:	8b 52 04             	mov    0x4(%edx),%edx
  80352f:	89 50 04             	mov    %edx,0x4(%eax)
  803532:	eb 0b                	jmp    80353f <alloc_block_BF+0x24c>
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	8b 40 04             	mov    0x4(%eax),%eax
  80353a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80353f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803542:	8b 40 04             	mov    0x4(%eax),%eax
  803545:	85 c0                	test   %eax,%eax
  803547:	74 0f                	je     803558 <alloc_block_BF+0x265>
  803549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354c:	8b 40 04             	mov    0x4(%eax),%eax
  80354f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803552:	8b 12                	mov    (%edx),%edx
  803554:	89 10                	mov    %edx,(%eax)
  803556:	eb 0a                	jmp    803562 <alloc_block_BF+0x26f>
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	8b 00                	mov    (%eax),%eax
  80355d:	a3 48 50 98 00       	mov    %eax,0x985048
  803562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803565:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803575:	a1 54 50 98 00       	mov    0x985054,%eax
  80357a:	48                   	dec    %eax
  80357b:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803583:	c9                   	leave  
  803584:	c3                   	ret    

00803585 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803585:	55                   	push   %ebp
  803586:	89 e5                	mov    %esp,%ebp
  803588:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  80358b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358f:	0f 84 6a 02 00 00    	je     8037ff <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803595:	ff 75 08             	pushl  0x8(%ebp)
  803598:	e8 b9 f4 ff ff       	call   802a56 <get_block_size>
  80359d:	83 c4 04             	add    $0x4,%esp
  8035a0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	83 e8 08             	sub    $0x8,%eax
  8035a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8035ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8035b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8035b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ba:	f7 d8                	neg    %eax
  8035bc:	89 c2                	mov    %eax,%edx
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8035c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8035c9:	e8 a1 f4 ff ff       	call   802a6f <is_free_block>
  8035ce:	83 c4 04             	add    $0x4,%esp
  8035d1:	0f be c0             	movsbl %al,%eax
  8035d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8035d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	01 d0                	add    %edx,%eax
  8035df:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8035e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8035e5:	e8 85 f4 ff ff       	call   802a6f <is_free_block>
  8035ea:	83 c4 04             	add    $0x4,%esp
  8035ed:	0f be c0             	movsbl %al,%eax
  8035f0:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8035f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8035f7:	75 34                	jne    80362d <free_block+0xa8>
  8035f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035fd:	75 2e                	jne    80362d <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8035ff:	ff 75 e8             	pushl  -0x18(%ebp)
  803602:	e8 4f f4 ff ff       	call   802a56 <get_block_size>
  803607:	83 c4 04             	add    $0x4,%esp
  80360a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  80360d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803610:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803613:	01 d0                	add    %edx,%eax
  803615:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803618:	6a 00                	push   $0x0
  80361a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80361d:	ff 75 e8             	pushl  -0x18(%ebp)
  803620:	e8 ad f6 ff ff       	call   802cd2 <set_block_data>
  803625:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803628:	e9 d3 01 00 00       	jmp    803800 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  80362d:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803631:	0f 85 c8 00 00 00    	jne    8036ff <free_block+0x17a>
  803637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80363b:	0f 85 be 00 00 00    	jne    8036ff <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803641:	ff 75 e0             	pushl  -0x20(%ebp)
  803644:	e8 0d f4 ff ff       	call   802a56 <get_block_size>
  803649:	83 c4 04             	add    $0x4,%esp
  80364c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  80364f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803652:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803655:	01 d0                	add    %edx,%eax
  803657:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  80365a:	6a 00                	push   $0x0
  80365c:	ff 75 cc             	pushl  -0x34(%ebp)
  80365f:	ff 75 08             	pushl  0x8(%ebp)
  803662:	e8 6b f6 ff ff       	call   802cd2 <set_block_data>
  803667:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  80366a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80366e:	75 17                	jne    803687 <free_block+0x102>
  803670:	83 ec 04             	sub    $0x4,%esp
  803673:	68 a0 4c 80 00       	push   $0x804ca0
  803678:	68 87 01 00 00       	push   $0x187
  80367d:	68 f7 4b 80 00       	push   $0x804bf7
  803682:	e8 10 d6 ff ff       	call   800c97 <_panic>
  803687:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80368a:	8b 00                	mov    (%eax),%eax
  80368c:	85 c0                	test   %eax,%eax
  80368e:	74 10                	je     8036a0 <free_block+0x11b>
  803690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803698:	8b 52 04             	mov    0x4(%edx),%edx
  80369b:	89 50 04             	mov    %edx,0x4(%eax)
  80369e:	eb 0b                	jmp    8036ab <free_block+0x126>
  8036a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036a3:	8b 40 04             	mov    0x4(%eax),%eax
  8036a6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8036ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ae:	8b 40 04             	mov    0x4(%eax),%eax
  8036b1:	85 c0                	test   %eax,%eax
  8036b3:	74 0f                	je     8036c4 <free_block+0x13f>
  8036b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b8:	8b 40 04             	mov    0x4(%eax),%eax
  8036bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036be:	8b 12                	mov    (%edx),%edx
  8036c0:	89 10                	mov    %edx,(%eax)
  8036c2:	eb 0a                	jmp    8036ce <free_block+0x149>
  8036c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c7:	8b 00                	mov    (%eax),%eax
  8036c9:	a3 48 50 98 00       	mov    %eax,0x985048
  8036ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e1:	a1 54 50 98 00       	mov    0x985054,%eax
  8036e6:	48                   	dec    %eax
  8036e7:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8036ec:	83 ec 0c             	sub    $0xc,%esp
  8036ef:	ff 75 08             	pushl  0x8(%ebp)
  8036f2:	e8 32 f6 ff ff       	call   802d29 <insert_sorted_in_freeList>
  8036f7:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  8036fa:	e9 01 01 00 00       	jmp    803800 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  8036ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803703:	0f 85 d3 00 00 00    	jne    8037dc <free_block+0x257>
  803709:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80370d:	0f 85 c9 00 00 00    	jne    8037dc <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803713:	83 ec 0c             	sub    $0xc,%esp
  803716:	ff 75 e8             	pushl  -0x18(%ebp)
  803719:	e8 38 f3 ff ff       	call   802a56 <get_block_size>
  80371e:	83 c4 10             	add    $0x10,%esp
  803721:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803724:	83 ec 0c             	sub    $0xc,%esp
  803727:	ff 75 e0             	pushl  -0x20(%ebp)
  80372a:	e8 27 f3 ff ff       	call   802a56 <get_block_size>
  80372f:	83 c4 10             	add    $0x10,%esp
  803732:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803738:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80373b:	01 c2                	add    %eax,%edx
  80373d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803740:	01 d0                	add    %edx,%eax
  803742:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803745:	83 ec 04             	sub    $0x4,%esp
  803748:	6a 00                	push   $0x0
  80374a:	ff 75 c0             	pushl  -0x40(%ebp)
  80374d:	ff 75 e8             	pushl  -0x18(%ebp)
  803750:	e8 7d f5 ff ff       	call   802cd2 <set_block_data>
  803755:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803758:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80375c:	75 17                	jne    803775 <free_block+0x1f0>
  80375e:	83 ec 04             	sub    $0x4,%esp
  803761:	68 a0 4c 80 00       	push   $0x804ca0
  803766:	68 94 01 00 00       	push   $0x194
  80376b:	68 f7 4b 80 00       	push   $0x804bf7
  803770:	e8 22 d5 ff ff       	call   800c97 <_panic>
  803775:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803778:	8b 00                	mov    (%eax),%eax
  80377a:	85 c0                	test   %eax,%eax
  80377c:	74 10                	je     80378e <free_block+0x209>
  80377e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803781:	8b 00                	mov    (%eax),%eax
  803783:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803786:	8b 52 04             	mov    0x4(%edx),%edx
  803789:	89 50 04             	mov    %edx,0x4(%eax)
  80378c:	eb 0b                	jmp    803799 <free_block+0x214>
  80378e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803791:	8b 40 04             	mov    0x4(%eax),%eax
  803794:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	85 c0                	test   %eax,%eax
  8037a1:	74 0f                	je     8037b2 <free_block+0x22d>
  8037a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a6:	8b 40 04             	mov    0x4(%eax),%eax
  8037a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ac:	8b 12                	mov    (%edx),%edx
  8037ae:	89 10                	mov    %edx,(%eax)
  8037b0:	eb 0a                	jmp    8037bc <free_block+0x237>
  8037b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	a3 48 50 98 00       	mov    %eax,0x985048
  8037bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cf:	a1 54 50 98 00       	mov    0x985054,%eax
  8037d4:	48                   	dec    %eax
  8037d5:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  8037da:	eb 24                	jmp    803800 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	6a 00                	push   $0x0
  8037e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8037e4:	ff 75 08             	pushl  0x8(%ebp)
  8037e7:	e8 e6 f4 ff ff       	call   802cd2 <set_block_data>
  8037ec:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8037ef:	83 ec 0c             	sub    $0xc,%esp
  8037f2:	ff 75 08             	pushl  0x8(%ebp)
  8037f5:	e8 2f f5 ff ff       	call   802d29 <insert_sorted_in_freeList>
  8037fa:	83 c4 10             	add    $0x10,%esp
  8037fd:	eb 01                	jmp    803800 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8037ff:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803800:	c9                   	leave  
  803801:	c3                   	ret    

00803802 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803802:	55                   	push   %ebp
  803803:	89 e5                	mov    %esp,%ebp
  803805:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803808:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80380c:	75 10                	jne    80381e <realloc_block_FF+0x1c>
  80380e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803812:	75 0a                	jne    80381e <realloc_block_FF+0x1c>
	{
		return NULL;
  803814:	b8 00 00 00 00       	mov    $0x0,%eax
  803819:	e9 8b 04 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  80381e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803822:	75 18                	jne    80383c <realloc_block_FF+0x3a>
	{
		free_block(va);
  803824:	83 ec 0c             	sub    $0xc,%esp
  803827:	ff 75 08             	pushl  0x8(%ebp)
  80382a:	e8 56 fd ff ff       	call   803585 <free_block>
  80382f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803832:	b8 00 00 00 00       	mov    $0x0,%eax
  803837:	e9 6d 04 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  80383c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803840:	75 13                	jne    803855 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803842:	83 ec 0c             	sub    $0xc,%esp
  803845:	ff 75 0c             	pushl  0xc(%ebp)
  803848:	e8 6f f6 ff ff       	call   802ebc <alloc_block_FF>
  80384d:	83 c4 10             	add    $0x10,%esp
  803850:	e9 54 04 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803855:	8b 45 0c             	mov    0xc(%ebp),%eax
  803858:	83 e0 01             	and    $0x1,%eax
  80385b:	85 c0                	test   %eax,%eax
  80385d:	74 03                	je     803862 <realloc_block_FF+0x60>
	{
		new_size++;
  80385f:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803862:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803866:	77 07                	ja     80386f <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803868:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  80386f:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803873:	83 ec 0c             	sub    $0xc,%esp
  803876:	ff 75 08             	pushl  0x8(%ebp)
  803879:	e8 d8 f1 ff ff       	call   802a56 <get_block_size>
  80387e:	83 c4 10             	add    $0x10,%esp
  803881:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803887:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80388a:	75 08                	jne    803894 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  80388c:	8b 45 08             	mov    0x8(%ebp),%eax
  80388f:	e9 15 04 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803894:	8b 55 08             	mov    0x8(%ebp),%edx
  803897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389a:	01 d0                	add    %edx,%eax
  80389c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80389f:	83 ec 0c             	sub    $0xc,%esp
  8038a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8038a5:	e8 c5 f1 ff ff       	call   802a6f <is_free_block>
  8038aa:	83 c4 10             	add    $0x10,%esp
  8038ad:	0f be c0             	movsbl %al,%eax
  8038b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8038b3:	83 ec 0c             	sub    $0xc,%esp
  8038b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8038b9:	e8 98 f1 ff ff       	call   802a56 <get_block_size>
  8038be:	83 c4 10             	add    $0x10,%esp
  8038c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8038c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8038ca:	0f 86 a7 02 00 00    	jbe    803b77 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8038d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038d4:	0f 84 86 02 00 00    	je     803b60 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8038da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e0:	01 d0                	add    %edx,%eax
  8038e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038e5:	0f 85 b2 00 00 00    	jne    80399d <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8038eb:	83 ec 0c             	sub    $0xc,%esp
  8038ee:	ff 75 08             	pushl  0x8(%ebp)
  8038f1:	e8 79 f1 ff ff       	call   802a6f <is_free_block>
  8038f6:	83 c4 10             	add    $0x10,%esp
  8038f9:	84 c0                	test   %al,%al
  8038fb:	0f 94 c0             	sete   %al
  8038fe:	0f b6 c0             	movzbl %al,%eax
  803901:	83 ec 04             	sub    $0x4,%esp
  803904:	50                   	push   %eax
  803905:	ff 75 0c             	pushl  0xc(%ebp)
  803908:	ff 75 08             	pushl  0x8(%ebp)
  80390b:	e8 c2 f3 ff ff       	call   802cd2 <set_block_data>
  803910:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803913:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803917:	75 17                	jne    803930 <realloc_block_FF+0x12e>
  803919:	83 ec 04             	sub    $0x4,%esp
  80391c:	68 a0 4c 80 00       	push   $0x804ca0
  803921:	68 db 01 00 00       	push   $0x1db
  803926:	68 f7 4b 80 00       	push   $0x804bf7
  80392b:	e8 67 d3 ff ff       	call   800c97 <_panic>
  803930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803933:	8b 00                	mov    (%eax),%eax
  803935:	85 c0                	test   %eax,%eax
  803937:	74 10                	je     803949 <realloc_block_FF+0x147>
  803939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393c:	8b 00                	mov    (%eax),%eax
  80393e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803941:	8b 52 04             	mov    0x4(%edx),%edx
  803944:	89 50 04             	mov    %edx,0x4(%eax)
  803947:	eb 0b                	jmp    803954 <realloc_block_FF+0x152>
  803949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394c:	8b 40 04             	mov    0x4(%eax),%eax
  80394f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803957:	8b 40 04             	mov    0x4(%eax),%eax
  80395a:	85 c0                	test   %eax,%eax
  80395c:	74 0f                	je     80396d <realloc_block_FF+0x16b>
  80395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803961:	8b 40 04             	mov    0x4(%eax),%eax
  803964:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803967:	8b 12                	mov    (%edx),%edx
  803969:	89 10                	mov    %edx,(%eax)
  80396b:	eb 0a                	jmp    803977 <realloc_block_FF+0x175>
  80396d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	a3 48 50 98 00       	mov    %eax,0x985048
  803977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80397a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803983:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80398a:	a1 54 50 98 00       	mov    0x985054,%eax
  80398f:	48                   	dec    %eax
  803990:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803995:	8b 45 08             	mov    0x8(%ebp),%eax
  803998:	e9 0c 03 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80399d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a3:	01 d0                	add    %edx,%eax
  8039a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039a8:	0f 86 b2 01 00 00    	jbe    803b60 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8039ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8039b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8039b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8039bd:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8039c0:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8039c4:	0f 87 b8 00 00 00    	ja     803a82 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8039ca:	83 ec 0c             	sub    $0xc,%esp
  8039cd:	ff 75 08             	pushl  0x8(%ebp)
  8039d0:	e8 9a f0 ff ff       	call   802a6f <is_free_block>
  8039d5:	83 c4 10             	add    $0x10,%esp
  8039d8:	84 c0                	test   %al,%al
  8039da:	0f 94 c0             	sete   %al
  8039dd:	0f b6 c0             	movzbl %al,%eax
  8039e0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8039e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039e6:	01 ca                	add    %ecx,%edx
  8039e8:	83 ec 04             	sub    $0x4,%esp
  8039eb:	50                   	push   %eax
  8039ec:	52                   	push   %edx
  8039ed:	ff 75 08             	pushl  0x8(%ebp)
  8039f0:	e8 dd f2 ff ff       	call   802cd2 <set_block_data>
  8039f5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8039f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039fc:	75 17                	jne    803a15 <realloc_block_FF+0x213>
  8039fe:	83 ec 04             	sub    $0x4,%esp
  803a01:	68 a0 4c 80 00       	push   $0x804ca0
  803a06:	68 e8 01 00 00       	push   $0x1e8
  803a0b:	68 f7 4b 80 00       	push   $0x804bf7
  803a10:	e8 82 d2 ff ff       	call   800c97 <_panic>
  803a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a18:	8b 00                	mov    (%eax),%eax
  803a1a:	85 c0                	test   %eax,%eax
  803a1c:	74 10                	je     803a2e <realloc_block_FF+0x22c>
  803a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a21:	8b 00                	mov    (%eax),%eax
  803a23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a26:	8b 52 04             	mov    0x4(%edx),%edx
  803a29:	89 50 04             	mov    %edx,0x4(%eax)
  803a2c:	eb 0b                	jmp    803a39 <realloc_block_FF+0x237>
  803a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a31:	8b 40 04             	mov    0x4(%eax),%eax
  803a34:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3c:	8b 40 04             	mov    0x4(%eax),%eax
  803a3f:	85 c0                	test   %eax,%eax
  803a41:	74 0f                	je     803a52 <realloc_block_FF+0x250>
  803a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a46:	8b 40 04             	mov    0x4(%eax),%eax
  803a49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a4c:	8b 12                	mov    (%edx),%edx
  803a4e:	89 10                	mov    %edx,(%eax)
  803a50:	eb 0a                	jmp    803a5c <realloc_block_FF+0x25a>
  803a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a55:	8b 00                	mov    (%eax),%eax
  803a57:	a3 48 50 98 00       	mov    %eax,0x985048
  803a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6f:	a1 54 50 98 00       	mov    0x985054,%eax
  803a74:	48                   	dec    %eax
  803a75:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7d:	e9 27 02 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803a82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a86:	75 17                	jne    803a9f <realloc_block_FF+0x29d>
  803a88:	83 ec 04             	sub    $0x4,%esp
  803a8b:	68 a0 4c 80 00       	push   $0x804ca0
  803a90:	68 ed 01 00 00       	push   $0x1ed
  803a95:	68 f7 4b 80 00       	push   $0x804bf7
  803a9a:	e8 f8 d1 ff ff       	call   800c97 <_panic>
  803a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa2:	8b 00                	mov    (%eax),%eax
  803aa4:	85 c0                	test   %eax,%eax
  803aa6:	74 10                	je     803ab8 <realloc_block_FF+0x2b6>
  803aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aab:	8b 00                	mov    (%eax),%eax
  803aad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ab0:	8b 52 04             	mov    0x4(%edx),%edx
  803ab3:	89 50 04             	mov    %edx,0x4(%eax)
  803ab6:	eb 0b                	jmp    803ac3 <realloc_block_FF+0x2c1>
  803ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803abb:	8b 40 04             	mov    0x4(%eax),%eax
  803abe:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac6:	8b 40 04             	mov    0x4(%eax),%eax
  803ac9:	85 c0                	test   %eax,%eax
  803acb:	74 0f                	je     803adc <realloc_block_FF+0x2da>
  803acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad0:	8b 40 04             	mov    0x4(%eax),%eax
  803ad3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ad6:	8b 12                	mov    (%edx),%edx
  803ad8:	89 10                	mov    %edx,(%eax)
  803ada:	eb 0a                	jmp    803ae6 <realloc_block_FF+0x2e4>
  803adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803adf:	8b 00                	mov    (%eax),%eax
  803ae1:	a3 48 50 98 00       	mov    %eax,0x985048
  803ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af9:	a1 54 50 98 00       	mov    0x985054,%eax
  803afe:	48                   	dec    %eax
  803aff:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803b04:	8b 55 08             	mov    0x8(%ebp),%edx
  803b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b0a:	01 d0                	add    %edx,%eax
  803b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803b0f:	83 ec 04             	sub    $0x4,%esp
  803b12:	6a 00                	push   $0x0
  803b14:	ff 75 e0             	pushl  -0x20(%ebp)
  803b17:	ff 75 f0             	pushl  -0x10(%ebp)
  803b1a:	e8 b3 f1 ff ff       	call   802cd2 <set_block_data>
  803b1f:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803b22:	83 ec 0c             	sub    $0xc,%esp
  803b25:	ff 75 08             	pushl  0x8(%ebp)
  803b28:	e8 42 ef ff ff       	call   802a6f <is_free_block>
  803b2d:	83 c4 10             	add    $0x10,%esp
  803b30:	84 c0                	test   %al,%al
  803b32:	0f 94 c0             	sete   %al
  803b35:	0f b6 c0             	movzbl %al,%eax
  803b38:	83 ec 04             	sub    $0x4,%esp
  803b3b:	50                   	push   %eax
  803b3c:	ff 75 0c             	pushl  0xc(%ebp)
  803b3f:	ff 75 08             	pushl  0x8(%ebp)
  803b42:	e8 8b f1 ff ff       	call   802cd2 <set_block_data>
  803b47:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803b4a:	83 ec 0c             	sub    $0xc,%esp
  803b4d:	ff 75 f0             	pushl  -0x10(%ebp)
  803b50:	e8 d4 f1 ff ff       	call   802d29 <insert_sorted_in_freeList>
  803b55:	83 c4 10             	add    $0x10,%esp
					return va;
  803b58:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5b:	e9 49 01 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b63:	83 e8 08             	sub    $0x8,%eax
  803b66:	83 ec 0c             	sub    $0xc,%esp
  803b69:	50                   	push   %eax
  803b6a:	e8 4d f3 ff ff       	call   802ebc <alloc_block_FF>
  803b6f:	83 c4 10             	add    $0x10,%esp
  803b72:	e9 32 01 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803b7d:	0f 83 21 01 00 00    	jae    803ca4 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b86:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b89:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803b8c:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803b90:	77 0e                	ja     803ba0 <realloc_block_FF+0x39e>
  803b92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b96:	75 08                	jne    803ba0 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803b98:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9b:	e9 09 01 00 00       	jmp    803ca9 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803ba6:	83 ec 0c             	sub    $0xc,%esp
  803ba9:	ff 75 08             	pushl  0x8(%ebp)
  803bac:	e8 be ee ff ff       	call   802a6f <is_free_block>
  803bb1:	83 c4 10             	add    $0x10,%esp
  803bb4:	84 c0                	test   %al,%al
  803bb6:	0f 94 c0             	sete   %al
  803bb9:	0f b6 c0             	movzbl %al,%eax
  803bbc:	83 ec 04             	sub    $0x4,%esp
  803bbf:	50                   	push   %eax
  803bc0:	ff 75 0c             	pushl  0xc(%ebp)
  803bc3:	ff 75 d8             	pushl  -0x28(%ebp)
  803bc6:	e8 07 f1 ff ff       	call   802cd2 <set_block_data>
  803bcb:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803bce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd4:	01 d0                	add    %edx,%eax
  803bd6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803bd9:	83 ec 04             	sub    $0x4,%esp
  803bdc:	6a 00                	push   $0x0
  803bde:	ff 75 dc             	pushl  -0x24(%ebp)
  803be1:	ff 75 d4             	pushl  -0x2c(%ebp)
  803be4:	e8 e9 f0 ff ff       	call   802cd2 <set_block_data>
  803be9:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803bec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bf0:	0f 84 9b 00 00 00    	je     803c91 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803bf6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfc:	01 d0                	add    %edx,%eax
  803bfe:	83 ec 04             	sub    $0x4,%esp
  803c01:	6a 00                	push   $0x0
  803c03:	50                   	push   %eax
  803c04:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c07:	e8 c6 f0 ff ff       	call   802cd2 <set_block_data>
  803c0c:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803c0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c13:	75 17                	jne    803c2c <realloc_block_FF+0x42a>
  803c15:	83 ec 04             	sub    $0x4,%esp
  803c18:	68 a0 4c 80 00       	push   $0x804ca0
  803c1d:	68 10 02 00 00       	push   $0x210
  803c22:	68 f7 4b 80 00       	push   $0x804bf7
  803c27:	e8 6b d0 ff ff       	call   800c97 <_panic>
  803c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c2f:	8b 00                	mov    (%eax),%eax
  803c31:	85 c0                	test   %eax,%eax
  803c33:	74 10                	je     803c45 <realloc_block_FF+0x443>
  803c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c38:	8b 00                	mov    (%eax),%eax
  803c3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c3d:	8b 52 04             	mov    0x4(%edx),%edx
  803c40:	89 50 04             	mov    %edx,0x4(%eax)
  803c43:	eb 0b                	jmp    803c50 <realloc_block_FF+0x44e>
  803c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c48:	8b 40 04             	mov    0x4(%eax),%eax
  803c4b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c53:	8b 40 04             	mov    0x4(%eax),%eax
  803c56:	85 c0                	test   %eax,%eax
  803c58:	74 0f                	je     803c69 <realloc_block_FF+0x467>
  803c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5d:	8b 40 04             	mov    0x4(%eax),%eax
  803c60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c63:	8b 12                	mov    (%edx),%edx
  803c65:	89 10                	mov    %edx,(%eax)
  803c67:	eb 0a                	jmp    803c73 <realloc_block_FF+0x471>
  803c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c6c:	8b 00                	mov    (%eax),%eax
  803c6e:	a3 48 50 98 00       	mov    %eax,0x985048
  803c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c86:	a1 54 50 98 00       	mov    0x985054,%eax
  803c8b:	48                   	dec    %eax
  803c8c:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803c91:	83 ec 0c             	sub    $0xc,%esp
  803c94:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c97:	e8 8d f0 ff ff       	call   802d29 <insert_sorted_in_freeList>
  803c9c:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803c9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ca2:	eb 05                	jmp    803ca9 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ca9:	c9                   	leave  
  803caa:	c3                   	ret    

00803cab <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803cab:	55                   	push   %ebp
  803cac:	89 e5                	mov    %esp,%ebp
  803cae:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803cb1:	83 ec 04             	sub    $0x4,%esp
  803cb4:	68 c0 4c 80 00       	push   $0x804cc0
  803cb9:	68 20 02 00 00       	push   $0x220
  803cbe:	68 f7 4b 80 00       	push   $0x804bf7
  803cc3:	e8 cf cf ff ff       	call   800c97 <_panic>

00803cc8 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803cc8:	55                   	push   %ebp
  803cc9:	89 e5                	mov    %esp,%ebp
  803ccb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803cce:	83 ec 04             	sub    $0x4,%esp
  803cd1:	68 e8 4c 80 00       	push   $0x804ce8
  803cd6:	68 28 02 00 00       	push   $0x228
  803cdb:	68 f7 4b 80 00       	push   $0x804bf7
  803ce0:	e8 b2 cf ff ff       	call   800c97 <_panic>

00803ce5 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803ce5:	55                   	push   %ebp
  803ce6:	89 e5                	mov    %esp,%ebp
  803ce8:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  803ceb:	83 ec 04             	sub    $0x4,%esp
  803cee:	6a 01                	push   $0x1
  803cf0:	6a 58                	push   $0x58
  803cf2:	ff 75 0c             	pushl  0xc(%ebp)
  803cf5:	e8 c1 e2 ff ff       	call   801fbb <smalloc>
  803cfa:	83 c4 10             	add    $0x10,%esp
  803cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803d00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d04:	75 14                	jne    803d1a <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  803d06:	83 ec 04             	sub    $0x4,%esp
  803d09:	68 10 4d 80 00       	push   $0x804d10
  803d0e:	6a 10                	push   $0x10
  803d10:	68 3e 4d 80 00       	push   $0x804d3e
  803d15:	e8 7d cf ff ff       	call   800c97 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  803d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1d:	83 ec 0c             	sub    $0xc,%esp
  803d20:	50                   	push   %eax
  803d21:	e8 bc ec ff ff       	call   8029e2 <sys_init_queue>
  803d26:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  803d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  803d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d36:	83 c0 18             	add    $0x18,%eax
  803d39:	83 ec 04             	sub    $0x4,%esp
  803d3c:	6a 40                	push   $0x40
  803d3e:	ff 75 0c             	pushl  0xc(%ebp)
  803d41:	50                   	push   %eax
  803d42:	e8 1e d9 ff ff       	call   801665 <strncpy>
  803d47:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  803d4a:	8b 55 10             	mov    0x10(%ebp),%edx
  803d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d50:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  803d59:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d5f:	89 10                	mov    %edx,(%eax)
}
  803d61:	8b 45 08             	mov    0x8(%ebp),%eax
  803d64:	c9                   	leave  
  803d65:	c2 04 00             	ret    $0x4

00803d68 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803d68:	55                   	push   %ebp
  803d69:	89 e5                	mov    %esp,%ebp
  803d6b:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  803d6e:	83 ec 08             	sub    $0x8,%esp
  803d71:	ff 75 10             	pushl  0x10(%ebp)
  803d74:	ff 75 0c             	pushl  0xc(%ebp)
  803d77:	e8 da e3 ff ff       	call   802156 <sget>
  803d7c:	83 c4 10             	add    $0x10,%esp
  803d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803d82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d86:	75 14                	jne    803d9c <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  803d88:	83 ec 04             	sub    $0x4,%esp
  803d8b:	68 50 4d 80 00       	push   $0x804d50
  803d90:	6a 2c                	push   $0x2c
  803d92:	68 3e 4d 80 00       	push   $0x804d3e
  803d97:	e8 fb ce ff ff       	call   800c97 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  803d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  803da2:	8b 45 08             	mov    0x8(%ebp),%eax
  803da5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803da8:	89 10                	mov    %edx,(%eax)
}
  803daa:	8b 45 08             	mov    0x8(%ebp),%eax
  803dad:	c9                   	leave  
  803dae:	c2 04 00             	ret    $0x4

00803db1 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803db1:	55                   	push   %ebp
  803db2:	89 e5                	mov    %esp,%ebp
  803db4:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803db7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc1:	8b 40 14             	mov    0x14(%eax),%eax
  803dc4:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803dc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803dcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803dd6:	f0 87 02             	lock xchg %eax,(%edx)
  803dd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803ddc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ddf:	85 c0                	test   %eax,%eax
  803de1:	75 db                	jne    803dbe <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803de3:	8b 45 08             	mov    0x8(%ebp),%eax
  803de6:	8b 50 10             	mov    0x10(%eax),%edx
  803de9:	4a                   	dec    %edx
  803dea:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  803ded:	8b 45 08             	mov    0x8(%ebp),%eax
  803df0:	8b 40 10             	mov    0x10(%eax),%eax
  803df3:	85 c0                	test   %eax,%eax
  803df5:	79 18                	jns    803e0f <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  803df7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfa:	8d 50 14             	lea    0x14(%eax),%edx
  803dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803e00:	83 ec 08             	sub    $0x8,%esp
  803e03:	52                   	push   %edx
  803e04:	50                   	push   %eax
  803e05:	e8 f4 eb ff ff       	call   8029fe <sys_block_process>
  803e0a:	83 c4 10             	add    $0x10,%esp
  803e0d:	eb 0a                	jmp    803e19 <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  803e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e12:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803e19:	c9                   	leave  
  803e1a:	c3                   	ret    

00803e1b <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803e1b:	55                   	push   %ebp
  803e1c:	89 e5                	mov    %esp,%ebp
  803e1e:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803e21:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803e28:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2b:	8b 40 14             	mov    0x14(%eax),%eax
  803e2e:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803e31:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803e34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e3d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803e40:	f0 87 02             	lock xchg %eax,(%edx)
  803e43:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e49:	85 c0                	test   %eax,%eax
  803e4b:	75 db                	jne    803e28 <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  803e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e50:	8b 50 10             	mov    0x10(%eax),%edx
  803e53:	42                   	inc    %edx
  803e54:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  803e57:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5a:	8b 40 10             	mov    0x10(%eax),%eax
  803e5d:	85 c0                	test   %eax,%eax
  803e5f:	7f 0f                	jg     803e70 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  803e61:	8b 45 08             	mov    0x8(%ebp),%eax
  803e64:	83 ec 0c             	sub    $0xc,%esp
  803e67:	50                   	push   %eax
  803e68:	e8 af eb ff ff       	call   802a1c <sys_unblock_process>
  803e6d:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  803e70:	8b 45 08             	mov    0x8(%ebp),%eax
  803e73:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803e7a:	90                   	nop
  803e7b:	c9                   	leave  
  803e7c:	c3                   	ret    

00803e7d <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803e7d:	55                   	push   %ebp
  803e7e:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803e80:	8b 45 08             	mov    0x8(%ebp),%eax
  803e83:	8b 40 10             	mov    0x10(%eax),%eax
}
  803e86:	5d                   	pop    %ebp
  803e87:	c3                   	ret    

00803e88 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803e88:	55                   	push   %ebp
  803e89:	89 e5                	mov    %esp,%ebp
  803e8b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  803e91:	89 d0                	mov    %edx,%eax
  803e93:	c1 e0 02             	shl    $0x2,%eax
  803e96:	01 d0                	add    %edx,%eax
  803e98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803e9f:	01 d0                	add    %edx,%eax
  803ea1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ea8:	01 d0                	add    %edx,%eax
  803eaa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803eb1:	01 d0                	add    %edx,%eax
  803eb3:	c1 e0 04             	shl    $0x4,%eax
  803eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803eb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803ec0:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803ec3:	83 ec 0c             	sub    $0xc,%esp
  803ec6:	50                   	push   %eax
  803ec7:	e8 22 e8 ff ff       	call   8026ee <sys_get_virtual_time>
  803ecc:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803ecf:	eb 41                	jmp    803f12 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803ed1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803ed4:	83 ec 0c             	sub    $0xc,%esp
  803ed7:	50                   	push   %eax
  803ed8:	e8 11 e8 ff ff       	call   8026ee <sys_get_virtual_time>
  803edd:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ee3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ee6:	29 c2                	sub    %eax,%edx
  803ee8:	89 d0                	mov    %edx,%eax
  803eea:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803eed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ef3:	89 d1                	mov    %edx,%ecx
  803ef5:	29 c1                	sub    %eax,%ecx
  803ef7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803efa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803efd:	39 c2                	cmp    %eax,%edx
  803eff:	0f 97 c0             	seta   %al
  803f02:	0f b6 c0             	movzbl %al,%eax
  803f05:	29 c1                	sub    %eax,%ecx
  803f07:	89 c8                	mov    %ecx,%eax
  803f09:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803f0c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803f18:	72 b7                	jb     803ed1 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803f1a:	90                   	nop
  803f1b:	c9                   	leave  
  803f1c:	c3                   	ret    

00803f1d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803f1d:	55                   	push   %ebp
  803f1e:	89 e5                	mov    %esp,%ebp
  803f20:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803f23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803f2a:	eb 03                	jmp    803f2f <busy_wait+0x12>
  803f2c:	ff 45 fc             	incl   -0x4(%ebp)
  803f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f32:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f35:	72 f5                	jb     803f2c <busy_wait+0xf>
	return i;
  803f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803f3a:	c9                   	leave  
  803f3b:	c3                   	ret    

00803f3c <__udivdi3>:
  803f3c:	55                   	push   %ebp
  803f3d:	57                   	push   %edi
  803f3e:	56                   	push   %esi
  803f3f:	53                   	push   %ebx
  803f40:	83 ec 1c             	sub    $0x1c,%esp
  803f43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f53:	89 ca                	mov    %ecx,%edx
  803f55:	89 f8                	mov    %edi,%eax
  803f57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f5b:	85 f6                	test   %esi,%esi
  803f5d:	75 2d                	jne    803f8c <__udivdi3+0x50>
  803f5f:	39 cf                	cmp    %ecx,%edi
  803f61:	77 65                	ja     803fc8 <__udivdi3+0x8c>
  803f63:	89 fd                	mov    %edi,%ebp
  803f65:	85 ff                	test   %edi,%edi
  803f67:	75 0b                	jne    803f74 <__udivdi3+0x38>
  803f69:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6e:	31 d2                	xor    %edx,%edx
  803f70:	f7 f7                	div    %edi
  803f72:	89 c5                	mov    %eax,%ebp
  803f74:	31 d2                	xor    %edx,%edx
  803f76:	89 c8                	mov    %ecx,%eax
  803f78:	f7 f5                	div    %ebp
  803f7a:	89 c1                	mov    %eax,%ecx
  803f7c:	89 d8                	mov    %ebx,%eax
  803f7e:	f7 f5                	div    %ebp
  803f80:	89 cf                	mov    %ecx,%edi
  803f82:	89 fa                	mov    %edi,%edx
  803f84:	83 c4 1c             	add    $0x1c,%esp
  803f87:	5b                   	pop    %ebx
  803f88:	5e                   	pop    %esi
  803f89:	5f                   	pop    %edi
  803f8a:	5d                   	pop    %ebp
  803f8b:	c3                   	ret    
  803f8c:	39 ce                	cmp    %ecx,%esi
  803f8e:	77 28                	ja     803fb8 <__udivdi3+0x7c>
  803f90:	0f bd fe             	bsr    %esi,%edi
  803f93:	83 f7 1f             	xor    $0x1f,%edi
  803f96:	75 40                	jne    803fd8 <__udivdi3+0x9c>
  803f98:	39 ce                	cmp    %ecx,%esi
  803f9a:	72 0a                	jb     803fa6 <__udivdi3+0x6a>
  803f9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fa0:	0f 87 9e 00 00 00    	ja     804044 <__udivdi3+0x108>
  803fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  803fab:	89 fa                	mov    %edi,%edx
  803fad:	83 c4 1c             	add    $0x1c,%esp
  803fb0:	5b                   	pop    %ebx
  803fb1:	5e                   	pop    %esi
  803fb2:	5f                   	pop    %edi
  803fb3:	5d                   	pop    %ebp
  803fb4:	c3                   	ret    
  803fb5:	8d 76 00             	lea    0x0(%esi),%esi
  803fb8:	31 ff                	xor    %edi,%edi
  803fba:	31 c0                	xor    %eax,%eax
  803fbc:	89 fa                	mov    %edi,%edx
  803fbe:	83 c4 1c             	add    $0x1c,%esp
  803fc1:	5b                   	pop    %ebx
  803fc2:	5e                   	pop    %esi
  803fc3:	5f                   	pop    %edi
  803fc4:	5d                   	pop    %ebp
  803fc5:	c3                   	ret    
  803fc6:	66 90                	xchg   %ax,%ax
  803fc8:	89 d8                	mov    %ebx,%eax
  803fca:	f7 f7                	div    %edi
  803fcc:	31 ff                	xor    %edi,%edi
  803fce:	89 fa                	mov    %edi,%edx
  803fd0:	83 c4 1c             	add    $0x1c,%esp
  803fd3:	5b                   	pop    %ebx
  803fd4:	5e                   	pop    %esi
  803fd5:	5f                   	pop    %edi
  803fd6:	5d                   	pop    %ebp
  803fd7:	c3                   	ret    
  803fd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fdd:	89 eb                	mov    %ebp,%ebx
  803fdf:	29 fb                	sub    %edi,%ebx
  803fe1:	89 f9                	mov    %edi,%ecx
  803fe3:	d3 e6                	shl    %cl,%esi
  803fe5:	89 c5                	mov    %eax,%ebp
  803fe7:	88 d9                	mov    %bl,%cl
  803fe9:	d3 ed                	shr    %cl,%ebp
  803feb:	89 e9                	mov    %ebp,%ecx
  803fed:	09 f1                	or     %esi,%ecx
  803fef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ff3:	89 f9                	mov    %edi,%ecx
  803ff5:	d3 e0                	shl    %cl,%eax
  803ff7:	89 c5                	mov    %eax,%ebp
  803ff9:	89 d6                	mov    %edx,%esi
  803ffb:	88 d9                	mov    %bl,%cl
  803ffd:	d3 ee                	shr    %cl,%esi
  803fff:	89 f9                	mov    %edi,%ecx
  804001:	d3 e2                	shl    %cl,%edx
  804003:	8b 44 24 08          	mov    0x8(%esp),%eax
  804007:	88 d9                	mov    %bl,%cl
  804009:	d3 e8                	shr    %cl,%eax
  80400b:	09 c2                	or     %eax,%edx
  80400d:	89 d0                	mov    %edx,%eax
  80400f:	89 f2                	mov    %esi,%edx
  804011:	f7 74 24 0c          	divl   0xc(%esp)
  804015:	89 d6                	mov    %edx,%esi
  804017:	89 c3                	mov    %eax,%ebx
  804019:	f7 e5                	mul    %ebp
  80401b:	39 d6                	cmp    %edx,%esi
  80401d:	72 19                	jb     804038 <__udivdi3+0xfc>
  80401f:	74 0b                	je     80402c <__udivdi3+0xf0>
  804021:	89 d8                	mov    %ebx,%eax
  804023:	31 ff                	xor    %edi,%edi
  804025:	e9 58 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  80402a:	66 90                	xchg   %ax,%ax
  80402c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804030:	89 f9                	mov    %edi,%ecx
  804032:	d3 e2                	shl    %cl,%edx
  804034:	39 c2                	cmp    %eax,%edx
  804036:	73 e9                	jae    804021 <__udivdi3+0xe5>
  804038:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80403b:	31 ff                	xor    %edi,%edi
  80403d:	e9 40 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  804042:	66 90                	xchg   %ax,%ax
  804044:	31 c0                	xor    %eax,%eax
  804046:	e9 37 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  80404b:	90                   	nop

0080404c <__umoddi3>:
  80404c:	55                   	push   %ebp
  80404d:	57                   	push   %edi
  80404e:	56                   	push   %esi
  80404f:	53                   	push   %ebx
  804050:	83 ec 1c             	sub    $0x1c,%esp
  804053:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804057:	8b 74 24 34          	mov    0x34(%esp),%esi
  80405b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80405f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804067:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80406b:	89 f3                	mov    %esi,%ebx
  80406d:	89 fa                	mov    %edi,%edx
  80406f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804073:	89 34 24             	mov    %esi,(%esp)
  804076:	85 c0                	test   %eax,%eax
  804078:	75 1a                	jne    804094 <__umoddi3+0x48>
  80407a:	39 f7                	cmp    %esi,%edi
  80407c:	0f 86 a2 00 00 00    	jbe    804124 <__umoddi3+0xd8>
  804082:	89 c8                	mov    %ecx,%eax
  804084:	89 f2                	mov    %esi,%edx
  804086:	f7 f7                	div    %edi
  804088:	89 d0                	mov    %edx,%eax
  80408a:	31 d2                	xor    %edx,%edx
  80408c:	83 c4 1c             	add    $0x1c,%esp
  80408f:	5b                   	pop    %ebx
  804090:	5e                   	pop    %esi
  804091:	5f                   	pop    %edi
  804092:	5d                   	pop    %ebp
  804093:	c3                   	ret    
  804094:	39 f0                	cmp    %esi,%eax
  804096:	0f 87 ac 00 00 00    	ja     804148 <__umoddi3+0xfc>
  80409c:	0f bd e8             	bsr    %eax,%ebp
  80409f:	83 f5 1f             	xor    $0x1f,%ebp
  8040a2:	0f 84 ac 00 00 00    	je     804154 <__umoddi3+0x108>
  8040a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8040ad:	29 ef                	sub    %ebp,%edi
  8040af:	89 fe                	mov    %edi,%esi
  8040b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040b5:	89 e9                	mov    %ebp,%ecx
  8040b7:	d3 e0                	shl    %cl,%eax
  8040b9:	89 d7                	mov    %edx,%edi
  8040bb:	89 f1                	mov    %esi,%ecx
  8040bd:	d3 ef                	shr    %cl,%edi
  8040bf:	09 c7                	or     %eax,%edi
  8040c1:	89 e9                	mov    %ebp,%ecx
  8040c3:	d3 e2                	shl    %cl,%edx
  8040c5:	89 14 24             	mov    %edx,(%esp)
  8040c8:	89 d8                	mov    %ebx,%eax
  8040ca:	d3 e0                	shl    %cl,%eax
  8040cc:	89 c2                	mov    %eax,%edx
  8040ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040d2:	d3 e0                	shl    %cl,%eax
  8040d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040dc:	89 f1                	mov    %esi,%ecx
  8040de:	d3 e8                	shr    %cl,%eax
  8040e0:	09 d0                	or     %edx,%eax
  8040e2:	d3 eb                	shr    %cl,%ebx
  8040e4:	89 da                	mov    %ebx,%edx
  8040e6:	f7 f7                	div    %edi
  8040e8:	89 d3                	mov    %edx,%ebx
  8040ea:	f7 24 24             	mull   (%esp)
  8040ed:	89 c6                	mov    %eax,%esi
  8040ef:	89 d1                	mov    %edx,%ecx
  8040f1:	39 d3                	cmp    %edx,%ebx
  8040f3:	0f 82 87 00 00 00    	jb     804180 <__umoddi3+0x134>
  8040f9:	0f 84 91 00 00 00    	je     804190 <__umoddi3+0x144>
  8040ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  804103:	29 f2                	sub    %esi,%edx
  804105:	19 cb                	sbb    %ecx,%ebx
  804107:	89 d8                	mov    %ebx,%eax
  804109:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80410d:	d3 e0                	shl    %cl,%eax
  80410f:	89 e9                	mov    %ebp,%ecx
  804111:	d3 ea                	shr    %cl,%edx
  804113:	09 d0                	or     %edx,%eax
  804115:	89 e9                	mov    %ebp,%ecx
  804117:	d3 eb                	shr    %cl,%ebx
  804119:	89 da                	mov    %ebx,%edx
  80411b:	83 c4 1c             	add    $0x1c,%esp
  80411e:	5b                   	pop    %ebx
  80411f:	5e                   	pop    %esi
  804120:	5f                   	pop    %edi
  804121:	5d                   	pop    %ebp
  804122:	c3                   	ret    
  804123:	90                   	nop
  804124:	89 fd                	mov    %edi,%ebp
  804126:	85 ff                	test   %edi,%edi
  804128:	75 0b                	jne    804135 <__umoddi3+0xe9>
  80412a:	b8 01 00 00 00       	mov    $0x1,%eax
  80412f:	31 d2                	xor    %edx,%edx
  804131:	f7 f7                	div    %edi
  804133:	89 c5                	mov    %eax,%ebp
  804135:	89 f0                	mov    %esi,%eax
  804137:	31 d2                	xor    %edx,%edx
  804139:	f7 f5                	div    %ebp
  80413b:	89 c8                	mov    %ecx,%eax
  80413d:	f7 f5                	div    %ebp
  80413f:	89 d0                	mov    %edx,%eax
  804141:	e9 44 ff ff ff       	jmp    80408a <__umoddi3+0x3e>
  804146:	66 90                	xchg   %ax,%ax
  804148:	89 c8                	mov    %ecx,%eax
  80414a:	89 f2                	mov    %esi,%edx
  80414c:	83 c4 1c             	add    $0x1c,%esp
  80414f:	5b                   	pop    %ebx
  804150:	5e                   	pop    %esi
  804151:	5f                   	pop    %edi
  804152:	5d                   	pop    %ebp
  804153:	c3                   	ret    
  804154:	3b 04 24             	cmp    (%esp),%eax
  804157:	72 06                	jb     80415f <__umoddi3+0x113>
  804159:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80415d:	77 0f                	ja     80416e <__umoddi3+0x122>
  80415f:	89 f2                	mov    %esi,%edx
  804161:	29 f9                	sub    %edi,%ecx
  804163:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804167:	89 14 24             	mov    %edx,(%esp)
  80416a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80416e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804172:	8b 14 24             	mov    (%esp),%edx
  804175:	83 c4 1c             	add    $0x1c,%esp
  804178:	5b                   	pop    %ebx
  804179:	5e                   	pop    %esi
  80417a:	5f                   	pop    %edi
  80417b:	5d                   	pop    %ebp
  80417c:	c3                   	ret    
  80417d:	8d 76 00             	lea    0x0(%esi),%esi
  804180:	2b 04 24             	sub    (%esp),%eax
  804183:	19 fa                	sbb    %edi,%edx
  804185:	89 d1                	mov    %edx,%ecx
  804187:	89 c6                	mov    %eax,%esi
  804189:	e9 71 ff ff ff       	jmp    8040ff <__umoddi3+0xb3>
  80418e:	66 90                	xchg   %ax,%ax
  804190:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804194:	72 ea                	jb     804180 <__umoddi3+0x134>
  804196:	89 d9                	mov    %ebx,%ecx
  804198:	e9 62 ff ff ff       	jmp    8040ff <__umoddi3+0xb3>
