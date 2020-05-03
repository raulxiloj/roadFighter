bubbleSortAsc macro array
LOCAL for, for2, continue, continue2, swap, finish
    xor ax, ax  ;al actual -  ah siguiente
    xor bx, bx  
    xor cx, cx
    mov bx, 2

    mov al, 3
    mul nElements
    mov ch, al
    sub ch, 3

    for:
        cmp cl, nElements
        jge finish
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