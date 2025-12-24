package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_timer.h")
extern class SDL_Timer {
	@:native("SDL_GetTicks")
    @:include("SDL2/SDL_timer.h")
    extern public static function SDL_GetTicks():UInt32;

	@:native("SDL_Delay")
    @:include("SDL2/SDL_timer.h")
    extern public static function SDL_Delay(ms:UInt32):Void;
}