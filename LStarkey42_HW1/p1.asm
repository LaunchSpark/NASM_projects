
SECTION .data
  title      db "The Adding Program", 10
  title_len  equ $-title
  p1msg      db "Please enter a single digit number: "
  p1msg_len  equ $-p1msg
  ansmsg     db "The answer is: "
  ansmsg_len equ $-ansmsg
  nl         db 10

SECTION .bss
  in1  resb 2       ; char + newline
  in2  resb 2
  ans  resb 1       

SECTION .text
  global _start
_start:
  ; print title
  mov eax,4
  mov ebx,1
  mov ecx,title
  mov edx,title_len
  int 0x80

  ; prompt & read first
  mov eax,4
  mov ebx,1
  mov ecx,p1msg
  mov edx,p1msg_len
  int 0x80

  mov eax,3
  mov ebx,0
  mov ecx,in1
  mov edx,2
  int 0x80

  ; prompt & read second
  mov eax,4
  mov ebx,1
  mov ecx,p1msg
  mov edx,p1msg_len
  int 0x80

  mov eax,3
  mov ebx,0
  mov ecx,in2
  mov edx,2
  int 0x80

  ; convert ASCII to numbers
  mov al, [in1]
  sub al, '0'
  mov bl, [in2]
  sub bl, '0'

  ; add
  add al, bl

  ; convert back to ASCII and store
  add al, '0'
  mov [ans], al

  ; print "The answer is: "
  mov eax,4
  mov ebx,1
  mov ecx,ansmsg
  mov edx,ansmsg_len
  int 0x80

  ; print result char
  mov eax,4
  mov ebx,1
  mov ecx,ans
  mov edx,1
  int 0x80

  ; newline
  mov eax,4
  mov ebx,1
  mov ecx,nl
  mov edx,1
  int 0x80

  ; exit
  mov eax,1
  xor ebx,ebx
  int 0x80
