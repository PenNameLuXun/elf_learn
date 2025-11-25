BUILD_DIR=../build/bootloader
SRCS:=$(wildcard *.asm)
# OBJS:=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(SRCS))
OBJS:=$(SRCS:%.asm=$(BUILD_DIR)/%.o)

allu:$(OBJS)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o:%.asm $(BUILD_DIR)
	nasm -f elf $< -F dwarf -g -o $@
	ld -m elf_i386 -T bootloader.lds $@ -o $@.elf
	objcopy -O binary $(BUILD_DIR)/bootloader.o.elf $@
#	nasm -f bin $< -o $@