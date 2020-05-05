bubbleSortAsc macro array
LOCAL for, for2, continue, continue2, swap, finish
    xor ax, ax  ;al actual -  ah siguiente
    xor bx, bx  ;access to array  
    xor cx, cx  ;cl = cont for num of elements | ch = size of the array 
    mov bx, 2   

    mov al, 3
    mul nElements
    mov ch, al
    sub ch, 3

    for:
        cmp cl, nElements
        jge finish
        pusha
        statistics
        popa
        for2:
            mov al, array[bx]
            mov ah, array[bx+3] 
            cmp al, ah
            jg swap
            jmp continue2
            
            swap:
            mov auxSort3, al    ;pts
            mov al, array[bx-1] ;level
            mov auxSort2, al
            mov al, array[bx-2] ;row
            mov auxSort, al

            mov al, array[bx+1] ;row
            mov array[bx-2], al
            mov al, array[bx+2] ;level;
            mov array[bx-1], al
            mov al, array[bx+3] ;pts
            mov array[bx], al
            
            mov al, auxSort
            mov array[bx+1], al
            mov al, auxSort2
            mov array[bx+2], al
            mov al, auxSort3
            mov array[bx+3], al
            
            continue2:
            add bl, 3
            cmp bl, ch
            jl for2
            mov bx, 2
            inc cl
            jmp for 
        
    finish:
        
endm

bubbleSortDesc macro array
LOCAL for, for2, continue, continue2, swap, finish
    xor ax, ax  ;al actual -  ah siguiente
    xor bx, bx  ;access to array  
    xor cx, cx  ;cl = cont for num of elements | ch = size of the array 
    mov bx, 2   

    mov al, 3
    mul nElements
    mov ch, al
    sub ch, 3

    for:
        cmp cl, nElements
        jge finish
        pusha
        statistics
        popa
        for2:
            mov al, array[bx]
            mov ah, array[bx+3] 
            cmp al, ah
            jl swap
            jmp continue2
            
            swap:
            mov auxSort3, al    ;pts
            mov al, array[bx-1] ;level
            mov auxSort2, al
            mov al, array[bx-2] ;row
            mov auxSort, al

            mov al, array[bx+1] ;row
            mov array[bx-2], al
            mov al, array[bx+2] ;level;
            mov array[bx-1], al
            mov al, array[bx+3] ;pts
            mov array[bx], al
            
            mov al, auxSort
            mov array[bx+1], al
            mov al, auxSort2
            mov array[bx+2], al
            mov al, auxSort3
            mov array[bx+3], al
            
            continue2:
            add bl, 3
            cmp bl, ch
            jl for2
            mov bx, 2
            inc cl
            jmp for 
        
    finish:
        
endm

getMax macro
LOCAL for, continue, swap
    xor ax, ax
    xor si, si
    mov si, 2

    for:
        cmp cl, nElements
        je finish

        mov al, arrayTop[si]
        cmp ax, numMax
        jbe continue 
        
        ;change value
        mov numMax, ax

        continue:   
            add si, 3
            inc cx
            jmp for
    
    finish:

endm

getSpaceBetween macro
    xor ax, ax
    xor bx, bx
    mov al, 5
    mul nElements
    mov spaceBtw, ax
endm 

getWidthBar macro
    xor ax, ax
    mov ax, 280
    sub ax, spaceBtw
    div nElements
    xor ah, ah
    mov widthBar, ax
endm

getScale macro val
    ;cleanBuffer auxd, sizeof auxd, 24h
    xor ax, ax
    xor bx, bx
    mov ax, 140
    mov bl, val
    mul bx
    mov bx, numMax
    div bx
    mov bx, 170
    sub bx, ax
    mov ax, bx
    ;convertAscii ax, auxd
    ;print auxd
    ;return ax
endm