org 0x7c00

jmp 0:start

ASCII_BACKSPACE equ 0x08
ASCII_RETURN equ 0x0d
ASCII_NEWLINE equ 0x0a
ASCII_NULL equ 0x00
ASCII_SPACE equ 0x20

INT_VECTOR_VIDEO equ 0x10
INT_VECTOR_DRIVE equ 0x13
INT_VECTOR_MISC equ 0x15
INT_VECTOR_KEYBOARD equ 0x16

VIDEO_PRINT equ 0x0e
MISC_WAIT equ 0x86
DRIVE_READ_SECTOR equ 0x02
DRIVE_WRITE_SECTOR equ 0x03

MIN_USERNAME_LENGTH equ 3
MAX_USERNAME_LENGTH equ 12

; CONST STRINGS
INPUT_MESSAGE: db 'Enter your name', ASCII_RETURN, ASCII_NEWLINE, ASCII_NULL
WELCOME_MESSAGE: db 'Hello '
NAME: db ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL
ENDL: db ASCII_RETURN, ASCII_NEWLINE, ASCII_NULL
DRIVE: dw 0x00

; Sets bx to NAME[%1] pointer
%macro get_name_index 1
    mov bx, NAME
    add bx, %1
%endmacro

; Wrapper for print_char function
%macro print_char_macro 1
    mov al, %1
    call print_char
%endmacro

; Wrapper for print function
%macro print_macro 1
    mov ax, %1
    call print
%endmacro

; Call wait sectors BIOS interrupt
%macro wait 0
  mov ah, MISC_WAIT
  int INT_VECTOR_MISC
%endmacro

; Prepares registers for drive sector read (write)
; @param 1 source (destination) for read (write)
%macro prepare_drive 1
  ; Source (Destination) sector = %1
  mov cl, %1
  ; Track = 0
  xor ch, ch
  ; Head = 0
  xor dh, dh
  ; Sectors Count = 1
  mov al, 0x01
  ; Set drive
  mov dl, [DRIVE]
%endmacro

; Call write sectors BIOS interrupt
%macro write_sectors 0
    mov ah, DRIVE_WRITE_SECTOR
    int INT_VECTOR_DRIVE
%endmacro

; Call read sectors BIOS interrupt
%macro read_sectors 0
    mov ah, DRIVE_READ_SECTOR
    int INT_VECTOR_DRIVE
%endmacro

; Prints character
; @param `al` character to print
print_char:
    mov ah, VIDEO_PRINT
    int INT_VECTOR_VIDEO
    ret

; Reads character
; @returns `al` character
read_char:
    xor ah, ah
    int INT_VECTOR_KEYBOARD
    ret

; Prints null terminated string
; @param `ax` pointer to first letter
print:
    mov bx, ax

print_loop:
    mov al, [bx]

    ; Finish if it's a null character
    test al, al
    jz print_end

    ; Otherwise print it
    call print_char

    ; Continue with the next character
    inc bx
    jmp print_loop

print_end:
    ret


start:

init_registers:
    ; Save drive number for future operations
    mov [DRIVE], dl

    ; Set all registers to 0
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax


; Initialize stack
init_stack:
    mov sp, 0x8000

; Print "Enter your name\r\n" message
input:
    mov ax, INPUT_MESSAGE
    call print

; Read characters
read_username:
    xor cx, cx

read_username_loop:
    call read_char

    cmp al, ASCII_RETURN
    je read_username_return

    cmp al, ASCII_BACKSPACE
    je read_username_backspace

    cmp cx, MAX_USERNAME_LENGTH
    jge read_username_loop

read_username_char:
    call print_char

    ; Set NAME[index] to character in al
    get_name_index cx
    mov [bx], al

    ; Increase length and continue
    inc cx
    jmp read_username_loop

read_username_backspace:
    ; If the name is empty continue the loop
    test cx, cx
    jz read_username_loop

    ; Remove previous character from screen
    call print_char
    print_char_macro ASCII_SPACE
    print_char_macro ASCII_BACKSPACE

    ; Set NAME[index] to null character
    get_name_index cx
    mov byte [bx], ASCII_NULL

    ; Decrease length
    dec cx
    jmp read_username_loop

read_username_return:
    ; If the name is long enough go to end
    cmp cx, MIN_USERNAME_LENGTH
    jge read_username_end

    ; Else
    jmp read_username_loop

read_username_end:
    ; Print endl
    print_macro ENDL

    ; Print welcome message and name as WELCOME_MESSAGE is not null
    ; terminated and NAME is in memory right after WELCOME_MESSAGE
    print_macro WELCOME_MESSAGE

    ; Print endl
    print_macro ENDL

save_username:
    prepare_drive 0x03

    ; Set source address to NAME
    mov bx, NAME

    write_sectors

wait_2s:
    ; 0x8480 + 0xffff * 0x1e = 0x1e8480
    mov dx, 0x8480
    mov cx, 0x1e
    wait

load_copy_instructions:
    prepare_drive 0x02
    mov bx, 0x7e00
    read_sectors
    jmp 0x7e00

; Fill the rest with zeros and add 0xaa55 sequence
times (510 - $ + $$) db 0
dw 0xaa55

; Second drive secotor (won't be overriden by drive load)
copy_minix_bootloader:
    prepare_drive 0x04

    ; Set destination to standard bootloader place
    mov bx, 0x7c00
    read_sectors

    jmp 0x7c00

times (1024 - $ + $$) db 0
