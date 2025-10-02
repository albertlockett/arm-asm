
.data
hwStr: .asciz  "Hello, world!\n"

.text
.global _main, main

.align  2

_main:
main:
    adrp x0, hwStr@PAGE
    add x0, x0, hwStr@PAGEOFF

    mov     x1, x0              // arg1 = pointer to buffer
    mov     x2, #14             // arg2 = length of string
    mov     x16, #4             // syscall number (write)
    mov     x0, #1              // arg0 = fd = stdout
    svc     #0                  // syscall

    mov     x0, #0              // return 0

    ret