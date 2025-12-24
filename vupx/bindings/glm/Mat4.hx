package vupx.bindings.glm;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("glm/glm.hpp")
@:native("glm::mat4")
@:unreflective
@:structAccess
extern class Mat4 {
    @:native("glm::mat4")
    extern public function new(value:Float);

    // CAMBIADO: Usar función estática con untyped __cpp__
    @:native("Mat4_mul")
    extern public static inline function mul(left:Mat4, right:Mat4):Mat4 {
        return untyped __cpp__("{0} * {1}", left, right);
    }

    extern public inline function mulVec4(v:Vec4):Vec4 {
        return untyped __cpp__("(*this) * {0}", v);
    }

    extern public inline function mulVec3(v:Vec3):Vec3 {
        return untyped __cpp__("glm::vec3((*this) * glm::vec4({0}, 1.0f))", v);
    }

    extern public inline function col(index:Int):Vec4 {
        return untyped __cpp__("(*this)[{0}]", index);
    }
}