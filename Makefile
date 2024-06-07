NASM = nasm
GCC = i586-elf-gcc
LD = i586-elf-ld
EMU = qemu-system-i386

all: build/bootloader.bin build/kernel.bin build/floppy.img

build/bootloader.bin: bootloader/bootloader.asm
	mkdir -p build
	$(NASM) -f bin bootloader/bootloader.asm -o build/bootloader.bin

build/kernel.bin: kernel/kernel.c
	$(GCC) -ffreestanding -m32 -c kernel/kernel.c -o build/kernel.o
	$(LD) -o build/kernel.bin -Ttext 0x1000 build/kernel.o --oformat binary

build/floppy.img: build/bootloader.bin build/kernel.bin
	dd if=/dev/zero of=build/floppy.img bs=512 count=2880
	mkfs.vfat -F 12 build/floppy.img
	sudo mount -o loop build/floppy.img /mnt
	sudo dd if=build/bootloader.bin of=/mnt/boot.bin bs=512 count=1 conv=notrunc
	sudo cp build/kernel.bin /mnt/
	sudo umount /mnt

run: build/floppy.img
	$(EMU) -fda build/floppy.img

clean:
	rm -rf build