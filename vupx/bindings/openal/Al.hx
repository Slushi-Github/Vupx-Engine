package vupx.bindings.openal;

import vupx.bindings.openal.Alc;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/alc.h")
@:native("ALchar")
extern typedef ALchar = Char;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/al.h")
@:native("ALenum")
extern typedef ALenum = Int;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/al.h")
@:native("ALint")
extern typedef ALint = Int;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/al.h")
@:native("ALboolean")
extern typedef ALboolean = Char;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/al.h")
@:native("ALfloat")
extern typedef ALfloat = Float32;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/al.h")
@:native("ALuint")
extern typedef ALuint = UInt;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/al.h")
@:native("ALsizei")
extern typedef ALsizei = Int;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/al.h")
@:native("ALvoid")
extern typedef ALvoid = Void;

////////////////////////////////

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("AL/al.h")
extern class Al {
    @:native("AL_POSITION")
    @:include("AL/al.h")
    extern public static var AL_POSITION(default, null):Int;

    @:native("AL_ORIENTATION")
    @:include("AL/al.h")
    extern public static var AL_ORIENTATION(default, null):Int;

    @:native("AL_NO_ERROR")
    @:include("AL/al.h")
    extern public static var AL_NO_ERROR(default, null):Int;

    ////////////////////////////////

    @:native("AL_FORMAT_MONO16")
    @:include("AL/al.h")    
    extern public static var AL_FORMAT_MONO16(default, null):Int;

    @:native("AL_FORMAT_STEREO16")
    @:include("AL/al.h")    
    extern public static var AL_FORMAT_STEREO16(default, null):Int;

    ////////////////////////////////

    @:native("AL_TRUE")
    @:include("AL/al.h")
    extern public static var AL_TRUE(default, null):Int;

    @:native("AL_FALSE")
    @:include("AL/al.h")
    extern public static var AL_FALSE(default, null):Int;

    @:native("AL_GAIN")
    @:include("AL/al.h")
    extern public static var AL_GAIN(default, null):Int;

    @:native("AL_LOOPING")
    @:include("AL/al.h")
    extern public static var AL_LOOPING(default, null):Int;

    @:native("AL_LOOPING")
    @:include("AL/al.h")
    extern public static var AL_SOURCE_STATE(default, null):Int;

    @:native("AL_BUFFER")
    @:include("AL/al.h")
    extern public static var AL_BUFFER(default, null):Int;

    @:native("AL_PITCH")
    @:include("AL/al.h")
    extern public static var AL_PITCH(default, null):Int;

    @:native("AL_PLAYING")
    @:include("AL/al.h")
    extern public static var AL_PLAYING(default, null):Int;

    @:native("AL_PAUSED")
    @:include("AL/al.h")
    extern public static var AL_PAUSED(default, null):Int;

    @:native("AL_STOPPED")
    @:include("AL/al.h")
    extern public static var AL_STOPPED(default, null):Int;

    @:native("AL_SEC_OFFSET")
    @:include("AL/al.h")
    extern public static var AL_SEC_OFFSET(default, null):Int;

    @:native("AL_VELOCITY")
    @:include("AL/al.h")
    extern public static var AL_VELOCITY(default, null):Int;

    @:native("AL_EXTENSIONS")
    @:include("AL/al.h")
    extern public static var AL_EXTENSIONS(default, null):Int;

    @:native("AL_BUFFERS_PROCESSED")
    @:include("AL/al.h")
    extern public static var AL_BUFFERS_PROCESSED(default, null):Int;
    ////////////////////////////////

    @:native("alGetError")
    @:include("AL/al.h")
    extern public static function alGetError():ALenum;

    @:native("alListener3f")
    @:include("AL/al.h")
    extern public static function alListener3f(param:ALenum, x:ALfloat, y:ALfloat, z:ALfloat):Void;

    @:native("alGenBuffers")
    @:include("AL/al.h")
    extern public static function alGenBuffers(n:Int, buffers:Pointer<ALuint>):Void;

    @:native("alDeleteBuffers")
    @:include("AL/al.h")
    extern public static function alDeleteBuffers(n:Int, buffers:Pointer<ALuint>):Void;

    @:native("alBufferData")
    @:include("AL/al.h")
    extern public static function alBufferData(buffer:ALuint, format:ALenum, data:Int, size:ALsizei, freq:ALint):Void;

    @:native("alGenSources")
    @:include("AL/al.h")
    extern public static function alGenSources(n:Int, sources:Pointer<ALuint>):Void;

    @:native("alDeleteSources")
    @:include("AL/al.h")
    extern public static function alDeleteSources(n:Int, sources:Pointer<ALuint>):Void;

    @:native("alSourcei")
    @:include("AL/al.h")
    extern public static function alSourcei(source:ALuint, param:ALenum, value:ALint):Void;

    @:native("alSourcef")
    @:include("AL/al.h")
    extern public static function alSourcef(source:ALuint, param:ALenum, value:ALfloat):Void;

    @:native("alSourcePlay")
    @:include("AL/al.h")
    extern public static function alSourcePlay(source:ALuint):Void;

    @:native("alSourcePause")
    @:include("AL/al.h")
    extern public static function alSourcePause(source:ALuint):Void;

    @:native("alSourceStop")
    @:include("AL/al.h")
    extern public static function alSourceStop(source:ALuint):Void;

    @:native("alGetSourcei")
    @:include("AL/al.h")
    extern public static function alGetSourcei(source:ALuint, param:ALenum, value:Pointer<Int>):Void;

    @:native("alListenerfv")
    @:include("AL/al.h")
    extern public static function alListenerfv(param:ALenum, value:Pointer<Float32>):Void;

    @:native("alGetSourcef")
    @:include("AL/al.h")
    extern public static function alGetSourcef(source:ALuint, param:ALenum, value:Pointer<ALfloat>):Void;

    @:native("alGetString")
    @:include("AL/al.h")
    extern public static function alGetString(param:ALenum):ConstStar<ALCchar>;

    @:native("alSourceQueueBuffers")
    @:include("AL/al.h")
    extern public static function alSourceQueueBuffers(source:ALuint, nb:Int, buffers:ConstPointer<ALuint>):Void;

    @:native("alSourceUnqueueBuffers")
    @:include("AL/al.h")
    extern public static function alSourceUnqueueBuffers(source:ALuint, nb:Int, buffers:Pointer<ALuint>):Void;
}