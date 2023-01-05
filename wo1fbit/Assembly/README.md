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
