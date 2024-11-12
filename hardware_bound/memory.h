/*
 * lib.h   v1.0
 *
 * This module contains Kernel base address and 
 * two macros to convert memory addresses.
 *
 * T.Kuz    11.2024
 */

#ifndef _MEMORY_H
#define _MEMORY_H

#include "stdint.h"

#define KERNEL_BASE  0xffff000000000000

/* macros to translate physical address to virtual */
#define P2V(p) ((uint64_t)(p) + KERNEL_BASE)
/* macros to translate physical address to virtual */
#define V2P(v) ((uint64_t)(v) - KERNEL_BASE)

/* note that both of this macros are used only in kernel space */


#endif