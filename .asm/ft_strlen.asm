;-----------------------------------------------
;	ft_strlen.asm
;
;	This 64-bit function computes the length
;	of the string s.
;
;	ryaoi@student.42.fr
;
;-----------------------------------------------

;	global ft_strlen

	section .text
ft_strlen:
	push rbp
	mov rbp, rsp
	push rcx
	push rbx
	mov rbx, rdi
	xor al, al
	mov rcx, 0xFFFFFFFF
	cld
	repne scasb			;scan till hitting al
	sub rdi, rbx
	sub rdi, 0x1
	mov rax, rdi
	pop rbx
	pop rcx
	leave
	ret
