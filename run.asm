section .data ;Data segment
userMsg db 'Please enter a number: ' ;Ask the user to enter a number
lenUserMsg equ $-userMsg ;The length of the message
dispMsg db 'You have entered: '
lenDispMsg equ $-dispMsg
section .bss ;Uninitialized data
num resb 5
section .text ;Code Segment
global main
main:
;User prompt
mov eax, 4
mov ebx, 1
mov ecx, userMsg
mov edx, lenUserMsg
int 80h

mov eax, 3
mov ebx, 2
mov ecx, num
mov edx, 5
int 80h

mov eax, 4
mov ebx, 1
mov ecx, dispMsg
mov edx, lenDispMsg
int 80h

mov eax, 4
mov ebx, 1
mov ecx, num
mov edx, 5
int 80h

mov eax, 1
mov ebx, 0
int 80h
