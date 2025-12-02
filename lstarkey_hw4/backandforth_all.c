#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ==== Assembly functions (implemented in functions.asm) ==== */
int  addstr(char *a, char *b);          /* menu 1 */
int  is_palindromeASM(char *s);        /* menu 2 */
int  factstr(char *s);                 /* menu 3 */
void palindrome_check(void);           /* menu 4 */

/* ==== C functions (implemented here) ==== */
int  fact(int n);                      /* used by factstr() in ASM */
int  is_palindromeC(char *s);          /* used by palindrome_check() in ASM */

/* ---- helper: safe line input ---- */
static void read_line(char *buffer, size_t size) {
    if (fgets(buffer, size, stdin) != NULL) {
        size_t len = strlen(buffer);
        if (len > 0 && buffer[len - 1] == '\n') {
            buffer[len - 1] = '\0';
        }
    }
}

int main(void) {
    char line[256];
    int running = 1;

    while (running) {
        printf("1) Add two numbers together\n");
        printf("2) Test if a string is a palindrome (C -> ASM)\n");
        printf("3) Print the factorial of a number\n");
        printf("4) Test if a string is a palindrome (ASM -> C)\n");
        printf("5) Quit\n");
        printf("Enter choice: ");

        read_line(line, sizeof line);
        int choice = atoi(line);

        switch (choice) {
        case 1: {
            char a[64], b[64];
            printf("Enter first number: ");
            read_line(a, sizeof a);
            printf("Enter second number: ");
            read_line(b, sizeof b);

            int sum = addstr(a, b);
            printf("Sum = %d\n\n", sum);
            break;
        }
        case 2: {
            char s[256];
            printf("Enter string: ");
            read_line(s, sizeof s);

            int result = is_palindromeASM(s);
            if (result) {
                printf("\"%s\" is a palindrome.\n\n", s);
            } else {
                printf("\"%s\" is not a palindrome.\n\n", s);
            }
            break;
        }
        case 3: {
            char s[64];
            printf("Enter number: ");
            read_line(s, sizeof s);

            int result = factstr(s);
            printf("Factorial = %d\n\n", result);
            break;
        }
        case 4:
            /* ASM function handles prompting, reading, calling C, and printing */
            palindrome_check();
            printf("\n");
            break;

        case 5:
            running = 0;
            break;
        default:
            printf("Invalid choice: %d\n", choice);
            break;
        }
    }

    return 0;
}

/* ===== C-only functions ===== */

/* factorial implemented in C, called by factstr() in ASM */
int fact(int n) {
    if (n < 0) {
        return 0;      /* factorial not defined for negative numbers */
    }

    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

/* palindrome check implemented in C, used by palindrome_check() in ASM */
int is_palindromeC(char *s) {
    int i = 0;
    int j = (int)strlen(s) - 1;

    while (i < j) {
        if (s[i] != s[j]) {
            return 0;
        }
        i++;
        j--;
    }
    return 1;
}
