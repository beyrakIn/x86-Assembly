section .data
msg db "Enter the file name: "
msg_len equ $-msg

msg2 db 0xA, "Bye", 0xA
msg2_len equ $-msg2

section .bss
f_name resb 3
fd_in resb 1
fd_out resb 1
info resb 10000
file_name resb 8 

section .text
global _start

_start:
mov eax, 4
mov ebx, 2
mov ecx, msg
mov edx, msg_len
int 80h


;read file name
mov eax, 3
mov ebx, 1
mov ecx, file_name
mov edx, 8
int 80h

;print the file name
mov eax, 4
mov ebx, 1
mov ecx, file_name
mov edx, 8
int 80h


;open the file for reading
mov eax, 5
mov ebx, file_name
mov ecx, 0
mov edx, 0777
int 80h

mov [fd_in], eax

;read from file 
mov eax, 3
mov ebx, [fd_in]
mov ecx, info
mov edx, 10000
int 80h

;close the file
mov eax, 6
mov ebx, [fd_in]
int 80h


;print the info
mov eax, 4
mov ebx, 1
mov ecx, info
mov edx, 10000
int 80h


; END
mov eax, 4
mov ebx, 2
mov ecx, msg2
mov edx, msg2_len
int 80h

mov eax, 1
mov ebx, 0
int 80h
