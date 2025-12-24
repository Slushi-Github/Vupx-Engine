package vupx.core.graphics;

import haxe.io.Bytes;

/**
 * Creates a new font atlas and stores it in the cache
 * 
 * @see ``vupx.objects.VpText``
 * 
 * Author: Slushi
 */
class VpTextFont {
    /**
     * Font texture
     */
    public var atlasTexture:VpTexture;

    /**
     * Font data
     */
    public var charData:Pointer<CppVoid>;

    /**
     * Font atlas size
     */
    public var atlasSize:Int;

    /**
     * Font size
     */
    public var fontSize:Float;

    /**
     * First character of the font
     */
    public var firstChar:Int = 32;  // Space

    /**
     * Number of characters in the font
     */
    public var numChars:Int = 96;   // 96 ASCII characters
    
    /**
     * Fonts cache
     */
    private static var fontCache:Map<String, VpTextFont> = new Map();
    
    /**
     * Get a cached font, or create a new one
     * 
     * @param fontPath Path to the font file
     * @param fontSize Size of the font
     */
    public static function get(fontPath:String, fontSize:Float):VpTextFont {
        if (!FileSystem.exists(fontPath)) {
            VupxDebug.log("Font file not found: " + fontPath, ERROR);
            return null;
        }
        else if (fontSize <= 0) {
            VupxDebug.log("Invalid font size: " + fontSize, ERROR);
            return null;
        }

        var key = fontPath + "_" + Std.int(fontSize);
        
        if (fontCache.exists(key)) {
            return fontCache.get(key);
        }
        
        var font = new VpTextFont(fontPath, fontSize);
        if (font != null && font.atlasTexture != null) {
            fontCache.set(key, font);
        }
        
        return font;
    }
    
    /**
     * Create a new font
     * 
     * @param fontPath Path to the font file
     * @param fontSize Size of the font
     */
    private function new(fontPath:String, fontSize:Float) {
        this.fontSize = fontSize;
        this.atlasSize = 512;
        
        var fontBytes:Bytes = null;
        try {
            fontBytes = File.getBytes(fontPath);
        } catch (e:Dynamic) {
            VupxDebug.log("Failed to read font file: " + fontPath, ERROR);
            return;
        }
        
        var atlasBuffer:Pointer<UInt8> = untyped __cpp__("(unsigned char*)malloc({0} * {0})", atlasSize);
        charData = Stdlib.malloc(Stdlib.sizeof(Stbtt_bakedchar) * 96);
        
        var result = Stb_TrueType.BakeFontBitmap(
            cast Pointer.ofArray(fontBytes.getData()),
            0,
            fontSize,
            atlasBuffer,
            atlasSize,
            atlasSize,
            firstChar,
            numChars,
            charData
        );
        
        if (result <= 0) {
            VupxDebug.log("Failed to bake font", ERROR);
            Stdlib.free(atlasBuffer);
            Stdlib.free(charData);
            return;
        }
        
        atlasTexture = VpTexture.createFromRawData(atlasSize, atlasSize, atlasBuffer, 1);
        Stdlib.free(atlasBuffer);
        
        VupxDebug.log('Font loaded: ${fontPath} at ${fontSize}px', DEBUG);
    }
    
    /**
     * Destroy the font
     */
    public function destroy():Void {
        if (atlasTexture != null) atlasTexture.destroy();
        if (charData != null) Stdlib.free(charData);
    }
}