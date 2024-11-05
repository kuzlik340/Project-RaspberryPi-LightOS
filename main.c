#include "uart.h"
#include "print.h"
#include "debug.h"
#include "lib.h"

void KMain(void)
{
    uint64_t value = 238;
    init_uart();
    printk("Hello, Raspberry pi\r\n");
    printk("test number %d\r\n", value);
    printk("test number %x\r\n", value);
    printk("We are at EL %u\r\n", (uint64_t)get_el());
    while (1) {
    }
}