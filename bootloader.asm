org 0x7c00

jmp 0:start

WELCOME_MSG: db 'Hello!', 0xd, 0xa, 0x0

; Wypisuje litere z rejestru al
print_char:
    mov ah, 0x0e
    int 0x10
    ret

; Wczytuje znak z klawiatury
read_char:
    xor ah, ah
    int 0x16
    ret

; Wypisuje słowo podane w rejestrze ax
print:
    mov bx, ax

print_loop:
    mov al, [bx]
    test al, al
    jz print_end
    call print_char
    add bx, 1
    jmp print_loop

print_end:
    ret

start:
    ; Zerowanie rejestrów
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    ; inicjacja stosu
    mov sp, 0x8000
    ; Wypisanie hello
    mov ax, WELCOME_MSG
    call print

read_and_print:
    call read_char
    call print_char
    jmp read_and_print

; Dopełnienie zerami i dodanie sekwencji aa55
times (510 - $ + $$) db 0
dw 0xaa55
