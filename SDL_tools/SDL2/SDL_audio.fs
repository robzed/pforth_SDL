\ ----===< prefix >===-----
c-library sdl_audio
s" SDL2" add-lib
\c #include <SDL2/SDL_audio.h>

\ ----===< int constants >===-----
#255	constant SDL_AUDIO_MASK_BITSIZE
#256	constant SDL_AUDIO_MASK_DATATYPE
#4096	constant SDL_AUDIO_MASK_ENDIAN
#32768	constant SDL_AUDIO_MASK_SIGNED
#8	    constant AUDIO_U8
#32776	constant AUDIO_S8
#16	    constant AUDIO_U16LSB
#32784	constant AUDIO_S16LSB
#4112	constant AUDIO_U16MSB
#36880	constant AUDIO_S16MSB
#16	    constant AUDIO_U16
#32784	constant AUDIO_S16
#32800	constant AUDIO_S32LSB
#36896	constant AUDIO_S32MSB
#32800	constant AUDIO_S32
#33056	constant AUDIO_F32LSB
#37152	constant AUDIO_F32MSB
#33056	constant AUDIO_F32
#16	    constant AUDIO_U16SYS
#32784	constant AUDIO_S16SYS
#32800	constant AUDIO_S32SYS
#33056	constant AUDIO_F32SYS
#1	    constant SDL_AUDIO_ALLOW_FREQUENCY_CHANGE
#2	    constant SDL_AUDIO_ALLOW_FORMAT_CHANGE
#4	    constant SDL_AUDIO_ALLOW_CHANNELS_CHANGE
#8	    constant SDL_AUDIO_ALLOW_SAMPLES_CHANGE
#15	    constant SDL_AUDIO_ALLOW_ANY_CHANGE
#9	    constant SDL_AUDIOCVT_MAX_FILTERS
#128	constant SDL_MIX_MAXVOLUME

\ --------===< enums >===---------
#0	    constant SDL_AUDIO_STOPPED
#1	    constant SDL_AUDIO_PLAYING
#2	    constant SDL_AUDIO_PAUSED

\ -------===< structs >===--------

\ struct SDL_AudioSpec
begin-structure SDL_AudioSpec
	c-int:      SDL_AudioSpec-freq
	c-uint16:   SDL_AudioSpec-format
	c-uint8:    SDL_AudioSpec-channels
	c-uint8:    SDL_AudioSpec-silence
	c-uint16:   SDL_AudioSpec-samples
	c-uint16:   SDL_AudioSpec-padding
	c-uint32:   SDL_AudioSpec-size
	c-func-ptr:	SDL_AudioSpec-callback
	c-pointer:  SDL_AudioSpec-userdata
end-structure

\ struct SDL_AudioCVT
begin-structure SDL_AudioCVT
	c-int:          SDL_AudioCVT-needed
    c-uint16:       SDL_AudioCVT-src_format
	c-uint16:       SDL_AudioCVT-dst_format
	c-double:       SDL_AudioCVT-rate_incr
	c-uint8-ptr:    SDL_AudioCVT-buf
	c-int:          SDL_AudioCVT-len
	c-int:          SDL_AudioCVT-len_cvt
	c-int:          SDL_AudioCVT-len_mult
	c-double:       SDL_AudioCVT-len_ratio
	10 c-func-ptrs: SDL_AudioCVT-filters
	c-int:          SDL_AudioCVT-filter_index
end-structure

\ ------===< functions >===-------
c-function SDL_GetNumAudioDrivers SDL_GetNumAudioDrivers  -- n	( -- )
c-function SDL_GetAudioDriver SDL_GetAudioDriver n -- a	( index -- )
c-function SDL_AudioInit SDL_AudioInit a -- n	( driver_name -- )
c-function SDL_AudioQuit SDL_AudioQuit  -- void	( -- )
c-function SDL_GetCurrentAudioDriver SDL_GetCurrentAudioDriver  -- a	( -- )
c-function SDL_OpenAudio SDL_OpenAudio a a -- n	( desired obtained -- )
c-function SDL_GetNumAudioDevices SDL_GetNumAudioDevices n -- n	( iscapture -- )
c-function SDL_GetAudioDeviceName SDL_GetAudioDeviceName n n -- a	( index iscapture -- )
c-function SDL_GetAudioDeviceSpec SDL_GetAudioDeviceSpec n n a -- n	( index iscapture spec -- )
c-function SDL_GetDefaultAudioInfo SDL_GetDefaultAudioInfo a a n -- n	( name spec iscapture -- )
c-function SDL_OpenAudioDevice SDL_OpenAudioDevice a n a a n -- n	( device iscapture desired obtained allowed_changes -- )
c-function SDL_GetAudioStatus SDL_GetAudioStatus  -- n	( -- )
c-function SDL_GetAudioDeviceStatus SDL_GetAudioDeviceStatus n -- n	( dev -- )
c-function SDL_PauseAudio SDL_PauseAudio n -- void	( pause_on -- )
c-function SDL_PauseAudioDevice SDL_PauseAudioDevice n n -- void	( dev pause_on -- )
c-function SDL_LoadWAV_RW SDL_LoadWAV_RW a n a a a -- a	( src freesrc spec audio_buf audio_len -- )
c-function SDL_FreeWAV SDL_FreeWAV a -- void	( audio_buf -- )
c-function SDL_BuildAudioCVT SDL_BuildAudioCVT a n n n n n n -- n	( cvt src_format src_channels src_rate dst_format dst_channels dst_rate -- )
c-function SDL_ConvertAudio SDL_ConvertAudio a -- n	( cvt -- )
." Hello from SDL_audio.fs" cr source hex . space . decimal 1000 ms
c-function SDL_NewAudioStream SDL_NewAudioStream n n n n n n -- a	( src_format src_channels src_rate dst_format dst_channels dst_rate -- )
c-function SDL_AudioStreamPut SDL_AudioStreamPut a a n -- n	( stream buf len -- )
c-function SDL_AudioStreamGet SDL_AudioStreamGet a a n -- n	( stream buf len -- )
c-function SDL_AudioStreamAvailable SDL_AudioStreamAvailable a -- n	( stream -- )
c-function SDL_AudioStreamFlush SDL_AudioStreamFlush a -- n	( stream -- )
c-function SDL_AudioStreamClear SDL_AudioStreamClear a -- void	( stream -- )
c-function SDL_FreeAudioStream SDL_FreeAudioStream a -- void	( stream -- )
c-function SDL_MixAudio SDL_MixAudio a a n n -- void	( dst src len volume -- )
c-function SDL_MixAudioFormat SDL_MixAudioFormat a a n n n -- void	( dst src format len volume -- )
c-function SDL_QueueAudio SDL_QueueAudio n a n -- n	( dev data len -- )
c-function SDL_DequeueAudio SDL_DequeueAudio n a n -- n	( dev data len -- )
c-function SDL_GetQueuedAudioSize SDL_GetQueuedAudioSize n -- n	( dev -- )
c-function SDL_ClearQueuedAudio SDL_ClearQueuedAudio n -- void	( dev -- )
c-function SDL_LockAudio SDL_LockAudio  -- void	( -- )
c-function SDL_LockAudioDevice SDL_LockAudioDevice n -- void	( dev -- )
c-function SDL_UnlockAudio SDL_UnlockAudio  -- void	( -- )
c-function SDL_UnlockAudioDevice SDL_UnlockAudioDevice n -- void	( dev -- )
c-function SDL_CloseAudio SDL_CloseAudio  -- void	( -- )
c-function SDL_CloseAudioDevice SDL_CloseAudioDevice n -- void	( dev -- )

\ ----===< postfix >===-----
end-c-library
