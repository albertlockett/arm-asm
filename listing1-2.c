#include "stdio.h"

extern "C" {
    void asmMain(void);
}

int main(void) {
    printf("calling asmMain\n");
    asmMain();
    printf("returned from asmMain\n");
}