.global delay
.global out_word
.global in_word

delay:
    subs x0, x0, #1
    bne delay
    ret

out_word:
    str w1, [x0]
    ret

in_word:
    ldr w0, [x0]
    ret
