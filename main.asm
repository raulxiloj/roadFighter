include macros.asm
include graphics.asm

.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header1    db 9,9,9,"======================",10,9,9,9,"     Road fighter     ",10,9,9,9,"======================",10,'$' 
header2    db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,"FACULTAD DE INGENIERIA",10,"CIENCIAS Y SISTEMAS",10,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,"NOMBRE: RAUL XILOJ",10,"CARNET: 201612113",10,"SECCION: A",10,'$'
mainMenu   db 10,9,9,9,"     1. Ingresar",10,9,9,9,"     2. Registrar",10,9,9,9,"     3. Salir",10,10,9,9,9,"Ingrese una opcion: ",'$'
;----------------------------Possibles errors--------------------------------
error1       db 10,13,"Error: Opcion invalida",10,13,'$'
;---------------------------------------------------------------------------------------------
;-----------------------------------------Code segment-----------------------------------------
;----------------------------------------------------------------------------------------------
.code
main proc
    mov ax, @data
    mov ds,ax
    menuPrincipal:
        clearScreen
        print header1
        print mainMenu
        getChar
        cmp al, '1'
        je login
        cmp al, '2'
        je register
        cmp al, '3'
        je exit
        jmp invalidChar
    login:

        jmp menuPrincipal
    register:

        jmp menuPrincipal
    invalidChar:
        jmp menuPrincipal
    exit:
        mov ah, 4ch
        int 21h
main endp

end main