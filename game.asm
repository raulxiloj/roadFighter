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
    initAwardsBlocks
    mov timeAward, 5
    mov currPos, 50072
    drawCar 50072              ;Initial position of the car 
    ;--------------------
    ;getPosition awards[28],awards[30]
    ;drawBlock ax, 0Eh, 0Ch
    ;--------------------
    runGame
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
        cmp al, 27      ;ESC 
        je pauseGame
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
    
    pauseGame:
        getKey  
        cmp al, 27      ;ESC 
        je refresh
        jmp pauseGame

    refresh:
        Delay 1200
        updateTime
        push bx
        moveAwards
        pop bx
        inc timeAux1
        inc timeAux2
        generateAwards

        ;TODO check points to finish
        ;cmp points, 0
        ;jl finishGame
        ;TODO check time level 
        ;cmp timeLevel, 
        ;je fin
        jmp while

    finishGame:
        ;save result of game
        cleanTime
        mov numAwards, 0
        mov timeAux1, 0

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
initAwardsBlocks macro
LOCAL while, addY, subY, continue
    ;RANDOM VAR for custom positions TODOOOOOOOOOO
    xor bx, bx
    xor cx, cx
    mov cx, 15
    while:
        mov awards[bx], 21                ;i
        mov awards[bx + 2], cx            ;j
        add bx, 4

    addY:
        add cx, 50
        cmp cx, 285
        jge subY
        jmp continue

    subY:
        sub cx, 200
        cmp cx, 15
        jle addY

    continue:
        cmp bx, 40
        jne while

endm

getPosition macro coorX, coorY
    xor ax, ax
    xor bx, bx
    mov ax, 320
    mov bx, coorX
    mul bx
    mov bx, coorY
    add ax, bx
endm

moveAwards macro
LOCAL while, continue, startAgain, finish, for
    xor si, si
    xor cx, cx
    mov cl, numAwards
    while:
        cmp cl, 0
        je finish
        push cx
        getPosition awards[si], awards[si+2]
        eraseBlock ax
        pop cx 
        add awards[si], 5
        cmp awards[si], 170
        jae startAgain
        jmp continue

    startAgain:
        mov awards[si], 21
        dec numAwards
        ;---------------------
        push si
        xor si, si
        for:
            xor ax, ax
            mov ax, awards[si+4]
            mov awards[si], ax
            mov ax, awards[si+6]
            mov awards[si + 2], ax 
            add si, 4
            cmp si, 36
            jne for
            ;generate random xd
            mov awards[36], 21
            mov awards[38], 50
        pop si
        ;---------------------
        jmp while

    continue:
        push cx
        getPosition awards[si], awards[si+2]
        drawBlock ax, 0Eh, 0Ch
        pop cx
        add si, 4
        dec cl
        jmp while

    finish:

endm

generateAwards macro
    mov al, timeAux1
    cmp al, timeAward
    jne finish

    inc numAwards
    mov timeAux1, 0

    finish:

endm

cleanTime macro
    mov minutes,0
    mov seconds,0
    mov minsAux[0], '0'
    mov minsAux[1], '0'
    mov secsAux[0], '0'
    mov secsAux[1], '0'
endm