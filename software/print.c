/*
 * print.c   v1.0
 *
 * This module contains all of the functions to 
 * print something into console.
 * An analog for the 'printf'
 *
 * T.Kuz    11.2024
 */
#include "stdint.h"
#include "stdarg.h"
#include "hardware_bound/uart.h"


/* Function to read a string into a buffer at a given position 
 * Returns the number of characters read from the string */ 
static int read_string(char *buffer, int position, const char *string)
{
    int index = 0;
    for(index = 0; string[index] != '\0'; index++){
        buffer[position++] = string[index];
    }
    return index;
}

/* Function to convert an unsigned decimal integer to a string
 * Stores the result in buffer starting from 'position' and returns the number of digits added */
static int udecimal_to_string(char *buffer, int position, uint64_t digits)
{
    char digits_map[10] = "0123456789";
    char digits_buffer[25];
    int size = 0;

    /* Extract digits in reverse order and store them in digits_buffer */
    do {
        digits_buffer[size++] = digits_map[digits % 10];
        digits /= 10;
    } while (digits != 0);

    /* Reverse the order of digits to store them correctly in the buffer */
    for (int i = size-1; i >= 0; i--) {
        buffer[position++] = digits_buffer[i];
    }

    return size;
}

/* Function to convert a signed decimal integer to a string
 * Adds a negative sign if the integer is negative, and returns the number of characters added */
static int decimal_to_string(char *buffer, int position, int64_t digits)
{
    int size = 0;

    /* Handle negative numbers by adding a '-' sign and converting to positive */ 
    if (digits < 0) {
        digits = -digits;
        buffer[position++] = '-';
        size = 1;
    }
    /* Use udecimal_to_string to convert the remaining positive part */
    size += udecimal_to_string(buffer, position, (uint64_t)digits);
    return size;
}



static int hex_to_string(char *buffer, int position, uint64_t digits)
{
    /* 16 bytes for the symbols since one byte represented as (00~FF)
     * since we have 64 bit number it means that there will be 8 bytes 
     * Do not forget about two bytes for the '0x' and 1 byte for the '\0'*/
    char digits_buffer[25];
    char digits_map[16] = "0123456789ABCDEF";
    int size = 0;
    do{
        digits_buffer[size++] = digits_map[digits % 16]; 
        digits /= 16;
    } while(digits != 0);
    for(int i = size - 1; i >= 0; i--){
        buffer[position++] = digits_buffer[i];
    }
    buffer[position++] = 'H';
    return size + 1;
}

/* Function to write a buffer to the console.
 * Iterates over each character in buffer and outputs it */
static void write_console(const char *buffer, int size)
{
    for (int i = 0; i < size; i++) {
        write_char(buffer[i]);
    }
}


/* Custom formatted print function similar to printf
 * Supports %x for hex, %u for unsigned, %d for signed integers, %s for strings */
int printk(const char *format, ...)
{
    char buffer[1024]; /* buffer for the info that we want to display */
    int buffer_size = 0; 
    int64_t integer = 0; /* an integer that we want to display */
    char *string = 0; /* pointer to string constant that was passed to this function */
    va_list args; /* list of arguments that were passed to this function */
    va_start(args, format);  /* initialize list of argument by 'va_start' macros */
    for(int i = 0; format[i] != '\0'; i++){
        /* if it is just straight text */
        if(format[i] != '%'){ 
            buffer[buffer_size++] = format[i];
        }
        /* if we have some variable or constant that we have to print */
        else{
            switch(format[++i]){
                case 'x':   /* Hexadecimal integer */
                    integer = va_arg(args, int64_t);
                    buffer_size += hex_to_string(buffer, buffer_size, (uint64_t)integer);
                    break;
                case 'u':    /* Unsigned decimal integer */ 
                    integer = va_arg(args, int64_t);
                    buffer_size += udecimal_to_string(buffer, buffer_size, (uint64_t)integer);
                    break;
                case 'd':   /* Signed decimal integer */
                    integer = va_arg(args, int64_t);
                    buffer_size += decimal_to_string(buffer, buffer_size, integer);
                    break;
                case 's':   /* String */
                    string = va_arg(args, char *);
                    buffer_size += read_string(buffer, buffer_size, string);
                    break;
                default:
                    /* if we have a '%' without anything after it*/
                    buffer[buffer_size++] = '%';
                    i--;         
            }
        }
    }
    write_console(buffer, buffer_size);
    va_end(args);
    return buffer_size;
}