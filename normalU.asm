userSession macro
LOCAL menu,initGame, logout
    menu:
        clearScreen
        print header2
        print userMenu
        getChar
        cmp al, '1'
        je initGame
        cmp al, '2'
        je menuPrincipal
        cmp al, '3'
        je logout
        jmp menu
    initGame:
        setVideoMode
        paintBoard 0fh
        paintBackground 7
        drawCar 50072        ;156,152
        getChar
        setTextMode
        jmp menu    
    logout:
        cleanBuffer userName, SIZEOF username, 24h
        cleanBuffer userPass, SIZEOF userPass, 24h
        jmp menuPrincipal

endm