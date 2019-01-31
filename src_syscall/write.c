#include "famine.h"

ssize_t _write(int fd, const void *buf, size_t count)
{
    ssize_t ret;

    __asm__(SYSCALL
            : "=r"(ret)
            : SYSINDEX(SYS_WRITE), PARAM1(fd), PARAM2(buf), PARAM3(count));
    return (ret);
}
