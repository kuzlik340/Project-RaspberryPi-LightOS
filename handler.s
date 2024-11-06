/* this is a vector table for the exceptions occured while system was running */
/* the processor here works based on the occured exception and based on the offset of element in table */
.section .text
.global vector_table

.ballign 0x800
vector_table:
/* this part won't be used, if we are switching to el1 we use stack of el1 */
.ballign 0x80
current_el_sp0_sync:        /* for sys calls and memory errors */
    b error
.ballign 0x80
current_el_sp0_irq:         /* for interrupts */
    b error
.ballign 0x80
current_el_sp0_fiq:         /* for high ptiority interrupts (not used) */
    b error
.ballign 0x80
current_el_sp0_serror:      /* for system error */
    b error


.ballign 0x80
current_el_spn_sync:        /* for sys calls and memory errors */
    b sync_handler
.ballign 0x80
current_el_spn_irq:         /* for interrupts */
    b error
.ballign 0x80
current_el_spn_fiq:         /* for high ptiority interrupts (not used) */
    b error
.ballign 0x80
current_el_spn_serror:      /* for system error */
    b error


.ballign 0x80
lower_el_aarch64_sync:      /* for sys calls and memory errors */
    b sync_handler
.ballign 0x80
lower_el_aarch64_irq:       /* for interrupts */
    b error
.ballign 0x80
lower_el_aarch64_fiq:       /* for high ptiority interrupts (not used) */
    b error
.ballign 0x80
lower_el_aarch64_serror:    /* for system error */
    b error


/* this part won't be used, since we are working only with aarch64 */
.ballign 0x80
lower_el_aarch32_sync:      /* for sys calls and memory errors */
    b sync_handler
.ballign 0x80
lower_el_aarch32_irq:       /* for interrupts */
    b error
.ballign 0x80
lower_el_aarch32_fiq:       /* for high ptiority interrupts (not used) */
    b error
.ballign 0x80
lower_el_aarch32_serror:    /* for system error */
    b error


sync_handler:
    mov x0, #1              /* first argument: id of exception */
    mrs x1, esr_el1         /* second argument: Exception Syndrome Register */
    mrs x2, elr_el1         /* third argument: address of inctruction that called exception */
    bl handler              /* call handler */
    eret                    /* use eret to return to instruction that was after 
                             * the instruction that caused exception */

error:
    mov x0, #0              /* first argument: error code */
    bl handler              /* call handler */

    eret
