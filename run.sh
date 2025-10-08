#!/bin/bash

# Check if a file name was passed
if [ -z "$1" ]; then
  echo "Usage: $0 filename.asm"
  exit 1
fi

filename="$1"

# Get the directory where the script resides
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find the file recursively from the script's directory
found_file=$(find "$script_dir" -type f -name "$filename" | head -n 1)

# If file wasn't found
if [ -z "$found_file" ]; then
  echo "Error: '$filename' not found in $script_dir or any subdirectory."
  exit 1
fi

# Extract base name (without path or extension)
basename="${filename%.*}"
output_dir="$(dirname "$found_file")"

# Move to file's directory for build
cd "$output_dir" || exit 1

# Assemble and link
nasm -g -f elf -F dwarf -o "$basename.o" "$filename"
ld "$basename.o" -m elf_i386 -o "$basename"

echo "Built: $output_dir/$basename"
