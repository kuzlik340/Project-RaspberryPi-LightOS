/* This module is for debugging OS while creating, 
 * will be turned off in version 0.1*/


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