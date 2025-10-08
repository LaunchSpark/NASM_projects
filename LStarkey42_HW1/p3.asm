SECTION .data
  title         db "The Dividing Program", 10
  title_len     equ $-title
  prompt        db "Please enter a single digit number: "
  prompt_len    equ $-prompt
  quotient_msg  db "The quotient is: "
  quotient_len  equ $-quotient_msg
  remainder_msg db "The remainder is: "
  remainder_len equ $-remainder_msg
  newline       db 10

SECTION .bss
  in1        resb 2              ; input buffer for first digit and newline
  in2        resb 2              ; input buffer for second digit and newline
  quotient   resb 1              ; storage for quotient character
  remainder  resb 1              ; storage for remainder character

SECTION .text
  global _start
_start:
  ; display program title
  mov eax, 4
  mov ebx, 1
  mov ecx, title
  mov edx, title_len
  int 0x80

  ; prompt for the first single-digit number
  mov eax, 4
  mov ebx, 1
  mov ecx, prompt
  mov edx, prompt_len
  int 0x80

  ; read the first single-digit number
  mov eax, 3
  mov ebx, 0
  mov ecx, in1
  mov edx, 2
  int 0x80

  ; prompt for the second single-digit number
  mov eax, 4
  mov ebx, 1
  mov ecx, prompt
  mov edx, prompt_len
  int 0x80

  ; read the second single-digit number
  mov eax, 3
  mov ebx, 0
  mov ecx, in2
  mov edx, 2
  int 0x80

  ; convert ASCII inputs to numeric values
  mov al, [in1]
  sub al, '0'
  mov bl, [in2]
  sub bl, '0'

  ; sign-extend dividend into AX and divide by divisor in BL
  cbw
  idiv bl

  ; convert quotient to ASCII and store
  add al, '0'
  mov [quotient], al

  ; convert remainder to ASCII and store
  mov al, ah
  add al, '0'
  mov [remainder], al

  ; display quotient message
  mov eax, 4
  mov ebx, 1
  mov ecx, quotient_msg
  mov edx, quotient_len
  int 0x80

  ; display quotient value
  mov eax, 4
  mov ebx, 1
  mov ecx, quotient
  mov edx, 1
  int 0x80

  ; newline between quotient and remainder lines
  mov eax, 4
  mov ebx, 1
  mov ecx, newline
  mov edx, 1
  int 0x80

  ; display remainder message
  mov eax, 4
  mov ebx, 1
  mov ecx, remainder_msg
  mov edx, remainder_len
  int 0x80

  ; display remainder value
  mov eax, 4
  mov ebx, 1
  mov ecx, remainder
  mov edx, 1
  int 0x80

  ; final newline
  mov eax, 4
  mov ebx, 1
  mov ecx, newline
  mov edx, 1
  int 0x80

  ; exit program
  mov eax, 1
  xor ebx, ebx
  int 0x80
