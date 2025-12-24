package vupx.core.graphics;

/**
 * Manages texture loading and sharing
 * Ensures textures are only loaded once and properly destroyed
 * 
 * author: Slushi
 */
class VpTextureCache {
    /**
     * Map of file path to texture
     */
    private static var cache:StringMap<VpTexture> = new StringMap<VpTexture>();
    
    /**
     * Reference count for each texture
     */
    private static var refCounts:StringMap<Int> = new StringMap<Int>();
    
    /**
     * Load a texture from file (or return cached version)
     */
    public static function get(path:String):VpTexture {
        if (path == null || path == "") return null;
        
        // Check if already loaded
        if (cache.exists(path)) {
            // Increment reference count
            var count = refCounts.get(path);
            refCounts.set(path, count + 1);
            
            return cache.get(path);
        }
        
        // Load new texture
        var texture = VpTexture.loadFromFile(path);
        if (texture != null) {
            cache.set(path, texture);
            refCounts.set(path, 1);
        }
        
        return texture;
    }
    
    /**
     * Create a texture from color (these are NOT cached since they're dynamic)
     */
    public static function createGraphic(width:Int, height:Int, color:VpColor):VpTexture {
        return VpTexture.createGraphic(width, height, color);
    }
    
    /**
     * Release a texture reference
     * Only destroys the texture when all references are released
     */
    public static function release(texture:VpTexture):Void {
        if (texture == null) return;
        
        // Find the path for this texture
        var path:String = null;
        for (key in cache.keys()) {
            if (cache.get(key) == texture) {
                path = key;
                break;
            }
        }
        
        if (path == null) {
            // This texture wasn't cached (probably a graphic)
            // Safe to destroy directly
            texture.destroy();
            return;
        }
        
        // Decrement reference count
        var count = refCounts.get(path);
        count--;
        
        if (count <= 0) {
            // No more references, destroy the texture
            cache.remove(path);
            refCounts.remove(path);
            texture.destroy();
        } else {
            // Still has references, just update count
            refCounts.set(path, count);
        }
    }
    
    /**
     * Clear all cached textures (call when exiting game)
     */
    public static function clear():Void {
        for (texture in cache) {
            if (texture != null) texture.destroy();
        }
        
        cache = new StringMap<VpTexture>();
        refCounts = new StringMap<Int>();
    }
    
    /**
     * Get debug info
     */
    public static function getDebugInfo():String {
        var count = 0;
        for (_ in cache.keys()) count++;
        
        return 'Cached textures: ${count}';
    }
    
    /**
     * Force clear all textures (useful when changing states)
     * This ignores reference counting - use carefully!
     */
    public static function forceClear():Void {
        clear();
    }
}