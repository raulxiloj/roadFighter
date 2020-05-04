;--------------------------------------------------------------
;------------------macros para manejar ficheros----------------
;--------------------------------------------------------------

;macro para obtener la ruta dada por un usuario
;similar al de getTexto, la unica diferencia es el fin de cadena
getPath macro array
LOCAL getCadena, finCadena
    mov si,0    ;xor si,si
    getCadena:
        getChar
        cmp al,0dh
        je finCadena
        mov array[si],al
        inc si
        jmp getCadena
    finCadena:
    mov al,00h
    mov array[si],al
endm

;macro para abrir un fichero
;param file = nombre del archivo
;param &handler = num del archivo
openFile macro file,handler
    mov ah,3dh
    mov al,010b
    lea dx,file
    int 21h
    jc errorOpening
    mov handler, ax
endm

;macro para leer en un fichero
;param handler = num del archivo
;param &fileData = variable donde se almacenara los bytes leidos
;param numBytes = num de bytes a leer
readFile macro handler,fileData,numBytes
    mov ah,3fh
    mov bx, handler
    mov cx, numBytes
    lea dx, fileData
    int 21h
    mov fileSize, ax
    jc errorReading
endm

;macro para cerrar un fichero
;param handler = num del fichero
closeFile macro handler
    mov ah, 3Eh
    mov bx, handler
    int 21h
endm

;macro para crear un fichero
;param file = nombre del archivo
;param &handler = num del fichero
createFile macro file,handler
    mov ah,3ch
    mov cx,00h
    lea dx, file
    int 21h
    jc errorCreating
    mov handler,ax
endm

;macro para escribir en un fichero
;param handler = num del archivo 
;param array = bytes a escribir
;param numBytes = num de bytes a escribir
writeFile macro handler,array,numBytes
    mov ah, 40h
    mov bx, handler
    mov cx, numBytes
    lea dx, array
    int 21h
    jc errorWriting
endm

;macro para seguir escribiendo en una de terminada posicion del fichero 
seekEnd macro handler
    mov ah,42h
    mov al, 02h
    mov bx, handler
    mov cx, 0
    mov dx, 0
    int 21h
    jc errorAppending
endm

;-----------------------------------------------------------------------------------------
;                       Special macros releated with files
;-----------------------------------------------------------------------------------------
getUsersData macro
    openFile userFile, handler
    readFile handler, fileData, 1000 
    closeFile handler
endm

saveUser macro user, pass
    openFile userFile, handler
    getLength user  ;possible change to the check length username
    seekEnd handler
    writeFile handler, user, si
    writeFile handler, comma, 1
    writeFile handler, pass, 4
    writeFile handler, newLine, 1
    closeFile handler
    print userSaved
    getChar 
endm 

;--------------------------------------------------------------
;----------macros para analizar el archivo de entrada----------
;--------------------------------------------------------------
analisis macro
    ;Lectura del archivo
    openFile inputFile, handler
    readFile handler, fileData, SIZEOF fileData
    closeFile handler
    ;Print data (just to see, everything is fine)
    print newLine
    print fileData
    ;analisis
    getLevelsData
    getChar
    cleanBuffer fileData, SIZEOF fileData, 24h
endm

getLevelsData macro
LOCAL while, continue, finish, state0, state1, state2, state3, state4, state5, state6, state7, finish1, finish2, finish3, finish4, finish5, finish6, finish7
    xor si, si
    xor ax, ax  ;LEVEL|1-num|2-timeLevel|3-timeObst|4-timePrice|5-color|6-ptsPrices|7-ptsObst
    xor bx, bx  ;actual char of aux 
    xor cx, cx  ;actual char of fileData

    while:
        cmp si, fileSize
        je finish
        
        mov cl, fileData[si]
        cmp ax, 0
        je state0
        cmp ax, 1
        je state1
        cmp ax, 2
        je state2
        cmp ax, 3
        je state3
        cmp ax, 4
        je state4
        cmp ax, 5
        je state5
        cmp ax, 6
        je state6
        cmp ax, 7
        je state7
        
        state0: ;'LEVEL'
            cmp cl, ';'
            jne continue 
            inc ax
            jmp continue

        state1: ;num level
            cmp cl, ';'
            je finish1

            mov auxFile[bx], cl
            inc bx
            jmp continue

            finish1:
                ;--------------------
                push ax
                print newLine
                print auxFile
                pop ax
                ;---------------------
                xor bx, bx
                inc ax
                ;get number
                push si
                cleanBuffer auxFile, SIZEOF auxFile, 24h
                pop si
                jmp continue

        state2: ;time level
            cmp cl, ';'
            je finish2

            mov auxFile[bx], cl
            inc bx
            jmp continue

            finish2:
                ;--------------------
                push ax
                print newLine
                print auxFile
                pop ax
                ;---------------------
                xor bx, bx
                inc ax
                push si
                cleanBuffer auxFile, SIZEOF auxFile, 24h
                pop si
                jmp continue

        state3: ;time obstacles
            cmp cl, ';'
            je finish3

            mov auxFile[bx], cl
            inc bx
            jmp continue

            finish3:
                ;--------------------
                push ax
                print newLine
                print auxFile
                pop ax
                ;---------------------
                xor bx, bx
                inc ax
                push si
                cleanBuffer auxFile, SIZEOF auxFile, 24h
                pop si
                jmp continue

        state4: ;time prices
            cmp cl, ';'
            je finish4

            mov auxFile[bx], cl
            inc bx
            jmp continue

            finish4:
                ;--------------------
                push ax
                print newLine
                print auxFile
                pop ax
                ;---------------------
                xor bx, bx
                inc ax
                push si
                cleanBuffer auxFile, SIZEOF auxFile, 24h
                pop si
                jmp continue

        state5: ;color
            cmp cl, ';'
            je finish5

            mov auxFile[bx], cl
            inc bx
            jmp continue

            finish5:
                ;--------------------
                push ax
                print newLine
                print auxFile
                pop ax
                ;---------------------
                xor bx, bx
                inc ax
                push si
                cleanBuffer auxFile, SIZEOF auxFile, 24h
                pop si
                jmp continue

        state6: ;pts prices
            cmp cl, ';'
            je finish6

            mov auxFile[bx], cl
            inc bx
            jmp continue

            finish6:
                ;--------------------
                push ax
                print newLine
                print auxFile
                pop ax
                ;---------------------
                xor bx, bx
                inc ax
                push si
                cleanBuffer auxFile, SIZEOF auxFile, 24h
                pop si
                jmp continue

        state7: ;pts obst
            cmp cl, 10
            je finish7

            mov auxFile[bx], cl
            inc bx
            jmp continue

            finish7:
                ;--------------------
                push ax
                print newLine
                print auxFile
                pop ax
                ;---------------------
                xor ax, ax
                xor bx, bx
                push si
                cleanBuffer auxFile, SIZEOF auxFile, 24h
                pop si
                jmp continue

        continue:
            inc si
            jmp while
    finish:

endm

;---------------------------------------------------------------
getTopData macro
    ;read the file
    openFile top1File, handler
    readFile handler, fileData, SIZEOF fileData
    closeFile handler
    ;print data (just to see, everything is fine)
    ;print newLine
    ;print fileData
    ;print newLine
    ;split data and save it into the array
    readTop1
    ;printArrayTop
    ;getChar
    cleanBuffer fileData, SIZEOF fileData, 24h
endm

readTop1 macro
LOCAL while, continue, finish, finish0, finish1, finish2
    
    xor si, si
    xor di, di  ;pos array
    xor ax, ax  ;state 
    xor bx, bx  ;pos auxTop
    xor cx, cx  ;counter rows
    xor dx, dx  ;actual char
    mov nElements, 0

    while:
        cmp si, fileSize
        je finish

        mov dl, fileData[si]
        cmp ax, 0
        je state0
        cmp ax, 1
        je state1
        cmp ax, 2
        je state2

    state0: ;row
        cmp dl, ','
        jne continue
        inc ax
        mov arrayTop[di], cl
        inc di
        jmp continue

    state1: ;level
        cmp dl, ','
        je finish1

        mov auxTop[bx], dl
        inc bx
        jmp continue

        finish1:
            xor bx, bx
            inc ax
            ;save number
            pusha
            convertNumber auxTop
            mov arrayTop[di], al
            popa
            inc di
            ;clean aux
            push si
            push cx
            cleanBuffer auxTop, SIZEOF auxTop, 24h
            pop cx
            pop si
            jmp continue
    
    state2: ;pts 
        cmp dl, 13
        je continue
        cmp dl, 10
        je finish2

        mov auxTop[bx], dl
        inc bx
        jmp continue

        finish2:
            xor bx, bx
            xor ax, ax
            ;save number
            pusha
            convertNumber auxTop
            mov arrayTop[di], al
            popa
            inc di 
            inc cx
            inc nElements
            ;clean aux
            push si
            push cx
            cleanBuffer auxTop, SIZEOF auxTop, 24h
            pop cx
            pop si

    continue:
        inc si
        jmp while

    finish:
        
endm

printArrayTop macro
LOCAL while, finish
    xor si, si
    xor ax, ax
    xor cx, cx
    mov si, 2
    while:
        cmp cl, nElements
        je finish
        
        mov al, arrayTop[si]
        pusha 
        convertAscii ax, auxd
        print newLine
        print auxd
        cleanBuffer auxd, SIZEOF auxd, 24h
        popa
        inc cx
        add si, 3
        jmp while

    finish:
endm