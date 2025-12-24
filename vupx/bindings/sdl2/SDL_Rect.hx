package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_rect.h")
@:native("SDL_Point")
extern class SDL_Point {
    public var x:Int;
    public var y:Int;

    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_rect.h")
@:native("SDL_FPoint")
extern class SDL_FPoint {
    public var x:Float;
    public var y:Float;

    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_rect.h")
@:native("SDL_Rect")
extern class SDL_Rect {
    public var x:Int;
    public var y:Int;
    public var w:Int;
    public var h:Int;
    
    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_rect.h")
@:native("SDL_FRect")
extern class SDL_FRect {
    public var x:Float;
    public var y:Float;
    public var w:Float;
    public var h:Float;

    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}