#include "stdint.h"
#include "print.h"

void handler(uint64_t numid, uint64_t esr, uint64_t elr)
{
    switch(numid){
        case 1:
            printk("sync error at %x: %x\r\n", elr, esr);
            while(1);
        default:
            printk("Uknown exception");
            while(1);
    }
}