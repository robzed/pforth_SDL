\ SDL2 parsing helper
\ Copyright (C) 2024 Rob Probin, based on work by ProgrammingRainbow
\ License: zLib (see LICENSE)
\ Written December 2024. 
\ Based off Video1 'main.fs' from ProgrammingRainbow's SDL2 tutorial.

\ SDL2 parsing helper
require sdl2_parse.fth

\ SDL2 library - notice internal paths assume we are in SDL2/ directory
S" SDL2/" set-require-subdir 
require SDL.fs
S" " set-require-subdir

\ Constants
0 CONSTANT NULL

\ Make a window title with a zero terminator for C-based SDL call
s\" pForth SDL demo\x00" DROP CONSTANT WINDOW_TITLE
800 CONSTANT WINDOW_WIDTH
600 CONSTANT WINDOW_HEIGHT
SDL_INIT_EVERYTHING CONSTANT SDL_FLAGS

0 VALUE exit-value
NULL VALUE window
NULL VALUE renderer

\ Words
: game-cleanup ( -- )
    renderer SDL_DestroyRenderer
    NULL TO renderer
    window SDL_DestroyWindow
    NULL TO window

    SDL_Quit
;

: c-str-len ( c-addr -- c-addr u ) 0 BEGIN 2DUP + C@ WHILE 1+ REPEAT ;

: error ( c-addr u -- )
    ." Error: " type cr
    SDL_GetError c-str-len type space cr
    1 TO exit-value
    game-cleanup
;

: initialize-sdl ( -- )
    SDL_FLAGS SDL_Init IF
        S" Error initializing SDL: " error
    THEN

    WINDOW_TITLE SDL_WINDOWPOS_CENTERED SDL_WINDOWPOS_CENTERED WINDOW_WIDTH WINDOW_HEIGHT 0
    SDL_CreateWindow TO window
    window 0= IF 
        S" Error creating Window: " error
    THEN

    window -1 0 SDL_CreateRenderer TO renderer
    renderer 0= IF
        S" Error creating Renderer: " error
    THEN
;

: random-color ( -- )
    renderer 256 choose 256 choose 256 choose 255 SDL_SetRenderDrawColor dup if
        S" Error setting color code " .
        S" SDL Error:" SDL_GetError c-str-len type cr
    else
        drop
    THEN
;

CREATE event SDL_Event ALLOT

: do-game-loop
    ." Start do-game-loop" cr
    BEGIN
        BEGIN event SDL_PollEvent WHILE
            event SDL_Event-type u32@
            dup ." event type =" . cr
            DUP SDL_QUIT_ENUM = IF
                ." SDL_QUIT event " dup cr
                exit
            THEN
            SDL_KEYDOWN = IF
                event SDL_KeyboardEvent-keysym SDL_Keysym-scancode s32@
                ." Key pressed " dup . cr
                DUP SDL_SCANCODE_ESCAPE = IF
                    drop exit
                THEN
                DUP SDL_SCANCODE_SPACE = IF
                    ." Pressed Space - Change colour" cr
                    random-color
                    renderer SDL_RenderClear if
                        S" Error clearing renderer" error
                    THEN
                    renderer SDL_RenderPresent
                THEN
                SDL_SCANCODE_M = IF
                    ." Pressed M" cr
                    \ do something when M is pressed
                THEN
            THEN
        REPEAT
        100 ms \ ." no events" cr
    AGAIN
    \ could replace exits via variable check with BEGIN...UNTIL loop
    ." *** Should never get here - exit from word by EXIT" cr
;


: game-main ( -- )
    \ clear the screen
    renderer SDL_RenderClear DROP
    renderer SDL_RenderPresent

    ." running game " cr 10 ms
    do-game-loop

;

: play-game ( -- )
    initialize-sdl
    game-main
    game-cleanup
    ." quit game " cr 10 ms
;

play-game
