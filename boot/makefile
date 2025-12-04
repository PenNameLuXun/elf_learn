BUILD_DIR=build
BOOTLOADER_NAME=bootloader
BOOTLOADER_STAGE2=bootloader2
KERNEL_NAME=my_kernel


BOOTLOADER:=$(BUILD_DIR)/bootloader/$(BOOTLOADER_NAME).img
BOOTLOADER2:=$(BUILD_DIR)/kernel/$(BOOTLOADER_STAGE2)
KERNEL_IMG:=$(BUILD_DIR)/kernel/kernel/$(KERNEL_NAME)
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
# #	dd if=$(KERNEL_IMG) of=$(DISK_IMG) bs=512 count=1 seek=1
# 	dd conv=notrunc if=$(KERNEL_IMG) of=$(DISK_IMG) bs=512 count=$$(($(shell stat --printf="%s" $(KERNEL_IMG))/512)) seek=1
#	dd if=/dev/zero of=$(DISK_IMG) bs=1M count=10
	dd if=/dev/zero of=$(DISK_IMG) bs=1M count=7
	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG) bs=512 count=1
	dd conv=notrunc if=$(BOOTLOADER2) of=$(DISK_IMG) bs=512 count=10 seek=1
	dd conv=notrunc if=$(KERNEL_IMG) of=$(DISK_IMG) bs=512 count=$$((($(shell stat --printf="%s" $(KERNEL_IMG))+512)/512)) seek=11


#-machine q35
qemu-gdb:disk
	qemu-system-i386 -hda $(DISK_IMG) -gdb tcp::26000 -S &
	@echo "here is: $(shell pwd)"
#	gdb ./build/bootloader/bootloader.o.elf -ex 'target remote localhost:26000' -ex 'set architecture i8086' -ex 'layout src' -ex 'layout regs' -ex 'break main' -ex 'continue'
#	gdb ./build/bootloader/bootloader.o.elf -ex 'add-symbol-file $(BOOTLOADER2).elf 0x500' -ex 'add-symbol-file $(KERNEL_IMG).elf 0x100000' 
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
