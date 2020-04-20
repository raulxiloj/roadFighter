initGame macro
    setVideoMode
    ;----------------SETUP----------------
    drawString 0, 1, userName       ;user
    drawChar 0, 12, 78              ;level N
    drawChar 0, 13, 49              ;#
    drawString 0, 21, pointsAux     ;points
    drawString 0, 71, time          ;time
    paintBoard 0fh
    paintBackground 7
    mov currPos, 50072
    drawCar 50072              ;Initial position of the car 
    ;------------------------------------------------
    mov auxBlock[0],'G'
    mov auxBlock[1], 21
    mov auxBlock[2], 15
    runGame
    ;macroTemp 
    ;------------------------------------------------
    ;drawBlock 19050, 2 ,0Ah     
    ;drawBlock 25650, 0Eh , 0Ch
    ;moveCar
    ;getChar
    setTextMode
endm

runGame macro
LOCAL while, refresh, moveCar, moveRight, moveLeft, pauseGame, finishGame
    while: 
        checkPress
        cmp al, 0
        je refresh
    
    moveCar:
        getKey  
        cmp ah, 4Bh
        je moveLeft
        cmp ah, 4Dh      
        je moveRight
        ;cmp al, 27      ;ESC 
        ;je pauseGame
        cmp al, 32      ;Space
        je finishGame
    
    moveLeft:   
        push bx
        eraseCar
        pop bx
        sub currPos, 5
        drawCar currPos
        jmp refresh

    moveRight:
        push bx
        eraseCar
        pop bx
        add currPos, 5
        drawCar currPos
        jmp refresh

    refresh:
        ;moveObjects
        jmp while

    finishGame:
        ;save result of game

endm

;-----------------------------------------------------------------------------
;TEMP MACRO for testing 
fillArrayBlocks macro
LOCAL while, addY, subY, continue
    xor bx, bx
    xor cx, cx

    while:
        mov awards[bx], 'G'
        mov awards[bx + 1], 20            ;x
        mov awards[bx + 2], cx            ;y
        add bx, 3

    addY:
        add cx, 25
        cmp cx, 290
        jge subY
        jmp continue

    subY:
        sub cx, 25
        cmp cx, 10
        jle addY

    continue:
        cmp bx, 30
        jne while

endm

getPosition macro coorX, coorY
    xor ax, ax
    xor bx, bx
    mov ax, 320
    mov bl, coorX
    mul bx
    mov bl, coorY
    add ax, bx
endm

macroTemp macro
LOCAL while, continue, startAgain, finish
    getPosition auxBlock[1], auxBlock[2]
    drawBlock ax, 0Eh, 0Ch
    add auxBlock[1], 4
    xor bx, bx
    while:
       
        push bx
        eraseBlock ax
        pop bx
        mov bl, auxBlock[1]
        add bl, 2
        mov auxBlock[1], bl
        cmp auxBlock[1], 170        
        jae startAgain            
        
        continue:
            push bx
            getPosition auxBlock[1], auxBlock[2]
            drawBlock ax, 0Eh, 0Ch
            pop bx
            Delay 400
            jmp while

        startAgain:
            mov auxBlock[1], 21
            xor bx, bx
            jmp continue

endm

movingAwards macro
LOCAL while
xor bx, bx
    while:
        awards[bx+1], 1
        awards[bx+2], 2
        add bx, 3
        cmp bx, 30
        jne while 
endm