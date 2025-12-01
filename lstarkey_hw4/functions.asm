; functions.asm
; 32-bit NASM, ELF format, cdecl calling convention

global addstr
global is_palindromeASM
global factstr
global palindrome_check

extern atoi          ; from stdlib
extern printf        ; from stdio
extern scanf         ; from stdio
extern is_palindromeC
extern fact

SECTION .data
    ; --- format strings / messages ---
prompt_str      db "Enter string: ", 0
fmt_str         db "%255s", 0
msg_pal         db "%s is a palindrome.", 10, 0
msg_not_pal     db "%s is not a palindrome.", 10, 0

SECTION .bss
    ; buffer used by palindrome_check
pal_buf         resb 256

SECTION .text

; ---------------------------------------------------------
; int addstr(char *a, char *b)
;   - convert both strings to int with atoi
;   - return their sum in EAX
;   a -> [ebp+8], b -> [ebp+12]
; ---------------------------------------------------------
addstr:
    push    ebp
    mov     ebp, esp
    push    ebx                 ; preserve callee-saved

    push    dword [ebp+8]        ; a
    call    atoi
    add     esp, 4
    mov     ebx, eax             ; x = atoi(a)

    push    dword [ebp+12]       ; b
    call    atoi
    add     esp, 4
    add     eax, ebx             ; eax = x + y (return value)

    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret

; ---------------------------------------------------------
; int is_palindromeASM(char *s)
;   - assembly implementation: check characters from ends toward middle
;   s -> [ebp+8]
; ---------------------------------------------------------
is_palindromeASM:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi

    mov     esi, [ebp+8]         ; s

    ; compute length
    xor     ecx, ecx             ; len = 0
    mov     edi, esi
.len_loop:
    cmp     byte [edi], 0
    je      .len_done
    inc     edi
    inc     ecx
    jmp     .len_loop
.len_done:

    mov     eax, 1               ; assume palindrome
    xor     ebx, ebx             ; i = 0
    mov     edx, ecx
    dec     edx                  ; j = len - 1
    mov     edi, ecx
    shr     edi, 1               ; half = len / 2

    cmp     edi, 0
    jle     .done

.compare_loop:
    mov     al, [esi+ebx]        ; s[i]
    mov     cl, [esi+edx]        ; s[j]
    cmp     al, cl
    jne     .not_pal
    inc     ebx                  ; i++
    dec     edx                  ; j--
    cmp     ebx, edi
    jl      .compare_loop
    jmp     .done

.not_pal:
    xor     eax, eax             ; not a palindrome

.done:
    pop     edi
    pop     esi
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret

; ---------------------------------------------------------
; int factstr(char *s)
;   - n = atoi(s);
;   - return fact(n);
;   s -> [ebp+8]
; ---------------------------------------------------------
factstr:
    push    ebp
    mov     ebp, esp

    push    dword [ebp+8]        ; s
    call    atoi
    add     esp, 4               ; eax = n

    push    eax                  ; argument n for fact
    call    fact
    add     esp, 4               ; eax = fact(n)

    mov     esp, ebp
    pop     ebp
    ret

; ---------------------------------------------------------
; void palindrome_check(void)
;   - prompt user for a string
;   - read into pal_buf
;   - call is_palindromeC(pal_buf)
;   - print appropriate message
; ---------------------------------------------------------
palindrome_check:
    push    ebp
    mov     ebp, esp

    ; 1) printf("Enter string: ");
    push    prompt_str
    call    printf
    add     esp, 4

    ; 2) scanf("%255s", pal_buf);
    push    pal_buf
    push    fmt_str
    call    scanf
    add     esp, 8

    ; 3) result = is_palindromeC(pal_buf);
    push    pal_buf
    call    is_palindromeC
    add     esp, 4               ; eax = result

    ; 4) if (result) print pal message, else non-pal message
    cmp     eax, 0
    je      .not_pal

    ; print palindrome message
    push    pal_buf
    push    msg_pal
    call    printf
    add     esp, 8
    jmp     .done

    .not_pal:
    push    pal_buf
    push    msg_not_pal
    call    printf
    add     esp, 8

    .done:

    mov     esp, ebp
    pop     ebp
    ret
