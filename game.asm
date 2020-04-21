initGame macro
    setVideoMode
    ;----------------SETUP----------------
    drawString 0, 1, userName       ;user
    drawChar 0, 13, 78              ;level N
    drawChar 0, 14, 49              ;#
    drawString 0, 22, pointsAux     ;points
    drawString 0, 74, minsAux       ;--time--
    drawString 0, 76, twoPts     
    drawString 0, 77, secsAux       
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
        Delay 1000
        updateTime
        ;moveObjects
        jmp while

    finishGame:
        ;save result of game

endm

updateTime macro
LOCAL mins, secs, finish
    xor cx, cx
    inc seconds 
    cmp seconds, 60
    jge mins

    secs:
        cmp seconds, 9
        jg twoDigits
        
        oneDigit:
            mov cx, seconds
            add cx, 48
            mov secsAux[1], cl
            jmp finish
        twoDigits:
            convertAscii seconds, secsAux
            jmp finish
    mins:
        ;i should check if the minutes are up to 10 but i really doubt it so fk it 
        mov seconds, 0
        mov secsAux[0], '0'
        mov secsAux[1], '0'
        inc minutes
        mov cx, minutes
        add cx, 48
        mov minsAux[1], cl
    finish:
        drawString 0, 74, minsAux       
        drawString 0, 76, twoPts        
        drawString 0, 77, secsAux 
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