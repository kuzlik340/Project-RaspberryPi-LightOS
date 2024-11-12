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

emable_mmu:
    adr x0, pgd_ttbr1
    msr ttbr1_el1, x0

    /* there is no ttbr0_el0 so el0 and el1 
     * share same tables for MMU except the user 
     * space is using pgd_ttbr0 and kernel uses pgd_ttbr1 */
    adr x0, pgd_ttbr0
    msr ttbr0_el1, x0

    ldr x0, =MAIR_ATTR
    msr mair_el1, x0

    ldr x0, =TCR_VALUE
    msr tcr_el1, x0

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
     * 0x34000000 is a memory end here and we are creating 
     * a memory for kernel and file system */
    mov x2, #0x34000000
    adr x1, pmd_ttbr1
    /* setting parameters for memory page */
    mov x0, #(1 << 10 | 1 << 2 | 1 << 0)

loop1:
    /* setting pages in PMD table until we address will reach
     * 0x34000000 physical address */
    str x0, [x1], #8
    /* we are adding the page_size here without any trouble 
     * and flags won't be overwritten since page_size is 2 mb 
     * and only bits from 21 will be changed after each 'ADD' operation */
    add x0, x0, #PAGE_SIZE    
    cmp x0, x2
    blo loop1

    adr x0, pud_ttbr1
    add x0, x0, #24
    /* store the link to pmd_3 which starts from 0xc0000000 
     * and ends with 0x100000000 */
    adr x1, pmd_3_ttbr1
    orr x1, x1, #3
    str x1, [x0]

    mov x2, #0x100000000        /* end of peripherals physical memory area */
    mov x0, #0xf0000000         /* start of peripherals physical memory area */

    adr x3, pmd_3_ttbr1
    /* putting an offset of peripheral area start in x4 */
    mov x4, #(0xf0000000 - 0xc0000000)
    /* finding the corresponding index of last page (2^21 is 2 MB)
     * do not forget to shift left for 3 bits since each entity in PMD is 8 bytes */
    lsr x1, x4, #(21 - 3)
    add x1, x1, x3
/* The register x1 contains the offset for the first entry in pmd_3_ttbr1, shifted left by 3 bits. 
 * This shift is necessary to correctly address the pages, as each entry in pmd3 occupies 8 bytes.
 * Therefore, if x1 points to the first slot in pmd3, incrementing it by 8 will point to the location 
 * for the next entry. Incrementing by 8 bytes effectively advances to the next page, so we needed 
 * to ensure that each 8-byte increase properly aligns with the page boundary. */

    /* setting type as device memory */
    orr x0, x0, #1
    orr x0, x0, #(1 << 10)

/* creating PMDs for the peripheral area adrresses */
loop2:
    str x0, [x1], #8
    add x0, x0, #PAGE_SIZE
    cmp x0, x2
    blo loop2



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



