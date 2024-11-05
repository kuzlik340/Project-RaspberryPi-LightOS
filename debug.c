#include "debug.h"
#include "print.h"

void error_check(char *file, uint64_t line)
{
    printk("\r\n----------------------------\r\n");
    printk("            ERROR CHECK");
    printk("\r\n----------------------------\r\n");
    printk("assertion failed [%s, %u]\r\n", file, line);

    while(1);

}
