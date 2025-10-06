
// this constant label 'one' cannot change
.equ one, 1

.data

i1: .byte 0
i2: .byte 7

// this label currVar can change    
.set currVar, 0
i3: .byte currVar
.set currVar, 2
i4: .byte currVar

// see comment below on align
.align 2
word3: .word 3

// use align to get the proper alignment
// e.g. 2^4 = 8 bytes for 64bit float
.align 4
f1: .double 1.11111

.text
.global _main, main
.align 2

someFunc:
    mov x4, #7
    mov x5, #2
    add x6, x4, x5
    ret

_main:
main:
    // use .req to create a register alas
    xZeroReg .req x0

    // load a variable into a register
    adrp x1, i2@PAGE
    add x1, x1, i2@PAGEOFF
    
    // moving and storing
    ldr x0, [x1]
    mov x0, #8
    str x0, [x1]
    // check that the value at i2 is now 8
    ldr x2, [x1]

    mov x3, #8
    mov x4, #9

    adds x5, x3, x4
    subs x6, x3, x4

    // we need to shuffle the lr register here
    // so we don't lose the return address in lr
    mov x1, lr
    bl someFunc
    mov lr, x1

    ret