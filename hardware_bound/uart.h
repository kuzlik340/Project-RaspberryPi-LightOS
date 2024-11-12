#ifndef _UART_H
#define _UART_H

#include "memory.h"
#define IO_BASE_ADDR    P2V(0xfe200000)

#define UART0_DR        IO_BASE_ADDR + 0x1000
#define UART0_FR        IO_BASE_ADDR + 0x1018
#define UART0_CR        IO_BASE_ADDR + 0x1030
#define UART0_LCRH      IO_BASE_ADDR + 0x102c
#define UART0_FBRD      IO_BASE_ADDR + 0x1028
#define UART0_IBRD      IO_BASE_ADDR + 0x1024
#define UART0_IMSC      IO_BASE_ADDR + 0x1038
#define UART0_MIS       IO_BASE_ADDR + 0x1040
#define UART0_ICR       IO_BASE_ADDR + 0x1044

unsigned char read_char(void);
void write_char(unsigned char c);
void write_string(const char *string);
void init_uart(void);
void uart_handler(void);

#endif

