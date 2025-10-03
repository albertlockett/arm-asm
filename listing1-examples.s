
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

_main:
main:
    // use .req to create a register alas
    xZeroReg .req x0

    // load a variable into a register
    adrp x1, i2@PAGE
    add x1, x1, i2@PAGEOFF
    
    ldr x0, [x1]
    mov x0, #8
    str x0, [x1]

    ldr x2, [x1]

    ret