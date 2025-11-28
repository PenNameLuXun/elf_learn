; ;=====================================
; ; bootloader.asm - simple bootloader
; ;=====================================



; bits 16
; ; org 0x7C00

; global start
; global boot
; global tokernel

; ;-------------------------------------
; ; Data
; ;-------------------------------------
; ; msg db "****Welcome to My Operating System!****", 0
; ; my_msg db "my name is jxl",0


; ; %include "others/io.asm"

; ;-------------------------------------
; ; Code
; ;-------------------------------------
; start:
;     cli
;     cld
;     ; move cursor to (row=5, col=10)ni
;     ; mov bh, 5
;     ; mov bl, 10
;     ; call MovCursor

;     ; ; mov al, '*'
;     ; ; call InputChar

;     ; ;print message
;     ; mov si, msg
;     ; call Print

;     ; mov bh, 6
;     ; mov bl, 10
;     ; call MovCursor
;     ; mov si, my_msg
;     ; call Print

;     jmp boot
    

; ;load my kernel from 2th sector to memeroy adress 0x500
; ; boot:
; ;     mov ax, 0x50
; ;     ;; set the buffer
; ;     mov es, ax
; ;     xor bx, bx

; ;     mov al, 28 ; read 2 sector
; ;     mov ch, 0 ; track 0
; ;     mov cl, 2 ; sector to read (The second sector)
; ;     mov dh, 0 ; head number
; ;     mov dl, 0 ; drive number

; ;     mov ah, 0x02 ; read sectors from disk
; ;     int 0x13 ; call the BIOS routine
; ;     jmp 0x60 ; jump and execute the sector!
; ;     ;jmp [500h + 18h]

; ;     hlt
; boot:
;     mov ax, 0x50       ; 段地址 0x50
;     mov es, ax
;     xor bx, bx         ; 内存偏移 0x0

;     mov cx, 28         ; 扇区计数
;     xor si, si         ; 内存偏移计数

; read_loop:
;     mov ah, 0x02       ; BIOS: 读取扇区
;     mov al, 1          ; 每次读 1 扇区

;     mov ch, 0          ; 柱面
;     mov dh, 0          ; 磁头
;     ;mov dl, 0          ; 驱动器, 让 BIOS 提供的 DL 决定磁盘类型
;     mov dl, 0x80


;     mov ax, si        ; AX = SI
;     mov cl, al
;     add cl, 2         ; 从扇区 2 开始

;     int 0x13

;     jc disk_error

;     add bx, 512       ; 内存位置前移
;     inc si            ; 记录读了几个扇区
;     loop read_loop    ; CX--，为0时退出

; tokernel:
;     jmp 0x600          ; 跳转到内核 entry

; disk_error:
;     hlt



; ;-------------------------------------
; ; Boot signature
; ;-------------------------------------
; times 510 - ($ - $$) db 0
; dw 0xAA55

;----------------------------------从hdd中读取kernel-------------------------------------
; NASM, 16-bit real mode
; 读取 count (in CX) 扇区，从 LBA (in DX:AX low/high or push dq) 开始到 ES:BX

; org 0x7C00

bits 16

global start
global read_loop_lba
global disk_error
global kernel_entry

start:
    ;| DL 值        | 含义           |
    ;| ----------- | ------------ |
    ;| 0x00 ~ 0x7F | 软盘（A:, B: 等） |
    ;| **0x80**    | 第一块 HDD      |
    ;| **0x81**    | 第二块 HDD      |
    ;| 0x82        | 第三块 HDD      |

    ; mov dl, 0x80      ; 驱动器号设置,默认启动bootloader时会自动设置成第一个驱动号，所以不用手动给,除非需要从其他位置寻找kernel

    ; SI = offset dap_struct (located in CS=DS=0 segment)
    ; 将dap_struct处的地址赋给si，这是DAP协议加载的要求。
    lea si, [dap_struct]

    mov ah, 0x42
    int 0x13
    jc disk_error
kernel_entry:
    ;jmp 0x0000:0x0600    ; jump to kernel entry (example)
    jmp far [0x518]

disk_error:
    cli
    hlt

dap_struct:
    db 16          ; 表示这个结构的字节数，该数据占用1字节(db)
    db 0           ; 保留项,1字节
    dw 28          ; read 28 sectors  2字节dw
    dw 0x0000      ; offset           2字节
    dw 0x0050      ; segment ← 注意这是段，不是物理地址 2字节
    dq 1           ; LBA=1  8字节 dq

times 510-($-$$) db 0
dw 0xAA55   ;MBR标记，表明这是一个二级启动器；一级启动器根据这个来判定该扇区(512字节)是否是一个二级启动引导器
