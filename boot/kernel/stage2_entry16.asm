; kernel_entry16.s
bits 16
global kernel_entry16
extern protected_mode_entry
global jmp2protected

kernel_entry16:
    cli
    ; 实模式下 DS/ES/SS 必须初始化
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; 开 A20
; .a20_wait:
;     in al, 0x64
;     test al, 2
;     jnz .a20_wait
;     mov al, 0xD1
;     out 0x64, al

.a20_wait2:
    ; in al, 0x64
    ; test al, 2
    ; jnz .a20_wait2
    ; mov al, 0xDF
    ; out 0x60, al

    ; 加载 GDT
    lgdt [gdt_descriptor]

    ; 设置 CR0 PE 位 = 1
    mov eax, cr0
    or  eax, 1
    mov cr0, eax
jmp2protected:
    ; far jump 到 32-bit 模式入口
    ;jmp 0x08:protected_mode_entry
    ;jmp dword protected_mode_entry_far
    jmp CODE_SEG:protected_mode_entry

; ; 定义 far pointer
; protected_mode_entry_far:
;     dw 0x08                  ; 代码段选择子
;     dd protected_mode_entry   ; 32-bit 偏移


gdt_start:

gdt_null:   ; 第一个段描述符强制设置为 0
    dd 0x0
    dd 0x0

gdt_code:   ; the code segment descriptor
    ; base = 0x0, limit = 0xfffff
    ; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
    ; type flags: (code )1 ( conforming )0 (readable )1 (accessed )0 -> 1010b
    ; 2nd flags: ( granularity )1 (32- bit default )1 (64- bit seg )0 (AVL )0 -> 1100b
    dw 0xffff       ; Limit (bits 0-15)
    dw 0x0          ; Base  (bits 0-15)
    db 0x0          ; Base  (bits 16-23)
    db 10011010b    ; 1st flags , type flags
    db 11001111b    ; 2nd flags , Limit (bits 16 -19)
    db 0x0          ; Base (bits 24-31)

gdt_data:   ;the data segment descriptor
    ; Same as code segment expect for the type flags:
    ; types flags: (code) 0 (expand down) 0 (writable) 1 (accessed) 0 -> 0010 b
    dw 0xffff       ; Limit (bits 0 -15)
    dw 0x0          ; Base  (bits 0-15)
    db 0x0          ; Base  (bits 16-23)
    db 10010010b    ; 1st flags , type flags
    db 11001111b    ; 2nd flags , Limit (bits 16 -19)
    db 0x0          ; Base (bits 24-31)

gdt_end:    ; The reason for putting a label at the end of the 
            ; GDT is so we can have the assembler calculate 
            ; the size of the GDT for the GDT decriptor (below)

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1    ; Size of GDT
    dd gdt_start                  ; Start address of our GDT


; 设置保护模式下要用到的段地址，代码段和数据段
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

var1 dd 1,2,3
MYTEXT1 db 'this is hello friends',0