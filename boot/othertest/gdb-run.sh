gdb main.elf \
        -ex 'target remote localhost:1235' \
        -ex 'set architecture i8086' \
        -ex 'layout src' \
        -ex 'layout regs' \
        -ex 'break main' \
        -ex 'continue'