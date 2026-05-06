org 100h

jmp start

; ---------------- DATA ----------------
prompt db 'Enter Password: $'
success db 13,10,'Access Granted$'
fail db 13,10,'Wrong Password$'
blocked db 13,10,'Access Denied (3 attempts used)$'

password db 'admin'
input db 0,0,0,0,0

; ---------------- CODE ----------------
start:
    mov ax, cs
    mov ds, ax

    mov bx, 3          ; 3 attempts

again:
    ; show prompt
    mov ah, 09h
    mov dx, prompt
    int 21h

    ; read password (5 chars)
    mov si, input
    mov cx, 5

read_loop:
    mov ah, 01h
    int 21h
    mov [si], al
    inc si
    loop read_loop

    ; compare password
    mov si, input
    mov di, password
    mov cx, 5

compare_loop:
    mov al, [si]
    cmp al, [di]
    jne wrong
    inc si
    inc di
    loop compare_loop

    ; correct password
    mov ah, 09h
    mov dx, success
    int 21h
    jmp exit

wrong:
    dec bx
    cmp bx, 0
    je blocked_msg

    mov ah, 09h
    mov dx, fail
    int 21h
    jmp again

blocked_msg:
    mov ah, 09h
    mov dx, blocked
    int 21h

exit:
    mov ah, 4ch
    int 21h