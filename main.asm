include macros.asm
include graphics.asm
include files.asm
include game.asm

.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header1     db 9,9,9,"======================",10,9,9,9,"     Road fighter     ",10,9,9,9,"======================",10,'$' 
header2     db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,"FACULTAD DE INGENIERIA",10,"CIENCIAS Y SISTEMAS",10,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,"NOMBRE: RAUL XILOJ",10,"CARNET: 201612113",10,"SECCION: A",10,'$'
mainMenu    db 10,9,9,9,"     1. Ingresar",10,9,9,9,"     2. Registrar",10,9,9,9,"     3. Salir",10,10,9,9,9,"Ingrese una opcion: ",'$'
userMenu    db 10,"1. Iniciar juego",10,"2. Cargar juego",10,"3. Logout",10,10,"Ingrese una opcion: ",'$'
adminMenu   db 10,"1. Top 10 puntos",10,"2. Top 10 tiempo",10,"3. Logout",10,10,"Ingrese una opcion: ",'$'
comma       db ","
newLine     db 10,'$'
;------------------------------Game var's---------------------------------------
currPos     dw ?                ;Actual position of  the car              
points      dw ?                ;var for managing points
pointsAux   db "000",'$'         
awards      db 30 dup ('$')     ;array of awards blocks
obstacles   db 30 dup ('$')     ;array of obstacles blocks
blocks      db 99 dup (0)
auxBlock    db 3 dup (0)
;-------Time game-------
seconds     dw ?
time        db "00:00:00",'$'
;------------------------Login & Register variables--------------------------
msgRegister db "Registro",10,"========",10,10,'$'
msgLogin    db "Ingresar",10,"========",10,10,'$'
inputName   db "Username: ",'$'
userName    db 15 dup ('$')
inputPass   db "Password: "
userPass    db 10 dup ('$')
auxUser     db 15 dup ('$')
auxPass     db 4 dup ('$')
adminName   db "admin"
adminPass   db "1234"
;------------------------File messages and variables-------------------------
userFile    db "c:\pro\users.txt",0
usersData   db 1000 dup('$')
fileSize    dw 0
handler     dw ?
userSaved   db 10,"Usuario registrado correctamente ",'$'
;----------------------------Possibles errors--------------------------------
error1      db 10,13,"ERROR: Opcion invalida",10,13,'$'
error2      db 10,13,"ERROR al abrir archivo",10,13,'$'
error3      db 10,13,"ERROR al escribir en el archivo",10,13,'$'
error4      db 10,13,"ERROR al cerrar el archivo",10,13,'$'
error5      db 10,13,"ERROR: moviendo el puntero del fichero",10,13,'$'
error6      db "ERROR: el nombre de usuario no puede exceder los 7 caracteres", 10,'$'
error7      db "ERROR: la contrasena tiene que ser 4 digitos",10,'$'
error8      db "ERROR: ese nombre ya esta registrado, por favor ingrese otro",10,'$'
error9      db "ERROR: credenciales incorrectas",10,'$'
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
        clearScreen
        loginAccess
        jmp menuPrincipal
    register:
        clearScreen
        registerUser
        jmp menuPrincipal
    invalidChar:

        jmp menuPrincipal
    errorOpening:
        print error2
        getChar
        jmp menuPrincipal
    errorReading:
        getChar
        jmp menuPrincipal
    errorWriting:
        print error3
        getChar
        jmp menuPrincipal
    errorClosing:
        print error4
        getChar
        jmp menuPrincipal
    errorAppending:
        print error5
        getChar
        jmp menuPrincipal
    exit:
        mov ah, 4ch
        int 21h
main endp

end main