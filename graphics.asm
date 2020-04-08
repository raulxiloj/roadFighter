;-------------------------------MACROS GRAPHICS---------------------------------

setGraphicMode macro
    mov ax, 0013h
    int 10h
endm

setTextMode macro
    mov ax, 0003h
    int 10h
endm

pressKey macro
    mov ah, 10h
    int 16h
endm