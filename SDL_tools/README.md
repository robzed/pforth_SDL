Introduction
============
The files in this folder are for changing pForth into a valid SDL2 Forth. 

Currently this is SDL2.

Generally the pForth related files are all 0BSD, but the SDL2/ folder are ZLib licensed. 

There is an interesting cross over for the following (autogenerated) files:
    * csrc/sdl2_dic_entries.h
    * csrc/sdl2_glue.h
    * csrc/sdl2_helper.h

These are generated from the SDL2/ files so this is derived from Zlib licensed
files - so are Zlib. 

I don't think this will be a problem - the 0BSD license you are free to do 
anything - and it has a disclaimer. Zlib is very similar except it asks for 
source marking, altered modifications and not misrepresenting. I don't
think these licenses are in conflict - but I'm not a lawyer.

Some other .fth files in the SDL_tools are either 0BSD or Zlib - check the header
of the file for details.

Changes to pForth Core
======================
Apart from adding custom C binds (via sdl_custom.c), there are two other areas that cause problems:

1. On the stock pForth, only 5 parameters can be passed to a SDL function. Even SDL_CreateWindow takes 6, so this
is tricky to avoid.

2. Names are limited to 31 characters ... and a reasonable number of important SDL functions are slightly longer than this. The pforth_case_case_creation.py will give warnings in this case, but none are longer than 63 characters. 

3. Floating point parameters and return are not supported right now for pForth in the C interface.

Since we want to keep as close to the SDL names as possible (with the exceptions noted by 
ProgrammingRainbow) we need to solve at last 1 and 2. 

Item 3 might be important - see limitations for how to solve this.


Limitations
===========

Currently no SDL2 functions that require a a floating point parameter or return are included in the build.

There are several possible options:

(a) extend the return type parameter to two bits - for none, integer, float return. For parameters
you'd need some way of telling whether they were integer or floats ... having such a bitmap
in the 32-bit is possible, but tricky for support up to 12 parameters... however, in current SDL2
version there are only 5 parameter functions with mixed integer/float parameters - so maybe 5 bits
reserved might be possible.
(b) ...


Information about files
=======================

`pforth_case_creation.py` parses the bindings from https://github.com/ProgrammingRainbow/Beginners-Guide-to-SDL2-in-Gforth and produces code for pForth C extensions. See
the top of this file for more details.

`sdl_custom.c` is a replacement for the example file in pForth, located in the `csrc` folder.

`sdl2_glue.h`, `sdl2_helper.h` and `sdl2_dic_entries.h` are auto-generated by the 
`pforth_case_creation.py` from the SDL2 Forth source from https://github.com/ProgrammingRainbow/Beginners-Guide-to-SDL2-in-Gforth

`sdl2_parse.fth` allows the files inside SDL2/ to be parsed, since these have 
additional definitions you'll need beyond C functions. 

`sdl2_example.fth` shows a basic demo of SDL.

`pforth.patch` has the patches in for C functions that support up to 12 parameters. It does 
not contain any of the other changes (the pfcustom.c changes, the Makefile changes 
or the above auto-generated files.)

Build the SDL pForth
====================

First install SDL2, SDL2_mixer, SDL2_ttf, SDL2_image. How you do this depends on
your machine. See https://wiki.libsdl.org/SDL2/Installation

On MacOS you have a choice of building it yourself, installing the framework 
inside (say into /Library/Framework) or using homebrew. 

Check you can build stock pForth and run the standalone version BEFORE you apply 
all these changes. You definately don't want to be dealing with both!

Once the standard pForth builds and runs without problems:

For Unix/Mac change `Makefile`:
1. Define -DPF_USER_CUSTOM in XCPPFLAGS to disable existing pf_custom.c
2. Add sdl_custom.c to PFSOURCE. 
3. Include the headers above (`sdl2_glue.h`, `sdl2_helper.h` an `sdl2_dic_entries.h`) into the PFINCLUDES define.
4. You'll need to tell it where to find the SDL2 headers. Examples:
    * Homebrew install: `-I/opt/homebrew/include/`
    * Standard MacOS install something like: `-F /Library/Frameworks`
    * I don't remember where Linux/Unix are ... you can do an internet search...
5. You'll need to tell it where to find the SDL2 libraries. Examples:
    * Homebrew install: `-L/opt/homebrew/lib -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer -lSDL2main` 
    * Standard MacOS install something like:  `-F /Library/Frameworks -framework SDL2  -framework SDL2_ttf -framework SDL2_image -framework SDL2_mixer -rpath /Library/Frameworks`
    * I don't remember where Linux/Unix are ... you can do an internet search...
6. Depending on your platform you might want to include `-D_THREAD_SAFE` in the compiler flags.

For reference, the Makefile changes look something like this:
```
    XCPPFLAGS = -DPF_SUPPORT_FP -D_DEFAULT_SOURCE -D_GNU_SOURCE -DPF_USER_CUSTOM

    PFSOURCE = $(PFBASESOURCE) $(IO_SOURCE) sdl_custom.c

    PFINCLUDES = pf_all.h pf_cglue.h pf_clib.h pf_core.h pf_float.h \
        pf_guts.h pf_host.h pf_inc1.h pf_io.h pf_mem.h pf_save.h \
        pf_text.h pf_types.h pf_win32.h pf_words.h pfcompfp.h \
        pfcompil.h pfinnrfp.h pforth.h sdl2_glue.h sdl2_helper.h sdl2_dic_entries.h

    CFLAGS = $(XCFLAGS) -I/opt/homebrew/include/     

    LDFLAGS = $(XLDFLAGS) -L/opt/homebrew/lib  -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer -lSDL2main
```


Then you need the following changes:
1. Optionally run the script 'python pforth_files/pforth_case_creation.py'. This files 
are supplied, and should be ok.
2. If you are using the MacOS Frameworks rather than Linux, homebrew or self build, you might 
need to make a change inside the autogenerated file `sdl2_helper.h`:
```
    #include <SDL2/SDL_image.h>
    #include <SDL2/SDL_ttf.h>
    #include <SDL2/SDL_mixer.h>
```
into 
```
    #include <SDL2_image/SDL_image.h>
    #include <SDL2_ttf/SDL_ttf.h>
    #include <SDL2_mixer/SDL_mixer.h>
```
3. Make sure the 4 files are accessible - maybe copy them into `csrc` inside pForth folder.
4. Apply the `pforth.patch` so we can support up to 12 parameters in C functions.
5. Add `#include <SDL2/SDL.h>` to the top of pf_main.c (SDL redefines main).
6. make clean
7. make all
6. It will also create a standalone executable image that includes the dictionary compiled inside. To run it enter:
    ./pforth_standalone
7. Test with        SDL_GetTicks .   ( should print a increasing number every time you run it)
```
    Stack<10> 
    SDL_GetTicks . 0    ok
    Stack<10> 
    SDL_GetTicks . 935    ok
    Stack<10> 
    SDL_GetTicks . 2071    ok
    Stack<10> 
    SDL_GetTicks . 2863    ok
    Stack<10> 
    SDL_GetTicks . 3652    ok
    Stack<10> 
    SDL_GetTicks . 4387    ok
```
8. Now you have a pForth with SDL functions built into it, you can test it with sdl2_example.fth.
NOTE: This uses `sdl2_parse.fth` before loading `SDL2/SDL.fs`. `sdl2_parse.fth` contains definitions
to parse the gForth defintions inside `SDL2/`

However, you need to make a bigger dictionary:     

You can use the word MAP to print information about the current size of the dictionary. If you enter MAP you will see something like this: 

Notice the variables CODE-SIZE and HEADERS-SIZE. They can be used to increase the size of the dictionary when you use SAVE-FORTH. For example, launch pForth as you normally do. Then enter:

    500000 CODE-SIZE !         \ request code portion of new dictionary to be 500000 bytes
    300000 HEADERS-SIZE !      \ request name portion of new dictionary to be 300000 bytes
    c" bigger.dic" SAVE-FORTH  \ create new and bigger dictionary file
    bye

Now run pForth using the new dictionary:

    pforth -dbigger.dic

And use MAP to verify that the dictionary is actually bigger. You can change the name of the new dictionary to "pforth.dic" to make it the default. 


9. Need more? There are a bunch of examples (see main.fs for example) at https://github.com/ProgrammingRainbow/Beginners-Guide-to-SDL2-in-Gforth that shouldn't be hard to get working under pForth rather than gForth - 
with the help of sdl2_parse.fth first before inclduing SDL2/SDL.fs, SDL2/SDL_image.fs, SDL2/SDL_ttf.fs and
SDL2/SDL_mixer.f.

Other notes: The pf_custom instructions say `Then rebuild the Forth using "pforth -i system.fth"` but 
I suspect `make all` does all of this.


MacOSX Notes for Dynamic Woes
==============================
On newer MacOSX you get a warning saying the framework cannot be opend. 

This is a pain - and you have to go to Priacy & Security (inside System Settings) 
each time it fails, and allow it. Then you try to reopen and all it specifically 
to open anyway. Then you get the next library.

After you've done all four libraries, you probably want to do a 'make build

The alternative is to statically link SDL - which means the executable has
everything you need.

See https://wiki.libsdl.org/SDL2/README/macos

The key part is...
    `sdl-config --static-libs`

You can remove  `-rpath /Library/Frameworks` from the linker command line.

Instructions are not yet provided for this, but I suspect if I want
to run it on anyone elses machine, a single binary

MacOSX Notes - Packages
=======================
You probably want to make a application package if you are going to distribute 
it more widely. 

I suggest you build the whole lot under Xcode rather than under the Makefile...


