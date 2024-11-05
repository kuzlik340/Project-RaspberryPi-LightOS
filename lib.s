.global delay
.global out_word
.global in_word
.global memset
.global memcpy_end
.global memmove
.global memcmp
.global get_el

get_el:
    mrs x0, currentel
    lsr x0, x0, #2     /* shifting the value in x0 by two bits */
    ret


/* same as for(volatile int i = x0; i > 0; i--); */
delay:
    subs x0, x0, #1
    bne delay
    ret

/* put the byte in register 1 at the memory address in register 0 */
out_word:
    str w1, [x0]
    ret
/* load the byte in register 0from the memory address in register 0 */
in_word:
    ldr w0, [x0]
    ret


/* x0 contains memory address that has to be initialized 
 * x1 contains value that will be writeen, x2 contains size */

/* initialize space in memory with value in register 1 */
memset:
    cmp x2, #0          /* if size equals 0 return */
    beq memset_end 

set:
    strb w1, [x0], #1   /* store w1 value in address at register 0 and increment value in register 0*/
    subs x2, x2, #1     /* decrement size with flag */
    bne set             /* while value in x2 not zero */

memset_end:  
    ret

/* x0 conatins source mem addr, x1 dst mem addr and x2 the size */
/* if source and dest are same return 0 if not return 1 */
memcmp:
    mov x3, x0          /* we are using the x0 as return value */
    mov x0, #0          /* set return value as zero */

compare: 
    cmp x2, #0          /* check if there is still bytes to compare */
    beq memcmp_end      /* if not then return */

    ldrb w4, [x3], #1   /* put byte on address x3 into register 4 then increment pointer in x3 */
    ldrb w5, [x1], #1   /* put byte on address x1 into register 5 then increment pointer in x1 */
    sub x2, x2, #1      /* decrement size value */
    cmp w4, w5          /* compare byte to byte */ 
    beq compare         /* if bytes are same then go to compare again */
    mov x0, #1          /* if bytes are not same return value 1 */
memcmp_end:
    ret

memmove: /* in this project will do same functions as memcpy */

/* compare two memory spaces x0 - destination, x1 - source, x2 - size */
memcpy:
    cmp x2, #0          /* if size equals 0 return */
    beq memcpy_end      
    mov x4, #1          /* incrementer for non overlaping coping (increasing order) */
    cmp x1, x0          
    bhs copy            /* if the address of source is larger then address of destination(no overlap) */
    add x3, x1, x2      /* if the address of source is smaller then add to it size */
    cmp x3, x0          /* check if end address of source will overlap destination */
    bls copy            

overlap:
    sub x3, x2, #1      /* since we are starting from 0... */
    add x0, x0, x3      /* put destination pointer in x0 at the end of space */
    add x1, x1, x3      /* put source pointer in x1 at the end of space */
    neg x4, x4          /* incrementer for non overlaping coping (-1) (decreasing order) */

copy:                  
    ldrb w3, [x1]       /* put byte on address x1 into register 3 */
    strb w3, [x0]       /* store byte in register 3 to address in x0*/
    add x0, x0, x4      /* decrement/increment pointer on destination space */
    add x1, x1, x4      /* decrement/increment pointer on source space */

    subs x2, x2, #1     /* decrement size */
    bne copy            /* if size not 0 go to copy again */

memcpy_end:
    ret

