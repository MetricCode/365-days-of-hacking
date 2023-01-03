# Assembly
There are many "flavours" of Assembly and since I'm an "original" type of guy, I prefer writing my Assembly in AT&T syntax.

## Sections
Every assembly program is divided into 3 distinct sections, with each having it's own purpose. These sections are:

* data section
* text section
* Bss section

1. Data section
This section is used to hold data that doesn't change in value when the program is run. They stay the same on program start and finish. They are what you might refer to as constants.

2. Bss section
This section is used to hold unitialized data. The data might/not change when program is run. They are what we refer to as variables.

3. Text section
The magic happens in this section. All the code thaat is going to be executed by the program is stored here.

You may omit the data and bss section if they are not needed at all the program.
You declare a section by using `.section`:

~~~
.section .data - declaring the data section
.section .text - declaring the text section
.section .bss - declaring the bss section

~~~

## Registers
Registers are used to hold data for our programs, with different registers having specific functions.
Say you want to put the number 4 in the eax register you'd write this:

~~~
.section .text
.globl _start
_start:
movl $4, %eax
~~~

Note: `in AT&T when loading data in memory the source comes first followed by the destination e.g opcode src, dest .The "%" symbol is prefixed for each register reference and a "$" for immediate operands.`

The opcode is the instruction that is executed by the CPU and the operand is the data or memory location used to execute that instruction. For the case above, `movl` is the opcode while the rest are the operands.
