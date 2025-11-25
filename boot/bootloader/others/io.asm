;==============================
; io.asm - simple I/O library
;==============================

;--------------------------------------
; MovCursor
; bh = row (Y)
; bl = column (X)
;--------------------------------------
MovCursor:
    push ax
    push bx
    push dx
    mov ah, 0x02        ; BIOS: set cursor position
    mov dh, bh           ; row
    mov dl, bl           ; column
    mov bh, 0            ; page number = 0
    int 0x10
    pop dx
    pop bx
    pop ax
    ret

;--------------------------------------
; PutChar
; al = char to print
; bl = color attribute
; cx = repeat count
;--------------------------------------
PutChar:
    push ax
    push bx
    push cx
.put_loop:
    mov ah, 0x09        ; BIOS: write character & attribute
    mov bh, 0
    int 0x10
    loop .put_loop
    pop cx
    pop bx
    pop ax
    ret

InputChar:
    push ax
    push cx

    push bx
    mov bl, 0x0A
    mov cx, 1
    call PutChar
    pop bx


    add bl, 1
    call MovCursor

    pop cx
    pop ax
    ret


;--------------------------------------
; Print
; ds:si = address of zero-terminated string
;--------------------------------------
Print:
    push ax
    push bx
    push cx
.next_char:
    lodsb               ; load [ds:si] -> AL, si++
    cmp al, 0
    je .done
    call InputChar
    jmp .next_char
.done:
    pop cx
    pop bx
    pop ax
    ret
