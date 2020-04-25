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

