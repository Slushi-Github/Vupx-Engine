package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_blendmode.h")
@:native("SDL_BlendMode")
extern enum abstract SDL_BlendMode(Int) to Int {
    @:native("SDL_BLENDMODE_NONE")
    var SDL_BLENDMODE_NONE;
    @:native("SDL_BLENDMODE_BLEND")
    var SDL_BLENDMODE_BLEND;
    @:native("SDL_BLENDMODE_ADD")
    var SDL_BLENDMODE_ADD;
    @:native("SDL_BLENDMODE_MOD")
    var SDL_BLENDMODE_MOD;
    @:native("SDL_BLENDMODE_INVALID")
    var SDL_BLENDMODE_INVALID;
}
