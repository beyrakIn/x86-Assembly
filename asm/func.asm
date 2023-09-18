section .note.GNU-stack
section .data
format_output db "Number %i.", 0x0A, 0x00

section .text
global main
extern printf

main:
        push ebp
        mov ebp, esp
        push 1337
        push format_output
        call printf
        mov eax, 0
        mov esp, ebp
        pop ebp
        ret
