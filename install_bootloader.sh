BOOTLOADER_ASM_FILE=/root/bootloader.asm
BOOTLOADER_FILE=/root/bootloader
DEVICE=/dev/c0d0

BOOTLOADER_FILE=/root/bootloader
DEVICE=/dev/c0d0

echo "Compiling bootloader"
nasm ${BOOTLOADER_ASM_FILE} -f bin -o ${BOOTLOADER_FILE} || return 1

echo "Trying to install bootloader..."
dd bs=512 count=1 if=$BOOTLOADER_FILE of=$DEVICE

echo "Succesfully installed bootloader: "
dd bs=512 count=1 if=$DEVICE | od -Ax -tx1 -v
