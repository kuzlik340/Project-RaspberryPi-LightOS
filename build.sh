#!/bin/bash
COMPILER_PATH="/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-gcc"
LINKER_PATH="/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-ld"
OBJCOPY_PATH="/Users/timofejkuzin/compiler_for_arch/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-objcopy"


$COMPILER_PATH -x assembler-with-cpp -c hardware_bound/boot.s -o boot.o
$COMPILER_PATH -x assembler-with-cpp -c hardware_bound/lib.s -o liba.o
$COMPILER_PATH -x assembler-with-cpp -c hardware_bound/handler.s -o handlera.o
$COMPILER_PATH -x assembler-with-cpp -c hardware_bound/mmu.s -o mmu.o

$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c hardware_bound/uart.c
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c kernel/main.c
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c software/print.c
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c software/debug.c
$COMPILER_PATH -std=c99 -ffreestanding -mgeneral-regs-only -c hardware_bound/handler.c
echo "MEOW"
$LINKER_PATH -nostdlib -T link.lds -o kernel_cm boot.o main.o liba.o uart.o print.o debug.o handlera.o handler.o mmu.o
$OBJCOPY_PATH -O binary kernel_cm kernel8.img
rm kernel_cm boot.o liba.o uart.o main.o print.o debug.o handlera.o handler.o
