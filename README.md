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


## CPU Modes for IA-32
- Real Mode
- Protected Mode
- System Management Mode

## Memory Layout
![Memory Layout](img/memorylayout.png)

	Stack <-> (Shared Libs + Mappings) <-> Heap

###### Maps
`-/proc/pid/maps`
```shell
➜ pmap 
Usage:
 pmap [options] PID [PID ...]
```

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

### (FPU) Floating Point Unit or x87
	R7, R6, R5, R4, R3, R2, R1, R0 (8 bit)


### MMX | XMM
	TODO:- On the way

## Sections

- `section .data` The data section is used for declaring initialized data or constants.
- `section .bss` The bss section is used for declaring variables. *(block started by symbol)*
- `section .text` The text section is used for keeping the actual code.


## System calls
You can find it [here](SYSTEM_CALL.md)

```asm
section .text
global main ;must be declared for linker (ld) 
main:       ;tells linker entry point 
mov edx,len ;message length 
mov ecx,msg ;message to write 
mov ebx,1   ;file descriptor (stdout) 
mov eax,4   ;system call number (sys_write) 
int 0x80    ;call kernel
mov eax,1   ;system call number (sys_exit) 
int 0x80    ;call kernel 

section .data 
msg db 'Hello, world!', 0xa ;our dear string 
len equ $ - msg             ;length of our dear string
```

#### Compiling and Linking an Assembly Program in NASM
```shell
nasm -f elf hello.asm
ld -m elf_i386 -s -o hello hello.o
```

### Linux System Calls
You can make use of Linux system calls in your assembly programs. You need to take the following steps for
using Linux system calls in your program:
- Put the system call number in the EAX register.
- Store the arguments to the system call in the registers EBX, ECX, etc.
- Call the relevant interrupt (80h)
- The result is usually returned in the EAX register

> There are six registers that stores the arguments of the system call used. These are the EBX, ECX, EDX, ESI,
EDI, and EBP. These registers take the consecutive arguments, starting with the EBX register. If there are more
than six arguments then the memory location of the first argument is stored in the EBX register.

The following code snippet shows the use of the system call sys_write:
```asm
mov edx,4   ; message length
mov ecx,msg ; message to write
mov ebx,1   ; file descriptor (stdout)
mov eax,4   ; system call number (sys_write)
int 0x80    ; call kernel
```

The following code snippet shows the use of the system call sys_exit:
```asm
mov eax,1   ; system call number (sys_exit)
mov ebx,0   ; program return code (optional)
int 0x80    ; call kernel
```
*the value to put in EAX before you call int 80h*

## Addressing Modes

The three basic modes of addressing are:
- Register addressing
- Immediate addressing
- Memory addressing


### The MOV Instruction
Syntax of the MOV instruction is:
```asm
MOV destination, source
```

The MOV instruction may have one of the following five forms:
```asm
MOV register, register
MOV register, immediate
MOV memory, immediate
MOV register, memory
MOV memory, register
```

### Type specifiers

| Type Specifier | Bytes addressed |
|----------------|-----------------|
| `BYTE`	 | 1	 	   |
| `WORD`	 | 2		   |
| `DWORD`	 | 4 		   |
| `QWORD`	 | 8 		   |
| `TBYTE`	 | 10 		   |


## Assembly Variables

|Directive |Purpose           |Storage Space     |
|----------|------------------|------------------|
|`DB`      |Define Byte       |allocates 1 byte  |
|`DW`      |Define Word       |allocates 2 bytes |
|`DD`      |Define Doubleword |allocates 4 bytes |
|`DQ`      |Define Quadword   |allocates 8 bytes |
|`DT`      |Define Ten Bytes  |allocates 10 bytes|


```asm
choice DB 'y'
number DW 12345
neg_number DW -12345
big_number DQ 123456789
real_number1 DD 1.234
real_number2 DQ 123.456
```

### Allocating Storage Space for Uninitialized Data

There are five basic forms of the reserve directive:
|Directive | Purpose 		  |
|----------|----------------------|
|`RESB`    |Reserve a Byte        |
|`RESW`    | Reserve a Word       |
|`RESD`    | Reserve a Doubleword |
|`RESQ`    |Reserve a Quadword    |
|`REST`    | Reserve a Ten Bytes  |

**Note that:**
- Each byte of character is stored as its ASCII value in hexadecimal
- Each decimal value is automatically converted to its 16-bit binary equivalent and stored as a hexadecimal number
- Processor uses the little-endian byte ordering
- Negative numbers are converted to its 2's complement representation
- Short and long floating-point numbers are represented using 32 or 64 bits, respectively


## Logical Instructions

|SN |Instruction |Format                  |
|---|------------|------------------------|
|1  | `AND`        | `AND operand1, operand2` |
|2  | `OR`         | `OR operand1, operand2`  |
|3  | `XOR`        | `XOR operand1, operand2` |
|4  | `TEST`       | `TEST operand1, operand2`|
|5  | `NOT`        | `NOT operand1`           |


## Assembly Conditions

**Unconditional jump**  -> This is performed by the JMP instruction. Conditional execution often involves a transfer of control to the address of an instruction that does not follow the currently executing instruction. Transfer of control may be forward to execute a new set of instructions, or backward to re-execute the same steps.

**Conditional jump** -> This is performed by a set of jump instructions j depending upon the condition. The conditional instructions transfer the control by breaking the sequential flow and they do it by changing the offset value in IP.

### The CMP Instruction
```asm
CMP destination, source
```

### Unconditional Jump
```asm
JMP label
```

### Conditional Jump
| Instruction | Description                             | Flags tested |
|-------------|-----------------------------------------|--------------|
|JE/JZ        | Jump Equal or Jump Zero                 | ZF           |
|JNE/JNZ      | Jump not Equal or Jump Not Zero         | ZF           |
|JG/JNLE      | Jump Greater or Jump Not Less/Equal     | OF, SF, ZF   |
|JGE/JNL      | Jump Greater/Equal or Jump Not Less     | OF, SF       |
|JL/JNGE      | Jump Less or Jump Not Greater/Equal     | OF, SF       |
|JLE/JNG      | Jump Less/Equal or Jump Not Greater     | OF, SF, Z    |

## Look at
[Tutorialspoint](https://www.tutorialspoint.com/assembly_programming/assembly_tutorial.pdf)
[The Art of Assembly Language](http://www.staroceans.org/kernel-and-driver/The.Art.of.Assembly.Language.2nd.Edition.pdf)
[x86-64 Assembly](http://www.egr.unlv.edu/~ed/assembly64.pdf)
[Oracle ASM](https://docs.oracle.com/cd/E19641-01/802-1948/802-1948.pdf)


