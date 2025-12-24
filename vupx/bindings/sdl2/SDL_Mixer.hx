package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_mixer.h")
@:native("MIX_InitFlags")
extern enum abstract MIX_InitFlags(Int) to Int {
	@:native("MIX_INIT_FLAC")
	var MIX_INIT_FLAC;
	@:native("MIX_INIT_MOD")
	var MIX_INIT_MOD;
	@:native("MIX_INIT_MP3")
	var MIX_INIT_MP3;
	@:native("MIX_INIT_OGG")
	var MIX_INIT_OGG;
	@:native("MIX_INIT_MID")
	var MIX_INIT_MID;
	@:native("MIX_INIT_OPUS")
	var MIX_INIT_OPUS;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_mixer.h")
@:native("Mix_Chunk")
@:structAccess
extern class Mix_Chunk {
	@:native("allocated")
	var allocated:Int;

	@:native("abuf")
	var abuf:Pointer<UInt8>;

	@:native("alen")
	var alen:UInt32;

	@:native("volume")
	var volume:UInt8;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_mixer.h")
@:native("Mix_Fading")
extern enum Mix_Fading {
	@:native("MIX_NO_FADING")
	MIX_NO_FADING;
	@:native("MIX_FADING_OUT")
	MIX_FADING_OUT;
	@:native("MIX_FADING_IN")
	MIX_FADING_IN;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_mixer.h")
@:native("Mix_MusicType")
extern enum abstract Mix_MusicType(Int) to Int {
	@:native("MUS_NONE")
	var MUS_NONE;
	@:native("MUS_CMD")
	var MUS_CMD;
	@:native("MUS_WAV")
	var MUS_WAV;
	@:native("MUS_MOD")
	var MUS_MOD;
	@:native("MUS_MID")
	var MUS_MID;
	@:native("MUS_OGG")
	var MUS_OGG;
	@:native("MUS_MP3")
	var MUS_MP3;
	@:native("MUS_FLAC")
	var MUS_FLAC;
	@:native("MUS_OPUS")
	var MUS_OPUS;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_mixer.h")
@:native("Mix_Music")
extern class Mix_Music {}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_mixer.h")
extern class SDL_Mixer {
	@:native("MIX_CHANNELS")
	@:include("SDL2/SDL_mixer.h")
	extern public static var MIX_CHANNELS:Int;

	@:native("MIX_DEFAULT_FORMAT")
	@:include("SDL2/SDL_mixer.h")
	extern public static var MIX_DEFAULT_FORMAT:Int;

	@:native("MIX_MAX_VOLUME")
	@:include("SDL2/SDL_mixer.h")
	extern public static var MIX_MAX_VOLUME:Int;

	@:native("Mix_Init")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_Init(flags:MIX_InitFlags):Int;

	@:native("Mix_Quit")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_Quit():Void;

	@:native("Mix_OpenAudio")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_OpenAudio(freq:Int, format:UInt16, channels:Int, chunksize:Int):Int;

	@:native("Mix_OpenAudioDevice")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_OpenAudioDevice(freq:Int, format:UInt16, channels:Int, chunksize:Int, device:ConstCharStar, flags:Int):Int;

	@:native("Mix_QuerySpec")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_QuerySpec(outfreq:Pointer<Int>, format:Pointer<UInt16>, channels:Pointer<Int>):Int;

	@:native("Mix_AllocateChannels")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_AllocateChannels(numchannels:Int):Void;

	// @:native("Mix_LoadWAV_RW")
	// @:include("SDL2/SDL_mixer.h")
	// extern public static function Mix_LoadWAV_RW(src:SDL_RWops, freesrc:Int, out_chunk:Pointer<Mix_Chunk>):Mix_Chunk;

	@:native("Mix_LoadMUS")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_LoadMUS(file:ConstCharStar):Pointer<Mix_Music>;

	@:native("Mix_LoadWAV")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_LoadWAV(file:ConstCharStar):Pointer<Mix_Chunk>;

	@:native("Mix_FreeChunk")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_FreeChunk(chunk:Pointer<Mix_Chunk>):Void;

	@:native("Mix_FreeMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_FreeMusic(music:Pointer<Mix_Music>):Void;

	@:native("Mix_PlayMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_PlayMusic(music:Pointer<Mix_Music>, loops:Int):Int;

	@:native("Mix_GetError")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_GetError():ConstCharStar;

	@:native("Mix_Volume")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_Volume(channel:Int, volume:Int):Void;

	@:native("Mix_VolumeChunk")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_VolumeChunk(chunk:Pointer<Mix_Chunk>, volume:Int):Void;

	@:native("Mix_VolumeMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_VolumeMusic(volume:Int):Void;

	@:native("Mix_HaltChannel")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_HaltChannel(channel:Int):Void;

	@:native("Mix_HaltMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_HaltMusic():Void;

	@:native("Mix_PlayChannel")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_PlayChannel(channel:Int, chunk:Pointer<Mix_Chunk>, loops:Int):Int;

	@:native("Mix_PlayingMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_PlayingMusic():Int;

	@:native("Mix_PausedMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_PausedMusic():Int;

	@:native("Mix_PauseMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_PauseMusic():Void;

	@:native("Mix_ResumeMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_ResumeMusic():Void;

	@:native("Mix_RewindMusic")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_RewindMusic():Void;

	@:native("Mix_SetMusicPosition")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_SetMusicPosition(position:Float):Int;

	@:native("Mix_CloseAudio")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_CloseAudio():Void;

	@:native("Mix_Pause")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_Pause(channel:Int):Void;

	@:native("Mix_Resume")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_Resume(channel:Int):Void;

	@:native("Mix_HookMusicFinished")
	@:include("SDL2/SDL_mixer.h")
	extern public static function Mix_HookMusicFinished(onFinishedFunc:Void->Pointer<CppVoid>):Void;
}
