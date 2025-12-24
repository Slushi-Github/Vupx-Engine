package vupx.bindings.glm;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("glm/glm.hpp")
@:native("glm::vec4")
@:structAccess
@:unreflective
extern class Vec4 {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var w:Float;

    @:native("glm::vec4")
    public function new(x:Float, y:Float, z:Float, w:Float);

    extern public inline function add(b:Vec4):Vec4 {
        return untyped __cpp__("(*this) + {0}", b);
    }

    extern public inline function sub(b:Vec4):Vec4 {
        return untyped __cpp__("(*this) - {0}", b);
    }

    extern public inline function mul(scalar:Float):Vec4 {
        return untyped __cpp__("(*this) * {0}", scalar);
    }

    extern public inline function get(index:Int):Float {
        return untyped __cpp__("(*this)[{0}]", index);
    }

    extern public inline function mulVector(b:Vec4):Vec4 {
        return untyped __cpp__("(*this) * {0}", b);
    }
}