include macros.asm

.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header     db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,"FACULTAD DE INGENIERIA",10,"CIENCIAS Y SISTEMAS",10,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,"NOMBRE: RAUL XILOJ",10,"CARNET: 201612113",10,"SECCION: A",10,'$'
menu1      db 10,"1. Ingresar",10,"2. Registrar",10,"3. Salir",10,10, "Ingrese una opcion: ",'$'

;---------------------------------------------------------------------------------------------
;-----------------------------------------Code segment-----------------------------------------
;----------------------------------------------------------------------------------------------
.code
main proc
    mov ax, @data
    mov ds,ax
    menuPrincipal:
        print menu1
        getChar
        cmp al, '1'
        je login
        cmp al, '2'
        je register
        cmp al, '3'
        je exit
    login:

        jmp menuPrincipal
    register:

        jmp menuPrincipal
    exit:
        mov ah, 4ch
        int 21h
main endp

end main