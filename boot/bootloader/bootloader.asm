;=====================================
; bootloader.asm - simple bootloader
;=====================================


;org 0x7C00
bits 16
global start
;jmp start

;-------------------------------------
; Data
;-------------------------------------
msg db "****Welcome to My Operating System!****", 0
my_msg db "my name is jxl",0


%include "others/io.asm"

;-------------------------------------
; Code
;-------------------------------------
start:
    cli
    cld
    ; move cursor to (row=5, col=10)
    mov bh, 5
    mov bl, 10
    call MovCursor

    ; mov al, '*'
    ; call InputChar

    ;print message
    mov si, msg
    call Print

    mov bh, 6
    mov bl, 10
    call MovCursor
    mov si, my_msg
    call Print

    jmp boot
    

;load my kernel from 2th sector
boot:
    mov ax, 0x50
    ;; set the buffer
    mov es, ax
    xor bx, bx

    mov al, 2 ; read 2 sector
    mov ch, 0 ; track 0
    mov cl, 2 ; sector to read (The second sector)
    mov dh, 0 ; head number
    mov dl, 0 ; drive number

    mov ah, 0x02 ; read sectors from disk
    int 0x13 ; call the BIOS routine
    jmp 0x50:0x0 ; jump and execute the sector!

    hlt



;-------------------------------------
; Boot signature
;-------------------------------------
times 510 - ($ - $$) db 0
dw 0xAA55
