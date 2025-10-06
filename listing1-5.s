
.data
save_lr: .dword 0
title: .asciz "listing 1.5"
hw_str: .asciz "hello world %d %d \n"
i: .word 6
j: .word 7

.text
.global _asm_main, asm_main
.global _get_title, get_title
.align 2

_asm_main:
asm_main:
    // save the LR register before calling printf
    adrp x0, save_lr@PAGE
    add x0, x0, save_lr@PAGEOFF
    str lr, [x0]

    // in mac OS, variable params go on the stack

    // make some room on the stack
    sub sp, sp, #64

    // push i into stack
    adrp x1, i@PAGE
    add x1, x1, i@PAGEOFF
    ldr x1, [x1]
    str x1, [sp]

    // push j into stack
    adrp x1, j@PAGE
    add x1, x1, j@PAGEOFF
    ldr x1, [x1]
    str x1, [sp, #8]

    // call printf
    adrp x0, hw_str@PAGE
    add x0, x0, hw_str@PAGEOFF
    bl _printf

    // pop the stack
    add sp, sp, #64

    // restore the LR register
    adrp x0, save_lr@PAGE
    add x0, x0, save_lr@PAGEOFF
    ldr lr, [x0]
    ret
    
_get_title:
get_title:
    // load the address of title into x0
    adrp x0, title@PAGE
    add x0, x0, title@PAGEOFF

    ret