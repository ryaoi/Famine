#ifndef __FAMINE_H__
#define __FAMINE_H__

#include <stdio.h>

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


ssize_t _write(int fd, const void *buf, size_t count);








#endif
