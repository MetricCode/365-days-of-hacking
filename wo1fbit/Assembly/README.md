# Assembly
There are many "flavours" of Assembly and since I'm an "original" type of guy, I prefer writing my Assembly in AT&T syntax.

## Sections
Every assembly program is divided into 3 distinct sections, with each having it's own purpose. These sections are:

* data section
* text section
* Bss section

1. Data section - this section is used to hold data that doesn't change in value when the program is run. They stay the same on program start and finish. They are what you might refer to as constants.

2. Bss section - this section is used to hold unitialized data. The data might/not change when program is run. They are what we refer to as variables.

3. Text section - the magic happens here. All the code thaat is going to be executed by the program is stored here.

You may omit the data and bss section if they are not needed at all the program.
You declare a section by using `.section`:

~~~
.section .data - declaring the data section
.section .text - declaring the text section
.section .bss - declaring the bss section

~~~

## Data Movement
When we want to move data from one register to another or from memory to memory or register to memory and vise versa, we use the `mov` opcode.

Syntax
~~~
mov src, dest
~~~

Note: `in AT&T when loading data in memory the source comes first followed by the destination e.g opcode src, dest .The "%" symbol is prefixed for each register reference and a "$" for immediate operands.`

The opcode is the instruction that is executed by the CPU and the operand is the data or memory location used to execute that instruction. For the case above, `mov` is the opcode while the rest are the operands.

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
