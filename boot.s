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
    /* check current exception level */
    mrs currentel
    lsr x0, x0, #2
    /* if exception level is not 2 then block booting */
    cmp x0, #2
    bne end

    /* init the EL1 with 0's */
    msr sctlr_el1, xzr
    /* set 31 bit as it will boot EL1 in aarch64 mode */
    mov x0, #(1 << 31)
    msr hcr_el2, x0
    /* turning off interrupts, setting EL1 to execute, set aarch64 mode */
    mov x0, #0b1111000101
    msr spsr_el2, x0
    /* set an address of el1_entry into x0 reg */
    adr x0, el1_entry
    /* seeting address of instruction that has to be executed
     * after leaving EL2 */
    msr elr_el2, x0
    /* go to EL1 */
    eret

el1_entry:    
    /* stack pointer to address 80000 */
    mov sp, #0x80000
    /* call Kernel, put seatbelts, we are starting */
    bl KMain
    b end
    










    