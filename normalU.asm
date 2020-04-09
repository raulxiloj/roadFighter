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