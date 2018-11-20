
%define SYS_WRITE	1
%define SYS_OPEN	2
%define SYS_CLOSE	3
%define SYS_FSTAT	5
%define SYS_MMAP	9
%define SYS_MUNMAP	11
%define SYS_FORK	57
%define SYS_EXIT	60
%define SYS_GETDENTS64	217

%define O_RDONLY	0x00
%define O_WRONLY	0x02
%define O_RDDIR		0x10000
%define PROT_FLAG	0x03
%define MAP_PRIVATE	0x02
%define ET_EXEC		0x02
%define	ET_DYN		0x03
%define ELFCLASS64	0x02
%define SIZE_OF_PHDR64 	0x38
%define PT_LOAD		0x1



%define VIRUS_SIZE	0x1000  ; sysconf(_SC_PAGESIZE) for 64


