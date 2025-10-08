SECTION .data
  title        db "The Swapping Program", 10
  title_len    equ $-title
  prompt       db "Please enter a two-character string: "
  prompt_len   equ $-prompt
  result_msg   db "After swapping: "
  result_len   equ $-result_msg

SECTION .bss
  input_buffer resb 3        ; two characters plus newline

SECTION .text
  global _start

_start:
  ; print the program title
  mov eax, 4
  mov ebx, 1
  mov ecx, title
  mov edx, title_len
  int 0x80

  ; prompt the user for a two-character string
  mov eax, 4
  mov ebx, 1
  mov ecx, prompt
  mov edx, prompt_len
  int 0x80

  ; read the two-character string (plus newline)
  mov eax, 3
  mov ebx, 0
  mov ecx, input_buffer
  mov edx, 3
  int 0x80

  ; swap the first two characters in memory
  mov al, [input_buffer]
  mov bl, [input_buffer + 1]
  mov [input_buffer], bl
  mov [input_buffer + 1], al

  ; display the result message
  mov eax, 4
  mov ebx, 1
  mov ecx, result_msg
  mov edx, result_len
  int 0x80

  ; print the swapped string including newline
  mov eax, 4
  mov ebx, 1
  mov ecx, input_buffer
  mov edx, 3
  int 0x80

  ; exit program
  mov eax, 1
  xor ebx, ebx
  int 0x80
