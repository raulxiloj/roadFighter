;--------------------------------------------------------------
;-----------------------macros generales-----------------------
;--------------------------------------------------------------

print macro cadena
    mov ah, 09h
    mov dx, offset cadena
    int 21h
endm

printChar macro char
    mov ah, 02h
    mov dl, char
    int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

clearScreen macro
    setGraphicMode
    setTextMode
endm

registerUser macro

endm