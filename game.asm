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
    initObstaclesBlocks
    mov timeAward, 5
    mov timeObs, 10
    mov currPos, 50072
    drawCar 50072              ;Initial position of the car 
    runGame
    setTextMode
endm

;------------------------Main macro for the game-----------------------------
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
        cmp al, 32      ;Space
        je finishGame
        jmp pauseGame

    refresh:
        Delay 1000
        updateTime
        push bx
        moveBlocks awards, numAwards, 0
        moveBlocks obstacles, numObs, 1         
        pop bx
        inc timeAux1
        inc timeAux2
        generateAwards
        generateObstacles
        checkCollision awards, numAwards, 0
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
        mov numObs, 0
        mov timeAux1, 0
        mov timeAux2, 0
endm

;------------------------Init positions of blocks----------------------------
initAwardsBlocks macro
LOCAL while, addY, subY, continue
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

initObstaclesBlocks macro
LOCAL while, addY, subY, continue
    xor bx, bx
    xor cx, cx
    mov cx, 43

    while:
        mov obstacles[bx], 21       ;i
        mov obstacles[bx + 2], cx   ;j
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

;------------------------------------------------------------------------------
getPosition macro coorX, coorY
    xor ax, ax
    xor bx, bx
    mov ax, 320
    mov bx, coorX
    mul bx
    mov bx, coorY
    add ax, bx
endm

moveBlocks macro array, num, type
LOCAL while, continue, startAgain, finish, for, drawObs, auxContinue
    xor si, si
    xor cx, cx
    mov cl, num
    while:
        cmp cl, 0
        je finish
        push cx
        getPosition array[si], array[si+2]
        eraseBlock ax
        pop cx 
        add array[si], 5
        cmp array[si], 170
        jae startAgain
        jmp continue

    startAgain:
        mov array[si], 21
        dec num
        ;---------------------
        push si
        xor si, si
        xor ax, ax
        mov ax, array[0]
        mov auxBlock[0], ax
        mov ax, array[2]
        mov auxBlock[2], ax
        for:
            xor ax, ax
            mov ax, array[si+4]
            mov array[si], ax
            mov ax, array[si+6]
            mov array[si + 2], ax 
            add si, 4
            cmp si, 36
            jne for
            ;-------------------
            mov ax, auxBlock[0]
            mov array[36], ax
            mov ax, auxBlock[2]
            mov array[38], ax
        pop si
        ;---------------------
        jmp while

    continue:
        push cx
        getPosition array[si], array[si+2]
        mov cl, type
        cmp cl, 0 ;yellow 
        jne drawObs
        ;draw award
            drawBlock ax, 0Eh, 0Ch
            jmp auxContinue
        drawObs:
            drawBlock ax, 2, 0Ah
        auxContinue:
        pop cx
        add si, 4
        dec cl
        jmp while

    finish:

endm

generateAwards macro
LOCAL finish
    mov al, timeAux1
    cmp al, timeAward
    jne finish

    inc numAwards
    mov timeAux1, 0

    finish:

endm

generateObstacles macro
LOCAL finish
    mov al, timeAux2
    cmp al, timeObs
    jne finish 

    inc numObs
    mov timeAux2, 0

    finish:
endm

;--------------------------------COLLISSIONS------------------------------------
checkCollision macro array, num, type 
LOCAL for, while, colission, finish, for2, continue, col
    push bx
    xor bx, bx
    xor si, si
    mov cl, num
    cmp cl, 0 
    jbe finish
    int 3
    for: 
        
        getPosition array[si], array[si + 2]
        add ax, 6400
        ;while:
            ;int 3
            cmp ax, currPos
            ja col
            jmp continue
            col:
            mov bx, currPos
            add bx, 20
            cmp ax, bx
            jb colission
            continue:
        ;    add ax, 5
        ;    add bx, 5
        ;    cmp bx, 20
        ;    jne while
    xor ax, ax
    ;xor bx, bx
    dec cl
    add si, 4
    cmp cl, 0
    jne for
    jmp finish

    colission:
        ;---------------------
        sub ax, 6400
        eraseBlock ax
        dec num 
        mov ax, array[si]
        mov auxBlock[0], ax
        mov ax, array[si + 2]
        mov auxBlock[2], ax
        for2:
            xor ax, ax
            mov ax, array[si+4]
            mov array[si], ax
            mov ax, array[si+6]
            mov array[si+2], ax
            add si, 4
            cmp si, 36
            jne for2
        mov ax, auxBlock[0]
        mov array[36], ax
        mov ax, auxBlock[2]
        mov array[38], ax
        ;---------------------
        mov al, type
        cmp al, 0   ;awards
        jne sub3

        add points,3 
        jmp finish
        sub3:
            sub points, 3
    finish:
    pop bx
    updatePoints
endm

;----------------------------------TIME------------------------------------------
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

cleanTime macro
    mov minutes,0
    mov seconds,0
    mov minsAux[0], '0'
    mov minsAux[1], '0'
    mov secsAux[0], '0'
    mov secsAux[1], '0'
endm

updatePoints macro
    convertAscii points, pointsAux
    drawString 0, 22, pointsAux
endm