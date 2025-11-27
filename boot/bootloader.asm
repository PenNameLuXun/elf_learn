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
;     mov dl, 0          ; 驱动器


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



;org 0x7c00    - remove as it may be rejected when assembling
;                with elf format. We can specify it on command
;                line or via a linker script.
bits 16

; Use a label for our main entry point so we can break on it
; by name in the debugger
main:
    cli
    mov ax, 0x0E61
    int 0x10
    hlt
    times 510 - ($-$$) db 0
    dw 0xaa55