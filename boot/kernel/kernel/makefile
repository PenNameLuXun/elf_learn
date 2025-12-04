BUILD_DIR=../../build/kernel/kernel
SRCS:=$(wildcard *.c)
OBJS:=$(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))

OS=$(BUILD_DIR)/my_kernel

CFLAGS+=-ffreestanding -nostdlib -gdwarf-4 -m32 -ggdb3

allu:$(OS)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)


#$(BUILD_DIR)/%.o表示OBJS中每一项都依赖当前目录下的同名.c文件
$(BUILD_DIR)/%.o:%.c $(BUILD_DIR)
	gcc $(CFLAGS) -c $< -o $@


$(OS):$(OBJS)
	ld -m elf_i386 -nmagic -T kernel.lds $(OBJS) -o $@.elf
	objcopy -O binary $@.elf $@




