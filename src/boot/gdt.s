gdt_start:

; Mandatory NULL Descriptor
gdt_null:
    dd 0x0
    dd 0x0

; Code Segment
gdt_code:
    dw 0xffff        ; Limit
    dw 0x0           ; Base (0-15)
    db 0x0           ; Base (16-23)
    db 10011010b     ; First Flags
    db 11001111b     ; Second Flags
    db 0x0           ; Base (24-31)

; Data Segment
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; Descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; Data
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
