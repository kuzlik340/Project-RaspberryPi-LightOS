.section .text
.global start

start:
    /* check the mpidr_el1 register to see on what 
     * core this code is currently executing */
    mrs x0, mpidr_el1
    /* apply bit mask, we have to check only last
     * to see on what core we are */
    and x0, x0, #3
    cmp x0, #0
    beq kernel_entry    /* if it is core 0 then start kernel */

/* if other core then core 0 just put core into sleep */
end:
    b end

kernel_entry:
    mrs x0, currentel   /* check current exception level */
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
    
    /* init bss segment with 0's */
    ldr x0, =bss_start
    ldr x1, =bss_end
    sub x2, x1, x0
    mov x1, #0
    bl memset

    ldr x0, =vector_table
    msr vbar_el1, x0
    /* call Kernel, put seatbelts, we are starting */
    bl KMain
    mov x0, #0b1111000000
    msr spsr_el1, x0
    adr x0, el0_entry
    msr elr_el1, x0
    eret


el0_entry:
    wfi
    b end
    










    