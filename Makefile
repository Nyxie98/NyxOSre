C_SOURCES = $(wildcard src/kernel/*.c src/drivers/*.c)
HEADERS = $(wildcard src/kernel/*.c src/drivers/*.c)

OBJ =  ${C_SOURCES:.c=.o}

all: os_image

run: all
	qemu-system-i386 -drive file=out/os_image,index=0,if=floppy,format=raw

os_image: out/boot_sect.bin out/kernel.bin
	cat $^ > out/os_image

out/kernel.bin: out/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

out/%.o: %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@

out/%.o: src/kernel/%.s
	nasm $< -f elf64 -o $@

out/%.bin: src/boot/%.s
	nasm $< -f bin -o $@

clean:
	rm -fr *.bin *.dis *.o os_image
	rm -fr src/kernel/*.o src/boot/*.bin src/drivers/*.o
