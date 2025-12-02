# set tdesc filename none
# set architecture i8086
# target remote localhost:26000

# # 在连接后，强制告诉 GDB 不要相信 QEMU 的 32 位描述
# # 注意：这行是在 target remote 之后
# set tdesc filename /dev/null

# #layout asm
# #layout reg
# b *0x7c00
# define hook-stop
#     # Translate the segment:offset into a physical address
#     printf "[%4x:%4x] ", $cs, $eip
#     x/i $cs*16+$eip
#     #set architecture i8086
#     #target remote localhost:26000
# end


# .gdbinit 修正版

# 1. 先连接 QEMU
target remote localhost:26000

# 2. 现在再强制设置为 8086 模式
set architecture i8086


directory ./bootloader
directory ./kernel

add-symbol-file ./build/kernel/my_kernel.elf 0x500

layout src
layout regs

# 4. 打断点
# b *0x7c00

# c

# b kernel_entry

# c

b jmp2protected




# 5. 定义显示 Hook
# define hook-stop
#     printf "[%4x:%4x] ", $cs, $ip
#     x/5i $cs*16+$ip
# end