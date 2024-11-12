/*
 * handler.h   v1.0
 *
 * This module contains the handler for all type of 
 * interrupts and exceptions
 *
 * T.Kuz    11.2024
 */
#ifndef _HANDLER_H
#define _HANDLER_H

/* function to initialize interrupt controller */
void init_interrupt_controller(void);
/* function to enable the timer */
void init_timer(void);
/* function to enable hardware interrupts */
void enable_irq(void);

#endif