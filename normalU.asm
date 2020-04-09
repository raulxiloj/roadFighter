userSession macro
LOCAL logout
    clearScreen
    print header2
    print userMenu
    getChar
    cmp al, '1'
    je menuPrincipal
    cmp al, '2'
    je menuPrincipal
    cmp al, '3'
    je logout
    jmp menuPrincipal

    logout:
        cleanBuffer userName, SIZEOF username, 24h
        cleanBuffer userPass, SIZEOF userPass, 24h
        jmp menuPrincipal

endm