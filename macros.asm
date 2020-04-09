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
LOCAL checkUserLength, continue, errorLength1, errorLength2, finish, checkPassLength, checkNameUsed
    print msgRegister
    checkUserLength:
        print inputName
        getString userName
        getLength userName
        cmp si, 0
        je checkUserLength
        cmp si, 8
        jl checkNameUsed
    errorLength1:
        print error6
        cleanBuffer userName, SIZEOF userName, 24h
        jmp checkUserLength
    checkNameUsed:
        nameAlreadyUsed
        cmp dx, 0
        je checkPassLength
        print error8
        cleanBuffer userName, SIZEOF userName, 24h
        jmp checkUserLength
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

;return dx
nameAlreadyUsed macro
LOCAL while, changeState, continue, checkName, match, notMatch, finish
    
    ;get Data
    openFile userFile, handler
    readFile handler, usersData, 1000 
    closeFile handler

    xor si, si
    xor ax, ax 
    xor bx, bx
    xor cx, cx  ;flag for state. 0 = getUser | 1 = find char of exit '\n'

    ;Split data
    while:
        cmp si, fileSize
        je finish
        xor ah, ah
        mov al, usersData[si]
        cmp al, 10
        je checkName 
        cmp al, ','
        je changeState
        cmp cx, 1
        je continue

        mov auxUser[bx], al    
        inc bx
        jmp continue

        changeState:
            mov cx, 1

        continue:
            inc si
            jmp while  
        
    checkName:
        compareStrings userName, auxUser
        pusha
        cleanBuffer auxUser, SIZEOF auxUser, 24h
        popa
        xor bx, bx      ;restart aux
        xor cx, cx 
        cmp dx, 1
        je finish
        jmp continue
    finish:
        cleanBuffer auxUser, SIZEOF auxUser, 24h
endm

;return dx
compareStrings macro str1, str2
LOCAL while, finish, continue, notEqual, equal
    xor di, di
    xor bx, bx
    xor dx, dx
    while:
        cmp di, 7
        je equal

        mov bh, str1[di]
        mov bl, str2[di]
        cmp bh, bl
        je continue
        jmp notEqual

        continue:
            inc di
            jmp while
    
    notEqual:
        mov dx, 0
        jmp finish
    
    equal:
        mov dx, 1

    finish:
endm
