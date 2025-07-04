/*
 * channel.c
 *
 *  Created on: Sep 22, 2024
 *      Author: HP
 */
#include "channel.h"
#include <kern/proc/user_environment.h>
#include <kern/cpu/sched.h>
#include <inc/string.h>
#include <inc/disk.h>

//===============================
// 1) INITIALIZE THE CHANNEL:
//===============================
// initialize its lock & queue
void init_channel(struct Channel *chan, char *name)
{
	strcpy(chan->name, name);
	init_queue(&(chan->queue));
}

//===============================
// 2) SLEEP ON A GIVEN CHANNEL:
//===============================
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// Ref: xv6-x86 OS code
void sleep(struct Channel *chan, struct spinlock* lk)
{

	struct Env *sara = get_cpu_proc(); //Get the current running process as
	//it's the one that needs to be blocked not the head of the ready queue and saving it in the sara pointer

	acquire_spinlock(&ProcessQueues.qlock);//Acquire the spin lock to protect the process queues
	release_spinlock(lk);// Release the spin lock of the current running process
						 // That was passed to the sleep function before blocking this process

	sara->env_status = ENV_BLOCKED;// Blocking the running process
	enqueue(&chan->queue, sara);// Enqueue the blocked process in the chan->queue

	sched(); // Schedule another ready process to be running and context switch from the previous running one
	acquire_spinlock(lk);// As I scheduled a new to process to be running then I need to reacquire the guard

	release_spinlock(&ProcessQueues.qlock);// Release the spin lock of that was protecting the process queues

	//TODO: [PROJECT'24.MS1 - #10] [4] LOCKS - sleep
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("sleep is not implemented yet");
	//Your Code is Here...
}

//==================================================
// 3) WAKEUP ONE BLOCKED PROCESS ON A GIVEN CHANNEL:
//==================================================
// Wake up ONE process sleeping on chan.
// The qlock must be held.
// Ref: xv6-x86 OS code
// chan MUST be of type "struct Env_Queue" to hold the blocked processes
void wakeup_one(struct Channel *chan)
{
	acquire_spinlock(&ProcessQueues.qlock);

	if (chan->queue.size != 0 ) // Make sure that the queue is not empty to wake up one blocked process
	{

		struct Env *sara= dequeue(&chan->queue); // Taking the front process in the queue to be awaken
		sara->env_status = ENV_READY;
	    enqueue(&ProcessQueues.env_ready_queues[0], sara); // Enqueue the awaken (ready) process to the ready queue in the highest priority index [0]
		//sched_insert_ready(sara);
	}
	else
		cprintf("There is nothing to be awaken\n"); // This message will be printed if the chan->queue is empty
	release_spinlock(&ProcessQueues.qlock);

	//TODO: [PROJECT'24.MS1 - #11] [4] LOCKS - wakeup_one
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wakeup_one is not implemented yet");
	//Your Code is Here...
}

//====================================================
// 4) WAKEUP ALL BLOCKED PROCESSES ON A GIVEN CHANNEL:
//====================================================
// Wake up all processes sleeping on chan.
// The queues lock must be held.
// Ref: xv6-x86 OS code
// chan MUST be of type "struct Env_Queue" to hold the blocked processes

void wakeup_all(struct Channel *chan)
{
	//TODO: [PROJECT'24.MS1 - #12] [4] LOCKS - wakeup_all
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wakeup_all is not implemented yet");
	//Your Code is Here...

	// Same logic of the wakeup_one
	// The only difference is that in the wakeup_all we use a loop instead of an if condition
	acquire_spinlock(&ProcessQueues.qlock);
	while (chan->queue.size != 0 )
	{

		struct Env *sara= dequeue(&chan->queue);

           sara->env_status = ENV_READY;
		   enqueue(&ProcessQueues.env_ready_queues[0], sara);
   		//sched_insert_ready(sara);

	}
	release_spinlock(&ProcessQueues.qlock);


}



