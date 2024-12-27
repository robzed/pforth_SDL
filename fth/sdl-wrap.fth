\ sdl.fth
\ Import all the High Level SDL Forth words
\
\ Author: Rob Probin
\ Copyright 2024 Rob Probin
\
\ Permission to use, copy, modify, and/or distribute this
\ software for any purpose with or without fee is hereby granted.
\
\ THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
\ WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
\ WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
\ THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
\ CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
\ FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
\ CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
\ OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

anew task-sdl-wrap.fth
decimal

\ This file is a bit weird, because it just includes other files...
\ We might change this at some point. 

\ SDL2 parsing helper
include ../SDL_tools/sdl2_parse.fth

\ SDL2 library - notice internal paths assume we are in SDL2/ directory
S" ../SDL_tools/SDL2/" set-require-subdir 
require SDL.fs
S" " set-require-subdir
