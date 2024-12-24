\ SDL2 parsing helper
\ Copyright (C) 2024 Rob Probin
\ License: zLib (see LICENSE)
\ Written to support loading of the gForth based definitions for SDL2
\ from https://github.com/ProgrammingRainbow/Beginners-Guide-to-SDL2-in-Gforth
\ Written December 2024. 

: c-library ( 'name' -- )
    \ could use create - but at the moment we just drop the name
    BL WORD 
    \ count ." C library ----------------" type cr
    \ .s cr
    drop
;

: _valid_param_type ( addr u -- flag)
    \ valid types are   n a d r func
    2dup s" n"    compare 0= if 2drop true exit then
    2dup s" a"    compare 0= if 2drop true exit then
    2dup s" d"    compare 0= if 2drop true exit then
    2dup s" r"    compare 0= if 2drop true exit then
    2dup s" func" compare 0= if 2drop true exit then
    2drop false
;
: _valid_return_type ( caddr -- flag )
    \ valid types are    n a d r func void
    2dup _valid_param_type if 2drop true exit then
    2dup s" void" compare 0= if 2drop true exit then
    2drop false
;

\ pForth doesn't have this yet, so we define it here
: parse-name  ( "word" -- c-addr u ) bl parse-word ;

: _parse_params ( addr u -- )
    begin
        parse-name
        2dup s" --" compare 0= if
            2drop exit
        then
        _valid_param_type 0= if
            ." Invalid parameter type" cr
            abort
        then
    again
;

\ Define a Forth word forth-name. Forth-name has the specified stack effect and calls the C function c-name. 
\ The contents are ignored by pForth, but are used by the pforth_case_creation.py script to generate the C code.
: c-function ( "forth-name" "c-name" "{type}" "--" "type" --  ) 

    \ get forthname, c-name - ignore what they are
    BL WORD drop BL WORD drop 

    \ now we look for parameters, until we see "--"
    _parse_params

    \ now we look for return type
    parse-name _valid_return_type 0= if
        ." Invalid return type" cr
        abort
    then
;

\ One line of C declarations for the C interface, dropped as a comment 
\ in pForth. (Used by pforth_case_creation.py)
: \c ( "rest-of-line" –  )
    postpone \
;

: end-c-library ( -- )
    \ nothing to do at the moment
;

: add-lib ( addr u -- )
    \ nothing to do at the moment
    \ ." Adding library ===============" type cr
    2drop
;


32 constant _subdir_max
create _subdirectory _subdir_max 1+ allot    \ 1+ is for off by one errors...
0 value _subdir_len

: set-require-subdir ( caddr u -- )
    to _subdir_len
    _subdir_len _subdir_max > if
        ." Subdirectory name too long" cr
        abort
    then
    _subdirectory _subdir_len MOVE ( src dst num -- )
;

256 constant _path_temp_max
create _path_temp _path_temp_max 1+ allot    \ 1+ is for off by one errors...
0 value _path_temp_len

\ copy caddr1 u1 path
: _concat_to_path_temp ( caddr1 u1 -- )
    \ check if too long
    dup _path_temp_len + _path_temp_max > if
        ." Path name too long" cr
        abort
    then
    \ source is caddr1
    \ destination is _path_temp + _path_temp_len
    _path_temp _path_temp_len + swap
    \ len is u1
    dup >r
    move ( src dst num -- )
    \ update length
    r> _path_temp_len + to _path_temp_len
;


\ new version of require for subdirectories
: REQUIRE ( i*x "name" -- i*x ) 
    parse-name    ( "name" -- addr u )
    \ don't bother if subdirectory is empty
    _subdir_len if
        0 to _path_temp_len
        _subdirectory _subdir_len _concat_to_path_temp
        _concat_to_path_temp ( addr u -- )
        \ new combined path 
        _path_temp _path_temp_len
    then
    required
;


