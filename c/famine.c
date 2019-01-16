
#include <elf.h>
#include <sys/types.h>
#include <dirent.h>


           struct linux_dirent64 {
//               ino64_t        d_ino;    /* 64-bit inode number */
               long long        d_ino;    /* 64-bit inode number */
//               off64_t        d_off;    /* 64-bit offset to next structure */
               unsigned long long        d_off;    /* 64-bit offset to next structure */
               unsigned short d_reclen; /* Size of this dirent */
               unsigned char  d_type;   /* File type */
               char           d_name[]; /* Filename (null-terminated) */
           };


/*
struct linux_dirent64 {
	long           d_ino;
	off_t          d_off;
	unsigned short d_reclen;
	char           d_name[];
};
*/

// for 64bit: gcc -masm=intel famine.c -nostartfiles
// for 32bit: gcc -masm=intel -m32 -D__32BIT__=1 famine.c -nostartfiles
// strip info with -s

#ifndef __32BIT__
/* The code is not compiled for 32bit so define everything for 64bit */
#define SYSCALL "syscall"
#define SYSINDEX "a"                //rax
#define PARAM1 "D"                  //rdi
#define PARAM2 "S"                  //rsi
#define PARAM3 "d"                  //rdx
#define MOV_PARAM4 "mov %0, r10;"
#define MOV_PARAM5 "mov %1, r8;"
#define MOV_PARAM6 "mov %2, r9;"

/* syscall index */
#define SYS_WRITE       1
#define SYS_OPEN        2
#define SYS_CLOSE       3
#define SYS_FSTAT       5
#define SYS_MMAP        9
#define SYS_MUNMAP      11
#define SYS_FORK        57
#define SYS_EXECVE      59
#define SYS_EXIT        60
#define SYS_GETDENTS64  217

#else

// https://www.ibiblio.org/gferg/ldp/GCC-Inline-Assembly-HOWTO.html
#define SYSCALL "int 0x80"
#define SYSINDEX "a"                //eax
#define PARAM1 "b"                  //ebx
#define PARAM2 "c"                  //ecx
#define PARAM3 "d"                  //edx
#define PARAM4 "S"                  //esi
#define PARAM5 "D"                  //edi

/* syscall index */
#define SYS_WRITE       4
#define SYS_OPEN        5
#define SYS_CLOSE       6
#define SYS_FSTAT       18
#define SYS_MMAP        90
#define SYS_MUNMAP      91
#define SYS_FORK        2
#define SYS_EXECVE      11
#define SYS_EXIT        1
#define SYS_GETDENTS64  220

#endif /* __32BIT__ */

//#define O_RDONLY        0x00
//#define O_WRONLY        0x02
#define O_RDDIR         0x10000
//#define PROT_FLAG       0x03
//#define MAP_PRIVATE     0x02
//#define ET_EXEC         0x02
//#define ET_DYN          0x03
//#define ELFCLASS32      0x01
//#define ELFCLASS64      0x02
#define GETDENT_BUFFSIZE 1024

const char signature[] __attribute__((section(".text#"), aligned(1))) = "Famine version 1.0 (c)oded by ryaoi";

const char hello[] __attribute__((section(".text#"), aligned(1))) = "Hello world\n";
const char dir1[] __attribute__((section(".text#"), aligned(1))) = "/tmp/test";
const char dir2[] __attribute__((section(".text#"), aligned(1))) = "/tmp/test2";

static inline void exit_failure(void) { asm(SYSCALL::SYSINDEX (SYS_EXIT), PARAM1 (0xFF)); }
static inline void exit_success(void) { asm(SYSCALL::SYSINDEX (SYS_EXIT), PARAM1 (0x0)); }

// functions

static inline char	*ft_strcpy(char *dst, const char *src)
{
	int i;

	i = 0;
	while (src[i])
	{
		dst[i] = src[i];
		i++;
	}
	dst[i] = '\0';
	return (dst);
}


static inline size_t	ft_strlen(const char *s)
{
	size_t i;

	i = 0;
	while (s[i] != '\0')
		i++;
	return (i);
}

static inline char	*ft_strcat(char *s1, char *s2)
{
	int i;

	i = 0;
	while (s1[i] != '\0')
		i++;
	while (*s2)
	{
		s1[i] = *(s2++);
		i++;
	}
	s1[i] = '\0';
	return (s1);
}
static inline void injection(const char *dir)
{
    int fd;
    int ret;
    char buf[GETDENT_BUFFSIZE];
    struct linux_dirent64 *ptr;
    char filename[256];
    int nread = 0;
    int bpos;
    int dirsize;

    asm(SYSCALL
        : "=r" (fd)
        : SYSINDEX (SYS_OPEN), PARAM1 (dir), PARAM2 (O_RDDIR));
    if (fd < 0)
        exit_failure();
    ft_strcpy(filename, dir);
    printf("filename:%s\tdir:%s\n", filename, dir);
    dirsize = ft_strlen(dir);
    printf("dirsize:%d\n", dirsize);
    printf("fd:%d\n", fd);
_loop_dirent:
    asm(SYSCALL
        : "=r" (nread)
        : SYSINDEX (SYS_GETDENTS64), PARAM1 (fd), PARAM2 (&buf), PARAM3(GETDENT_BUFFSIZE));
    if (nread == -1)
        exit_failure();
    if (nread != 0)
    {
        for (bpos = 0; bpos < nread;)
        {
            ptr = (struct linux_dirent64 *) (buf + bpos);
            filename[dirsize] = '/';
            filename[dirsize+1] = '\0';
            ft_strcat(filename, ptr->d_name);
            printf("got:%s\n", filename);
            // check the file
            bpos += ptr->d_reclen;
        }
        goto _loop_dirent;
    }
}

// start

void _start(void)
{
		//printf("Hello world\n");
//		syscall(SYS_write, 1, addr_helloworld, 13);
/*
		__asm__(
		    "mov rdx, 0xd;"
		    "lea rsi, haha;"
		    "mov rdi, 0x1;"
		    "mov rax, 0x1;"
		    "syscall;");
		    */
		asm(SYSCALL
		    :
		    : SYSINDEX (SYS_WRITE), PARAM1 (0x1), PARAM2 (&hello), PARAM3 (0xc));
        injection(dir1);
		exit_success();
}




