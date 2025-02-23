# SDL2 Bindings by Programming Rainbow - used in making pforth_SDL

This folder contains the binding from https://github.com/ProgrammingRainbow/Beginners-Guide-to-SDL2-in-Gforth

Zlib License - see LICENSE.

Also see the videos here https://www.youtube.com/watch?v=PZFMcBKKiCM

A complete set of bindings for `SDL2`, `SDL_image`, `SDL_mixer`, and `SDL_ttf`. 

Originally for gForth, but made to work with pForth.

# NOTES from original README.txt


## SDL Event Enum name collisions.
Because Forth is not case-sensitive, there are some naming collisions with the Event Enums. For example, the function `SDL_Quit` and the Event Enum `SDL_QUIT` are viewed as the same. For the 6 Event Enums, _ENUM has been added to their names. The `SDL_Quit` function will still close SDL, but for checking if an `SDL_QUIT` event has occurred, `SDL_QUIT_ENUM` is used.
```forth
SDL_QUIT_ENUM
SDL_DISPLAYEVENT_ENUM
SDL_WINDOWEVENT_ENUM
SDL_SYSWMEVENT_ENUM
SDL_SENSORUPDATE_ENUM
SDL_USEREVENT_ENUM
```
## SDL_Color struct in SDL_ttf fuctions.
Many functions in `SDL_ttf` take an `SDL_Color` struct directly instead of a pointer to a struct. Pointers to C structs are easily passed to functions in Forth but not structs directly. There are wrapper functions so that a pointer to a struct can be passed instead. The bindings use the original `SDL_ttf` function names that point to the wrapper functions so the only change is `SDL_Color` structs are passed as pointers like all others.

## NULL for C
`NULL` is used often in C. It’s simply 0, so we add a constant.
```
0 CONSTANT NULL
```

## Working with C style strings
Forth strings are a pair of an address to a character array and a length. C strings are an address to a charater array that ends with a NULL terminator. To use C strings in Gforth, you simply need to add the missing length to make it an address length pair. `c-str-len` takes a NULL terminated string address and adds the missing length. To send a Forth string into a C function, you will need to add the NULL terminator with an escape sequence, and you will need to drop the length like this `S\" C style string\0" DROP`.
```forth
: c-str-len ( c-addr -- c-addr u ) 0 BEGIN 2DUP + C@ WHILE 1+ REPEAT ;
```

## Take care storing and retrieving from SDL structs and unions.

_For pForth I've supplied u32@ s32! - but feel free to add synonyms like : l@ u32@ ;_

Gforth stores numbers on a 64bit system as a 64bit two's compliment signed int. However, SDL uses different data types in their structs and unions. When storing into a struct, you must make sure to store the right number of bytes or it will overwrite the next memory blocks. For example SDL_Rect uses 4 32-bit signed ints. Using `L!` will work to store a number into the struct. Be sure to use 32-bit signed `SL@` and not `L@` when retreving because it's a signed number otherwise a stored value of -1 will return over 4 billion.
```forth
CREATE test SDL_Rect ALLOT  ok
-1 test SDL_Rect-x L!  ok
test SDL_Rect-x L@ . 4294967295  ok
test SDL_Rect-x SL@ . -1  ok
```

## Accessing members of C Structs and Unions
https://wiki.libsdl.org/SDL2/SDL_Rect \
SDL uses structs and unions that have members. An example is the `SDL_Rect` struct, which has 4 members: x, y, w, h. Each member of an `SDL_Rect` is of type 32-bit signed int. In C, `SDL_Rect myrect;` creates the variable myrect, and to access x, we would use `myrect.x`. This is just a fancy way of offsetting the address to the position of its member. The bindings in Forth will have an `SDL_Rect` for allocating the size of the struct, but it also has `SDL_Rect-x`, `SDL_Rect-y`, `SDL_Rect-w`, and `SDL_Rect-h` for use as offsets. So in Gforth, `myrect SDL_Rect-x SL@` will put on the stack the address to the x member and then fetch it correctly with `SL@` as a 32-bit signed int. Remember, all the bindings structs and unions will have the type-member to get the offset. Here is an example of a fetch and store.
```forth
// C SDL2 assignment and retrieve
SDL_Rect myrect;
myrect.x = 10
int getx = myrect.x

\ Forth SDL2 store and fetch
CREATE myrect SDL_Rect ALLOT
0 VALUE getx
10 myrect SDL_Rect-x L!
myrect SDL_Rect-x SL@ TO getx
```

# How to use SDL2 Bindings.
Using the SDL2 bindings for Gforth is just as it is in C. The function names are exactly the same. All arguments are placed on the stack in the same order as the C version. The return value is placed on the stack afterward. All the SDL2 Constants and Enums are included. NULL is simply 0, below I will create a CONSTANT for convenience. Below is an example.

C version from https://wiki.libsdl.org/SDL2/SDL_CreateWindow
```c
// SDL_Window * SDL_CreateWindow(const char *title, int x, int y, int w, int h, Uint32 flags);
SDL_Window *window = SDL_CreateWindow("Window Title", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, 0);
```
Gforth version
```forth
S\"Window Title\0" DROP SDL_WINDOWPOS_CENTERED SDL_WINDOWPOS_CENTERED 800 600 0 SDL_CreateWindow TO window
```

