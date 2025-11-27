BUILD_DIR=../build/bootloader
SRCS:=$(wildcard *.asm)
# OBJS:=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(SRCS))
OBJS:=$(SRCS:%.asm=$(BUILD_DIR)/%.o)

allu:$(OBJS)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o:%.asm $(BUILD_DIR)
#	nasm -f elf32 $< -F dwarf -g3 -o $@
	nasm -f elf32 -g3 -F dwarf $< -o $@    
	ld -melf_i386 -Ttext=0x7c00 $@ -o $@.elf
	objcopy -O binary $@.elf $(BUILD_DIR)/bootloader.img
#	nasm -f bin $< -o $@