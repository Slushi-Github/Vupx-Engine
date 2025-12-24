package vupx.bindings.glm;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("glm/glm.hpp")
@:native("glm::vec2")
@:structAccess
@:unreflective 
extern class Vec2 {
    extern public var x:Float;
    extern public var y:Float;

    @:native("glm::vec2")
    extern public function new(x:Float, y:Float);

    extern public inline function add(b:Vec2):Vec2 {
        return untyped __cpp__("(*this) + {0}", b);
    }

    extern public inline function sub(b:Vec2):Vec2 {
        return untyped __cpp__("(*this) - {0}", b);
    }

    extern public inline function mul(scalar:Float):Vec2 {
        return untyped __cpp__("(*this) * {0}", scalar);
    }
    
    extern public inline function get(index:Int):Float {
        return untyped __cpp__("(*this)[{0}]", index);
    }
}