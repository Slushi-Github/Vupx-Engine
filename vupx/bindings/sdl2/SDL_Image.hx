package vupx.bindings.sdl2;


@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_image.h")
@:native("IMG_InitFlags")
extern enum abstract IMG_InitFlags(Int) to Int {
    @:native("IMG_INIT_PNG")
    var IMG_INIT_PNG;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_image.h")
extern class SDL_Image {
    @:native("IMG_Init")
    @:include("SDL2/SDL_image.h")
    extern public static function IMG_Init(flags:IMG_InitFlags):Int;

    @:native("IMG_Quit")
    @:include("SDL2/SDL_image.h")
    extern public static function IMG_Quit():Void;

    @:native("IMG_Load")
    @:include("SDL2/SDL_image.h")
    extern public static function IMG_Load(file:ConstCharStar):Pointer<SDL_Surface>;

	@:native("IMG_GetError")
    @:include("SDL2/SDL_image.h")
    extern public static function IMG_GetError():ConstCharStar;
}