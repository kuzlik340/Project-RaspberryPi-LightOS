.section .text
.global start

start:
    mrs x0, mpidr_el1
    and x0, x0, #3
    cmp x0, #0
    beq kernel_entry

end:
    b end

kernel_entry:
    mov sp, #0x80000
    bl KMain
    b end
    