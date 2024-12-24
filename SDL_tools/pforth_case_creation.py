#!/usr/bin/env python
# -*- coding: utf-8 -*-
# pforth_case_creation.py
# This script is used to generate the glue code for the pforth SDL2 module.
#
# It reads the SDL2/SDL.fs, SDL2/SDL_image.fs, SDL2/SDL_ttf.fs, and SDL2/SDL_mixer.fs files
# (from https://github.com/ProgrammingRainbow/Beginners-Guide-to-SDL2-in-Gforth )
# and generates the glue code for the pforth SDL2 module. This code is licensed
# under the zlib license - as ProgrammingRainbow's code and libSDL itself.
#
# See https://gforth.org/manual/Declaring-C-Functions.html for more information 
# about the C functions used in gForth.
#
# Written by Rob Probin December 2024
# This code is 0BSD licensed

import os
import sys

files_to_parse = [
    "extra_pforth.fs",
    "SDL2/SDL.fs",
    "SDL2/SDL_image.fs",
    "SDL2/SDL_ttf.fs",
    "SDL2/SDL_mixer.fs",
]
warning =  "/* WARNING: This is an auto-generated file. Do not edit it manually.\n"
warning += "   Edit the corresponding .fs file instead and run pforth_case_creation.py to regenerate this file.\n"
warning += "   This file ZLib licensed because it's generated from the SDL2/ directory. */\n"

helper_code = [warning]
glue_code = [warning]
dic_entry_code = [warning]

duplicate_check = { 
    # we preload with SDL_main because we don't want it to be included in Forth
    "SDL_main": ("SDL_main", "SDL_main", "C_RETURNS_VALUE", 2)
    }

def duplicate(c_name, forth_name, ret_type, parameters):
    global duplicate_check
    # duplicate c function names don't matter ... but forth names do
    key = forth_name
    if key in duplicate_check:
        (c_name2, forth_name2, ret_type2, parameters2) = duplicate_check[key]
        if forth_name != forth_name2 or ret_type != ret_type2 or parameters != parameters2:
            print(f"Duplicate function name: {key}")
            print(f"  {c_name} != {c_name2}")
            print(f"  {forth_name} != {forth_name2}")
            print(f"  {ret_type} != {ret_type2}")
            print(f"  {parameters} != {parameters2}")
            sys.exit(7)
        return True
    duplicate_check[key] = (c_name, forth_name, ret_type, parameters)
    return False

def create_dict_entry(c_name, comment_out):
    global dic_entry_code
    output =  f'(CFunc0) {c_name},'   #f'CreateDicEntryC(CASE_{word}, "{word}", 0);'
    if comment_out is not None:
        output = "/*" + comment_out + output + "*/"
    dic_entry_code.append(output)

def create_glue_code(forth_name, ret_type, params, comment_out):
    global glue_code
    output = f'err = CreateGlueToC( "{forth_name}", i++, {ret_type}, {params}); if( err < 0 ) return err;'
    if comment_out is not None:
        output = "/*" + comment_out + output + "*/"
    glue_code.append(output)

def add_helper_code(str):
    global helper_code
    helper_code.append(str)

def parse_c_function(xline):
    # something like this:
    # c-function TTF_OpenFontIndexRW TTF_OpenFontIndexRW a n n n -- a	( src freesrc ptsize index -- )
    forth_name = xline[1]
    c_name = xline[2]
    parameters = 0
    return_index = 0
    comment_out = None
    for i in range(3, len(xline)):
        if xline[i] == "r":
            print("We don't yet support float parameter values", xline)
            comment_out = "[[[float param]]] "
        elif xline[i] == "a":
            pass
        elif xline[i] == "n":
            pass
        elif xline[i] == "--":
            return_index = i + 1
            break
        else:
            print("Unrecognized parameter type", xline[i])
            print(xline)
            sys.exit(8)

        parameters += 1
    if return_index == 0:
        print("Illegal c-function declaration", xline)
        sys.exit(4)

    if xline[return_index] == "void":
        ret_type = "C_RETURNS_VOID"
    elif xline[return_index] == "a":
        ret_type = "C_RETURNS_VALUE"
    elif xline[return_index] == "n":
        ret_type = "C_RETURNS_VALUE"
    elif xline[return_index] == "r":
        # pForth doesn't support float return values, so we need to
        # extend it to support float return values (probably doubles).
        ret_type = "C_RETURNS_FLOAT"
        if comment_out is None:
            comment_out = "[[[float ret]]] "
        else:
            comment_out = "[[[float param+ret]]] "
    else:
        print("Illegal return type", xline[return_index])
        print(xline)
        sys.exit(5)

    # pforth can only handle 5 parameters by default, so we need
    # to extend the number of parameters
    if parameters > 12:
        print("Too many parameters", xline)
        sys.exit(6)
    if parameters > 12:
        comment_out = "[[[params > 12]]] "
        # for the moment remove parameters more than 5

    if not duplicate(c_name, forth_name, ret_type, parameters):
        create_glue_code(forth_name, ret_type, parameters, comment_out)
        create_dict_entry(c_name, comment_out)
    else:
        print("Duplicate function name", xline)

    if len(c_name) > 31:
        if len(c_name) > 63:
            print(">>>>>> C function name too long", c_name, len(c_name))
            sys.exit(9)
        #else:
        #    print("WARNING: Long C function name", c_name, len(c_name))
    if len(forth_name) > 31:
        if len(forth_name) > 63:
            print(">>>>>> Forth function name too long", forth_name, len(forth_name))
            sys.exit(10)
        #else:
        #    print("WARNING: Long Forth function name", forth_name, len(forth_name))



def parse_sdl_api_file(file_path):
    with open(file_path, "r") as f:
        lines = f.readlines()

    for line in lines:
        if len(line) >255:
            print(">>>>>> Line too long", line, len(line))
            sys.exit(11)
            
        sline = line.strip()
        xline = sline.split()
        if len(xline) > 0:
            word = xline[0].lower()
            if word == "require":
                print(f"Found require: {sline}")
                if len(xline) >= 1:
                    print("--------------------------------------")
                    module_filename = xline[1]
                    print(f"Module: {module_filename}")
                    parse_sdl_api_file(f"SDL2/{module_filename}")
                else:
                    print("Illegal require declaration", sline)
                    sys.exit(1)
            elif word == "c-function":
                print(f"Found c-function: {sline}")
                if len(xline) >= 5:
                    parse_c_function(xline)
                else:
                    print("Illegal c-function declaration")
                    sys.exit(2)
            elif word == "\\c":
                if len(xline) < 2:
                    print("Illegal \\c declaration")
                    sys.exit(3)
                print(f"Found \\c: {sline}")
                i = line.find("\\c")
                add_helper_code(line[i+3:])
            else:
                pass

def main():
    for file in files_to_parse:
        print("======================================")
        print(f"Parsing file: {file}")
        parse_sdl_api_file(file)

    with open("../csrc/sdl2_helper.h", "w") as f:
        for line in helper_code:
            f.write(line)

    with open("../csrc/sdl2_glue.h", "w") as f:
        for line in glue_code:
            f.write(line)
            f.write("\n")

    with open("../csrc/sdl2_dic_entries.h", "w") as f:
        for line in dic_entry_code:
            f.write(line)
            f.write("\n")

if __name__ == '__main__':
    main()