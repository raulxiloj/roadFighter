initGame macro
    setVideoMode
    paintBoard 0fh
    paintBackground 7
    mov currPos, 50072
    drawCar 50072        
    moveCar
    setTextMode
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

drawCar macro pos 
LOCAL body, wheels1, wheels2
    mov di, pos
    mov dl, 4

    mov [di+3], dl
    mov [di+4], dl
    mov [di+5], dl
    mov [di+6], dl
    mov [di+7], dl
    mov [di+8], dl
    mov [di+9], dl
    mov [di+10], dl
    mov [di+11], dl
    mov [di+12], dl
    mov [di+13], dl
    mov [di+14], dl
    mov [di+15], dl
    mov [di+16], dl

    mov cx, 24
    body:
        add di, 320
        mov [di+3], dl
        mov [di+4], dl
        mov [di+5], dl
        mov [di+6], dl
        mov [di+7], dl
        mov [di+8], dl
        mov [di+9], dl
        mov [di+10], dl
        mov [di+11], dl
        mov [di+12], dl
        mov [di+13], dl
        mov [di+14], dl
        mov [di+15], dl
        mov [di+16], dl
        loop body

    ;-------------------------------
    mov di, pos
    mov dl, 0
    add di, 640
    mov [di], dl
    mov [di+1], dl
    mov [di+2], dl
    mov [di+17], dl
    mov [di+18], dl
    mov [di+19], dl
    mov cx, 6
    wheels1:
        add di, 320
        mov [di], dl
        mov [di+1], dl
        mov [di+2], dl
        mov [di+17], dl
        mov [di+18], dl
        mov [di+19], dl
        loop wheels1
    ;-------------------------------
    add di, 2240
    mov [di], dl
    mov [di+1], dl
    mov [di+2], dl
    mov [di+17], dl
    mov [di+18], dl
    mov [di+19], dl
    xor cx, cx
    mov cx, 7
    wheels2:
        add di, 320
        mov [di], dl
        mov [di+1], dl
        mov [di+2], dl
        mov [di+17], dl
        mov [di+18], dl
        mov [di+19], dl
        loop wheels2
endm

eraseCar macro 
LOCAL while, while2, littleFix
    xor bx, bx      ;next row
    xor cx, cx      ;counter, ch for rows and cl for cols
    mov cx, 0
    mov dl, 7
    mov di, currPos
    jmp while
    littleFix:
        add bx, 320
        mov di, bx
        mov cl, 0
    while:
        inc ch
        mov bx, di
        while2:
            mov [di], dl
            inc di 
            inc cl
            cmp cl, 20
            jne while2
            cmp ch, 25
            jne littleFix    

endm

moveCar macro
LOCAL while, moveLeft, moveRight, pauseGame, finishGame, finish
    while:
        getKey 
        cmp ah, 4Bh
        je moveLeft
        cmp ah, 4Dh      
        je moveRight
        cmp al, 27      ;ESC 
        je pauseGame
        cmp al, 32      ;Space
        je finishGame
        jmp while
    
    moveLeft:   
        eraseCar
        sub currPos, 5
        drawCar currPos
        jmp while

    moveRight:
        eraseCar
        add currPos, 5
        drawCar currPos
        jmp while

    pauseGame:
        ;print prueba
        jmp while

    finishGame:
        ;save result of game

    finish:

endm