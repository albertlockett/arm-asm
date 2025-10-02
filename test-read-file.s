.data
location: .asciz "/Users/albertlockett/Development/aoa_arm64/test_read_file_input.txt"
location_len: .word 67

// 6 is the line length
read_buf: .space 6

// this is the result
total: .word 0

.text
.global _main, main
.global _read_line, read_line
.global _left_bigger, left_bigger
.global _finish, finish

.global _b1, b1

.align 2
_main:
main:
    // move filename into register 0
    adrp x0, location@PAGE
    add x0, x0, location@PAGEOFF

    mov x1, #0 // move readonly flag into register 1
    mov x2, #0 // move mode into register 2
    mov x16, #5 // move open syscall (5) into the register 16
    svc     #0 // open file

    // TODO handle if filename open was unsuccessful
    // e.g. if x0 < 0

    // safe the file descriptor for later
    mov x19, x0

    // we'll use this to store the total
    // TODO instead of using this, we should store the value in memory
    mov x21, #0

read_line:
    mov x0, x19 // move the file descriptor into x0
    // move the read_buffer into x1
    adrp x1, read_buf@PAGE
    add x1, x1, read_buf@PAGEOFF
    mov x2, #6  // move number of bytes to read into x2
    mov x16, #3 // move the syscall read (3) into syscall reg
    svc #0

    cmp x0, xZR
    ble finish

    // now going to decode the line

    adrp x1, read_buf@PAGE
    add x1, x1, read_buf@PAGEOFF

    // load the ascii bytes of what we just read
    ldrb w3, [x1]
    ldrb w4, [x1, #4]

    // convert ascii to decimal
    sub x3, x3, #0x30
    sub x4, x4, #0x30

    // load the address of the total
    adrp x1, total@PAGE
    add x1, x1, total@PAGEOFF

    // load the actual total
    ldr x2, [x1]

    // check which one was bigger & increment
    cmp x3, x4
    bgt left_bigger
    
    // here the right value was bigger
    add x2, x2, x4
    str x2, [x1]
    b read_line

    // here (clearly) the left value was bigger
left_bigger:
    add x2, x2, x3
    str x2, [x1]
    b read_line

finish:
    // load the address of the total
    adrp x1, total@PAGE
    add x1, x1, total@PAGEOFF

    // load the actual total
    ldr x2, [x1]

    ret

