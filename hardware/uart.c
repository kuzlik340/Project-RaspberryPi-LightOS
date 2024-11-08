#include "uart.h"
#include "lib.h"


void write_char(unsigned char c)
{
    /* waiting for the transmit buffer to be empty */
    while (in_word(UART0_FR) & (1 << 3)) { }
    /* send char */
    out_word(UART0_DR, c);
}

unsigned char read_char(void)
{
    return in_word(UART0_DR);
}

void write_string(const char *string)
{
    for (int i = 0; string[i] != '\0'; i++) {
        write_char(string[i]);
    }
}


void uart_handler()
{
    uint32_t status = in_word(UART0_MIS);
    if(status & (1 << 4)){
        char ch = read_char();
        if (ch == '\r'){
            write_string("\r\n");
        }
        else{
            write_char(ch);
        }
        write_char(read_char());
        out_word(UART0_ICR, (1 << 4));
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
    /* enable 8 bit frames, enable error-check bit */
    out_word(UART0_LCRH, (1 << 5) | (1 << 6));
    /* unblocking receive interrupt checker */
    out_word(UART0_IMSC, (1 << 4));
    /* start uart0 and enable bit 8  for recieve 
     * and bit 9 to send messages */
    out_word(UART0_CR, (1 << 0) | (1 << 8) | (1 << 9));
}
