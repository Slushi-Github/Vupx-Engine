package vupx.bindings.opengl;

typedef GLADloadproc = Callable<ConstCharStar -> RawPointer<CppVoid>>;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("glad/glad.h")
extern class Glad {
    @:native("gladLoadGLLoader")
    extern public static function gladLoadGLLoader(proc:GLADloadproc):Int;
}