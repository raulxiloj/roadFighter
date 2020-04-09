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
    printChar 10
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
LOCAL while, changeState, continue, checkName , finish
    getUsersData
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
        compareStrings userName, auxUser, 7
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

;return dx (0 = not equal, 1 = equal)
compareStrings macro str1, str2, length
LOCAL while, finish, continue, notEqual, equal
    xor di, di
    xor bx, bx
    xor dx, dx
    while:
        cmp di, length
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

;---------------------------------------------------------------------------------
loginAccess macro
LOCAL isAdmin, isUser, error
    print msgLogin
    print inputName
    getString userName
    print inputPass
    getString userPass
    
    isAdmin:
        compareStrings userName, adminName, 5
        cmp dx, 0
        je isUser
        compareStrings userPass, adminPass, 4
        cmp dx, 0
        je error
        adminSession

    isUser:
        checkIfIsUser
        cmp dx, 0
        je error
        userSession

    error:
        cleanBuffer userName, SIZEOF username, 24h
        cleanBuffer userPass, SIZEOF userPass, 24h
        print error9
        getChar
        jmp menuPrincipal

endm

checkIfIsUser macro
LOCAL while, checkUser, changeState, state1, state2, continue, finish
    getUsersData
    xor si, si
    xor ax, ax 
    xor bx, bx
    xor cx, cx  ;flag for state. 0 = user | 1 = password

    ;Split data
    while:
        cmp si, fileSize
        je finish
        xor ah, ah
        mov al, usersData[si]
        cmp al, 10
        je checkUser 
        cmp al, ','
        je changeState
        cmp cx, 1
        je state2

        state1:
            mov auxUser[bx], al    
            inc bx
            jmp continue

        state2:
            mov auxPass[bx], al    
            inc bx
            jmp continue

        changeState:
            mov cx, 1
            xor bx, bx

        continue:
            inc si
            jmp while  
        
    checkUser:
    ;check username
    compareStrings userName, auxUser, 7
    pusha
    cleanBuffer auxUser, SIZEOF auxUser, 24h
    popa
    xor bx, bx      ;restart aux
    xor cx, cx      ;restart flag
    cmp dx, 0
    je continue
    ;check password
    compareStrings userPass, auxPass, 4
    pusha
    cleanBuffer auxPass, SIZEOF auxPass, 24h
    popa
    cmp dx, 1 
    je finish
    jmp continue

    finish:
    
endm