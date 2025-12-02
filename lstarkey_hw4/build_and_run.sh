#!/bin/sh
set -e

# Build assembly
nasm -g -f elf32 -F dwarf -o functions.o functions.asm

# Build and link C + ASM (32-bit, static as per assignment)
gcc -g -Wall -static -m32 -o backandforth backandforth_all.c functions.o

# Run the program
./backandforth
