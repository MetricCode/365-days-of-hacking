# Assembly
There are many flavors of assembly language, each with its own unique syntax and features. Personally, I prefer to write my assembly code using AT&T syntax.

Every assembly program is divided into three distinct sections, each with a specific purpose:

## Sections
Every assembly program is divided into 3 distinct sections, with each having it's own purpose. These sections are:

* Data section
* Text section
* BSS (Block Started by Symbol) section

1. Data section - Data section - this section is used to hold data that doesn't change in value when the program is run. They remain the same from program start to finish. They can be thought of as constants.

2. BSS section - this section is used to hold uninitialized data. The data may or may not change when the program is run. They are what we refer to as variables.

3. Text section - the magic happens here. All the code that is going to be executed by the program is stored here.

A section is declared by using `.section section_name`.
~~~
.section .data - declare the data section
.section .text - declare the text section
.section .bss - declare the bss section
~~~

To summarize, a basic template for an assembly program in AT&T syntax looks like this:
~~~
.section .data ; remember this is optional depending on what you're doing
.section .text
.globl _start ; define the _start label marking where the program starts
_start:        ; lables are declared by giving the name of the label followed by a colon
[instructions]
.section .bss ; this is optionsal depending on what you're doing
~~~

## Data Movement

To move data from one location to another (e.g. from a register to memory, from memory to a register, etc.), you can use the mov instruction. The syntax is as follows:
~~~
mov src, dest
~~~

Note that in AT&T syntax, the source comes before the destination (e.g. mov src, dest). The % symbol is used to refer to registers, and the $ symbol is used for immediate operands.

The opcode (e.g. mov) is the instruction that is executed by the CPU, and the operands (e.g. src and dest) are the data or memory locations used in the instruction.

### Operand Sizes

In x86 assembly, you can specify the size of an operand using suffixes on the opcodes and operands. For example, the mov opcode has different variants for moving different sizes of data: movb for moving a byte (8 bits), movw for moving a word (16 bits), and movl for moving a long (32 bits). If you don't specify a size, the assembler will use the default size for the current mode (16 bits for real mode, 32 bits for protected mode).

## Registers
Registers are used to hold data for our programs, with different registers having specific functions.
Types of Registers:
* Status and control registers.
* General-purpose data registers.
* Special purpose register.

#### Status and Control Register:
Status and Control registers report and allow modification of the state of the processor and of the program being executed.

#### General-Purpose Data Registers: 
General purpose registers are extra registers that are present in the CPU and are utilized anytime data or a memory location is required. These registers are used for storing operands and pointers. These are mainly used for holding the following:

* Operands for logical and arithmetic operations
* Operands for address calculation
* Memory pointers

There are 3 types of General-purpose data registers they are:

1. Data registers: Data registers consists of four 32-bit data registers, which are used for arithmetic, logical and other operations. Data registers are again classified into 4 types they are:

    AX: This is known as the accumulator register. Its 16 bits are split into two 8-bit registers, AH and AL, allowing it to execute 8-bit instructions as well. In 8086 microprocessors, it is used in the arithmetic, logic, and data transfer instructions. One of the numbers involved in manipulation and division must be in AX or AL.
    BX: This is called a Base register. It has 16 bits and is split into two registers with 8 bits each, BH and BL. An address register is the BX  register. It typically includes a data pointer for indirect addressing that is based, based indexed, or register-based.
    CX: This is known as the Count register. Its 16 bits are split into two 8-bit registers, CH and CL, allowing it to execute 8-bit instructions as well. This acts as a counter for loops. It facilitates the development of program loops. Shift/rotate instructions and string manipulation both allow the use of the count register as a counter.
    DX: This is known as the Data register. Its 16 bits are split into two 8-bit registers, DH and DL so that it can execute 8-bit instructions as well. In I/O operations, the data register can be used as a port number. It is also applied to division and multiplication.

2. Pointer registers: The pointer registers consist of 16-bit left sections (SP, and BP) and 32-bit ESP and EBP registers.

    SP: This is known as a Stack pointer used to point the program stack. For accessing the stack segment, it works with SS. It has a 16-bit size. It designates the item at the top of the stack. The stack pointer will be (FFFE)H if the stack is empty. The stack segment is relative to its offset address.
    BP: This is known as the Base pointer used to point data in the stack segments. We can utilize BP to access data in the other segments, unlike SP. It has a 16-bit size. It mostly serves as a way to access parameters given via the stack. The stack segment is relative to its offset address.

Index registers: The 16-bit rightmost bits of the 32-bit ESI and EDI index registers. SI and DI are sometimes employed in addition and sometimes in subtraction as well as for indexed addressing.

     SI: This source index register is used to identify memory addresses in the data segment that DS is addressing. Therefore, it is simple to access successive memory locations when we increment the contents of SI. It has a 16-bit size. Relative to the data segment, it has an offset.
    DI: The function of this destination index register is identical to that of SI. String operations are a subclass of instructions that employ DI to access the memory addresses specified by ES. It is generally used as a Destination index for string operations.

3. Special Purpose Registers:

To store machine state data and change state configuration, special purpose registers are employed. In other words, it is also defined as the CPU has a number of registers that are used to carry out instruction execution these registers are called special purpose registers. Special purpose registers are of 8 types they are cs, ds, ss, es, fs, and gs registers come under segment registers. These registers hold up to six segment selectors. 

    CS (Code Segment register): A 16-bit register called a code segment (CS) holds the address of a 64 KB section together with CPU instructions. All accesses to instructions referred to by an instruction pointer (IP) register are made by the CPU using the CS segment. Direct changes to CS registration are not possible. When using the far jump, far call, and far return instructions, the CS register is automatically updated.
     DS (Data Segment register): A 64KB segment of program data is addressed using a 16-bit register called the data segment. The processor by default believes that the data segment contains all information referred to by the general registers (AX, BX, CX, and DX) and index registers (SI, DI). POP and LDS commands can be used to directly alter the DS register.
     SS (Stack Segment register): A 16-bit register called a stack segment holds the address of a 64KB segment with a software stack. The CPU by default believes that the stack segment contains all information referred to by the stack pointer (SP) and base pointer (BP) registers. POP instruction allows for direct modification of the SS register.
     ES (Extra Segment register): A 16-bit register called extra segment holds the address of a 64KB segment, typically holding program data. In string manipulation instructions, the CPU defaults to assuming that the DI register refers to the ES segment. POP and LES commands can be used to directly update the ES register.
     FS (File Segment register): FS registers don’t have a purpose that is predetermined by the CPU; instead, the OS that runs them gives them a purpose. On Windows processes, FS is used to point to the thread information block (TIB).
     GS (Graphics Segment register): The GS register is used in Windows 64-bit to point to operating system-defined structures. OS kernels frequently use GS to access thread-specific memory. The GS register is employed by Windows to control thread-specific memory. In order to access CPU-specific memory, the Linux kernel employs GS. A pointer to a thread local storage, or TLS, is frequently used as GS.
     IP (Instruction Pointer register): The registers CS and IP are used by the 8086 to access instructions. The segment number of the following instruction is stored in the CS register, while the offset is stored in the IP register. Every time an instruction is executed, IP is modified to point to the upcoming instruction. The IP cannot be directly modified by an instruction, unlike other registers; an instruction may not have the IP as its operand.
     Flag register: The status register for an x86 CPU houses its current state, and it is called the FLAGS register. The flag bits’ size and significance vary depending on the architecture. It often includes information about current CPU operation limitations as well as the outcome of mathematical operations. Some of these limitations might forbid the execution of a particular class of “privileged” instructions and stop some interrupts from triggering. Other status flags may override memory mapping and specify the response the CPU should have in the event of an arithmetic overrun.


## Arithmetic
### Addition

The `add` opcode is used to perform addition operations. The results are stored in the second operand.
To add the number 4 to the eax register:

~~~
add $4, %eax
~~~

### Multiplication
The `imul` opcode is used for multiplication. The second operand holds the results.
To mulitply the values inside the rdi and rsi registers and save results in %rsi:

~~~
imul %rdi, $rsi
~~~

### Division
The `div` opcode is used for division. However x86 division is different from normal math in such that it is integer division. Normally 10/3 = 10.3 but in integer division 10/3 = 3. Why? In integer division, 3.33 gets rounded to 3.

For this operation, the `rax` register is loaded by the divided (for those who like maths: in 10/3, 10 is the divided while 3 is the divisor). then the opcode is called with the divisor as it's only operand. The result is placed in the rdx register.

For example, speed = distance / time. To calculate the speed in assembly, you will first load distance in the rax register, load time in another register, say rdi. The rsult code would be:

For this our distance is 40 metres and time is 8 seconds

```
mov $40, %rax ; load dist into rax
mov $8, %rdi ; load time into rdi
div %rdi ; divide whatever is in rax with rdi, the remainder store in rdx

```

## The Stack
The stack is a location in memory that is used to store data during program execution. It starts from high memory addresses to low memoery addresses. It stores data using a first in last out policy. This is because data just "stacks" ip the other. Imagine a stack of plates, the one on the bottom was the first one while the one on the top is the last one to get placed. To get the first plate that is on the bottom you ave to remove all the others first in the order in which they were placed. To place data on top of the stack we use the `push` opcode while to remove the current data on top of the stock we use the `pop` opcode.

Syntax:
~~~
push $4; push the value 4 on top of the stack
pop %eax; remove the data on top of the stack which is 4 and place it in the eax register
~~~

## Jumps
* `jmp location` - jump (unconditional)
* `je` - jump if equal
* `jne location` - jump if not equal
* `jns location` - Jump if not signed (Jump if positive). Jumps to the destination label mentioned in the instruction if the SF is set, else no action is taken. If the sign flag is 0 it indicates a positive signed number. Hence the instruction causes a jump if the result of previous instruction is positive.
* `jg location` - jump if greater. It performs a signed comparison jump after a `cmp` if the destination operand is greater than the source operand

## hello World !
~~~
; this part of the program is explained below

.section .data
message:
.asciz "Hello World!\n"
message_len:
.equ len, message_len-message
.section .text
.globl _start
_start:

movl $message, %ecx
movl $len, %edx
movl $1, %ebx
movl $4, %eax
int $0x80

; this part of the code is where  we exit. When a program exits gracefully, the status code is 0, anything else means there was
; problem unless stated otherwise. The ebx register holds the exit status code of the program. Since we want to exit, we put the system
; exit call 1 in the eax register then we call the kernel with the int instruction.

movl $0, %ebx
movl $1, %eax
int $0x80
~~~

When assembled and ran, the above program prints "Hello World!" to the terminal.

The hello world program is explained as follows.

1. The `ecx` register holds the data or location of the data to be printed.
2. The `edx` register holds the length of the data to be printed.
3. The `ebx` register holds the file descriptors of where to read or write the data. In our case, we use 2 as our fd since we are writing to stdout. In linux the default file descriptors are 0,1 and 2 with each fd referencing stdin, stdout and stderr respectively.
4. The `eax` register holds the system call. System calls are used by the program to ask the kernel for assistance with different system calls telling the kernel what is needed. Since we are writing, we use `4` as the system call number for write.

* `.section .data` - data section.
* `message:` - label that marks a place in memory where our message is.
* `.ascii "Hello World\n"` - the message. The .asciz directive accepts string literals as arguments. String literal are a sequence characters in double quotes. The string literals are assembled into consecutive memory locations. The assembler automatically inserts a nul character (\0 character) after each string. The .ascii directive is same as .asciz, but the assembler does not insert a null character after each string.
* `message_len:` - label that we use to get the length of our message.
* `.equ len, message_len-message` - `.equ` is a directive that tells the assembler that when it sees `len` anywhere it should replace it with the value of `message_len-message`. This makes it easy for us as the assembler calculates the len for us. This is because we would need to give `edx` the correct length of our message otherwise we would a get a shortened message.

To assemble the above program, we run:
the name of the file is learn.s

```
as -o learn.o learn.s ## create the object file
ld -o learn learn.o ## link the object file with the needed files ad save the binary as learn
```
Running the above commands every time we make changes to learn.s is tiring, to automate all steps of building the binary , we make use of Makefiles.
