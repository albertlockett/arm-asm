.data

left_op:    .dword 0xf0f0f0f0
right_op1:  .dword 0x0f0f0f0f
right_op2:  .dword 0x12345678
result:     .dword 0x0
save_lr:    .dword 0x0
fmt_str1:   .asciz "%lx AND %lx = %lx\n"
fmt_str2:   .asciz "%lx OR  %lx = %lx\n"
fmt_str3:   .asciz "%lx XOR %lx = %lx\n"
fmt_str4:   .asciz "NOT %lx = %lx\n"
title:       .asciz "listing 2.5"


.text
.global _get_title, get_title
.global _asm_main, asm_main

.align 2

_get_title:
get_title:
    // load the address of title into x0
    adrp x0, title@PAGE
    add x0, x0, title@PAGEOFF
    ret

_asm_main:
asm_main:
    // save the LR register before calling printf
    adrp x0, save_lr@PAGE
    add x0, x0, save_lr@PAGEOFF
    str lr, [x0]

    // in mac OS, variable params go on the stack

    // make some room on the stack
    sub sp, sp, #64

    // Demonstrate the AND operation:
    adrp x0, left_op@PAGE
    add x0, x0, left_op@PAGEOFF
    ldr x1, [x0]
    adrp x0, right_op1@PAGE
    add x0, x0, right_op1@PAGEOFF
    ldr x2, [x0]
    and x3, x2, x1
    adrp x0, result@PAGE
    add x0, x0, result@PAGEOFF
    str x3, [x0]

    // push left_op onto stack
    adrp x1, left_op@PAGE
    add x1, x1, left_op@PAGEOFF
    ldr x1, [x1]
    str x1, [sp]

    // push left_op onto stack
    adrp x1, right_op1@PAGE
    add x1, x1, right_op1@PAGEOFF
    ldr x1, [x1]
    str x1, [sp, #8]

    // push result onto stack
    adrp x1, result@PAGE
    add x1, x1, result@PAGEOFF
    ldr x1, [x1]
    str x1, [sp, #16]

    // print the result
    adrp x0, fmt_str1@PAGE
    add x0, x0, fmt_str1@PAGEOFF

    bl _printf
b2:
    // do same thing for OR
    adrp x0, left_op@PAGE
    add x0, x0, left_op@PAGEOFF
    ldr x1, [x0]
    adrp x0, right_op1@PAGE
    add x0, x0, right_op1@PAGEOFF
    ldr x2, [x0]
    orr x3, x2, x1

    adrp x0, result@PAGE
    add x0, x0, result@PAGEOFF
    str x3, [x0]

    // push left_op onto stack
    adrp x1, left_op@PAGE
    add x1, x1, left_op@PAGEOFF
    ldr x1, [x1]
    str x1, [sp]

    // push left_op onto stack
    adrp x1, right_op1@PAGE
    add x1, x1, right_op1@PAGEOFF
    ldr x1, [x1]
    str x1, [sp, #8]

    // push result onto stack
    adrp x1, result@PAGE
    add x1, x1, result@PAGEOFF
    ldr x1, [x1]
    str x1, [sp, #16]

    // print the result
    adrp x0, fmt_str2@PAGE
    add x0, x0, fmt_str2@PAGEOFF

    bl _printf

    // TODO same thing for not, etc

    // pop the stack
    add sp, sp, #64

    // restore the LR register
    adrp x0, save_lr@PAGE
    add x0, x0, save_lr@PAGEOFF
    ldr lr, [x0]
    

    ret

