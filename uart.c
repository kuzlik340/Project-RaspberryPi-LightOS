#include "uart.h"
#include "lib.h"

void write_char(unsigned char c)
{
    /* waiting for the transmit buffer to be empty */
    while (in_word(UART0_FR) & (1 << 5)) { }
    /* send char */
    out_word(UART0_DR, c);
}

unsigned char read_char(void)
{
    /* waiting for the receive buffer to recieve message */
    while (in_word(UART0_FR) & (1 << 4)) { }
    return in_word(UART0_DR);
}

void write_string(const char *string)
{
    for (int i = 0; string[i] != '\0'; i++) {
        write_char(string[i]);
    }
}

void init_uart(void)
{
    /* disable the uart0 to reinitialize it */
    out_word(UART0_CR, 0);
    /* by calculations we should put here 26 for 115200 baudrate */
    out_word(UART0_IBRD, 26);
    /* do not use the fractional baudarate register */
    out_word(UART0_FBRD, 0);
    /* enable FIFO for faster data transfer, 
     * enable 8 bit frames, enable error-check bit */
    out_word(UART0_LCRH, (1 << 4) | (1 << 5) | (1 << 6));
    /* blocking interrupt checker */
    out_word(UART0_IMSC, 0);
    /* start uart0 and enable bit 8  for recieve 
     * and bit 9 to send messages */
    out_word(UART0_CR, (1 << 0) | (1 << 8) | (1 << 9));
}
