section .data
msg db "Enter the file name: "
msg_len equ $-msg

msg2 db "Bye", 0xA
msg2_len equ $-msg2

section .bss
input resb 3

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
mov ecx, input
mov edx, 3
int 80h

mov eax, 4
mov ebx, 2
mov ecx, input
mov edx, 3
int 80h

mov eax, 8
mov ebx, input	; file name
mov ecx, 777	; file permission
mov edx, 1
int 80h

mov eax, 4
mov ebx, 2
mov ecx, msg2
mov edx, msg2_len
int 80h

mov eax, 1
mov ebx, 0
int 80h
