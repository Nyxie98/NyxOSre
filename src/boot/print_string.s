; Print string
; Param bx - Address of string to print
print_string:
    pusha
    mov si, bx

    mov ah, 0x0e
    mov al, [si]
.loop:
    lodsb
    int 0x10
    cmp al, 0
    jne .loop

    popa
    ret

; Print Hex as String
; Param dx - Hex value to print
print_hex:
    pusha
    mov cx, 4

.loop:
    dec cx

    mov ax, dx
    shr dx, 4
    and ax, 0xf

    mov bx, HEX_OUT
    add bx, 2
    add bx, cx

    cmp ax, 0xa
    jl .letter
    add byte [bx], 7
    jl .letter

.letter:
    add byte [bx], al

    cmp cx, 0
    je .done
    jmp .loop
    
.done:    
    mov bx, HEX_OUT
    call print_string
    call hex_reset
    popa
    ret

; Reset String
hex_reset:
    pusha
    mov bx, HEX_OUT
    add bx, 2

.start:
    cmp byte [bx], 0
    jne .set
    jmp .fin

.set:
    mov byte [bx], 0x30
    inc bx
    jmp .start
.fin:
    popa
    ret 

; Data
HEX_OUT:
    db '0x0000',0
