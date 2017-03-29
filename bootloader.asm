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

; CONST STRINGS
INPUT_MESSAGE: db 'Enter your name', ASCII_RETURN, ASCII_NEWLINE, ASCII_NULL
WELCOME_MESSAGE: db 'Hello '
NAME: db ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL, ASCII_NULL
ENDL: db ASCII_RETURN, ASCII_NEWLINE, ASCII_NULL

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
input:
    mov ax, INPUT_MESSAGE
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

; Fill the rest with zeros and add 0xaa55 sequence
times (510 - $ + $$) db 0
dw 0xaa55
