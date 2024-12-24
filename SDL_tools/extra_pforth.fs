\ Written by Rob Probin, December 2024
\ This file is 0BSD licensed.

\c #include <stdint.h>

\ various small loads ... all native endian

\c uint64_t u64_fetch(void* addr) { return (*(uint64_t*)addr); }
\c cell_t   s64_fetch(void* addr) { return (*( int64_t*)addr); }

\c uint32_t u32_fetch(void* addr) { return (*(uint32_t*)addr); }
\c cell_t   s32_fetch(void* addr) { return (*( int32_t*)addr); }

\c uint16_t u16_fetch(void* addr) { return (*(uint16_t*)addr); }
\c cell_t   s16_fetch(void* addr) { return (*( int16_t*)addr); }

\c uint8_t   u8_fetch(void* addr) { return (*( uint8_t*)addr); }
\c cell_t    s8_fetch(void* addr) { return (*(  int8_t*)addr); }

c-function u64@      u64_fetch   a -- n ( address -- data )
c-function s64@      s64_fetch   a -- n ( address -- data )

c-function u32@      u32_fetch   a -- n ( address -- data )
c-function s32@      s32_fetch   a -- n ( address -- data )

c-function u16@      u16_fetch   a -- n ( address -- data )
c-function s16@      s16_fetch   a -- n ( address -- data )

c-function  u8@       u8_fetch   a -- n ( address -- data )
c-function  s8@       s8_fetch   a -- n ( address -- data )

\c void u64_store(uint64_t data, void* addr) { *(uint64_t*)addr = data; }
\c void s64_store( int64_t data, void* addr) { *( int64_t*)addr = data; }

\c void u32_store(uint32_t data, void* addr) { *(uint32_t*)addr = data; }
\c void s32_store( int32_t data, void* addr) { *( int32_t*)addr = data; }

\c void u16_store(uint16_t data, void* addr) { *(uint16_t*)addr = data; }
\c void s16_store( int16_t data, void* addr) { *( int16_t*)addr = data; }

\c void  u8_store( uint8_t data, void* addr) { *( uint8_t*)addr = data; }
\c void  s8_store(  int8_t data, void* addr) { *(  int8_t*)addr = data; }

c-function u64!      u64_store   n a -- void ( data address -- )
c-function s64!      s64_store   n a -- void ( data address -- )

c-function u32!      u32_store   n a -- void ( data address -- )
c-function s32!      s32_store   n a -- void ( data address -- )

c-function u16!      u16_store   n a -- void ( data address -- )
c-function s16!      s16_store   n a -- void ( data address -- )

c-function  u8!       u8_store   n a -- void ( data address -- )
c-function  s8!       s8_store   n a -- void ( data address -- )


\ SDL already has big and little endian specific functions
\ SDL_ReadBE16, SDL_ReadBE32, SDL_ReadBE64, SDL_ReadLE16, SDL_ReadLE32, SDL_ReadLE64, 
\ SDL_ReadU8, SDL_WriteBE16, SDL_WriteBE32, SDL_WriteBE64, SDL_WriteLE16, SDL_WriteLE32, SDL_WriteLE64, SDL_WriteU8

\ NOTICE: We replaced these untested little endian definitions with C versions for speed
\ : u8@ c@ ;
\ : u16@ ( addr -- u ) dup u8@ swap 1+ u8@ << 8 + ;
\ : s16@ ( addr -- n ) u16@ 0x8000 and dup 0<> IF 0xffff0000 or THEN ;
\ : u32@ ( addr -- u ) dup u16@ swap 2+ u16@ << 16 + ;
\ : s32@ ( addr -- n ) u32@ 0x80000000 and dup 0<> IF 0xffffffff00000000 or THEN ;

\ If you wanted to match the gForth ones, then you could do something like this:
\ https://gforth.org/manual/Special-Memory-Accesses.html
\ https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Memory-Access.html?
\ : l@ u32@ ;
\ : sl@ s32@ ;


