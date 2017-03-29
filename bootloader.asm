org 0x7c00

jmp 0:start

ASCII_BACKSPACE equ 0x08
ASCII_RETURN equ 0x0d
ASCII_NEWLINE equ 0x0a
ASCII_NULL equ 0x00
ASCII_SPACE equ 0x20

INT_VECTOR_KEYBOARD equ 0x16
INT_VECTOR_VIDEO equ 0x10

VIDEO_PRINT equ 0x0e

MIN_USERNAME_LENGTH equ 3
MAX_USERNAME_LENGTH equ 12

; Welcome message
WELCOME_MSG: db 'Enter your name', ASCII_RETURN, ASCII_NEWLINE, ASCII_NULL
; Reserved 12 bytes for username
NAME: resb MAX_USERNAME_LENGTH

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

; Main
start:

; Sets all registers to 0
init_registers:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax

; Initializes stack
init_stack:
    mov sp, 0x8000

; Prints "Enter your name\r\n" message
welcome:
    mov ax, WELCOME_MSG
    call print

; Reads characters
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
    inc cx
    jmp read_username_loop

read_username_backspace:
    ; If the name is empty continue the loop
    test cx, cx
    jz read_username_loop

    ; Remove previous character from screen
    call print_char
    mov al, ASCII_SPACE
    call print_char
    mov al, ASCII_BACKSPACE
    call print_char

    ; Decrease length
    dec cx
    jmp read_username_loop

read_username_return:
    ; If length >= 3 finish input
    cmp cx, MIN_USERNAME_LENGTH
    jge read_username_end

    ; Else
    jmp read_username_loop

read_username_end:
    mov al, '#'
    call print_char

; Dopełnienie zerami i dodanie sekwencji aa55
times (510 - $ + $$) db 0
dw 0xaa55
