#include "stdint.h"
#include "print.h"
#include "lib.h"
#include "irq.h"

static uint64_t ticks = 0;

void init_interrupt_controller(void)
{   
    /* initilize both registers as 0's so we can modify them */
    out_word(DIST, 0);
    out_word(CPU_INTERFACE, 0);
    /* all interrupts will be processed by processor */
    out_word(ICC_PR, 0xff);
    /* set the highest priority to interrupts from timer */ 
    out_word(ICD_PR + 64, 0);
    /* set the interface of processor as core 0 since it is the only working core */
    out_word(ICD_PTR + 64, 1);
    /* set the sensitivity as edge-triggered (0b10) */
    out_word(ICD_ICFGR + 16, 2);
    /* enabling interrupts from ID 64 */
    out_word(ICD_ISENABLE + 8, 1);
    /* enable distributor and CPU interface */
    out_word(DIST, 1);
    out_word(CPU_INTERFACE, 1);
}

/* this will make interruption every 10 ms */
void init_timer(void)
{
    out_word(TIMER_PREDIV, 0x7d);
    out_word(TIMER_LOAD, 19841);
    out_word(TIMER_CTL, 0b10100010);
}

static uint32_t get_irq_num()
{
    return in_word(ICC_ACK);
}

static void timer_interrupt_handler()
{
    uint32_t mask = in_word(TIMER_MSKIRQ);
    if (mask & 1){
        if(ticks % 100 == 0){
            printk("Timer %u\r\n", ticks);
        }
        ticks++;
        out_word(TIMER_ACK, 1);
    }

}

void handler(uint64_t numid, uint64_t esr, uint64_t elr)
{
    uint32_t irq_id;
    switch(numid){
        case 1:
            printk("sync error at %x: %x\r\n", elr, esr);
            while(1);
        case 2: /* hardware interrupt */
            irq_id = get_irq_num();
            if (irq_id == 64){
                timer_interrupt_handler();
            }
            else{
                printk("uknown interrupt request \r\n");
                while(1);
            }
            out_word(ICC_EOI, irq_id);
            break;    
        default:
            printk("Uknown exception");
            while(1);
    }
}