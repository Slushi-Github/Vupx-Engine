package vupx.bindings.sdl2;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_video.h")
@:native("SDL_WindowFlags")
extern enum abstract SDL_WindowFlags(Int) to Int {
    @:native("SDL_WINDOW_FULLSCREEN") var SDL_WINDOW_FULLSCREEN;
    @:native("SDL_WINDOW_OPENGL") var SDL_WINDOW_OPENGL;
    @:native("SDL_WINDOW_SHOWN") var SDL_WINDOW_SHOWN;
    @:native("SDL_WINDOW_HIDDEN") var SDL_WINDOW_HIDDEN;
    @:native("SDL_WINDOW_BORDERLESS") var SDL_WINDOW_BORDERLESS;
    @:native("SDL_WINDOW_RESIZABLE") var SDL_WINDOW_RESIZABLE;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_video.h")
@:native("SDL_GLattr")
extern enum abstract SDL_GLattr(Int) to Int {
    @:native("SDL_GL_RED_SIZE") var SDL_GL_RED_SIZE;
    @:native("SDL_GL_GREEN_SIZE") var SDL_GL_GREEN_SIZE;
    @:native("SDL_GL_BLUE_SIZE") var SDL_GL_BLUE_SIZE;
    @:native("SDL_GL_ALPHA_SIZE") var SDL_GL_ALPHA_SIZE;
    @:native("SDL_GL_BUFFER_SIZE") var SDL_GL_BUFFER_SIZE;
    @:native("SDL_GL_DOUBLEBUFFER") var SDL_GL_DOUBLEBUFFER;
    @:native("SDL_GL_DEPTH_SIZE") var SDL_GL_DEPTH_SIZE;
    @:native("SDL_GL_STENCIL_SIZE") var SDL_GL_STENCIL_SIZE;
    @:native("SDL_GL_ACCUM_RED_SIZE") var SDL_GL_ACCUM_RED_SIZE;
    @:native("SDL_GL_ACCUM_GREEN_SIZE") var SDL_GL_ACCUM_GREEN_SIZE;
    @:native("SDL_GL_ACCUM_BLUE_SIZE") var SDL_GL_ACCUM_BLUE_SIZE;
    @:native("SDL_GL_ACCUM_ALPHA_SIZE") var SDL_GL_ACCUM_ALPHA_SIZE;
    @:native("SDL_GL_STEREO") var SDL_GL_STEREO;
    @:native("SDL_GL_MULTISAMPLEBUFFERS") var SDL_GL_MULTISAMPLEBUFFERS;
    @:native("SDL_GL_MULTISAMPLESAMPLES") var SDL_GL_MULTISAMPLESAMPLES;
    @:native("SDL_GL_ACCELERATED_VISUAL") var SDL_GL_ACCELERATED_VISUAL;
    @:native("SDL_GL_RETAINED_BACKING") var SDL_GL_RETAINED_BACKING;
    @:native("SDL_GL_CONTEXT_MAJOR_VERSION") var SDL_GL_CONTEXT_MAJOR_VERSION;
    @:native("SDL_GL_CONTEXT_MINOR_VERSION") var SDL_GL_CONTEXT_MINOR_VERSION;
    @:native("SDL_GL_CONTEXT_EGL") var SDL_GL_CONTEXT_EGL;
    @:native("SDL_GL_CONTEXT_FLAGS") var SDL_GL_CONTEXT_FLAGS;
    @:native("SDL_GL_CONTEXT_PROFILE_MASK") var SDL_GL_CONTEXT_PROFILE_MASK;
    @:native("SDL_GL_SHARE_WITH_CURRENT_CONTEXT") var SDL_GL_SHARE_WITH_CURRENT_CONTEXT;
    @:native("SDL_GL_FRAMEBUFFER_SRGB_CAPABLE") var SDL_GL_FRAMEBUFFER_SRGB_CAPABLE;
    @:native("SDL_GL_CONTEXT_RELEASE_BEHAVIOR") var SDL_GL_CONTEXT_RELEASE_BEHAVIOR;
    @:native("SDL_GL_CONTEXT_RESET_NOTIFICATION") var SDL_GL_CONTEXT_RESET_NOTIFICATION;
    @:native("SDL_GL_CONTEXT_NO_ERROR") var SDL_GL_CONTEXT_NO_ERROR;
    @:native("SDL_GL_FLOATBUFFERS") var SDL_GL_FLOATBUFFERS;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_video.h")
@:native("SDL_GLprofile")
extern enum abstract SDL_GLprofile(Int) to Int {
    @:native("SDL_GL_CONTEXT_PROFILE_CORE") var SDL_GL_CONTEXT_PROFILE_CORE;
    @:native("SDL_GL_CONTEXT_PROFILE_COMPATIBILITY") var SDL_GL_CONTEXT_PROFILE_COMPATIBILITY;
    @:native("SDL_GL_CONTEXT_PROFILE_ES") var SDL_GL_CONTEXT_PROFILE_ES;
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_video.h")
extern typedef SDL_GLContext = Pointer<Void>;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_video.h")
@:native("SDL_Window")
extern class SDL_Window {
    @:haxe.warning("-WExternWithExpr")
	public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_video.h")
@:native("SDL_DisplayMode")
@:structAccess
extern class SDL_DisplayMode {
    var w:Int;
    var h:Int;
    var refresh_rate:Int;
    var format:UInt32;

    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL_video.h")
extern class SDL_Video {
    @:native("SDL_WINDOWPOS_CENTERED")
    extern public static var SDL_WINDOWPOS_CENTERED:Int;

	@:native("SDL_WINDOWPOS_UNDEFINED")
    extern public static var SDL_WINDOWPOS_UNDEFINED:Int;

    @:native("SDL_CreateWindow")
	extern public static function SDL_CreateWindow(title:ConstCharStar, x:Int, y:Int, w:Int, h:Int, flags:Int):Pointer<SDL_Window>;

    @:native("SDL_DestroyWindow")
    extern public static function SDL_DestroyWindow(window:Pointer<SDL_Window>):Void;

    @:native("SDL_VideoQuit")
    extern public static function SDL_VideoQuit():Void;

    @:native("SDL_GL_SetAttribute")
    extern public static function SDL_GL_SetAttribute(attr:SDL_GLattr, value:Int):Void;

    @:native("SDL_GL_CreateContext")
    extern public static function SDL_GL_CreateContext(window:Pointer<SDL_Window>):SDL_GLContext;

    @:native("SDL_GL_DeleteContext")
    extern public static function SDL_GL_DeleteContext(context:SDL_GLContext):Void;

    @:native("SDL_GL_GetProcAddress")
    extern public static function SDL_GL_GetProcAddress(proc:ConstCharStar):Void;

    @:native("SDL_GetDesktopDisplayMode")
    extern public static function SDL_GetDesktopDisplayMode(displayIndex:Int, mode:Pointer<SDL_DisplayMode>):Int;

    @:native("SDL_GL_SwapWindow")
    extern public static function SDL_GL_SwapWindow(window:Pointer<SDL_Window>):Void;

    @:native("SDL_GL_SetSwapInterval")
    extern public static function SDL_GL_SetSwapInterval(interval:Int):Int;
} 