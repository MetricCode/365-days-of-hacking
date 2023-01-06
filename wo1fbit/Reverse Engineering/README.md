## Reverse Engineering

### Comparison
`test eax, eax` - tests whether EAX is zero or not and sets or unsets the ZF bit. It is the same as `and eax, eax` (bitwise and) except that it doesn't store the result in eax. So eax isn't affected by the test, but the zero-flag is, for example.

`strcmp` stores the results in the eax register. Any other value apart from 0 inside the eax after the `strcmp` means the strings are not equal. If it is 0 they are.
