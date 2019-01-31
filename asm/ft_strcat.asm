;-----------------------------------------------
;	ft_strcat.asm
;
;	This 64-bit function append a copy of the 
;	null-terminated string s2 to the end of the
;	null-terminated string s1, then add a 
;	terminating '\0'
;
;	ryaoi@student.42.fr
;
;-----------------------------------------------

;	global ft_strcat

	section .text
ft_strcat:
	push rbx
	mov rax, rdi			; save the ret addres
_ft_strcat_goend_s1:
	inc rdi
	cmp byte[rdi-1], 0
	jnz _ft_strcat_goend_s1
	dec rdi
_ft_strcat_loop:
	inc rdi
	inc rsi
	mov bl,	byte[rsi-1]
	mov byte[rdi-1], bl
	cmp byte[rsi-1], 0
	jg _ft_strcat_loop
_exit:
	pop rbx
	ret
