/*
 * boot.s   v1.0
 *
 * Contains all boot functions to initialize system before
 * giving control to the kernel.
 *
 * T.Kuz    11.2024
 */

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
    beq kernel_entry            /* if it is core 0 then start go to kernel_entry */

/* if other core then core 0 just put core into sleep */
end:
    b end

kernel_entry:
    mrs x0, currentel   /* check current exception level */
    lsr x0, x0, #2      
    /* if exception level is not 2 then block booting, 
     * something went wrong */
    cmp x0, #2
    bne end

    /* init the EL1 with 0's since we will put our own parameters */
    msr sctlr_el1, xzr
    /* set 31 bit as it will boot EL1 in aarch64 mode */
    mov x0, #(1 << 31)
    msr hcr_el2, x0
    /* turning off interrupts, setting EL1 to execute, set aarch64 mode */
    mov x0, #0b1111000101
    msr spsr_el2, x0
    /* set an address of el1_entry into x0 reg */
    adr x0, el1_entry
    /* setting address of instruction that has to be executed
     * after leaving EL2 */
    msr elr_el2, x0
    /* go to EL1 */
    eret

el1_entry:    
    /* stack pointer to address 80000 */
    mov sp, #0x80000
    /* boot virtual memory */
    bl setup_vm
    /* enable memory map unit */
    bl enable_mmu
    
    /* init bss segment with 0's */
    ldr x0, =bss_start
    ldr x1, =bss_end
    sub x2, x1, x0
    mov x1, #0
    /* call memset function */
    bl memset

    /* set vector table for exceptions */
    ldr x0, =vector_table
    msr vbar_el1, x0
    /* since here we are working with enabled MMU we have to 
     * put 0xffff in the start because all kernel program 
     * is working in the memory starting from 0xffff000000000000.
     * All user programms will work from the 0x0 address. */
    mov x0, #0xffff000000000000
    /* setting stack pointer to the 0xffff000000080000. 
     * Same as 80000 in physical memory */
    add sp, sp, x0

    /* set address of the KMain into x0 */
    ldr x0, =KMain
    /* call Kernel, put seatbelts, we are starting */
    blr x0

    /* all of the instructions below will be 
     * for switching from el1 to el0 */
    mov x0, #0
    msr spsr_el1, x0
    adr x0, el0_entry
    msr elr_el1, x0
    eret


el0_entry:
    wfi
    b end
    










    