#include "uart.h"

void KMain(void)
{
    init_uart();
    write_string("Hello, Raspberry pi\r\n");
    while (1) {
    }
}