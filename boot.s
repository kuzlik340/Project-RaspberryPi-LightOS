.section .text
.global start

start:
    /* check the mpidr_el1 register to see on what 
     * core this code is currently executing */
    mrs x0, mpidr_el1
    /* apply bit mask, we have to check only last
     * to see on what core we are */
    and x0, x0, #3
    /* if it is core 0 then start kernel */
    cmp x0, #0
    beq kernel_entry

/* if other core then core 0 just put core into sleep */
end:
    b end

kernel_entry:
    mrs currentel
    lsr x0, x0, #2
    cmp x0, #2
    bne end

    msr sctlr_el1, xzr
    mov x0, #(1 << 31)
    msr hcr_el2, x0
    mov x0, #0b1111000101
    msr spsr_el2, x0

    adr x0, el1_entry
    msr elr_el2, x0

    eret

el1_entry:    
    /* stack pointer to address 80000 */
    mov sp, #0x80000
    /* call Kernel, put seatbelts, we are starting */
    bl KMain
    b end
    










    