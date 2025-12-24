package vupx.bindings.glm;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("glm/glm.hpp")
@:include("glm/gtc/matrix_transform.hpp")
@:include("glm/gtc/type_ptr.hpp")
@:include("glm/gtx/euler_angles.hpp")
@:unreflective
extern class GLM {
    @:native("glm::radians")
    public static function radians(degrees:Float):Float;

    @:native("glm::degrees")
    public static function degrees(radians:Float):Float;

    @:native("glm::translate")
    public static function translate(m:Mat4, v:Vec3):Mat4;

    // CORREGIDO: Función estática para rotate
    public static inline function rotate(m:Mat4, angle:Float, axis:Vec3):Mat4 {
        return untyped __cpp__("glm::rotate({0}, (float){1}, {2})", m, angle, axis);
    }

    @:native("glm::scale")
    public static function scale(m:Mat4, v:Vec3):Mat4;

    @:native("glm::ortho")
    public static function ortho(left:Float, right:Float, bottom:Float, top:Float, zNear:Float, zFar:Float):Mat4;

    @:native("glm::perspective")
    public static function perspective(fovy:Float, aspect:Float, near:Float, far:Float):Mat4;

    @:native("glm::lookAt")
    public static function lookAt(eye:Vec3, center:Vec3, up:Vec3):Mat4;

    @:native("glm::inverse")
    public static function inverse(m:Mat4):Mat4;

    @:native("glm::value_ptr")
    public static function value_ptr(m:Mat4):Pointer<Float32>;
    
    @:native("glm::value_ptr")
    public static function value_ptr_vec3(v:Vec3):Pointer<Float32>;

    @:native("glm::normalize")
    public static function normalize(v:Vec3):Vec3;

    @:native("glm::cross")
    public static function cross(x:Vec3, y:Vec3):Vec3;

    @:native("glm::dot")
    public static function dot(x:Vec3, y:Vec3):Float;

    @:native("glm::length")
    public static function length(v:Vec3):Float;

    @:native("glm::distance")
    public static function distance(p0:Vec3, p1:Vec3):Float;

    @:native("glm::mix")
    public static function mix(x:Vec3, y:Vec3, a:Float):Vec3;
    
    @:native("glm::clamp")
    public static function clamp(x:Float, minVal:Float, maxVal:Float):Float;
    
    @:native("glm::eulerAngleXYZ")
    public static function eulerAngleXYZ(angleX:Float, angleY:Float, angleZ:Float):Mat4;
    
    @:native("glm::eulerAngleYXZ")
    public static function eulerAngleYXZ(angleY:Float, angleX:Float, angleZ:Float):Mat4;
    
    @:native("glm::mat4(1.0f)")
    public static inline function mat4Identity():Mat4 {
        return untyped __cpp__("glm::mat4(1.0f)");
    }
    
    @:native("GLM_transformPoint")
    public static inline function transformPoint(matrix:Mat4, point:Vec3):Vec3 {
        return untyped __cpp__("glm::vec3({0} * glm::vec4({1}, 1.0f))", matrix, point);
    }
    
    @:native("GLM_transformVector")
    public static inline function transformVector(matrix:Mat4, vector:Vec3):Vec3 {
        return untyped __cpp__("glm::vec3({0} * glm::vec4({1}, 0.0f))", matrix, vector);
    }
}