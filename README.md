# PForth SDL - pForth extended with libSDL bindings

This is a work in progress - currently under construction.

Originally this was meant to be a set of instructions inside a different project
but as the changes grew, it seemed like having a fork of pforth was the best idea
for everyone, including me. However, although this is a fork, it intends to stay 
as close to pForth base as I can - and hopefully some of the non-SDL changes can 
be migrated back to pForth.

It's based on the following projects:

* pForth  
    * https://www.softsynth.com/pforth
    * https://github.com/philburk/pforth
    * 0BSD License
* ProgrammingRainbow's SDL binding for gForth:
    * https://github.com/ProgrammingRainbow/Beginners-Guide-to-SDL2-in-Gforth
    * Zlib License
    * (also see the videos here https://www.youtube.com/watch?v=PZFMcBKKiCM)
* libSDL
    * https://www.libsdl.org
    * Zlib License

Current lot of things are under construction. Right now it works for me on MacOS 
with the SDL framework installed in Library/Framework - but mainly I want to fix the 
cross-platform stuff and add static linking with SDL in so that people an play 
your game without extra DLLs, shared libs, or frameworks. Oh, I really want to get
back to programming my game (which isn't even for pForth or SDL) ... this is a 
purely a side quest :-D

This project is licensed mostly in 0BSD, with the SDL specific parts being Zlib.

Instructions - see the three projects above. NOTE: There are a few minor
differences between gForth and pForth, so you might need to make some adjustments
if you are following Programming Rainbow's SDL tutorial. At some point I'll add 
some notes for that, but right now you are 


## IMMEDIATE TO DO LIST

* ~~Move stuff from caves to SDL-pForth~~
* ~~Add license and readme to SDL2 directory~~
* ~~Switch the license over to 0BSD for non-SDL files~~
* ~~Make 16 bit and 32 bit fetches native - Create forth definitions - made with py tool~~
    * ~~and stores~~
* Test SDL example works 
* ~~edit readme in SDL pForth - explain what it is - basic version!~~
* merge back to SDL_master
* make sure SDL dictionary is built in as standard /or/ has enough space to import SDL2 libs and sdl2_parse.fth <<<< rebuild dictionary should have those definitions built in!!!!
* Long names size should be configurable (31 or 63)
    * Optional Long name - PR back to pForth
* float parameters, float return - allow rest of SDL functions to be used
* SDL import stuff   (what does this mean?)
* Portability: Tidy up make file for Linux, homebrew
* Portability: Fix windows build
* Portability: Statically link SDL2 - in reality, README: because this means people an play your game without extra DLLs, shared libs, or frameworks
* Portability: Fix sdl2_helper.h paths for SDL2 that are mac Library/framework specific… (SDL2_Mixer/, etc.)

## LONGER TERM TO DO LIST

* Fix this README properly - instructions of building, and instructions on SDL_tools directory and SDL2_example.fth
* Add instructions for differences between gForth and pForth when using tutorials.
* Add names too long warning


# ORIGINAL PFORTH TEXT - edit it at some point.

# PForth - a Portable ANS-like Forth written in ANSI 'C'

by Phil Burk
with Larry Polansky, David Rosenboom and Darren Gibbs.
Support for 64-bit cells by Aleksej Saushev.

Last updated: November 27, 2022

Portable Forth written in 'C' for most 32 and 64-bit platforms.

PForth is written in 'C' and can be easily ported to new 32 and 64-bit platforms. 
It only needs character input and output functions to operate and, therefore, does not require an operating system.
This makes it handy for bringing up and testing embedded systems.

PForth also works on desktops including Windows, Mac and Linux and supports command line history.
This lets you develop hardware tests on a desktop before trying them on your embedded system.
But pForth is not a rich and friendly desktop programming environment.
There are no GUI tools for developing desktop applications. PForth is lean and mean and optimized for portability.

PForth has a tool for compiling code on a desktop, then exporting the dictionary in big or little endian format as 'C' source code.
This lets you compile tests for an embedded system that does not have file I/O.

PForth is based on ANSI-Forth but is not 100% compatible. https://forth-standard.org/standard/words

Code for pForth is maintained on GitHub at: https://github.com/philburk/pforth

Documentation for pForth at: http://www.softsynth.com/pforth/

To report bugs or request features please file a GitHub Issue.
  
For questions or general discussion please use the pForth forum at:
  http://groups.google.com/group/pforthdev

## LEGAL NOTICE

Permission to use, copy, modify, and/or distribute this
software for any purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

## Contents of SDK

    platforms - tools for building pForth on various platforms
    platforms/unix - Makefile for unix

    csrc - pForth kernel in ANSI 'C'
    csrc/pf_main.c - main() application for a standalone Forth
    csrc/stdio - I/O code using basic stdio for generic platforms
    csrc/posix - I/O code for Posix platform
    csrc/win32 - I/O code for basic WIN32 platform
    csrc/win32_console - I/O code for WIN32 console that supports command line history

    fth - Forth code
    fth/util - utility functions

## How to Build pForth

Building pForth involves two steps:
1) building the C based Forth kernel
2) building the Forth dictionary file using: ./pforth -i system.fth
3) optional build of standalone executable with built-in dictionary

We have provided build scripts to simplify this process.

On Unix and MacOS using Makefile:

    cd platforms/unix
    make all
    ./pforth_standalone
    
For more details, see the [Wiki](https://github.com/philburk/pforth/wiki/Compiling-on-Unix)

Using CMake:

    cmake .
    make
    cd fth
    ./pforth_standalone

For embedded systems, see the pForth reference manual at:

  http://www.softsynth.com/pforth/pf_ref.php

## How to Run pForth

To run the all-in-one pForth enter:

    ./pforth_standalone
    
OR, to run using the dictionary file, enter:

    ./pforth

Quick check of Forth:

    3 4 + .
    words
    bye

To compile source code files use:

    INCLUDE filename

To create a custom dictionary enter in pForth:

    c" newfilename.dic" SAVE-FORTH
    
The name must end in ".dic".

To run PForth with the new dictionary enter in the shell:

    pforth -dnewfilename.dic

To run PForth and automatically include a forth file:
    pforth myprogram.fth
    
## How to Test pForth

PForth comes with a small test suite.  To test the Core words,
you can use the coretest developed by John Hayes.

On Unix and MacOS using Makefile:

    cd platforms/unix
    make test

Using CMake:

    cmake .
    make
    cd fth
    ./pforth
    include tester.fth
    include coretest.fth

To run the other tests, enter:

    pforth t_corex.fth
    pforth t_strings.fth
    pforth t_locals.fth
    pforth t_alloc.fth

They will report the number of tests that pass or fail.

You can also test pForth kernel without loading a dictionary using option "-i".
Only the primitive words defined in C will be available.
This might be necessary if the dictionary can't be built.

    ./pforth -i
    3 4 + .
    23 77 swap .s
    loadsys
