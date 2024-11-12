/*
 * debug.c   v1.0
 *
 * This module contains one macros to check some condition.
 * For example ASSERT(b != NULL).
 *
 * T.Kuz    11.2024
 */


#ifndef _DEBUG_H
#define _DEBUG_H

#include "stdint.h"

/* for example we can check buffer != NULL */
#define ASSERT(e) do {                          \
    if (!(e))                                   \
       error_check(__FILE__, __LINE__);         \
} while(0)                                       

void error_check(char *file, uint64_t line);

#endif