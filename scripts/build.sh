#!/bin/bash

set -e

# Cria diretórios necessários
mkdir -p build

# Compila o bootloader
nasm -f bin bootloader/bootloader.asm -o build/bootloader.bin

# Compila o kernel
i586-elf-gcc -ffreestanding -m32 -c kernel/kernel.c -o build/kernel.o
i586-elf-ld -o build/kernel.bin -Ttext 0x1000 build/kernel.o --oformat binary

# Cria a imagem de disco
dd if=/dev/zero of=build/floppy.img bs=512 count=2880
mkfs.vfat -F 12 build/floppy.img
sudo mount -o loop build/floppy.img /mnt
sudo dd if=build/bootloader.bin of=/mnt/boot.bin bs=512 count=1 conv=notrunc
sudo cp build/kernel.bin /mnt/
sudo umount /mnt

echo "Build completed. Run with: qemu-system-i386 -fda build/floppy.img"
