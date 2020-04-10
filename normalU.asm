userSession macro
LOCAL menu,initGame, logout
    menu:
        clearScreen
        print header2
        print userMenu
        getChar
        cmp al, '1'
        je initGame
        cmp al, '2'
        je menuPrincipal
        cmp al, '3'
        je logout
        jmp menu
    initGame:
        setVideoMode
        paintBoard 0fh
        paintBackground 08
        getChar
        setTextMode
        jmp menu    
    logout:
        cleanBuffer userName, SIZEOF username, 24h
        cleanBuffer userPass, SIZEOF userPass, 24h
        jmp menuPrincipal

endm

;320*i+j
paintBoard macro color
LOCAL top, bottom, leftSide, rightSide
mov dl, color
mov di, 6410        ;(20,10) 
top:
    mov [di], dl
    inc di
    cmp di, 6710    ;(20,310) 
    jne top
;-------------------------------------------------
mov di, 60810       ;(190,10) 
bottom:
    mov [di], dl
    inc di
    cmp di, 61110   ;(190, 310)
    jne bottom
;-------------------------------------------------
mov di, 6410        ;(20,10) 
leftSide:
    mov [di], dl
    add di, 320
    cmp di, 60810   ;(190,10)
    jne leftSide 
;-------------------------------------------------
mov di, 6709        ;(20,309)  
rightSide:
    mov [di], dl
    add di, 320
    cmp di, 61109   ;(190,309)
    jne rightSide
endm

paintBackground macro color
LOCAL for1, for2
    xor ax, ax    ;count rows
    xor bx, bx    ;next row
    xor cx, cx    ;aux
    mov ax, 0
    mov dl, color
    mov di, 6731      
    jmp for1
    fixRow:
        add bx, 320
        mov di, bx   
    for1:
        inc ax
        mov bx, di
        mov cx, di
        add cx, 298
        for2: 
            mov [di], dl
            inc di 
            cmp di, cx
            jne for2
            cmp ax, 169
            jne fixRow
endm