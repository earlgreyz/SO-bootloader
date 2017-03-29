org 0x7c00          ; informacja o poczatkowym adresie progoramu

jmp 0:start         ; wyzerowanie rejestru cs

WELCOME_MSG: db 'Hello!', 0xd, 0xa, 0x0

; Wypisuje litere z rejestru al
print_char:
    mov ah, 0xe
    int 0x10
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
    mov ax, cs      ; wyzerowanie pozostalych rejestrow
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x8000  ; inicjacja stosu
    mov ax, WELCOME_MSG
    call print

times (510 - $ + $$) db 0;
dw 0xaa55
