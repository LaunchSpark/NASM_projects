; p2.asm
; Build: nasm -g -f elf -F dwarf -o p2.o p2.asm && ld p2.o -m elf_i386 -o p2

SECTION .data
  title      db "The Multiplying Program",10
  title_len  equ $-title
  pmsg       db "Please enter a single digit number: "
  pmsg_len   equ $-pmsg
  amsg       db "The answer is: "
  amsg_len   equ $-amsg
  nl         db 10

SECTION .bss
  in1   resb 2
  in2   resb 2
  num2  resb 1        ; numeric second input
  ans   resb 1        ; <— renamed from 'out'

SECTION .text
  global _start
_start:
  ; title
  mov eax,4
  mov ebx,1
  mov ecx,title
  mov edx,title_len
  int 0x80

  ; read first
  mov eax,4
  mov ebx,1
  mov ecx,pmsg
  mov edx,pmsg_len
  int 0x80

  mov eax,3
  mov ebx,0
  mov ecx,in1
  mov edx,2
  int 0x80

  ; read second
  mov eax,4
  mov ebx,1
  mov ecx,pmsg
  mov edx,pmsg_len
  int 0x80

  mov eax,3
  mov ebx,0
  mov ecx,in2
  mov edx,2
  int 0x80

  ; convert inputs
  mov al, [in1]
  sub al, '0'          ; AL = first number

  mov bl, [in2]
  sub bl, '0'
  mov [num2], bl       ; store second number (as byte) in memory

  ; zero AX, reload AL, and multiply by [num2]
  xor ax, ax
  mov al, [in1]
  sub al, '0'
  imul byte [num2]     ; AX = AL * [num2]; assume result is single digit

  add al, '0'          ; make printable
  mov [ans], al

  ; print answer
  mov eax,4
  mov ebx,1
  mov ecx,amsg
  mov edx,amsg_len
  int 0x80

  mov eax,4
  mov ebx,1
  mov ecx,ans
  mov edx,1
  int 0x80

  mov eax,4
  mov ebx,1
  mov ecx,nl
  mov edx,1
  int 0x80

  ; exit
  mov eax,1
  xor ebx,ebx
  int 0x80
