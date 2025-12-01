; kernel_entry16.s
bits 16
global kernel_entry16
global protected_mode_entry

kernel_entry16:
    ;cli
    ; 实模式下 DS/ES/SS 必须初始化
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; 开 A20
.a20_wait:
    in al, 0x64
    test al, 2
    jnz .a20_wait
    mov al, 0xD1
    out 0x64, al

.a20_wait2:
    in al, 0x64
    test al, 2
    jnz .a20_wait2
    mov al, 0xDF
    out 0x60, al

    ; 加载 GDT
    lgdt [gdt_descriptor]

    ; 设置 CR0 PE 位 = 1
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    ; far jump 到 32-bit 模式入口
    jmp 0x08:protected_mode_entry


; ===== 32-bit 部分 =====
bits 32
extern kernel_main   ; kernel.c 编译后提供的函数

protected_mode_entry:
    mov ax, 0x10      ; 32-bit 数据段选择子
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax

    mov esp, 0x90000  ; 设置栈

    call kernel_main  ; 跳到 C 代码

.halt:
    hlt
    jmp .halt


; ====== 简单的 GDT ======
gdt_start:
    dq 0x0000000000000000     ; NULL
    dq 0x00CF9A000000FFFF     ; code segment
    dq 0x00CF92000000FFFF     ; data segment
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start
