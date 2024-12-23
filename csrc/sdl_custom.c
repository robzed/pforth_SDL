/*
 * sdl_custom.cpp
 *
 *  Created on: Dec 2024
 *      Author: Rob Probin
 *      License: zlib
 *
 * Add SDL functions to the Forth dictionary.
 * (Theoretically you could add others C functions to the dictionary)
 * 
 * See original `pf_custom.h` for more details (steps 1-4)
 * 
 */

#include "pf_all.h"

#include "sdl2_helper.h"

/*
 * For some reason these were throwing errors...
 */
#undef SDL_Swap16
#undef SDL_Swap32
#undef SDL_Swap64
static Uint16 SDL_Swap16(Uint16 x);
static Uint32 SDL_Swap32(Uint32 x);
static Uint64 SDL_Swap64(Uint64 x);

Uint16 SDL_Swap16(Uint16 x)
{
    return SDL_static_cast(Uint16, ((x << 8) | (x >> 8)));
}
Uint32 SDL_Swap32(Uint32 x)
{
    return SDL_static_cast(Uint32, ((x << 24) | ((x << 8) & 0x00FF0000) |
                                    ((x >> 8) & 0x0000FF00) | (x >> 24)));
}
Uint64 SDL_Swap64(Uint64 x)
{
    Uint32 hi, lo;

    /* Separate into high and low 32-bit values and swap them */
    lo = SDL_static_cast(Uint32, x & 0xFFFFFFFF);
    x >>= 32;
    hi = SDL_static_cast(Uint32, x & 0xFFFFFFFF);
    x = SDL_Swap32(lo);
    x <<= 32;
    x |= SDL_Swap32(hi);
    return (x);
}


const CFunc0 CustomFunctionTable[];

const CFunc0 CustomFunctionTable[]=
{
	#include "sdl2_dic_entries.h"
};

Err CompileCustomFunctions( void )
{
    Err err;
    int i = 0;

    #include "sdl2_glue.h"

    return 0;
}
