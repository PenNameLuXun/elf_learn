# stage2_entry.S
.code32
.global protected_mode_entry
.extern stage2_main  # 这是我们在 C 文件里定义的函数

protected_mode_entry:
    # 1. 初始化段寄存器 (必须在汇编里做)
    movw $0x10, %ax   # 0x10 是 GDT 中的数据段选择子
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw %ax, %fs
    movw %ax, %gs

    # 2. 设置栈 (必须在调用 C 函数前做)
    # 我们把栈设置在 0x90000 (安全且够大)
    movl $0x90000, %esp

    # 3. 进入 C 语言世界
    call stage2_main

    # 4. 如果 C 函数返回了 (理论上不应该返回)，死循环
halt_loop:
    hlt
    jmp halt_loop