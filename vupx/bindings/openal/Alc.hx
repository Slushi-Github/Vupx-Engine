package vupx.bindings.openal;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
@:native("ALCdevice")
extern class ALCdevice {
    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
@:native("ALCcontext")
extern class ALCcontext {
    @:haxe.warning("-WExternWithExpr")
    public function new() {}
}

////////////////////////////////

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
@:native("ALCchar")
extern typedef ALCchar = Char;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
@:native("ALCchar")
extern typedef ALCenum = Int;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
@:native("ALCchar")
extern typedef ALCint = Int;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
@:native("ALCchar")
extern typedef ALCboolean = Char;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
@:native("ALCfloat")
extern typedef ALCfloat = Float;

////////////////////////////////

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
extern class Alc {

    @:native("ALC_DEVICE_SPECIFIER")
    @:include("AL/alc.h")
    extern public static var ALC_DEVICE_SPECIFIER(default, null):Int;

    @:native("alcOpenDevice")
    @:include("AL/alc.h")
    extern public static function alcOpenDevice(devicename:Pointer<ALCchar>):Pointer<ALCdevice>;

    @:native("alcCloseDevice")
    @:include("AL/alc.h")
    extern public static function alcCloseDevice(device:Pointer<ALCdevice>):Int;

    @:native("alcGetError")
    @:include("AL/alc.h")
    extern public static function alcGetError(device:Pointer<ALCdevice>):ALCenum;

    @:native("alcCreateContext")
    @:include("AL/alc.h")
    extern public static function alcCreateContext(device:Pointer<ALCdevice>, attrlist:Pointer<Int>):Pointer<ALCcontext>;

    @:native("alcDestroyContext")
    @:include("AL/alc.h")
    extern public static function alcDestroyContext(context:Pointer<ALCcontext>):Void;

    @:native("alcMakeContextCurrent")
    @:include("AL/alc.h")
    extern public static function alcMakeContextCurrent(context:Pointer<ALCcontext>):ALCboolean;

    @:native("alcGetString")
    @:include("AL/alc.h")
    extern public static function alcGetString(device:Pointer<ALCdevice>, param:ALCenum):Pointer<ALCchar>;
}