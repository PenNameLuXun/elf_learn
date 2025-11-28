BUILD_DIR=build
BOOTLOADER_NAME=bootloader
KERNEL_NAME=my_kernel
BOOTLOADER:=$(BUILD_DIR)/$(BOOTLOADER_NAME)/bootloader.img
KERNEL_O:=$(BUILD_DIR)/kernel/$(KERNEL_NAME).elf
DISK_IMG:=$(BUILD_DIR)/disk.img

.PHONY:all bootloader kernel disk qemu
all:disk

bootloader:
	make -C bootloader

kernel:
	make -C kernel

disk:bootloader kernel
# 	dd if=/dev/null of=$(DISK_IMG) bs=512 count=2880
# 	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG) bs=512
# #	dd if=$(KERNEL_O) of=$(DISK_IMG) bs=512 count=1 seek=1
# 	dd conv=notrunc if=$(KERNEL_O) of=$(DISK_IMG) bs=512 count=$$(($(shell stat --printf="%s" $(KERNEL_O))/512)) seek=1
	dd if=/dev/zero of=$(DISK_IMG) bs=1M count=10
	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG) bs=512 count=1
	dd conv=notrunc if=$(KERNEL_O) of=$(DISK_IMG) bs=512 count=$$(($(shell stat --printf="%s" $(KERNEL_O))/512)) seek=1


#-machine q35
qemu-gdb:disk
	qemu-system-i386 -hda $(DISK_IMG) -gdb tcp::26000 -S &
	@echo "here is: $(shell pwd)"
#	gdb ./build/bootloader/bootloader.o.elf -ex 'target remote localhost:26000' -ex 'set architecture i8086' -ex 'layout src' -ex 'layout regs' -ex 'break main' -ex 'continue'
	gdb ./build/bootloader/bootloader.o.elf
qemu:disk
	qemu-system-i386 -hda $(DISK_IMG)

clean:
	@rm -rf $(BUILD_DIR)


# 玩一下 1.测试一下统配（%）替换的使用
TEST_LAG= 8.o build/build.o ddd.o
TEST_LAG_C=$(TEST_LAG:%.o=%.c)
test-lag:
	echo "$(TEST_LAG_C)"
