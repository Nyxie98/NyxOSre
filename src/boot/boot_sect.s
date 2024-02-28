[org 0x7c00]
KERNEL_OFFSET equ 0x1000

        mov [BOOT_DRIVE], dl

        ; Init Stack
        mov bp, 0x9000
        mov sp, bp

        ; In Real Mode
        mov bx, START_MSG
        call print_string

        call load_kernel

        call switch_to_pm
        
        jmp $

%include "src/boot/print_string.s"
%include "src/boot/disk_util.s"
%include "src/boot/gdt.s"
%include "src/boot/screen_util_pm.s"
%include "src/boot/protected_mode.s"

[bits 16]
load_kernel:
        mov bx, MSG_LOAD_KERNEL
        call print_string

        mov bx, KERNEL_OFFSET
        mov dh, 15
        mov dl, [BOOT_DRIVE]
        call disk_load

        ret


[bits 32]
BEGIN_PM:
        mov ebx, END_MSG
        call print_string_pm

        call KERNEL_OFFSET

        jmp $

BOOT_DRIVE:
        db 0
START_MSG:
        db 'OS in Real Mode...', 0
END_MSG:
        db 'OS in Protected Mode...', 0
MSG_LOAD_KERNEL:
        db 'Loading kernel into memory...', 0

times 510-($-$$) db 0
dw 0xaa55
