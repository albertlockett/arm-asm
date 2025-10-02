#include "stdio.h"

extern "C" {
    void asmMain();
}

int main() {
    asmMain();
    return 0;
}