package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_error.h")
extern class SDL_Error {
	@:native("SDL_GetError")
    @:include("SDL2/SDL_error.h")
	extern public static function SDL_GetError():ConstCharStar;
}   