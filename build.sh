#!/bin/bash
COMPILER_PATH="compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc"
LINKER_PATH="compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-ld"
OBJCOPY_PATH="compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-objcopy"

$COMPILER_PATH -x assembler-with-cpp -c boot.s -o boot.o
$COMPILER_PATH -x assembler-with-cpp -c lib.s -o liba.o
$COMPILER_PATH -x assembler-with-cpp -c handler.s -o handlera.o
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c uart.c
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c main.c
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c print.c
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c debug.c
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c handler.c
$LINKER_PATH -nostdlib -T link.lds -o kernel boot.o main.o liba.o uart.o print.o debug.o handlera.o handler.o
$OBJCOPY_PATH -O binary kernel kernel8.img
rm kernel boot.o liba.o uart.o main.o print.o debug.o handlera.o handler.o
