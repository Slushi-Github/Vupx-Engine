package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:native("SDL_BlitMap")
@:include("SDL2/SDL_surface.h")
extern class SDL_BlitMap {
    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_surface.h")
@:native("SDL_Surface")
extern class SDL_Surface {
    @:include("SDL2/SDL_surface.h")
	public var flags:UInt32;
    @:include("SDL2/SDL_surface.h")
    public var format:Pointer<SDL_Pixels.SDL_PixelFormat>;
    @:include("SDL2/SDL_surface.h")
    public var w:UInt32;
    @:include("SDL2/SDL_surface.h")
    public var h:UInt32;
    @:include("SDL2/SDL_surface.h")
    public var pitch:UInt32;
    @:include("SDL2/SDL_surface.h")
    public var pixels:Pointer<CppVoid>;
    @:include("SDL2/SDL_surface.h")
    public var userdata:Pointer<Void>;
    @:include("SDL2/SDL_surface.h")
    public var locked:UInt32;
    @:include("SDL2/SDL_surface.h")
    public var lock_data:Pointer<Void>;
    @:include("SDL2/SDL_surface.h")
    public var clip_rect:SDL_Rect;
    @:include("SDL2/SDL_surface.h")
    public var map:Pointer<SDL_BlitMap>;
    @:include("SDL2/SDL_surface.h")
    public var refcount:Int;

    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_surface.h")
extern class SDL_SurfaceClass {
    @:native("SDL_FreeSurface")
    @:include("SDL2/SDL_surface.h")
    extern public static function SDL_FreeSurface(surface:Pointer<SDL_Surface>):Int;

    @:native("SDL_CreateRGBSurface")
    @:include("SDL2/SDL_surface.h")
    extern public static function SDL_CreateRGBSurface(flags:UInt32, width:UInt32, height:UInt32, depth:UInt32, Rmask:UInt32, Gmask:UInt32, Bmask:UInt32, Amask:UInt32):Pointer<SDL_Surface>;

    @:native("SDL_FillRect")
    @:include("SDL2/SDL_surface.h")
    extern public static function SDL_FillRect(dst:Pointer<SDL_Surface>, rect:Pointer<SDL_Rect>, color:UInt32):Int;

    @:native("SDL_ConvertSurfaceFormat")
    @:include("SDL2/SDL_surface.h")
    extern public static function SDL_ConvertSurfaceFormat(surface:Pointer<SDL_Surface>, pixel_format:UInt32, flags:UInt32):Pointer<SDL_Surface>;
}