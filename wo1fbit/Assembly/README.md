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
