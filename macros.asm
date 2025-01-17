;--------------------------------------------------------------
;-----------------------GENERAL MACROS-------------------------
;--------------------------------------------------------------

;-----------------------------------------------
;-----------------BASIC MACROS------------------
;-----------------------------------------------
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

getKey macro
    xor ax, ax  ;ah = 0
    int 16h
endm

checkPress macro
    mov ah, 0Bh
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
    ;video mode
    mov ax, 0013h
    int 10h
    ;text mode
    mov ax, 0003h
    int 10h
    printChar 10
endm

;-----Macro to convert an 'int' to 'string'-----
convertAscii macro num,buffer
LOCAL divide,getDigits,cleanRemainder
    xor si, si    
    xor bx, bx      
    xor cx, cx      ;count digits
    mov bl, 10      ;divisor
    mov ax, num
    jmp divide
    
    cleanRemainder:
        xor ah,ah
    divide:
        div bl          ;ax = al/bl
        inc cx          ;count digits
        push ax         
        cmp al, 0       ;quotient == 0? 
        je getDigits   
        jmp cleanRemainder
    getDigits:
        pop ax
        add ah,48
        mov buffer[si],ah
        inc si
        loop getDigits
        mov ah, 24h
        mov buffer[si],ah
endm

;-----Macro to convert ascii to number
;return ax
convertNumber macro num
LOCAL three, two, finish
    xor ax, ax
    xor bx, bx
    xor dx, dx
    
    getLength num
    cmp si, 3
    je three
    cmp si, 2
    je two
    
    mov al, num[0]
    sub al, 48
    jmp finish

    three:  ;ex: num = 330 
        mov ax, 100
        mov bl, num[0]
        sub bl, 48
        mul bx
        ;---------------
        mov dx, ax
        xor ax, ax
        mov ax, 10
        mov bl, num[1]
        sub bl, 48
        mul bx 
        add ax, dx
        ;---------------
        mov bl, num[2]
        sub bl, 48
        add ax, bx
        jmp finish

    two:    ;ex: num = 80
        mov ax, 10
        mov bl, num[0]
        sub bl, 48
        mul bx 
        mov bl, num[1]
        sub bl, 48
        add ax, bx

    finish:

endm

;-------------------DELAY-----------------------
Delay macro constante
LOCAL D1,D2,Fin
    push si
    push di
    mov si,constante

    D1:
        dec si
        jz Fin
        mov di,constante

    D2:
        dec di
        jnz D2
        jmp D1

    Fin:
        pop di
        pop si
endm

;-----------------SOUND-------------------------
Sound macro hz
    mov al, 86h
    out 43h, al
    mov ax, (1193180/hz)
    out 42h, al
    mov al, ah
    out 42h, al
    in al, 61h
    or al, 00000011b
    out 61h, al
    delay 500
    in al, 61h
    and al, 11111100b
    out 61h, al
endm
;-----------------------------------------------------------------------------
;-------------------------------REGISTER--------------------------------------
;-----------------------------------------------------------------------------
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
        mov al, fileData[si]
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
        cleanBuffer fileData, SIZEOF fileData, 24h
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

;-------------------------------------------------------------------------
;-------------------------------LOGIN-------------------------------------
;-------------------------------------------------------------------------
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
        mov al, fileData[si]
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
        cleanBuffer fileData, SIZEOF fileData, 24h
endm

;--------------------------------------------------------------------------
;-----------------------------ADMIN MODE-----------------------------------
;--------------------------------------------------------------------------
adminSession macro
LOCAL menu, topPuntos, topTiempo, logout, bubble, quick, shell, bubbleAsc, bubbleDesc
    menu:
        clearScreen
        print header2
        print adminMenu
        getChar
        cmp al, '1'
        je topPuntos
        cmp al, '2'
        je topTiempo
        cmp al, '3'
        je logout
        jmp menu

    topPuntos:
        ;----------------
        getTopData
        getMax
        getSpaceBetween
        getWidthBar
        ;----------------
        clearScreen
        getTypeSort
        getVelocity 
        isAscDesc

        cmp typeOfSort, 'B'
        je bubble
        cmp typeOfSort, 'Q'
        je quick
        jmp shell

        bubble:
            cmp ax, 1 
            je bubbleAsc

            bubbleDesc:
                bubbleSortDesc arrayTop
                printReport arrayTop
                getChar
                createReport arrayTop
                jmp menu

            bubbleAsc:
                bubbleSortAsc arrayTop
                printReport arrayTop
                getChar
                createReport arrayTop
                jmp menu

        quick:

            quickSort arrayTop

            jmp menu

        shell:

            jmp menu
    topTiempo:
        statistics
        jmp menu
    logout:
        cleanBuffer userName, SIZEOF username, 24h
        cleanBuffer userPass, SIZEOF userPass, 24h
        jmp menuPrincipal

endm

getTypeSort macro
LOCAL menu, bubble, quick, shell, finish
    menu:
        print sortMenu
        getChar
        cmp al, '1'
        je bubble
        cmp al, '2'
        je quick
        cmp al, '3'
        je shell
        jmp menu

    bubble:
        mov typeOfSort, 'B'
        jmp finish
    
    quick:
        mov typeOfSort, 'Q'
        jmp finish
    
    shell:
        mov typeOfSort, 'S'
    
    finish:

endm

getVelocity macro
    xor ax, ax
    xor bx, bx
    print velMsg
    getChar
    mov velChoosed, al
    mov bl, al
    sub bl, 48
    xor ax, ax
    mov ax, 200
    mul bx
    mov velocity, ax
endm

;return ax 1 = asc | 0 = desc
isAscDesc macro
LOCAL menu, ascendent, descendet, finish
    
    menu:
        print typeMsg
        getChar 
        cmp al, '1'
        je ascendent
        cmp al, '2'
        je descendent
        jmp menu

    ascendent:
        mov ax, 1
        jmp finish

    descendent:
        mov ax, 0
        
    finish:

endm

printReport macro array
LOCAL for, finish, auxSpaces, finishSpaces, printSpaces
    xor cx, cx
    xor si, si
    print dashes
    print topTitle
    for: 
        cmp cl, nElements
        je finish

        push cx
        push si 
        getName array[si]
        pop si
        pop cx
        print newLine
        add cx, 49
        
        print space
        printChar cl 
        printChar 46
        printChar 32
        print auxName
        
        push si 
        getLength auxName
        cmp si, 7
        je finishSpaces

        printSpaces:
            printChar 32
            inc si
            cmp si, 7
            jne printSpaces
        finishSpaces:
            pop si
        
        print space

        mov bl, arrayTop[si+1]
        add bl, 48
        printChar bl
        print space
        
        pusha 
        cleanBuffer auxd, SIZEOF auxd, 24h
        popa

        pusha
        xor dx, dx
        mov dl, arrayTop[si+2]
        convertAscii dx, auxd
        print auxd 
        popa

        sub cx, 49
        pusha
        cleanBuffer auxName, SIZEOF auxName, 24h
        popa

        add si, 3
        inc cx  
        jmp for
    
    finish:
        print newLine
        print newLine
        print dashes
endm

getName macro val
LOCAL while, copyName, incrementCX, copyName, finish, auxCopy

    openFile top1File, handler
    readFile handler, fileData, SIZEOF fileData
    closeFile handler

    xor bx, bx
    xor cx, cx
    xor dx, dx
    
    while:
        cmp val, cl 
        je copyName 

        mov dl, fileData[bx]

        cmp dl, 10
        je incrementCX

        inc bx
        jmp while


        incrementCX:
            inc cx
            inc bx
            jmp while

        copyName:
            xor si, si
            auxCopy:
                mov dl, fileData[bx]
                
                cmp dl, ','
                je finish

                mov auxName[si], dl
                inc si 
                inc bx
                jmp auxCopy

        finish:

endm

;-------------------------------------------------------------------------=
;-----------------------------NORMAL USER----------------------------------
;--------------------------------------------------------------------------
userSession macro
LOCAL menu, startGame, logout
    menu:
        clearScreen
        print header2
        print userMenu
        getChar
        cmp al, '1'
        je startGame
        cmp al, '2'
        je chargeGame
        cmp al, '3'
        je logout
        jmp menu
    startGame:
        initGame
        jmp menu    
    chargeGame:
        print msgFile
        ;getPath inputFile
        ;analisis
        jmp menu
    logout:
        cleanBuffer userName, SIZEOF username, 24h
        cleanBuffer userPass, SIZEOF userPass, 24h
        jmp menuPrincipal

endm