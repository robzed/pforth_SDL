\ This is a direct port of an SDL2 example
\ https://github.com/xyproto/sdl2-examples/tree/main/c99
\ BSD-3-Clause license 

0 constant NULL
false value quit_flag
NULL value ren
NULL value win
NULL value tex
NULL value bmp
variable event
0 value startTime
0 value elapsedTime

: c-str-len ( c-addr -- c-addr u ) 0 BEGIN 2DUP + C@ WHILE 1+ REPEAT ;
: ctype ( c-str-addr -- ) c-str-len type ;

\ SDL_LoadBMP is Macro in C
: SDL_LoadBMP ( c-string -- SDL_Surface* )
    S\" rb\x00" drop SDL_RWFromFile 1 SDL_LoadBMP_RW
;

\ Forth words this long are generally considered bad style, but
\ provided here as an example of how to use SDL2 in Forth
: main ( -- )

    SDL_INIT_EVERYTHING SDL_Init if
        ." SDL_Init Error: " SDL_GetError ctype cr
        exit
    then

    s\" Hello World!\x00" drop -1 -1 800 600 SDL_WINDOW_SHOWN SDL_CreateWindow to win
    win NULL = if
        ." SDL_CreateWindow Error: " SDL_GetError ctype cr
        SDL_Quit
        exit
    then

    win -1 SDL_RENDERER_ACCELERATED SDL_RENDERER_PRESENTVSYNC or SDL_CreateRenderer to ren
    ren NULL = if
        ." SDL_CreateRenderer Error: " SDL_GetError ctype cr
        win SDL_DestroyWindow
        SDL_Quit
        exit
    then

    s\" cat.bmp\x00" drop SDL_LoadBMP to bmp
    bmp NULL = if
        ." SDL_LoadBMP Error: " SDL_GetError ctype cr
        ren SDL_DestroyRenderer
        win SDL_DestroyWindow
        SDL_Quit
        exit
    then

    ren bmp SDL_CreateTextureFromSurface to tex
    tex NULL = if
        ." SDL_CreateTextureFromSurface Error: " SDL_GetError ctype cr
        bmp SDL_FreeSurface
        ren SDL_DestroyRenderer
        win SDL_DestroyWindow
        SDL_Quit
        exit
    then
    bmp SDL_FreeSurface

    false to quit_flag
    SDL_GetTicks to startTime
    begin quit_flag 0= while

        begin event SDL_PollEvent while
            event SDL_Event-type u32@ 
            dup SDL_QUIT_ENUM = if 
                true to quit_flag
            then
            dup SDL_KEYDOWN = if
                event SDL_KeyboardEvent-keysym SDL_Keysym-sym s32@ SDLK_ESCAPE = if
                    true to quit_flag
                then
            then
            drop
        repeat

        SDL_GetTicks startTime - to elapsedTime
        elapsedTime 5000 > if
            true to quit_flag
        then

        ren SDL_RenderClear
        ren tex NULL NULL SDL_RenderCopy
        ren SDL_RenderPresent
        100 SDL_Delay
    repeat

    tex SDL_DestroyTexture
    ren SDL_DestroyRenderer
    win SDL_DestroyWindow
    SDL_Quit
;

main
