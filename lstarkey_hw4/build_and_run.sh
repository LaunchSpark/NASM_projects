#!/bin/sh
set -e

# Optional: install 32-bit toolchain/glibc headers (needed for -m32 builds)
if command -v apt-get >/dev/null 2>&1 && [ "$(uname -s)" = "Linux" ]; then
  echo "Installing 32-bit build dependencies (requires sudo)..."
  sudo apt-get update
  sudo apt-get install -y build-essential gcc-multilib g++-multilib libc6-dev libc6-dev-i386
fi

# Build assembly
nasm -g -f elf32 -F dwarf -o functions.o functions.asm

# Build and link C + ASM (32-bit, static as per assignment)
gcc -g -Wall -static -m32 -o backandforth backandforth_all.c functions.o

# Run the program
./backandforth
