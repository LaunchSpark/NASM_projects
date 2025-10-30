; palindrome.asm  — NASM, Linux 32-bit (int 0x80), cdecl for is_palindrome

SECTION .data
  prompt      db "Please enter a string:", 10
  prompt_len  equ $-prompt
  yesmsg      db "It is a palindrome", 10
  yesmsg_len  equ $-yesmsg
  nomsg       db "It is NOT a palindrome", 10
  nomsg_len   equ $-nomsg

SECTION .bss
  buf   resb 1024          ; input buffer

SECTION .text
  global _start


is_palindrome:
  push ebp
  mov  ebp, esp
  push ebx
  push esi
  push edi

  mov  esi, [ebp+8]        ; buffer
  mov  ecx, [ebp+12]       ; len
  mov  eax, 1              ; assume true

  xor  ebx, ebx            ; i = 0
  mov  edx, ecx
  dec  edx                 ; j = len - 1
  mov  edi, ecx
  shr  edi, 1              ; half = len / 2

  cmp  edi, 0
  jle  .done

.compare_loop:
  mov  al, [esi+ebx]       ; buf[i]
  mov  cl, [esi+edx]       ; buf[j]
  cmp  al, cl
  jne  .not_pal
  inc  ebx                 ; i++
  dec  edx                 ; j--
  cmp  ebx, edi
  jl   .compare_loop
  jmp  .done

.not_pal:
  xor  eax, eax            ; return 0

.done:
  pop  edi
  pop  esi
  pop  ebx
  mov  esp, ebp
  pop  ebp
  ret


_start:
.read_again:
  ; write prompt
  mov  eax, 4              ; sys_write
  mov  ebx, 1              ; fd = stdout
  mov  ecx, prompt
  mov  edx, prompt_len
  int  0x80

  ; read input
  mov  eax, 3              ; sys_read
  mov  ebx, 0              ; fd = stdin
  mov  ecx, buf
  mov  edx, 1024
  int  0x80                ; EAX = bytes read

  cmp  eax, 0
  jle  .exit               ; EOF or error -> exit

  ; if first byte is newline, exit
  cmp  byte [buf], 10
  je   .exit

  ; exclude the trailing newline from the length
  dec  eax                 ; count--

  ; cdecl: push args right-to-left -> len, then buffer
  push eax                 ; len (count-1)
  push dword buf           ; buffer pointer
  call is_palindrome
  add  esp, 8              ; caller cleans

  cmp  eax, 1
  jne  .print_no

  ; print "It is a palindrome"
  mov  eax, 4
  mov  ebx, 1
  mov  ecx, yesmsg
  mov  edx, yesmsg_len
  int  0x80
  jmp  .read_again

.print_no:
  mov  eax, 4
  mov  ebx, 1
  mov  ecx, nomsg
  mov  edx, nomsg_len
  int  0x80
  jmp  .read_again

.exit:
  mov  eax, 1              ; sys_exit
  xor  ebx, ebx
  int  0x80
