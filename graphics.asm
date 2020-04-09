;-------------------------------MACROS GRAPHICS---------------------------------

setVideoMode macro
    mov ax, 0013h
    int 10h
    mov ax, 0A000h
    mov ds, ax      ; DS = A000h (memoria de graficos)
endm

setTextMode macro
    mov ax, 0003h
    int 10h
    mov ax, @data   ;to return the ds to the dataaaaa
    mov ds,ax
endm

pressKey macro
    mov ah, 10h
    int 16h
endm