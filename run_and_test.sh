#!/bin/sh
set -e

# Build, then run two scripted sessions that cover all menu options (1→5) and a few edge cases.

BASE_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$BASE_DIR/lstarkey_hw4"

echo "== Building =="
nasm -g -f elf32 -F dwarf -o functions.o functions.asm
gcc -g -Wall -static -m32 -o backandforth backandforth_all.c functions.o

run_session() {
  name="$1"
  input="$2"
  log="$(mktemp "$BASE_DIR/lstarkey_hw4/backandforth_${name}.XXXX.log")"
  printf "== %s ==\n" "$name"
  printf "%s" "$input" | ./backandforth >"$log"
  printf "Output logged to %s\n" "$log"
  echo "$log"
}

# Session 1: nominal paths for each option in order.
session1_input="1
42
-17
2
racecar
3
5
4
hello
5
"

log1=$(run_session "session1_basic" "$session1_input")
grep -q "Sum = 25" "$log1"
grep -q "\"racecar\" is a palindrome." "$log1"
grep -q "Factorial = 120" "$log1"
grep -q "hello is not a palindrome." "$log1"

# Session 2: edge-ish values for each option in order.
session2_input="1
0
0
2

3
-3
4
a
5
"

log2=$(run_session "session2_edges" "$session2_input")
grep -q "Sum = 0" "$log2"
grep -q "\"\" is a palindrome." "$log2"
grep -q "Factorial = 0" "$log2"
grep -q "a is a palindrome." "$log2"

rm -f "$log1" "$log2"
echo "All scripted checks passed."
