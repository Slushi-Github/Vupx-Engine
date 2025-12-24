package vupx.bindings.glm;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("glm/glm.hpp")
@:native("glm::vec3")
@:structAccess
@:unreflective  // NUEVO: Evita conversión automática a Dynamic
extern class Vec3 {
    public var x:Float;
    public var y:Float;
    public var z:Float;

    @:native("glm::vec3")
    public function new(x:Float, y:Float, z:Float);

    extern public inline function add(b:Vec3):Vec3 {
        return untyped __cpp__("(*this) + {0}", b);
    }

    extern public inline function sub(b:Vec3):Vec3 {
        return untyped __cpp__("(*this) - {0}", b);
    }

    extern public inline function mulScalar(scalar:Float):Vec3 {
        return untyped __cpp__("(*this) * {0}", scalar);
    }

    extern public inline function mulVector(b:Vec3):Vec3 {
        return untyped __cpp__("(*this) * {0}", b);
    }

    extern public inline function divScalar(scalar:Float):Vec3 {
        return untyped __cpp__("(*this) / {0}", scalar);
    }

    extern public inline function get(index:Int):Float {
        return untyped __cpp__("(*this)[{0}]", index);
    }
    
    extern public inline function addAssign(b:Vec3):Vec3 {
        return untyped __cpp__("(*this) += {0}", b);
    }

    extern public inline function subAssign(b:Vec3):Vec3 {
        return untyped __cpp__("(*this) -= {0}", b);
    }
}