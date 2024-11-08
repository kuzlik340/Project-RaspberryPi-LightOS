#!/bin/bash
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc -x assembler-with-cpp -c boot.s -o boot.o
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc -x assembler-with-cpp -c lib.s -o liba.o
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc -x assembler-with-cpp -c handler.s -o handlera.o
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc -std=c99 -ffreestanding -mgeneral-regs-only  -c uart.c
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc -std=c99 -ffreestanding -mgeneral-regs-only -c main.c 
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc -std=c99 -ffreestanding -mgeneral-regs-only -c print.c
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc -std=c99 -ffreestanding -mgeneral-regs-only -c debug.c
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc -std=c99 -ffreestanding -mgeneral-regs-only -c handler.c
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-ld -nostdlib -T link.lds -o kernel boot.o main.o liba.o uart.o print.o debug.o handlera.o handler.o
/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-objcopy -O binary kernel kernel8.img
rm kernel boot.o liba.o uart.o main.o print.o debug.o

