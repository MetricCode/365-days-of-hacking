# Reverse Engineering

## Stack Canaries
Stack canaries (also known as "stack cookies") are a security feature that is used to help detect and prevent stack buffer overflow attacks.

In a stack buffer overflow attack, an attacker attempts to write data beyond the bounds of a fixed-size buffer that is stored on the program's call stack. If the attacker is successful, they may be able to modify the program's sensitive data (such as local variables and function arguments) and potentially take control of the program's execution.

To help prevent these types of attacks, many programs use stack canaries to place a special "canary" value on the stack just before the program's sensitive data. The canary value is chosen such that it is highly unlikely to occur as part of the program's normal execution.

If an attacker attempts to overflow the buffer and modify the sensitive data, they will also overwrite the canary value. When the program checks the value of the canary, it will detect that the value has been changed and terminate the program before any damage can be done. This helps to prevent the attacker from taking control of the program's execution and potentially causing harm.

Stack canaries can be implemented in a program using special functions and compiler support. In C, the `__stack_chk_guard` symbol is often used to hold the value of the stack canary, and the `__stack_chk_fail` function is called to handle a detected stack buffer overflow. In assembly language, the `__stack_chk_guard` symbol and the `__stack_chk_fail` function can be implemented using special directives and instructions.

Stack canaries can be detected and analyzed through static analysis of the program's binary or by attempting to trigger a stack buffer overflow and observing the program's behavior. This can be useful for security researchers and reverse engineers who are attempting to identify vulnerabilities in a program and develop ways to exploit them.

### Comparison
`test eax, eax` - tests whether EAX is zero or not and sets or unsets the ZF bit. It is the same as `and eax, eax` (bitwise and) except that it doesn't store the result in eax. So eax isn't affected by the test, but the zero-flag is, for example.

`strcmp` stores the results in the eax register. Any other value apart from 0 inside the eax after the `strcmp` means the strings are not equal. If it is 0 they are.
