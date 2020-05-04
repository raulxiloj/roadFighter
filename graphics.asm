;-------------------------------MACROS GRAPHICS---------------------------------

setVideoMode macro
    mov ax, 0013h
    int 10h
    mov ax, 0A000h
    mov es, ax      ; using the extra segment for the graphics
endm

setTextMode macro
    mov ax, 0003h
    int 10h
endm

pressKey macro
    mov ah, 10h
    int 16h
endm

;-----------------------------------------------------------------------------
;320*i+j
paintBoard macro color
LOCAL top, bottom, leftSide, rightSide
    mov dl, color
    mov di, 6410        ;(20,10) 
    top:
        mov es:[di], dl
        inc di
        cmp di, 6710    ;(20,310) 
        jne top
    ;-------------------------------------------------
    mov di, 60810       ;(190,10) 
    bottom:
        mov es:[di], dl
        inc di
        cmp di, 61110   ;(190, 310)
        jne bottom
    ;-------------------------------------------------
    mov di, 6410        ;(20,10) 
    leftSide:
        mov es:[di], dl
        add di, 320
        cmp di, 60810   ;(190,10)
        jne leftSide 
    ;-------------------------------------------------
    mov di, 6709        ;(20,309)  
    rightSide:
        mov es:[di], dl
        add di, 320
        cmp di, 61109   ;(190,309)
        jne rightSide
endm

;-----------------------------------------------------------------------------
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
            mov es:[di], dl
            inc di 
            cmp di, cx
            jne for2
            cmp ax, 169
            jne fixRow
endm

;-----------------------------------------------------------------------------
drawCar macro pos 
LOCAL body, wheels1, wheels2
    mov di, pos
    mov dl, 4

    mov es:[di+3], dl
    mov es:[di+4], dl
    mov es:[di+5], dl
    mov es:[di+6], dl
    mov es:[di+7], dl
    mov es:[di+8], dl
    mov es:[di+9], dl
    mov es:[di+10], dl
    mov es:[di+11], dl
    mov es:[di+12], dl
    mov es:[di+13], dl
    mov es:[di+14], dl
    mov es:[di+15], dl
    mov es:[di+16], dl

    mov cx, 24
    body:
        add di, 320
        mov es:[di+3], dl
        mov es:[di+4], dl
        mov es:[di+5], dl
        mov es:[di+6], dl
        mov es:[di+7], dl
        mov es:[di+8], dl
        mov es:[di+9], dl
        mov es:[di+10], dl
        mov es:[di+11], dl
        mov es:[di+12], dl
        mov es:[di+13], dl
        mov es:[di+14], dl
        mov es:[di+15], dl
        mov es:[di+16], dl
        loop body

    ;-------------------------------
    mov di, pos
    mov dl, 0
    add di, 640
    mov es:[di], dl
    mov es:[di+1], dl
    mov es:[di+2], dl
    mov es:[di+17], dl
    mov es:[di+18], dl
    mov es:[di+19], dl
    mov cx, 6
    wheels1:
        add di, 320
        mov es:[di], dl
        mov es:[di+1], dl
        mov es:[di+2], dl
        mov es:[di+17], dl
        mov es:[di+18], dl
        mov es:[di+19], dl
        loop wheels1
    ;-------------------------------
    add di, 2240
    mov es:[di], dl
    mov es:[di+1], dl
    mov es:[di+2], dl
    mov es:[di+17], dl
    mov es:[di+18], dl
    mov es:[di+19], dl
    xor cx, cx
    mov cx, 7
    wheels2:
        add di, 320
        mov es:[di], dl
        mov es:[di+1], dl
        mov es:[di+2], dl
        mov es:[di+17], dl
        mov es:[di+18], dl
        mov es:[di+19], dl
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
            mov es:[di], dl
            inc di 
            inc cl
            cmp cl, 20
            jne while2
            cmp ch, 25
            jne littleFix    
endm

;-----------------------------------------------------------------------------
;Colors
;Good block: 0Eh, 0Ch
;Bad block: 2 ,0Ah  
drawBlock macro pos, color1, color2  
LOCAL while, L1, L2, L3, secondAux, finish
    xor cx, cx
    mov di, pos
    mov dl, color1

    while:
        cmp cx, 4
        jl L1
        cmp cx, 8
        jl L2
        cmp cx, 12 
        jl L3
        cmp cx, 16
        jl L2
        cmp cx, 20
        jl L1
        jmp finish

    L1:
        inc cx
        mov es:[di+8], dl
        mov es:[di+9], dl
        mov es:[di+10], dl
        mov es:[di+11], dl
        add di, 320
        jmp while
    L2:
        inc cx
        mov es:[di+4], dl
        mov es:[di+5], dl
        mov es:[di+6], dl
        mov es:[di+7], dl
        mov dl, color2
        mov es:[di+8], dl
        mov es:[di+9], dl
        mov es:[di+10], dl
        mov es:[di+11], dl
        mov dl, color1
        mov es:[di+12], dl
        mov es:[di+13], dl
        mov es:[di+14], dl
        mov es:[di+15], dl
        add di, 320
        jmp while
    L3:  
        inc cx
        mov es:[di], dl
        mov es:[di+1], dl
        mov es:[di+2], dl
        mov es:[di+3], dl
        mov dl, color2
        mov bx, 4
        push cx
        mov cx, 12
        secondAux:
            mov es:[di + bx],dl
            inc bl
            loop secondAux
        pop cx
        mov dl, color1
        mov es:[di+16], dl
        mov es:[di+17], dl
        mov es:[di+18], dl
        mov es:[di+19], dl
        add di, 320
        jmp while

    finish:

endm

eraseBlock macro pos
LOCAL while, while2, littleFix
    xor bx, bx      ;next row
    xor cx, cx      ;counter, ch for rows and cl for cols
    mov cx, 0
    mov dl, 7
    mov di, pos
    jmp while
    littleFix:
        add bx, 320
        mov di, bx
        mov cl, 0
    while:
        inc ch
        mov bx, di
        while2:
            mov es:[di], dl
            inc di 
            inc cl
            cmp cl, 20
            jne while2
            cmp ch, 20
            jne littleFix 
endm
;-----------------------------------------------------------------------------
drawChar macro row, col, char
    ;set cursor 
    mov dh, row     ;row
    mov dl, col     ;col
    mov bh, 0       ;page
    mov ah, 02h
    int 10h
    ;print char in video
    mov al, char
    mov bl, 15d     ;color
    mov bh, 0       ;page
    mov ah, 0Eh
    int 10h
endm
;-----------------------------------------------------------------------------
drawString macro row, col, string 
LOCAL while
    xor bx, bx
    xor cx, cx
    mov cl, col
    getLength string 
    while:
        push bx
        drawChar row, cl, string[bx]
        pop bx
        inc cl
        inc bx
        dec si
        cmp si, 0
        jne while
endm

;--------------------------------BAR GRAPH------------------------------------
statistics macro
    setVideoMode 
    paintBoard 0fh
    drawBars
    ;drawBar 16050, 20, 7   ;(50,50)
    getChar
    setTextMode
endm

drawBar macro pos, width, color
LOCAL for, for2
;bottom limit (189,320) = 60800     
    xor ax, ax
    xor bx, bx  ;limit width
    xor cx, cx
    mov dl, color
    mov di, pos
    
    mov cx, di  ;aux
    add cx, widthBar
    mov bx, cx  ;limit width
    mov cx, di

    jmp for2

    for:
        
        add bx, 320
        mov di, cx
        add di, 320
        mov cx, di
        for2:
            mov es:[di], dl
            inc di
            cmp di, bx
            jne for2
            cmp di, 60800 
            jb for
        
endm

;Draw bars array
drawBars macro array
LOCAL while, finish
    xor si, si
    xor cx, cx
    mov si, 2
    mov varX, 20
    int 3
    while:
        cmp cl, nElements
        je finish
        getScale arrayTop[si]
        mov auxBar, ax
        getPosition auxBar, varX  
        mov auxBar2, ax
        pusha 
        drawBar auxBar2, widthBar, colorBar
        popa
        add si, 3
        inc cx
        mov dx, widthBar
        add varX, dx
        add varX, 5
        inc colorBar
        jmp while

    finish:
endm

;drawBar 16050, 20, 7   ;(50,50)