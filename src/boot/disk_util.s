disk_load:
    push dx

    mov ah, 0x02 ; BIOS Read Sector
    mov al, dh   ; Read DH Sectors
    mov ch, 0x00 ; Select Cylinder 0
    mov dh, 0x00 ; Select Head 0
    mov cl, 0x02 ; Read From Second Sector

    int 0x13     ; BIOS Interrupt

    jc disk_error

    pop dx
    cmp dh, al
    jne disk_sector_error
    ret

; Sector Count Incorrect
disk_sector_error:
    mov bx, DISK_SECT_MSG
    call print_string
    mov dx, ax
    call print_hex

    jmp $

; Other Disk Error
disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    mov dx, ax
    call print_hex
    jmp $

; Data
DISK_ERROR_MSG:
    db 'Disk read error!', 0

DISK_SECT_MSG:
    db 'Disk sector count incorrect!', 0
