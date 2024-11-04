#include "uart.h"
#include "print.h"

void KMain(void)
{
    uint64_t value = 238;
    init_uart();
    printk("Hello, Raspberry pi\r\n");
    printk("test number %d\r\n", value);
    printk("test number %x\r\n", value);
    while (1) {
    }
}