;--------------------------------------------------------------
;-----------------------macros generales-----------------------
;--------------------------------------------------------------

;-------------BASIC MACROS--------------
print macro cadena
    mov ah, 09h
    mov dx, offset cadena
    int 21h
endm

printChar macro char
    mov ah, 02h
    mov dl, char
    int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

;Macro para obtener texto del usuario
;param array = variable en donde se almacerana el texto 
getString macro array
LOCAL getCadena, finCadena
    xor si,si    
    getCadena:
        getChar
        cmp al,0dh
        je finCadena
        mov array[si],al
        inc si
        jmp getCadena
    finCadena:
    mov al,24h
    mov array[si],al
endm

getLength macro var
LOCAL while, finish
    xor si,si
    while:
        cmp var[si],24h
        je finish
        inc si
        jmp while
    finish:
endm

;Macro para limpiar un array 
;param buffer = array de bytes
;param numBytes = numero de bytes a limpiar
;para caracter = caracter con el que se va a limpiar 
cleanBuffer macro buffer,numBytes,caracter
LOCAL repeat 
    mov si,0
    mov cx,0
    mov cx,numBytes
    repeat:
    mov buffer[si],caracter
    inc si
    loop repeat
endm

clearScreen macro
    setGraphicMode
    setTextMode
endm

;------------------------------------------------------------------------------------
registerUser macro
LOCAL checkUserLength, continue, errorLength1, errorLength2, finish, checkPassLength
    print msgRegister
    checkUserLength:
        print inputName
        getString userName
        getLength userName
        cmp si, 0
        je checkUserLength
        cmp si, 8
        jl checkPassLength
    errorLength1:
        print error6
        cleanBuffer userName, SIZEOF userName, 24h
        jmp checkUserLength
    ;checkUserExist: tag TODOcheck if it already exist
    checkPassLength:
        print inputPass
        getString userPass
        getLength userPass
        cmp si, 4
        je continue
    errorLength2:
        print error7
        cleanBuffer userPass, SIZEOF userPass, 24h
        jmp checkPassLength
    continue:
        checkNumericPassword
        cmp al, 1
        je checkPassLength
    finish:
        saveUser userName, userPass 
        cleanBuffer userName, SIZEOF userName, 24h
        cleanBuffer userPass, SIZEOF userPass, 24h
endm

checkNumericPassword macro
LOCAL while, continue, error, finish
    int 3
    xor ax, ax
    xor si, si
    while:
        cmp userPass[si], 48
        jge continue
        jmp error
    continue:
        cmp userPass[si], 57
        jg error
        inc si    
        cmp si, 4
        je finish
        jmp while
    error:
        mov ax, 1
        print error7
        cleanBuffer userPass, SIZEOF userPass, 24h
    finish:
    
endm
