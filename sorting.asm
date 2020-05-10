;---------------------BubbleSort algorithm---------------------
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

;---------------------QuickSort algorithm---------------------
quickSort macro array
LOCAL while,fin,fin0,fin1
    pusha
    mov si, sp
    mov tamMin, 0
    mov al, nElements
    sub ax, 1
    mov tamMax, ax
    push tamMin
    push tamMax

    while:
        cmp sp, si
        je fin
        pop tamMax
        pop tamMin 
        partitionAsc 
        mov bx, pivot
        dec bx
        cmp bx, tamMin
        jle fin0
        push tamMin
        push bx    

    fin0:
        mov bx, pivot
        inc bx
        cmp bx, tamMax
        jge fin1
        push bx 
        push tamMax
    fin1:
        jmp while

    fin:
        popa
endm

partitionAsc macro array
LOCAL for, fin, fin1, swap

    pusha 

    mov di, tamMax
    mov dl, array[di]
    mov si, tamMin
    dec si
    mov bx, tamMin

    for:
        mov cx, tamMax
        dec cx
        cmp bx, cx
        jg fin
        mov cl, array[bx]
        cmp cl, dl
        jg fin1
    swap:
        inc si
        xor cx, cx
        mov cl, array[si]
        mov al, array[bx]
        mov array[si], al
        mov array[bx], cl
        mov valActual, cx
    fin1:
        inc bx
        jmp for
    fin:
        mov cl, array[si + 1]
        mov di, tamMax
        mov dl, array[di]
        mov array[si + 1], dl
        mov array[di], cl
        xor ch, ch
        mov valActual, cx
        inc si
        mov pivot, si

        popa
endm