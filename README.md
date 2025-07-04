# FOS: FCIS Operating System

Welcome to the **FOS Project** — a hands-on, educational operating system built from scratch in C.  

This project is a student-made operating system built from scratch to help us understand how operating systems work by implementing its main parts step by step in three milestones.
It was developed as part of the Operating Systems course at Ain Shams University.
Supervised by Dr. Ahmed SalahEldin.

## Milestones Overview
### Milestone 1: Preprocessing
Focus: Command Prompt, System Calls, Dynamic Allocator, Locks

- Implement process_command() for handling user input.
- Add and manage system calls.
- Build a dynamic memory allocator using an explicit free list.
- Implement synchronization using locks.

 **Key Files:**

- kern/cmd/command_prompt.c
- lib/syscall.c
- kern/trap/syscall.c
- lib/dynamic_allocator.c
- lib/lock.c

### Milestone 2: Memory Management
Focus: Kernel Heap, User Heap, Shared Memory, Fault Handler (Placement)

- Implement kmalloc, kfree, kheap_physical_address, and kheap_virtual_address.
- Support user-level dynamic allocation via malloc, free, sys_sbrk.
- Handle memory sharing with smalloc() and sget().
- Manage page fault placement and validation.

**Key Files:**
- kern/mem/kheap.c
- lib/uheap.c
- kern/mem/chunk_operations.c
- kern/trap/fault_handler.c

### Milestone 3: CPU Features
Focus: Page Replacement, Semaphores, Priority Round-Robin Scheduling
- Implement Nth Chance Clock Page Replacement in page_fault_handler.
- Create user-level semaphores (create, get, wait, signal).
- Build a multi-level priority Round-Robin scheduler with starvation handling.

**Key Files:**
- kern/trap/fault_handler.c
- lib/semaphore.c
- kern/cpu/sched.c
- kern/cpu/sched_helpers.c

## Requirements
Watch this video to learn how to import and run the FOS Project Template in Eclipse:
   [How to import the FOS Project Template on Eclipse](https://youtu.be/e3u9z_KPPRk?si=oFrYpuIauBwIWgvp) 

## Testing
Each function can be tested using the provided test cases inside the FOS shell.

**Example Commands**
```
Copy code
FOS> run tpr1 11       # Test page replacement
FOS> run tsem1 100     # Test semaphore logic
FOS> run midterm 100   # Test concurrent modification
```

A successful test will print:
```
Congratulations!! test [TEST NAME] completed successfully.
```

> **Note:** Detailed descriptions for each milestone and all related test cases are available in the [`Appendices`](./Appendices/) folder.

## Contributors
- [Zeina Wady](https://github.com/zeinawady)
- [Basmala Ayman](https://github.com/basmala-ayman)
- [Kenzy Adel](https://github.com/KenzyAdel)
- [Sara Darwish](https://github.com/sara-saye)
- [Ruba Abdelsalam](https://github.com/Rrr3rrr2004)
- [Sara Eslam](https://github.com/Sara-Eslam)