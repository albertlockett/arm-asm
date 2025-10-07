#include "stdio.h"

// asm functions
void asm_main();
char* get_title();

int main() {
    char *title = get_title();
    printf("calling %s\n", title);
    asm_main();
    printf("terminated \n");
}