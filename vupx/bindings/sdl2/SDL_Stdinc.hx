package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_stdinc.h")
extern class SDL_Stdinc {
    @:native("SDL_memset")
    @:include("SDL2/SDL_stdinc.h")
	extern public static function SDL_memset(dst:Pointer<Void>, c:Int, len:SizeT):Pointer<Void>;

	@:native("SDL_memcpy")
	@:include("SDL2/SDL_stdinc.h")
	extern public static function SDL_memcpy(dst:Pointer<Void>, src:Pointer<Void>, len:SizeT):Pointer<Void>;

	@:native("SDL_malloc")
	@:include("SDL2/SDL_stdinc.h")
	extern public static function SDL_malloc(size:SizeT):Pointer<Void>;

	@:native("SDL_zero")
	@:include("SDL2/SDL_stdinc.h")
	extern public static function SDL_zero(dst:Pointer<Void>):Pointer<Void>;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_stdinc.h")
@:native("SDL_bool")
extern enum SDL_Bool {
	@:native("SDL_FALSE")
	SDL_FALSE;
	@:native("SDL_TRUE")
	SDL_TRUE;
}