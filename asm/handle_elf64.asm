
%include "define.asm"

%define ptr		rbp-0x8
%define phnum		rbp-0x10

%define map_ptr		rbp-0x8
%define size		rbp-0x10


check_available_segment_padding_space:
;
; 	int check_available_segment_padding_space(void *phdr, size_t e_phnum)
;
;	void *ptr
; 	size_t phnum

	push rbp
	mov rbp, rsp
	sub rbp 0x10
	mov [ptr], rdi
	mov [phnum], rsi

loop_phnum:
	mov rcx, [ptr]
	movzx rax, dword [rcx]
	cmp rax, PT_LOAD
	jne go_next_phnum

	; handle here if PT_LOAD
	; if 
    ;

go_next_phnum:
	mov rax, [ptr]
	add rax, SIZE_OF_PHDR64
	mov [ptr], rax
	mov rax, [phnum]
	sub rax, -1
	mov [phnum], rax
	cmp rax, 0
	jl loop_phnum_bad_end

loop_phnum_bad_end:
	mov rax, -1
loop_phnum_end:
	leave
	ret

handle_elf64:

;	int handle_elf64(void *map_ptr, size_t size)
;	
;	void	*map_ptr
;	size_t	size

	push rbp
	mov rbp, rsp
	sub rsp, 0x10	; 8 + 8
	mov [map_ptr], rdi
	mov [size], rsi

	mov rdi, [rdi+0x20]			;rdi = ehdr->e_phoff
	mov rax, [map_ptr]
	movzx rax, word [rax+0x38]		;rax = ehdr->e_phnum
	mov rbx, SIZE_OF_PHDR64
	mul rbx			; rax = ehdr->e_phnum*SIZE_OF_PHDR64
	add rax, rdi		; rax = rax + ehdr->e_phoff
	cmp rax, [size]		; rax > size ?
	jl handle_elf64_bad_end

	mov rax, [map_ptr]
	mov rdi, [rax+0x20]
	add rdi, [map_ptr]		; rdi = map_ptr+ehdr->e_phoff
	movzx rsi, word [rax+0x38]	; rsi = ehdr->e_phnum
	call check_available_segment_padding_space	
	test rax, rax
	je handle_elf64_end

handle_elf64_bad_end:
	mov rax, -1
handle_elf64_end:
	leave
	ret
