BUILD_DIR=build
BOOTLOADER_NAME=bootloader
KERNEL_NAME=my_kernel
BOOTLOADER_O:=$(BUILD_DIR)/$(BOOTLOADER_NAME)/bootloader.o
KERNEL_O:=$(BUILD_DIR)/kernel/$(KERNEL_NAME).o
DISK_IMG:=$(BUILD_DIR)/disk.img

.PHONY:all bootloader kernel disk qemu
all:disk

bootloader:
	make -C bootloader

kernel:
	make -C kernel

disk:bootloader kernel
	dd if=/dev/null of=$(DISK_IMG) bs=512 count=2880
	dd conv=notrunc if=$(BOOTLOADER_O) of=$(DISK_IMG) bs=512
	dd if=$(KERNEL_O) of=$(DISK_IMG) bs=512 count=1 seek=1


qemu-gdb:disk
	qemu-system-i386 -machine q35 -fda $(DISK_IMG) -gdb tcp::26000 -S &
	@echo "here is: $(shell pwd)"
	gdb
qemu:disk
	qemu-system-i386 -machine q35 -fda $(DISK_IMG)

clean:
	@rm -rf $(BUILD_DIR)


# 玩一下 1.测试一下统配（%）替换的使用
TEST_LAG= 8.o build/build.o ddd.o
TEST_LAG_C=$(TEST_LAG:%.o=%.c)
test-lag:
	echo "$(TEST_LAG_C)"
