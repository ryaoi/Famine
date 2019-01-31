#include "famine.h"
#include <stdio.h>

const char hello[] __attribute__((section(".text#"), aligned(1))) = "Hello world\n";

void _start(void)
{
    int ret = _write(1, &hello, 13);
    printf("ret:%d\n", ret);
}
