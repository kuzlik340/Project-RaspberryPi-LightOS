/*
 * lib.s   v1.0
 *
 * This module contains all functions for MMU.
 *
 * T.Kuz    11.2024
 */

 /*
 * Small comment from developer:
 *
 * This module was a really big pain in the ass. 
 * If you will have some questions about this module 
 * you may contact me via issues on github.
 */
.equ MAIR_ATTR, (0x44 << 8)
.equ TCR_T0SZ,  (16) 
.equ TCR_T1SZ,  (16 << 16)
.equ TCR_TG0,   (0 << 14)
.equ TCR_TG1,   (2 << 30)
.equ TCR_VALUE, (TCR_T0SZ | TCR_T1SZ | TCR_TG0 | TCR_TG1)
.equ PAGE_SIZE, (2*1024*1024)

.global enable_mmu
.global setup_vm

enable_mmu:
    adr x0, pgd_ttbr1
    msr ttbr1_el1, x0

    /* there is no ttbr0_el0 so el0 and el1 
     * share same tables for MMU except the user 
     * space is using pgd_ttbr0 and kernel uses pgd_ttbr1 */
    adr x0, pgd_ttbr0
    msr ttbr0_el1, x0

    /* by this block MAIR_ATTR we are setting that we have two types of memory
     * if there will be a 0 at the end of PMD entity then it is device memory (peripheral area)
     * if there will be a 1 at the end of PMD entity then it is normal memory*/
    ldr x0, =MAIR_ATTR
    msr mair_el1, x0

    /* Setting parameters to the control block. Basic size of page is set to 4 KB 
     * but in the project we are using 2MB pages. This basic size do not blocking us to create 
     * bigger memory pages*/
    ldr x0, =TCR_VALUE
    msr tcr_el1, x0

    /* enabling MMU */
    mrs x0, sctlr_el1
    orr x0, x0, #1
    msr sctlr_el1, x0
    
    ret


setup_vm:
setup_kvm:
    /* creating one entry in PGD table */
    adr x0, pgd_ttbr1
    adr x1, pud_ttbr1
    orr x1, x1, #3
    str x1, [x0]
  
    /* creating one entry in PUD table */
    adr x0, pud_ttbr1
    adr x1, pmd_ttbr1
    orr x1, x1, #3
    str x1, [x0]

    /* setting a register 2 as border for addresses. 
     * 0x34000000 is a 'memory end' here and we are creating 
     * a memory for kernel and file system */
    mov x2, #0x34000000
    adr x1, pmd_ttbr1
    /* setting parameters for memory page */
    mov x0, #(1 << 10 | 1 << 2 | 1 << 0)

loop1:
    /* setting pages in PMD table until the address 
     * will reach 0x34000000 address */
    str x0, [x1], #8
    /* we are adding the page_size here without any trouble 
     * and flags won't be overwritten since page_size is 2 mb 
     * and only bits from 21 will be changed after each 'ADD' operation */
    add x0, x0, #PAGE_SIZE    
    cmp x0, x2
    blo loop1


    /* in this part we are creating a new element in PUD table for 
     * the peripheral area. Since the peripheral area on RPI 4B starts 
     * from 0xF0000000 (~3.75 GB). We have to set a new element in PUD with offset 24 since
     * we will pass 0(1st GB), 1st(2nd GB) and 2nd(3rd GB) elements. Then we will create new
     * element at the 24 byte offset from start of PUD_TTBR1*/

    adr x0, pud_ttbr1
    add x0, x0, #24
    /* store the address of PMD3 table */
    adr x1, pmd_3_ttbr1
    /* set paramenters as this elemnt of PUD contains a pointer to PMD */
    orr x1, x1, #3
    str x1, [x0]

    mov x2, #0x100000000        /* end of peripherals physical memory area */
    mov x0, #0xf0000000         /* start of peripherals physical memory area */

    adr x3, pmd_3_ttbr1
    /* putting an offset of peripheral area start in x4 */
    mov x4, #(0xf0000000 - 0xc0000000)
    /* by this block of code we will find the offset from pmd3_ttb1[0] to pmd3_ttbr1[n]
     * where n is pages that are between 0xC0000000 and 0xF0000000. So we can do it by divising
     * an offset at x4 by 2^21 and then we have to multiply it by 2^3 because the value in x1 will point to
     * pmd3_ttbr[n] and all of the elemnts in pmd3_ttbr have a size of 8 bytes. */
    lsr x1, x4, #(21 - 3)
    add x1, x1, x3

    /* setting type as device memory */
    orr x0, x0, #1
    orr x0, x0, #(1 << 10)

/* creating PMDs for the peripheral area adrresses */
loop2:
    str x0, [x1], #8
    add x0, x0, #PAGE_SIZE
    cmp x0, x2
    blo loop2


/* function to setup user virtual memory */
setup_uvm:
    adr x0, pgd_ttbr0
    adr x1, pud_ttbr0
    orr x1, x1, #3
    str x1, [x0]

    adr x0, pud_ttbr0
    adr x1, pmd_ttbr0
    orr x1, x1, #3
    str x1, [x0]

    adr x1, pmd_ttbr0
    mov x0, #(1 << 10 | 1 << 2 | 1 << 0)
    str x0, [x1]

    ret







.balign 4096
pgd_ttbr1: /* 512 entries. Each entry reprsents 512 Gb of Virtual memory */
    .space 4096
pud_ttbr1: /* 512 entries. Each entry reprsents 1 Gb of Virtual memory */
    .space 4096
pmd_ttbr1: /* 512 entries. Each entry points to 2mb physical page */
    .space 4096
pmd_3_ttbr1:
    .space 4096


pgd_ttbr0: /* 512 entries. Each entry reprsents 512 Gb of Virtual memory */
    .space 4096
pud_ttbr0: /* 512 entries. Each entry reprsents 1 Gb of Virtual memory */
    .space 4096
pmd_ttbr0: /* 512 entries. Each entry points to 2mb physical page */
    .space 4096



