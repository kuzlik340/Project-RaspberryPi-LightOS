/*
 * print.h   v1.0
 *
 * This module contains declaration of global printk 
 * function to print something into console
 * 
 * T.Kuz    11.2024
 */

#ifndef _PRINT_H
#define _PRINT_H

#include "stdint.h"

int printk(const char *format, ...);

#endif