package vupx.bindings.stb_truetype;

@:buildXml('
<files id="haxe">
    <compilerflag value="-DSTBTT_STATIC"/>
    <compilerflag value="-DSTB_TRUETYPE_IMPLEMENTATION"/>
</files>
')
@:include("stb_truetype/include/stb_truetype.h")
extern class Stb_TrueType {
    @:native("stbtt_BakeFontBitmap")
    static function BakeFontBitmap(data:Pointer<CppVoid>, offset:Int, pixelHeight:Float,
                                    pixels:Pointer<UInt8>, pw:Int, ph:Int,
                                    firstChar:Int, numChars:Int, chardata:Pointer<CppVoid>):Int;
    
    @:native("stbtt_GetBakedQuad")
    static function GetBakedQuad(chardata:Pointer<CppVoid>, pw:Int, ph:Int,
                                    charIndex:Int, xpos:Pointer<Float32>, ypos:Pointer<Float32>,
                                    q:Pointer<Stbtt_aligned_quad>, openglFillrule:Int):Void;
}

@:include("stb_truetype/include/stb_truetype.h")
@:native("stbtt_aligned_quad")
@:structAccess
extern class Stbtt_aligned_quad {
    public var x0:Float;
    public var y0:Float;
    public var x1:Float;
    public var y1:Float;
    public var s0:Float;
    public var t0:Float;
    public var s1:Float;
    public var t1:Float;
}

@:include("stb_truetype/include/stb_truetype.h")
@:native("stbtt_bakedchar")
@:structAccess
extern class Stbtt_bakedchar {
    public var x0:Float;
    public var y0:Float;
    public var x1:Float;
    public var y1:Float;
    public var xoff:Float;
    public var yoff:Float;
    public var xadvance:Float;
}