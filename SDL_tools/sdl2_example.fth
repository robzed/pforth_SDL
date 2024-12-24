\ SDL2 parsing helper
\ Copyright (C) 2024 Rob Probin, based on work by ProgrammingRainbow
\ License: zLib (see LICENSE)
\ Written December 2024. 
\ Based off Video1 'main.fs' from ProgrammingRainbow's SDL2 tutorial.

\ SDL2 parsing helper
require pforth_files/sdl2_parse.fth

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

    ." go to create window " cr 1000 ms
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
    renderer 256 choose 256 choose 256 choose 255 SDL_SetRenderDrawColor DROP
;

CREATE event SDL_Event ALLOT

\ various small loads ... all little endian
\ NOTICE: We should replace these with C versions for speed
\ e.g. return (*(uint16_t*)addr)
\ e.g. return (*(uint32_t*)addr)
\ e.g. return (*(int16_t*)addr)
\ e.g. return (*(int32_t*)addr)
: u8@ c@ ;
: u16@ ( addr -- u ) dup u8@ swap 1+ u8@ << 8 + ;
: s16@ ( addr -- n ) u16@ 0x8000 and dup 0<> IF 0xffff0000 or THEN ;
: u32@ ( addr -- u ) dup u16@ swap 2+ u16@ << 16 + ;
: s32@ ( addr -- n ) u32@ 0x80000000 and dup 0<> IF 0xffffffff00000000 or THEN ;

\ These match the gForth ones
\ https://gforth.org/manual/Special-Memory-Accesses.html
\ https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Memory-Access.html?
\ : l@ u32@ ;
\ : sl@ s32@ ;
 

: do-event-loop
    BEGIN
        BEGIN event SDL_PollEvent WHILE
            event SDL_Event-type u32@
            DUP SDL_QUIT_ENUM = IF
                exit
            THEN
            SDL_KEYDOWN = IF
                event SDL_KeyboardEvent-keysym SDL_Keysym-scancode s32@
                DUP SDL_SCANCODE_ESCAPE = IF
                    exit
                THEN
                DUP SDL_SCANCODE_SPACE = IF
                    random-color
                    renderer SDL_RenderClear DROP
                THEN
                SDL_SCANCODE_M = IF
                    \ do something when M is pressed
                THEN
            THEN
        REPEAT
    AGAIN
;


: game-loop ( -- )
    renderer SDL_RenderClear DROP
        
    renderer SDL_RenderPresent

    game-cleanup
;

: play-game ( -- )
    initialize-sdl
    game-loop
;

play-game

