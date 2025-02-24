/*
 * lib.h   v1.0
 *
 * This module contains all basic functions to work with memory, 
 * getting the current Exception Level and a function for delay.
 *
 * T.Kuz    11.2024
 */
#ifndef _LIB_H
#define _LIB_H

#include "stdint.h"

void delay(uint64_t value);
void out_word(uint64_t addr, uint32_t value);
uint32_t in_word(uint64_t addr);
void memset(void *dst, int value, unsigned int size);
void memcpy(void *dst, void *src, unsigned int size);
void memmove(void *dst, void *src, unsigned int size);
int memcmp(void *src1, void *src2, unsigned int size);
unsigned char get_el(void);

#endif
