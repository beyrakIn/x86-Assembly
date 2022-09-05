section .data
msg db "Enter you text: "
msg_len equ $-msg

section .bss
text resb 10
count resb 1

section .text
global _start
_start:

mov eax, 4
mov ebx, 2
mov ecx, msg
mov edx, msg_len
int 80h

mov eax, 3
mov ebx, 2
mov ecx, text
mov edx, 10
int 80h

mov eax, 0
mov [count], eax

loop:
mov eax, 4
mov ebx, 2
mov ecx, text
mov edx, 10
int 80h

mov eax, [count]
inc eax
mov [count], eax
cmp eax, 9h
jne loop

mov eax, 1
mov ebx, 0
int 80h
