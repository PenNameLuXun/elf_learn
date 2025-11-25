
# nasm -f elf32 -g -F dwarf bootloader.asm -o bootloader.elf
nasm -f bin bootloader.asm -o bootloader
nasm -f bin my_kernel.asm -o my_kernel
dd if=/dev/null of=disk.img bs=512 count=2880
dd conv=notrunc if=bootloader of=disk.img bs=512
dd if=my_kernel of=disk.img bs=512 count=1 seek=1

if [[ "$1" == "1" ]];then
    echo "start to debug..."
    qemu-system-i386 -machine q35 -fda disk.img -gdb tcp::26000 -S
else
    qemu-system-i386 -machine q35 -fda disk.img
fi