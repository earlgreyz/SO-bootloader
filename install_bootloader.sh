BOOTLOADER_ASM_FILE=/root/bootloader.asm
BOOTLOADER_FILE=/root/bootloader
DEVICE=/dev/c0d0

BOOTLOADER_FILE=/root/bootloader
DEVICE=/dev/c0d0

echo -n "Compiling bootloader..."
nasm ${BOOTLOADER_ASM_FILE} -f bin -o ${BOOTLOADER_FILE} || return 1
echo "OK"

echo -n "Moving default bootloader..."
dd bs=512 count=1 if=/dev/c0d0 of=/dev/c0d0 seek=1 || return 2
echo "OK"

echo "Trying to install bootloader..."
dd bs=446 count=1 if=$BOOTLOADER_FILE of=$DEVICE || return 3
echo "OK"

echo "Succesfully installed bootloader: "
dd bs=446 count=1 if=$DEVICE | od -Ax -tx1 -v
