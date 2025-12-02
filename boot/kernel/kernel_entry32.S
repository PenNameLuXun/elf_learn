.code32
.global protected_mode_entry
.extern kernel_main

protected_mode_entry:
    # 设置段寄存器 (0x10 = 数据段选择子)
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw %ax, %fs
    movw %ax, %gs

    # 设置栈指针
    movl $0x90000, %esp

    # 进入 C 内核
    call kernel_main

halt:
    hlt
    jmp halt
