/*
 * main.c   v1.0
 *
 * This is the kernel of OS.
 *
 * T.Kuz    11.2024
 */
#include "uart.h"
#include "print.h"
#include "debug.h"
#include "lib.h"
#include "handler.h"

void KMain(void)
{
    uint64_t value = 238;
    init_uart();
    printk("Hello from Raspberry pi\r\n");
    printk("We are at EL %u\r\n", (uint64_t)get_el());

    init_timer();
    init_interrupt_controller();
    enable_irq();
    while (1) {
    }
}