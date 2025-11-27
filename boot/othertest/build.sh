nasm -f elf32 -g3 -F dwarf main.asm -o main.o
ld -Ttext=0x7c00 -melf_i386 main.o -o main.elf
objcopy -O binary main.elf main.img

# qemu-system-i386 -hda main.img tcp::1235 -S -s &
qemu-system-i386 -hda main.img -S -gdb tcp::1235 &