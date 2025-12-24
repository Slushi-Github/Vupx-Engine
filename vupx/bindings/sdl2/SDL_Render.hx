package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_RendererFlags")
extern enum abstract SDL_RendererFlags(Int) to Int {
    @:native("SDL_RENDERER_SOFTWARE")
    var SDL_RENDERER_SOFTWARE;
    @:native("SDL_RENDERER_ACCELERATED")
    var SDL_RENDERER_ACCELERATED;
    @:native("SDL_RENDERER_PRESENTVSYNC")
    var SDL_RENDERER_PRESENTVSYNC;
    @:native("SDL_RENDERER_TARGETTEXTURE")
    var SDL_RENDERER_TARGETTEXTURE;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_RendererInfo")
extern typedef SDL_RendererInfo = {
    @:native("name")
    var name:ConstCharStar;
    @:native("flags")
    var flags:UInt32;
    @:native("num_texture_formats")
    var num_texture_formats:UInt32;
    @:native("texture_formats")
    var texture_formats:UInt32;
    @:native("max_texture_width")
    var max_texture_width:Int;
    @:native("max_texture_height")
	var max_texture_height:Int;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_TextureAccess")
extern enum SDL_TextureAccess {
    @:native("SDL_TEXTUREACCESS_STATIC")
    SDL_TEXTUREACCESS_STATIC;
    @:native("SDL_TEXTUREACCESS_STREAMING")
    SDL_TEXTUREACCESS_STREAMING;
    @:native("SDL_TEXTUREACCESS_TARGET")
    SDL_TEXTUREACCESS_TARGET;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_TextureModulate")
extern enum SDL_TextureModulate {
    @:native("SDL_TEXTUREMODULATE_NONE")
    SDL_TEXTUREMODULATE_NONE;
    @:native("SDL_TEXTUREMODULATE_COLOR")
    SDL_TEXTUREMODULATE_COLOR;
    @:native("SDL_TEXTUREMODULATE_ALPHA")
    SDL_TEXTUREMODULATE_ALPHA;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_RendererFlip")
extern enum SDL_RendererFlip {
    @:native("SDL_FLIP_NONE")
    SDL_FLIP_NONE;
    @:native("SDL_FLIP_HORIZONTAL")
    SDL_FLIP_HORIZONTAL;
    @:native("SDL_FLIP_VERTICAL")
    SDL_FLIP_VERTICAL;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_Texture")
extern class SDL_Texture {
    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_Renderer")
extern class SDL_Renderer {
    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_Vertex")
@:valueType
extern class SDL_Vertex {
    public var position:SDL_Rect.SDL_FPoint;
    public var color:SDL_Color;
    public var tex_coord:SDL_Rect.SDL_FPoint;

    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
@:native("SDL_ScaleMode")
extern enum SDL_ScaleMode {
    @:native("SDL_ScaleModeNearest")
    SDL_ScaleModeNearest;
    @:native("SDL_ScaleModeLinear")
    SDL_ScaleModeLinear;
    @:native("SDL_ScaleModeBest")
    SDL_ScaleModeBest;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_render.h")
extern class SDL_Render {
	@:native("SDL_GetNumRenderDrivers")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetNumRenderDrivers():Int;

    @:native("SDL_GetRenderDriverInfo")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetRenderDriverInfo(index:Int, info:Pointer<SDL_RendererInfo>):Int;
    
    @:native("SDL_CreateWindowAndRenderer")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_CreateWindowAndRenderer(width:Int, height:Int, window_flags:UInt32, window:Pointer<SDL_Window>, renderer:Pointer<SDL_Renderer>):Int;

    @:native("SDL_CreateRenderer")
    @:include("SDL2/SDL_render.h")
	extern public static function SDL_CreateRenderer(window:Pointer<SDL_Window>, index:Int, flags:SDL_RendererFlags):Pointer<SDL_Renderer>;

    @:native("SDL_CreateSoftwareRenderer")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_CreateSoftwareRenderer(surface:Pointer<SDL_Surface>):Pointer<SDL_Renderer>;

    @:native("SDL_GetRenderer")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetRenderer(window:Pointer<SDL_Window>):Pointer<SDL_Renderer>;

    @:native("SDL_GetRendererInfo")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetRendererInfo(renderer:Pointer<SDL_Renderer>, info:Pointer<SDL_RendererInfo>):Int;
    
	@:native("SDL_GetRendererOutputSize")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetRendererOutputSize(renderer:Pointer<SDL_Renderer>, w:Pointer<Int>, h:Pointer<Int>):Int;

	@:native("SDL_CreateTexture")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_CreateTexture(renderer:Pointer<SDL_Renderer>, format:UInt32, access:SDL_TextureAccess, w:Int, h:Int):Pointer<SDL_Texture>;

	@:native("SDL_CreateTextureFromSurface")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_CreateTextureFromSurface(renderer:Pointer<SDL_Renderer>, surface:Pointer<SDL_Surface>):Pointer<SDL_Texture>;

    @:native("SDL_QueryTexture")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_QueryTexture(texture:Pointer<SDL_Texture>, format:Pointer<UInt32>, access:Pointer<Int>, w:Pointer<Int>, h:Pointer<Int>):Int;

	@:native("SDL_SetTextureColorMod")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_SetTextureColorMod(texture:Pointer<SDL_Texture>, r:UInt8, g:UInt8, b:UInt8):Int;

    @:native("SDL_GetTextureColorMod")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetTextureColorMod(texture:Pointer<SDL_Texture>, r:Pointer<UInt8>, g:Pointer<UInt8>, b:Pointer<UInt8>):Int;

    @:native("SDL_SetTextureAlphaMod")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_SetTextureAlphaMod(texture:Pointer<SDL_Texture>, alpha:UInt8):Int;

    @:native("SDL_GetTextureAlphaMod")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetTextureAlphaMod(texture:Pointer<SDL_Texture>, alpha:Pointer<UInt8>):Int;

    @:native("SDL_SetTextureBlendMode")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_SetTextureBlendMode(texture:Pointer<SDL_Texture>, blendMode:SDL_BlendMode):Int;

    @:native("SDL_SetRenderDrawBlendMode")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_SetRenderDrawBlendMode(renderer:Pointer<SDL_Renderer>, blendMode:SDL_BlendMode):Int;

    @:native("SDL_GetTextureBlendMode")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetTextureBlendMode(texture:Pointer<SDL_Texture>, blendMode:Pointer<SDL_BlendMode>):Int;

	@:native("SDL_UpdateTexture")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_UpdateTexture(texture:Pointer<SDL_Texture>, rect:RawConstPointer<SDL_Rect>, pixels:ConstPointer<Void>, pitch:Int):Int;

	@:native("SDL_UpdateYUVTexture")
    @:include("SDL2/SDL_render.h")
	extern public static function SDL_UpdateYUVTexture(texture:Pointer<SDL_Texture>, rect:RawConstPointer<SDL_Rect>, Yplane:RawConstPointer<UInt8>, Ypitch:Int,
		Uplane:RawConstPointer<UInt8>, Upitch:Int, Vplane:RawConstPointer<UInt8>, Vpitch:Int):Int;

    @:native("SDL_LockTexture")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_LockTexture(texture:Pointer<SDL_Texture>, rect:RawConstPointer<SDL_Rect>, pixels:Pointer<Void>, pitch:Pointer<Int>):Int;

    @:native("SDL_UnlockTexture")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_UnlockTexture(texture:Pointer<SDL_Texture>):Void;

    @:native("SDL_RenderTargetSupported")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_RenderTargetSupported(renderer:Pointer<SDL_Renderer>):Int;

    @:native("SDL_SetRenderTarget")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_SetRenderTarget(renderer:Pointer<SDL_Renderer>, texture:Pointer<SDL_Texture>):Int;

    @:native("SDL_GetRenderTarget")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetRenderTarget(renderer:Pointer<SDL_Renderer>):Pointer<SDL_Texture>;

	@:native("SDL_RenderSetLogicalSize")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_RenderSetLogicalSize(renderer:Pointer<SDL_Renderer>, w:Int, h:Int):Int;

	@:native("SDL_RenderGetLogicalSize")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_RenderGetLogicalSize(renderer:Pointer<SDL_Renderer>, w:Pointer<Int>, h:Pointer<Int>):Int;

	@:native("SDL_RenderSetIntegerScale")
    @:include("SDL2/SDL_render.h")
	extern public static function SDL_RenderSetIntegerScale(renderer:Pointer<SDL_Renderer>, enable:SDL_Bool):Int;

	@:native("SDL_DestroyTexture")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_DestroyTexture(texture:Pointer<SDL_Texture>):Void;

	@:native("SDL_DestroyRenderer")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_DestroyRenderer(renderer:Pointer<SDL_Renderer>):Void;

	@:native("SDL_RenderCopy")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_RenderCopy(renderer:Pointer<SDL_Renderer>, texture:Pointer<SDL_Texture>, srcRect:RawConstPointer<SDL_Rect>, dstRect:Pointer<SDL_Rect>):Int;

    @:native("SDL_RenderCopyEx")
    @:include("SDL2/SDL_render.h")
	extern public static function SDL_RenderCopyEx(renderer:Pointer<SDL_Renderer>, texture:Pointer<SDL_Texture>, srcRect:RawConstPointer<SDL_Rect>, dstRect:Pointer<SDL_Rect>,
		angle:Float, center:Pointer<SDL_Rect.SDL_Point>, flip:SDL_RendererFlip):Int;

    @:native("SDL_RenderCopyExF")
    @:include("SDL2/SDL_render.h")
	extern public static function SDL_RenderCopyExF(renderer:Pointer<SDL_Renderer>, texture:Pointer<SDL_Texture>, srcRect:RawConstPointer<SDL_Rect>, dstRect:Pointer<SDL_Rect.SDL_FRect>,
		angle:Float, center:Pointer<SDL_Rect.SDL_FPoint>, flip:SDL_RendererFlip):Int;

	@:native("SDL_RenderPresent")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_RenderPresent(renderer:Pointer<SDL_Renderer>):Int;

    @:native("SDL_RenderClear")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_RenderClear(renderer:Pointer<SDL_Renderer>):Int;

	@:native("SDL_SetRenderDrawColor")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_SetRenderDrawColor(renderer:Pointer<SDL_Renderer>, r:UInt8, g:UInt8, b:UInt8, a:UInt8):Int;

    @:native("SDL_RenderFillRect")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_RenderFillRect(renderer:Pointer<SDL_Renderer>, rect:RawConstPointer<SDL_Rect>):Int;

    @:native("SDL_RenderGeometry")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_RenderGeometry(renderer:Pointer<SDL_Renderer>, texture:Pointer<SDL_Texture>, vertices:Pointer<SDL_Vertex>, num_vertices:Int, indices:Int, num_indices:Int):Int;

    @:native("SDL_SetTextureScaleMode")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_SetTextureScaleMode(texture:Pointer<SDL_Texture>, scaleMode:SDL_ScaleMode):Int;

    @:native("SDL_GetTextureScaleMode")
    @:include("SDL2/SDL_render.h")
    extern public static function SDL_GetTextureScaleMode(texture:Pointer<SDL_Texture>, blendMode:Pointer<SDL_ScaleMode>):Int;
}
