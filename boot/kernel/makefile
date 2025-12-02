BUILD_DIR=../build/kernel
SRCS:=$(wildcard *.c)
OBJS:=$(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))

OS=$(BUILD_DIR)/my_kernel

CFLAGS+=-ffreestanding -nostdlib -gdwarf-4 -m32 -ggdb3

allu:$(OS)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

#$(BUILD_DIR)/%.o:%.asm $(BUILD_DIR)
#	nasm -f bin $< -o $@

#$(BUILD_DIR)/%.o表示OBJS中每一项都依赖当前目录下的同名.c文件
$(BUILD_DIR)/%.o:%.c $(BUILD_DIR)
	gcc $(CFLAGS) -c $< -o $@


$(OS):$(OBJS)
#	nasm -f elf32 -g3 -F dwarf $< -o $@ 
	nasm -f elf32 -g3 -F dwarf kernel_entry16.asm -o $(BUILD_DIR)/kernel_entry16.o
	gcc $(CFLAGS) -c kernel_entry32.S -o $(BUILD_DIR)/kernel_entry32.o
	ld -m elf_i386 -nmagic -T os.lds $(BUILD_DIR)/kernel_entry16.o $(BUILD_DIR)/kernel_entry32.o $(OBJS) -o $@.elf
	objcopy -O binary $@.elf $@

# --- 对齐到512字节 ---
# 	dd if=/dev/zero bs=512 count=1 >> $@ 2>/dev/null
# 	truncate -s %512 $@

