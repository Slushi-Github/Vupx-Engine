package vupx.bindings.sdl2;

/**
 * Random fact: Did you know that the SDL2 bindings 
 * for this engine were originally created for 
 * Leafy Engine, the engine developed for the Nintendo Wii U?
 * Here, only the way of making bindings was changed, that is, 
 * switching from using Reflaxe/C++ to what HXCPP uses (Ptr -> Pointer for example).
 */
@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("SDL2/SDL.h")
extern class SDL {
    @:native("SDL_INIT_TIMER")
	@:include("SDL2/SDL.h")
	extern public static var SDL_INIT_TIMER:UInt32;

	@:native("SDL_INIT_AUDIO")
	@:include("SDL2/SDL.h")
	extern public static var SDL_INIT_AUDIO:UInt32;

	@:native("SDL_INIT_VIDEO")
	@:include("SDL2/SDL.h")
    extern public static var SDL_INIT_VIDEO:UInt32;

	@:native("SDL_INIT_JOYSTICK")
	@:include("SDL2/SDL.h")
    extern public static var SDL_INIT_JOYSTICK:UInt32;

	@:native("SDL_INIT_GAMECONTROLLER")
	@:include("SDL2/SDL.h")
    extern public static var SDL_INIT_GAMECONTROLLER:UInt32;

    @:native("SDL_INIT_HAPTIC")
	@:include("SDL2/SDL.h")
    extern public static var SDL_INIT_HAPTIC:UInt32;
    
	@:native("SDL_INIT_EVENTS")
	@:include("SDL2/SDL.h")
    extern public static var SDL_INIT_EVENTS:UInt32;
    
	@:native("SDL_INIT_SENSOR")
	@:include("SDL2/SDL.h")
    extern public static var SDL_INIT_SENSOR:UInt32;

	@:native("SDL_INIT_NOPARACHUTE")
	@:include("SDL2/SDL.h")
    extern public static var SDL_INIT_NOPARACHUTE:UInt32;
    
	@:native("SDL_INIT_EVERYTHING")
	@:include("SDL2/SDL.h")
    extern public static var SDL_INIT_EVERYTHING:UInt32;

    ////////////////////////////////////////////

    @:native("SDL_Init")
    extern public static function SDL_Init(flags:UInt32):Int;

    @:native("SDL_Quit")
    extern public static function SDL_Quit():Void;

	@:native("SDL_QuitSubSystem")
	extern public static function SDL_QuitSubSystem(flags:UInt32):Void;
}