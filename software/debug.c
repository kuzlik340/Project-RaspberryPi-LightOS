/*
 * debug.c   v1.0
 *
 * This module contains one function to print the error 
 * message when assertion was failed. Used in this project 
 * for debugging while writing new modules
 *
 * T.Kuz    11.2024
 */
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
