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


; NASM, 16-bit real mode
; 读取 count (in CX) 扇区，从 LBA (in DX:AX low/high or push dq) 开始到 ES:BX

; org 0x7C00

bits 16

global start
global read_loop_lba
global disk_error
global kernel_entry

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov dl, 0x80      ; HDD

    mov ax, 0x0050     ; ES = 0x50 → load kernel at 0x500:0
    mov es, ax
    xor bx, bx

    ; SI = offset dap_struct (located in CS=DS=0 segment)
    lea si, [dap_struct]

    mov ah, 0x42
    int 0x13
    jc disk_error
kernel_entry:
    jmp 0x0000:0x0600    ; jump to kernel entry (example)

disk_error:
    cli
    hlt

dap_struct:
    db 16
    db 0
    dw 28          ; read 28 sectors
    dw 0x0000      ; offset
    dw 0x0050      ; segment ← 注意这是段，不是物理地址
    dq 1           ; LBA=1

times 510-($-$$) db 0
dw 0xAA55
