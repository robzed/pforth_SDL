\ SDL2 parsing helper
\ Copyright (C) 2024 Rob Probin, based on work by ProgrammingRainbow
\ License: zLib (see LICENSE)
\ Written December 2024. 
\ Based off Video1 'main.fs' from ProgrammingRainbow's SDL2 tutorial.

\ Constants
0 CONSTANT NULL

\ Make a window title with a zero terminator for C-based SDL call.
\ NOTE: We don't make this a constant from s\" outside word (function) definition
\ because that doesn't create a permanent string in the dictionary - 
\ just a temporary one that is replaced the next time s\" is executed.
: window_title s\" pForth SDL demo\x00" DROP ;
800 CONSTANT WINDOW_WIDTH
600 CONSTANT WINDOW_HEIGHT
SDL_INIT_EVERYTHING CONSTANT SDL_FLAGS

0 VALUE exit-value
NULL VALUE window
NULL VALUE renderer

\ Text stuff
NULL VALUE Sans
NULL VALUE surfaceMessage
NULL VALUE MessageTexture
CREATE Message_rect SDL_Rect ALLOT
CREATE White SDL_Color ALLOT

CREATE event SDL_Event ALLOT

\
\ Words
\
: cleanup-events ( -- )
    ." Waiting for events for 0.1 s" cr
    100 0 do
        event SDL_PollEvent if
            event SDL_Event-type u32@
            ." <<event type =" . cr
        then
        1 sdl_delay
    loop
    ." DONE - Waiting for events for 0.1 s" cr
    \ SDL_GetTicks64
;

: game-cleanup ( -- )
    renderer if renderer SDL_DestroyRenderer THEN
    NULL TO renderer
    window if window SDL_DestroyWindow then
    NULL TO window

    \ cleanup-events

    TTF_Quit
    SDL_Quit
;

: c-str-len ( c-addr -- c-addr u ) 0 BEGIN 2DUP + C@ WHILE 1+ REPEAT ;

: .SDL_error ( c-addr u -- )
    ." Error: " type cr
    SDL_GetError c-str-len type space cr
    1 TO exit-value
    game-cleanup
;

: initialize-sdl ( -- )
    SDL_FLAGS SDL_Init IF
        ." Error initializing SDL: " .SDL_error
    THEN

    WINDOW_TITLE SDL_WINDOWPOS_CENTERED SDL_WINDOWPOS_CENTERED WINDOW_WIDTH WINDOW_HEIGHT 0
    SDL_CreateWindow TO window
    window 0= IF 
        ." Error creating Window: " .SDL_error
    THEN

    window -1 0 SDL_CreateRenderer TO renderer
    renderer 0= IF
        ." Error creating Renderer: " .SDL_error
    THEN

   TTF_Init IF
        S" Error initializing SDL_ttf: " .SDL_error
    THEN
;

: random-color ( -- )
    renderer 256 choose 256 choose 256 choose 255 SDL_SetRenderDrawColor dup if
        ." Error setting color code " .
        ." SDL Error:" SDL_GetError c-str-len type cr
    else
        drop
    THEN
;


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
                THEN
                SDL_SCANCODE_M = IF
                    ." Pressed M" cr
                    \ do something when M is pressed
                THEN
            THEN
        REPEAT
        \ ." no events to process" cr

        \ -------------------------------------------------------
        \ We could update game state here, or other objects.
        \
        \ We would likely want to calculate the time since the last frame, and
        \ use that to update the game state.
        \ -------------------------------------------------------

        \ game drawing
        renderer SDL_RenderClear if
            ." Error clearing renderer" cr
        THEN

        renderer MessageTexture NULL Message_rect SDL_RenderCopy IF
            ." Error rendering text" cr
            ." SDL Error:" SDL_GetError c-str-len type cr
            exit
        THEN

        renderer SDL_RenderPresent

        10 ms   \ delay to slow things down - usually we use dynamic frame rate limiter
    AGAIN
    \ could replace exits via variable check with BEGIN...UNTIL loop
    ." *** Should never get here - exit from word by EXIT" cr
;


: create-text
    \ converted from https://stackoverflow.com/questions/22886500/how-to-render-text-in-sdl2
    \ this opens a font style and sets a size
    S\" font_for_example/caladea-regular.ttf\x00" drop 24 TTF_OpenFont
         to Sans
    Sans 0= IF
        ." Error opening font" cr
        ." SDL Error:" SDL_GetError c-str-len type cr
        bye
    THEN

    \ setup white color
    255 White SDL_Color-r C!
    255 White SDL_Color-g C!
    255 White SDL_Color-b C!
    255 White SDL_Color-a C!

    \ as TTF_RenderText_Solid could only be used on
    \ SDL_Surface then you have to create the surface first
    Sans S\" Space = change color, Escape = Quit\x00" drop White
        TTF_RenderText_Solid TO surfaceMessage
    surfaceMessage 0= IF
        ." Error creating surface" cr
        ." SDL Error:" SDL_GetError c-str-len type cr
        bye
    THEN

    \ now you can convert it into a texture
    renderer  surfaceMessage 
        SDL_CreateTextureFromSurface TO MessageTexture
    MessageTexture 0= IF
        ." Error creating texture" cr
        ." SDL Error:" SDL_GetError c-str-len type cr
        bye
    THEN

    \ set position of the text
    10 Message_rect SDL_Rect-x u32!
    10 Message_rect SDL_Rect-y u32!
    350 Message_rect SDL_Rect-w u32!
    50 Message_rect SDL_Rect-h u32!
;

: destroy-text
    surfaceMessage SDL_FreeSurface
    MessageTexture SDL_DestroyTexture
;

: game-main ( -- )
    \ clear the screen
    renderer SDL_RenderClear DROP
    renderer SDL_RenderPresent
    create-text

    ." running game " cr 10 ms
    do-game-loop
    destroy-text
;

: play-game ( -- )
    initialize-sdl
    game-main
    game-cleanup
    ." quit game " cr 10 ms
;

play-game
