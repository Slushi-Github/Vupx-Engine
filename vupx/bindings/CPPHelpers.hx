package vupx.bindings;

typedef CArray<T> = RawPointer<T>;

typedef CConstArray<T> = RawConstPointer<T>;

@:include("string.h")
extern class CPPHelpers {
    /**
     * Converts a value to a pointer
     * @param value The value to convert
     * @return Pointer Returns a pointer to the value
     */
    public static inline function toPointer<T>(value:T):Pointer<T> {
        return Pointer.addressOf(value);
    }

    /**
     * Frees a pointer
     * @param value The object to free
     */
    public static inline function free<T>(value:Pointer<Any>):Void {
        return Stdlib.free(value);
    }

    /**
     * Checks if a object is null, directly in C++ code
     * @param value The object to check
     * @return Bool Returns true if the object is null
     */
    public static inline function isNull(value:Any):Bool {
        return untyped __cpp__("{0} == NULL", value);
    }

    /**
     * Checks if a pointer is null, directly in C++ code
     * @param value The pointer to check
     * @return Bool Returns true if the object is null
     */
    public static inline function isPtrNull(value:Any):Bool {
        return untyped __cpp__("{0} == nullptr", value);
    }

    @:native("memset")
    extern public static function memset(s:Pointer<CppVoid>, c:Int, n:SizeT):Int;

    // CASTS ////////////////////////////

    // public static inline function castToInt(value:Any):Int {
    //     return untyped __cpp__("(int){0}", value);
    // }

    // public static inline function castToFloat(value:Any):Float {
    //     return untyped __cpp__("(float){0}", value);
    // }

    // public static inline function castToBool(value:Any):Bool {
    //     return untyped __cpp__("(bool){0}", value);
    // }

    // public static inline function castToVoidPointer(value:Any):Pointer<CppVoid> {
    //     return untyped __cpp__("(void*){0}", value);
    // }

    // public static inline function castToIntPointer(value:Any):Pointer<Int> {
    //     return untyped __cpp__("(int*){0}", value);
    // }

    // public static inline function castToFloatPointer(value:Any):Pointer<Float> {
    //     return untyped __cpp__("(float*){0}", value);
    // }

    // public static inline function castToBoolPointer(value:Any):Pointer<Bool> {
    //     return untyped __cpp__("(bool*){0}", value);
    // }

    // public static inline function castToUInt8Pointer(value:Any):Pointer<UInt8> {
    //     return untyped __cpp__("(uint8_t*){0}", value);
    // }

    // public static inline function castToUInt32Pointer(value:Any):Pointer<UInt32> {
    //     return untyped __cpp__("(uint32_t*){0}", value);
    // }

    // public static inline function castToUInt64Pointer(value:Any):Pointer<UInt64> {
    //     return untyped __cpp__("(uint64_t*){0}", value);
    // }
}