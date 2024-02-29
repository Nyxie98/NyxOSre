SRC=src
BOOT=src/boot
KERNEL=src/kernel
DRIVERS=src/drivers
OUT=out

C_SOURCES=($KERNEL/*.c $DRIVERS/*.c)
C_HEADERS=($KERNEL/*.h $DRIVERS/*.h)
S_SOURCES=($BOOT/*.s)

# echo ${C_SOURCES[@]} ${C_HEADERS[@]} ${S_SOURCES[@]}

echo Assembling Boot Sector
nasm $SRC/boot_sect.s -f bin -o $OUT/boot_sect.bin
# qemu-system-i386 -fda out/boot_sect.bin

gcc -ffreestanding -c $KERNEL/kernel.c -o $OUT/kernel.o

nasm $KERNEL/kernel_entry.s -f elf64 -o $OUT/kernel_entry.o

ld -o $OUT/kernel.bin -Ttext 0x1000 $OUT/kernel_entry.o $OUT/kernel.o --oformat binary

cat $OUT/boot_sect.bin $OUT/kernel.bin > $OUT/os_image

qemu-system-i386 -drive file=$OUT/os_image,index=0,if=floppy,format=raw
