
#define VGA_MEMORY 0xB8000
#define WHITE_ON_BLACK 0x0F

void print_char(int row, int col, char c) {
    unsigned char *vga = (unsigned char *)VGA_MEMORY;
    int index = (row * 80 + col) * 2;
    vga[index] = c;
    vga[index + 1] = WHITE_ON_BLACK;
}

void print_string(const char* str) {
    static int row = 0, col = 0;
    unsigned char *vga = (unsigned char *)VGA_MEMORY;

    while (*str) {
        if (*str == '\n') {
            row++;
            col = 0;
        } else {
            int index = (row * 80 + col) * 2;
            vga[index] = *str;
            vga[index + 1] = WHITE_ON_BLACK;
            col++;
        }
        str++;
    }
}
int kernel_main(){
    print_string("Hello from 32-bit kernel!\n");
    print_string("This is VGA text output.\n");
    return 0;
}