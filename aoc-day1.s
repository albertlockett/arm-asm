.data
location: .asciz "/Users/albertlockett/Development/aoa_arm64/test_read_file_input.txt"
location_len: .word 67

// enough space to read one line plus the newline
read_buf: .space 6

// for test input
// there are 6 lines, each has a 1 byte val, so we need 6 bytes
l_col: .space 6
r_col: .space 6

num_lines_read: .word 0
rows_sorted: .word 0
num_swaps: .word 0

.text
.global _main, main

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

read_line:
    mov x0, #3
    // x0 already contains the file descriptor
    adrp x1, read_buf@PAGE
    add x1, x1, read_buf@PAGEOFF
    mov x2, #6  // move number of bytes to read into x2
    mov x16, #3 // move the syscall read (3) into syscall reg
    svc #0

    // when we read to end of file, jump to where we do bubble sort
    cmp x0, #0
    beq sort_left

read_left:
    adrp x1, read_buf@PAGE
    add x1, x1, read_buf@PAGEOFF

    ldr x1, [x1]
    and x1, x1, #0xFF
    sub x1, x1, #0x30

    // read how many lines have been read (will be used later)
    adrp x3, num_lines_read@PAGE
    add x3, x3, num_lines_read@PAGEOFF
    ldr x3, [x3]

store_left:
    adrp x2, l_col@PAGE
    add x2, x2, l_col@PAGEOFF
    // offset by how many lines read
    add x2, x2, x3
    strb w1, [x2]


read_right:
    adrp x1, read_buf@PAGE
    add x1, x1, read_buf@PAGEOFF
    add x1, x1, #4

    ldr x1, [x1]
    and x1, x1, #0xFF
    sub x1, x1, #0x30

store_right:
    adrp x2, r_col@PAGE
    add x2, x2, r_col@PAGEOFF
    // offset by how many lines read
    add x2, x2, x3
    strb w1, [x2]

incr_lines_read:
    adrp x1, num_lines_read@PAGE
    add x1, x1, num_lines_read@PAGEOFF
    ldr x2, [x1]
    add x2, x2, #1
    strb w2, [x1]

// go back to the read line
    b read_line


sort_left:
    adrp x0, l_col@PAGE
    add x0, x0, l_col@PAGEOFF
    
    // offset the bytes we done sorted this pass
    adrp x3, rows_sorted@PAGE
    add x3, x3, rows_sorted@PAGEOFF
    ldr x3, [x3]
    and x3, x3, 0xFF
    add x0, x0, x3
    
    ldr x1, [x0]
    and x1, x1, 0xFF
    ldr x2, [x0, #1]
    and x2, x2, 0xFF
    cmp x1, x2
    bgt do_swap

swap_ret:
    // increment how many rows we sorted
    adrp x1, rows_sorted@PAGE
    add x1, x1, rows_sorted@PAGEOFF
    ldr x2, [x1]
    and x2, x2, 0xFF // TODO this wont' work when we have vals > 255
    add x2, x2, #1
    strb w2, [x1]

    // check if we swapped all thw rows
    adrp x0, num_lines_read@PAGE
    add x0, x0, num_lines_read@PAGEOFF
    ldr x0, [x0]
    and x0, x0, 0xFF // TODO this wont' work when we have vals > 255
    cmp x0, x2
    beq sort_pass_finish

    // sort more lines
    b sort_left

do_swap:
    strb w2, [x0]
    strb w1, [x0, #1]

    // increment # of swaps
    adrp x3, num_swaps@PAGE
    add x3, x3, num_swaps@PAGEOFF
    ldr x4, [x3]
    add x4, x4, #1
    strb w4, [x3]

    b swap_ret

sort_pass_finish:
    // load how many swaps we did
    adrp x0, num_swaps@PAGE
    add x0, x0, num_swaps@PAGEOFF
    ldr x1, [x0]
    and x1, x1, 0xFF

    cmp x1, #0
    beq sort_right

    // if we did some swaps, reset & do another pass
    mov x1, #0
    strb w1, [x0]

    // reset rows sorted
    adrp x8, rows_sorted@PAGE
    add x8, x8, rows_sorted@PAGEOFF
    mov x1, #0
    strb w1, [x8]

    b sort_left

sort_right:
    adrp x0, l_col@PAGE
    add x0, x0, l_col@PAGEOFF
    // placeholder
tmp1:
    mov x0, x0

fin:
    ret