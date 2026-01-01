global _start

section .data
	filename db "new_file.txt", 0

section .bss
	buffer resb 1024

section .text
_start:

	xor eax , eax
	xor ebx , ebx
	xor edx , edx

	mov al , 102
	mov bl , 1

	push edx
	push 1
	push 2
	mov ecx , esp
	int 0x80

	mov esi , eax                  ; Save socket file descriptor for later use

	; Bind the socket to the specified IP and port

	xor eax , eax
	xor ebx , ebx

	mov al , 102
	mov bl , 2

	push edx
	push edx
	push 0x6f01a8c0                ; IP address: 192.168.1.111
	push word 0x5c11               ; Port number: 4444
	push word 2
	mov ecx , esp ;ecx in sockaddr *

	push 16
	push ecx
	push esi
	mov ecx , esp
	int 0x80

	; Listen for incoming connections

	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx
	mov al , 102

	mov bl , 4

	push 2
	push esi
	mov ecx , esp
	int 0x80

	; Accept incoming client connections in a loop

accept_loop:

	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx

	mov al , 102
	mov bl , 5

	push edx
	push edx
	push esi
	mov ecx , esp
	int 0x80

	mov edi, eax                   ; Save client socket file descriptor

	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx
	xor edx , edx

	mov al , 5
	mov ebx , filename
	mov ecx , 65
	mov edx , 420
	int 0x80

	mov ebp , eax                  ; Save file descriptor for writing received data

transfer_loop:

	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx
	xor edx , edx

	mov al , 3
	mov ebx , edi
	mov ecx , buffer
	mov edx , 1024
	int 0x80

	cmp eax, 0                     ; Check if bytes were read (0 means connection closed)
	jle transfer_finish

	mov al , 4
	mov ebx , ebp
	mov ecx , buffer
	mov edx , 1024
	int 0x80

	jmp transfer_loop

	; Transfer is finished - close all file descriptors and exit

transfer_finish:

	xor eax , eax
	mov al , 6
	mov ebx , ebp
	int 0x80

	; Close client socket (edi)
	mov eax, 6                     ; sys_close syscall
	mov ebx, edi                   ; Client socket fd
	int 0x80

	; Close server socket (esi)
	mov eax, 6                     ; sys_close syscall
	mov ebx, esi                   ; Server socket fd
	int 0x80

	; Exit the program
	mov eax, 1                     ; sys_exit syscall
	xor ebx, ebx                   ; Return code: 0
	int 0x80

