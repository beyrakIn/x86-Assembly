# x86 Assembly Language and Shellcoding on Linux

-   Computer Architecture Basics
-   IA-32/64 Family
-   Compilers, Assemblers and Linkers
-   CPU Modes and Memory Addressing
-   Tools of the trade
    -   Nasm, Ld, Objdump, Ndisasm etc.
-   IA-32 Assembly Language
    -   Registers and Flags
    -   Program Structure for use with nasm
    -   Data Types
    -   Data Movement Instructions
    -   Arithmetic instructions
    -   Reading and Writing from memory
    -   Conditional instructions
    -   Strings and Loops
    -   Interrupts, Traps and Exceptions
    -   Procedures, Prologues and Epilogues
    -   Syscall structure and ABI for Linux
    -   Calling standard library functions
    -   FPU instructions
    -   MMX, SSE, SSE2 etc. instruction sets


## What is Assembly Language?
	- Low level programming language
	- Communicate with microprocessor
	- Specific to the processor family
	- An almost one-to-one correspodence with machine code

### Different Processors - Different Assembly Languages
	- Intel
	- ARM
	- MIPS

- find **CPU** details on the system
	- `lscpu`
	- `cat /proc/cpuinfo`


# IA-32 Architecture

## System Organization Basics

```
CPU 
Memory
I/O Devices

(System Bus)
```

- **Control Unit** - Retrieve/Decode instructions, Retrieve/Store data in memory
- **Execution Unit** - Actual execution of instruction happens here
- **Registers** - Internal memory locations used as *variables*
- **Flags** - Used to indicate various *event* when execution is happening

## Registers

	- General Purpose Registers
	- Segment Registers
	- Flags, EIP
	- Floating Point Unit Registers
	- MMX Registers
	- XMM Registers

### General Purpose Registers
	EAX, EBX, ECX, EDX | AX, BX, CX, DX | AH, BH, CH, DH | AL, BL, CL. DL |
	EIP, EBP, ESI, EDI | IP, BP, SI, DI |

`EAX` | Accumulato Register - used for storing operand data and result data
`EBX` | Base Register - Pointer to Data
`ECX` | Counter Register - Loop operations
`EDX` | Data Register - I/O Pointer

`ESI` / `EDI` | Data Pointer Registers for memory operations

`ESP` | Stack Pointer Register
`EBP` | Stack Data Pointer Register

### Segment Registers

	CS - Code
	DS - Data
	SS - Stack
	ES - Data
	FS - Data
	GS - Data (16 bit)

### EFLAGS Registers

	X ID Flag (ID) - 21 (bit position)
	X Virtual Interrupt Pending (VIP) -20
	X Virtual Interruot Flag (VIF) - 19
	X Alingment Check (AC) - 18
	X Virtual-8086 Mode (VM) - 17
	X Resumne Flag (RF) - 16
	X Nested Task (NT) - 14
	X I/O Privilege Level (IOPL) - 12, 13
	S Overflow Flag (OF) - 11
	C Direction Flag (DF) - 10
	X Interrupt Enable Flag (IF) - 9
	X Trap Flag (TF) - 8 
	S Sign Flag (SF) - 7
	S Zero Flag (ZF) - 6
	S Auxiliary Carry Flag (AF) - 4
	S Parity Flag (PF) - 2
	S Carry Flag (CF) - 0
	
	S Indicates a Status Flag 
	C Indicates a Control Flag
	X Indicates a System Flag

- **EIP** - Instruction Pointer

### Floating Point Unit or x87
	R7, R6, R5, R4, R3, R2, R1, R0 (8 bit)


### MMX | XMM

## Sections

- `section .data` The data section is used for declaring initialized data or constants.
- `section .bss` The bss section is used for declaring variables. 
- `section .text` The text section is used for keeping the actual code.

```asm
section .text
global main ;must be declared for linker (ld) main: ;tells linker entry point 
mov edx,len ;message length 
mov ecx,msg ;message to write 
mov ebx,1   ;file descriptor (stdout) 
mov eax,4   ;system call number (sys_write) 
int 0x80    ;call kernel
mov eax,1   ;system call number (sys_exit) 
int 0x80    ;call kernel 

section .data 
msg db 'Hello, world!', 0xa ;our dear string 
len equ $ - msg ;length of our dear string
```

#### Compiling and Linking an Assembly Program in NASM
```
nasm -f elf hello.asm
ld -m elf_i386 -s -o hello hello.o
```




## Look at
[Tutorialspoint](https://www.tutorialspoint.com/assembly_programming/assembly_tutorial.pdf)
[The Art of Assembly Language](http://www.staroceans.org/kernel-and-driver/The.Art.of.Assembly.Language.2nd.Edition.pdf)
[x86-64 Assembly](http://www.egr.unlv.edu/~ed/assembly64.pdf)
[Oracle ASM](https://docs.oracle.com/cd/E19641-01/802-1948/802-1948.pdf)


