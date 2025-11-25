BUILD_DIR=../build/kernel
SRCS:=$(wildcard *.asm)
OBJS:=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(SRCS))

allu:$(OBJS)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o:%.asm $(BUILD_DIR)
#	nasm -f elf $< -F dwarf -g -o $@
	nasm -f bin $< -o $@
