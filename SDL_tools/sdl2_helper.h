/* WARNING: This is an auto-generated file. Do not edit it manually. 
   Edit the corresponding .fs file instead and run pforth_case_creation.py to regenerate this file. */
#include <stddef.h>
int sizeof_char() { return sizeof(char); }
int sizeof_short() { return sizeof(short); }
int sizeof_size_t() { return sizeof(size_t); }
int sizeof_int() { return sizeof(int); }
int sizeof_float() { return sizeof(float); }
int sizeof_double() { return sizeof(double); }
int sizeof_pointer() { return sizeof(void *); }
#include <SDL2/SDL_platform.h>
#include <SDL2/SDL_config.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_main.h>
#include <SDL2/SDL_assert.h>
#include <SDL2/SDL_atomic.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_endian.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_mutex.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_atomic.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_mutex.h>
#include <SDL2/SDL_thread.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_rwops.h>
#include <SDL2/SDL_audio.h>
#include <SDL2/SDL_clipboard.h>
#include <SDL2/SDL_cpuinfo.h>
#include <SDL2/SDL_pixels.h>
#include <SDL2/SDL_rect.h>
#include <SDL2/SDL_blendmode.h>
#include <SDL2/SDL_surface.h>
#include <SDL2/SDL_video.h>
#include <SDL2/SDL_scancode.h>
#include <SDL2/SDL_keycode.h>
#include <SDL2/SDL_keyboard.h>
#include <SDL2/SDL_mouse.h>
#include <SDL2/SDL_guid.h>
#include <SDL2/SDL_joystick.h>
#include <SDL2/SDL_sensor.h>
#include <SDL2/SDL_gamecontroller.h>
#include <SDL2/SDL_quit.h>
#include <SDL2/SDL_touch.h>
#include <SDL2/SDL_gesture.h>
#include <SDL2/SDL_events.h>
#include <SDL2/SDL_filesystem.h>
#include <SDL2/SDL_haptic.h>
#include <SDL2/SDL_hidapi.h>
#include <SDL2/SDL_hints.h>
#include <SDL2/SDL_loadso.h>
#include <SDL2/SDL_log.h>
#include <SDL2/SDL_messagebox.h>
#include <SDL2/SDL_metal.h>
#include <SDL2/SDL_power.h>
#include <SDL2/SDL_render.h>
#include <SDL2/SDL_shape.h>
#include <SDL2/SDL_system.h>
#include <SDL2/SDL_timer.h>
#include <SDL2/SDL_version.h>
#include <SDL2/SDL_locale.h>
#include <SDL2/SDL_misc.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
SDL_Surface * GF_TTF_RenderText_Solid(TTF_Font *font, const char *text, SDL_Color *fg) {
    return TTF_RenderText_Solid(font, text, *fg); }
SDL_Surface * GF_TTF_RenderUTF8_Solid(TTF_Font *font, const char *text, SDL_Color *fg) {
    return TTF_RenderUTF8_Solid(font, text, *fg); }
SDL_Surface * GF_TTF_RenderUNICODE_Solid(TTF_Font *font, const Uint16 *text, SDL_Color *fg) {
    return TTF_RenderUNICODE_Solid(font, text, *fg); }
SDL_Surface * GF_TTF_RenderText_Solid_Wrapped(TTF_Font *font, \
    const char *text, SDL_Color *fg, Uint32 wrapLength) {
    return TTF_RenderText_Solid_Wrapped(font, text, *fg, wrapLength); }
SDL_Surface * GF_TTF_RenderUTF8_Solid_Wrapped(TTF_Font *font, \
    const char *text, SDL_Color *fg, Uint32 wrapLength) {
    return TTF_RenderUTF8_Solid_Wrapped(font, text, *fg, wrapLength); }
SDL_Surface * GF_TTF_RenderUNICODE_Solid_Wrapped(TTF_Font *font, \
    const Uint16 *text, SDL_Color *fg, Uint32 wrapLength) {
    return TTF_RenderUNICODE_Solid_Wrapped(font, text, *fg, wrapLength); }
SDL_Surface * GF_TTF_RenderGlyph_Solid(TTF_Font *font, Uint16 ch, SDL_Color *fg) {
    return TTF_RenderGlyph_Solid(font, ch, *fg); }
SDL_Surface * GF_TTF_RenderGlyph32_Solid(TTF_Font *font, Uint32 ch, SDL_Color *fg) {
    return TTF_RenderGlyph32_Solid(font, ch, *fg); }
SDL_Surface * GF_TTF_RenderText_Shaded(TTF_Font *font, \
    const char *text, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderText_Shaded(font, text, *fg, *bg); }
SDL_Surface * GF_TTF_RenderUTF8_Shaded(TTF_Font *font, \
    const char *text, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderUTF8_Shaded(font, text, *fg, *bg); }
SDL_Surface * GF_TTF_RenderUNICODE_Shaded(TTF_Font *font, \
    const Uint16 *text, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderUNICODE_Shaded(font, text, *fg, *bg); }
SDL_Surface * GF_TTF_RenderText_Shaded_Wrapped(TTF_Font *font, \
    const char *text, SDL_Color *fg, SDL_Color *bg, Uint32 wrapLength) {
    return TTF_RenderText_Shaded_Wrapped(font, text, *fg, *bg, wrapLength); }
SDL_Surface * GF_TTF_RenderUTF8_Shaded_Wrapped(TTF_Font *font, \
    const char *text, SDL_Color *fg, SDL_Color *bg, Uint32 wrapLength) {
    return TTF_RenderUTF8_Shaded_Wrapped(font, text, *fg, *bg, wrapLength); }
SDL_Surface * GF_TTF_RenderUNICODE_Shaded_Wrapped(TTF_Font *font, \
    const Uint16 *text, SDL_Color *fg, SDL_Color *bg, Uint32 wrapLength) {
    return TTF_RenderUNICODE_Shaded_Wrapped(font, text, *fg, *bg, wrapLength); }
SDL_Surface * GF_TTF_RenderGlyph_Shaded(TTF_Font *font, Uint16 ch, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderGlyph_Shaded(font, ch, *fg, *bg); }
SDL_Surface * GF_TTF_RenderGlyph32_Shaded(TTF_Font *font, Uint32 ch, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderGlyph32_Shaded(font, ch, *fg, *bg); }
SDL_Surface * GF_TTF_RenderText_Blended(TTF_Font *font, const char *text, SDL_Color *fg) {
    return TTF_RenderText_Blended(font, text, *fg); }
SDL_Surface * GF_TTF_RenderUTF8_Blended(TTF_Font *font, const char *text, SDL_Color *fg) {
    return TTF_RenderUTF8_Blended(font, text, *fg); }
SDL_Surface * GF_TTF_RenderUNICODE_Blended(TTF_Font *font, const Uint16 *text, SDL_Color *fg) {
    return TTF_RenderUNICODE_Blended(font, text, *fg); }
SDL_Surface * GF_TTF_RenderText_Blended_Wrapped(TTF_Font *font, \
    const char *text, SDL_Color *fg, Uint32 wrapLength) {
    return TTF_RenderText_Blended_Wrapped(font, text, *fg, wrapLength); }
SDL_Surface * GF_TTF_RenderUTF8_Blended_Wrapped(TTF_Font *font, \
    const char *text, SDL_Color *fg, Uint32 wrapLength) {
    return TTF_RenderUTF8_Blended_Wrapped(font, text, *fg, wrapLength); }
SDL_Surface * GF_TTF_RenderUNICODE_Blended_Wrapped(TTF_Font *font, \
    const Uint16 *text, SDL_Color *fg, Uint32 wrapLength) {
    return TTF_RenderUNICODE_Blended_Wrapped(font, text, *fg, wrapLength); }
SDL_Surface * GF_TTF_RenderGlyph_Blended(TTF_Font *font, Uint16 ch, SDL_Color *fg) {
    return TTF_RenderGlyph_Blended(font, ch, *fg); }
SDL_Surface * GF_TTF_RenderGlyph32_Blended(TTF_Font *font, Uint32 ch, SDL_Color *fg) {
    return TTF_RenderGlyph32_Blended(font, ch, *fg); }
SDL_Surface * GF_TTF_RenderText_LCD(TTF_Font *font, \
    const char *text, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderText_LCD(font, text, *fg, *bg); }
SDL_Surface * GF_TTF_RenderUTF8_LCD(TTF_Font *font, \
    const char *text, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderUTF8_LCD(font, text, *fg, *bg); }
SDL_Surface * GF_TTF_RenderUNICODE_LCD(TTF_Font *font, \
    const Uint16 *text, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderUNICODE_LCD(font, text, *fg, *bg); }
SDL_Surface * GF_TTF_RenderText_LCD_Wrapped(TTF_Font *font, \
    const char *text, SDL_Color *fg, SDL_Color *bg, Uint32 wrapLength) {
    return TTF_RenderText_LCD_Wrapped(font, text, *fg, *bg, wrapLength); }
SDL_Surface * GF_TTF_RenderUTF8_LCD_Wrapped(TTF_Font *font, \
    const char *text, SDL_Color *fg, SDL_Color *bg, Uint32 wrapLength) {
    return TTF_RenderUTF8_LCD_Wrapped(font, text, *fg, *bg, wrapLength); }
SDL_Surface * GF_TTF_RenderUNICODE_LCD_Wrapped(TTF_Font *font, \
    const Uint16 *text, SDL_Color *fg, SDL_Color *bg, Uint32 wrapLength) {
    return TTF_RenderUNICODE_LCD_Wrapped(font, text, *fg, *bg, wrapLength); }
SDL_Surface * GF_TTF_RenderGlyph_LCD(TTF_Font *font, Uint16 ch, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderGlyph_LCD(font, ch, *fg, *bg); }
SDL_Surface * GF_TTF_RenderGlyph32_LCD(TTF_Font *font, Uint32 ch, SDL_Color *fg, SDL_Color *bg) {
    return TTF_RenderGlyph32_LCD(font, ch, *fg, *bg); }
#include <SDL2/SDL_mixer.h>
