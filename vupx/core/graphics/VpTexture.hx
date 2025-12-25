package vupx.core.graphics;

/**
 * a OpenGL texture loaded from a file or SDL surface or directly pixels data
 * 
 * Author: Slushi
 */
class VpTexture {
    /**
     * The OpenGL texture ID
     */
    public var id:UInt32;
    
    /**
     * The width of the texture
     */
    public var width:Int;

    /**
     * The height of the texture
     */
    public var height:Int;

    /**
     * The path of the texture file
     */
    public var path:String;
    
    
    /**
     * Is the texture loaded
     */
    private var _loaded:Bool = false;

    /**
     * Is this a cached texture?
     */
    public var isCached:Bool = false;
    
    /**
     * Create a new texture
     */
    public function new() {
        id = 0;
        width = 0;
        height = 0;
        path = "";
    }
    
    /**
     * create a texture from a file
     */
    public static function loadFromFile(filepath:String):Null<VpTexture> {
        VupxDebug.log('Loading texture: ${filepath}', DEBUG);

        if (filepath == "" || filepath == null) {
            VupxDebug.log('Texture path is empty', ERROR);
            return null;
        }
        else if(!FileSystem.exists(filepath)) {
            VupxDebug.log('Texture file does not exist: ${filepath}', ERROR);
            return null;
        }
        
        var surface:Pointer<SDL_Surface> = SDL_Image.IMG_Load(filepath);
        if (surface == null) {
            VupxDebug.log('Failed to create SDL surface for texture [${filepath}]: ${SDL_Image.IMG_GetError()}', ERROR);
            return null;
        }
        
        var texture = new VpTexture();
        texture.isCached = true;
        texture.path = filepath;
        texture.width = surface.ptr.w;
        texture.height = surface.ptr.h;
        
        GL.glGenTextures(1, Pointer.addressOf(texture.id));
        GL.glBindTexture(GL.GL_TEXTURE_2D, texture.id);
        
        // Determine the GL format based on BytesPerPixel of the SDL surface
        var format:Int = GL.GL_RGBA;
        if (untyped __cpp__("surface->ptr->format->BytesPerPixel") == 3) {
            format = GL.GL_RGB;
        }
        else if (untyped __cpp__("surface->ptr->format->BytesPerPixel") == 4) {
            format = GL.GL_RGBA;
        }
        else {
            VupxDebug.log('Unsupported image format for texture [${filepath}] (BytesPerPixel: ' + untyped __cpp__("surface->ptr->format->BytesPerPixel") + ')', ERROR);
            SDL_SurfaceClass.SDL_FreeSurface(surface);
            return null;
        }
        
        GL.glTexImage2D(
            GL.GL_TEXTURE_2D,
            0,
            format,
            texture.width,
            texture.height,
            0,
            format,
            GL.GL_UNSIGNED_BYTE,
            surface.ptr.pixels
        );
        
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
        
        SDL_SurfaceClass.SDL_FreeSurface(surface);
        
        texture._loaded = true;
        
        VupxDebug.log('Texture loaded: ${filepath} (${texture.width}x${texture.height})', DEBUG);
        
        return texture;
    }

    /**
     * create a texture from a SDL surface (converted to RGBA8888)
     */
    public static function loadFromSDLSurfaceFixed(surface:Pointer<SDL_Surface>):Null<VpTexture> {
        if (surface == null) {
            VupxDebug.log('Cant load from null SDL surface', ERROR);
            return null;
        }
        
        var convertedSurface:Pointer<SDL_Surface> = SDL_SurfaceClass.SDL_ConvertSurfaceFormat(
            surface,
            SDL_PixelsClass.SDL_PIXELFORMAT_RGBA32,
            0
        );
        
        if (convertedSurface == null) {
            VupxDebug.log('Failed to convert SDL surface format: ' + SDL_Error.SDL_GetError(), ERROR);
            return null;
        }
        
        var texture = new VpTexture();
        texture.path = "";
        texture.isCached = false;
        texture.width = convertedSurface.ptr.w;
        texture.height = convertedSurface.ptr.h;
        
        GL.glGenTextures(1, Pointer.addressOf(texture.id));
        GL.glBindTexture(GL.GL_TEXTURE_2D, texture.id);
        
        GL.glTexImage2D(
            GL.GL_TEXTURE_2D,
            0,
            GL.GL_RGBA,
            texture.width,
            texture.height,
            0,
            GL.GL_RGBA,
            GL.GL_UNSIGNED_BYTE,
            convertedSurface.ptr.pixels
        );
        
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
        
        SDL_SurfaceClass.SDL_FreeSurface(convertedSurface);
        
        texture._loaded = true;
        
        VupxDebug.log('Texture loaded from SDL surface (${texture.width}x${texture.height})', DEBUG);
        
        return texture;
    }

    /**
     * Create a texture with a color and size
     */
    public static function createGraphic(width:Null<Int> = 1, height:Null<Int> = 1, color:Null<VpColor> = VpColor.WHITE):Null<VpTexture> {
        var surface:Pointer<SDL_Surface> = SDL_SurfaceClass.SDL_CreateRGBSurface(
            0,
            width ?? 1,
            height ?? 1,
            32,
            0x00FF0000,
            0x0000FF00,
            0x000000FF,
            0xFF000000 
        );

        if (surface == null) {
            VupxDebug.log("Failed to create SDL surface: " + SDL_Image.IMG_GetError(), ERROR);
            return null;
        }

        var mappedColor:UInt32 = SDL_PixelsClass.SDL_MapRGBA(
            surface.ptr.format,
            color.red ?? 255, // R
            color.green ?? 255, // G
            color.blue ?? 255, // B
            color.alpha ?? 255 // A
        );

        SDL_SurfaceClass.SDL_FillRect(surface, null, mappedColor);

        var texture = new VpTexture();
        texture.path = "";
        texture.isCached = false;
        texture.width = surface.ptr.w;
        texture.height = surface.ptr.h;
        
        GL.glGenTextures(1, Pointer.addressOf(texture.id));
        GL.glBindTexture(GL.GL_TEXTURE_2D, texture.id);
        
        var format:Int = GL.GL_RGBA;
        // surface2 really not exists in this Haxe code, but yes in C++ code from HXCPP..
        if (untyped __cpp__("surface2->ptr->format->BytesPerPixel") == 3) {
            format = GL.GL_RGB;
        }
        
        GL.glTexImage2D(
            GL.GL_TEXTURE_2D,
            0,
            format,
            texture.width,
            texture.height,
            0,
            format,
            GL.GL_UNSIGNED_BYTE,
            surface.ptr.pixels
        );
        
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
        
        SDL_SurfaceClass.SDL_FreeSurface(surface);
        
        texture._loaded = true;

        VupxDebug.log('Texture created (${texture.width}x${texture.height})', DEBUG);
        
        return texture;
    }

    /**
     * Create or update a texture from raw pixel data (RGBA)
     */
    public static function createFromPixelData(width:Int, height:Int, pixels:Pointer<UInt8>):Null<VpTexture> {
        if (pixels == null) {
            VupxDebug.log('Pixel data is null', ERROR);
            return null;
        }

        var texture = new VpTexture();
        texture.path = "";
        texture.width = width;
        texture.height = height;
        
        GL.glGenTextures(1, Pointer.addressOf(texture.id));
        GL.glBindTexture(GL.GL_TEXTURE_2D, texture.id);
        
        GL.glTexImage2D(
            GL.GL_TEXTURE_2D,
            0,
            GL.GL_RGBA,
            texture.width,
            texture.height,
            0,
            GL.GL_RGBA,
            GL.GL_UNSIGNED_BYTE,
            cast pixels
        );
        
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
        
        texture._loaded = true;
        
        VupxDebug.log('Texture created from pixel data (${texture.width}x${texture.height})', DEBUG);
        
        return texture;
    }

    /**
     * Update texture with new pixel data (RGBA)
     */
    public function updatePixelData(pixels:Pointer<UInt8>):Void {
        if (!_loaded) {
            VupxDebug.log("Cannot update unloaded texture", ERROR);
            return;
        }

        if (pixels == null) {
            VupxDebug.log('Pixel data is null', ERROR);
            return;
        }
        
        GL.glBindTexture(GL.GL_TEXTURE_2D, id);
        GL.glTexSubImage2D(
            GL.GL_TEXTURE_2D,
            0,
            0, 0,
            width,
            height,
            GL.GL_RGBA,
            GL.GL_UNSIGNED_BYTE,
            cast pixels
        );
    }

    // En VpTexture.hx
    public static function createFromRawData(width:Int, height:Int, data:Pointer<UInt8>, channels:Int = 4):Null<VpTexture> {
        var texture = new VpTexture();
        texture.width = width;
        texture.height = height;
        
        var format = switch(channels) {
            case 1: GL.GL_RED;
            case 3: GL.GL_RGB;
            case 4: GL.GL_RGBA;
            default: GL.GL_RGBA;
        };
        
        GL.glGenTextures(1, Pointer.addressOf(texture.id));
        GL.glBindTexture(GL.GL_TEXTURE_2D, texture.id);
        GL.glTexImage2D(GL.GL_TEXTURE_2D, 0, format, width, height, 0, 
                    format, GL.GL_UNSIGNED_BYTE, cast data);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
        GL.glBindTexture(GL.GL_TEXTURE_2D, 0);
        
        texture._loaded = true;
        return texture;
    }
    
    /**
     * Bind the texture
     * @param slot 
     */
    public function bind(slot:Null<Int> = 0):Void {
        if (!_loaded) {
            VupxDebug.log("Trying to bind unloaded texture", ERROR);
            return;
        }

        if (slot == null) {
            return;
        }
        
        GL.glActiveTexture(GL.GL_TEXTURE0 + slot);
        GL.glBindTexture(GL.GL_TEXTURE_2D, id);
    }

    /**
      * Bind the texture without checking if it's loaded
      * 
      * Use this with caution, it will crash the engine if the texture is really not loaded
      * 
      * @param slot
     */
    public function unsafeFind(slot:Null<Int> = 0):Void {
        GL.glActiveTexture(GL.GL_TEXTURE0 + slot);
        GL.glBindTexture(GL.GL_TEXTURE_2D, id);
    }
    
    /**
     * Unbind the texture
     */
    public static function unbind():Void {
        GL.glBindTexture(GL.GL_TEXTURE_2D, 0);
    }
    
    /**
     * Free the texture from memory
     */
    public function destroy():Void {
        if (_loaded && id != 0) {
            GL.glDeleteTextures(1, Pointer.addressOf(id));
            _loaded = false;
            id = 0;
            VupxDebug.log('Texture destroyed: ${path}', DEBUG);
        }
    }

    /**
     * Free the texture from memory without checking if it's loaded
     * 
     * Use this with caution, it will crash the engine if the texture is really not loaded
     */
    public function unsafeDestroy():Void {
        if (id != 0) {
            GL.glDeleteTextures(1, Pointer.addressOf(id));
            _loaded = false;
            id = 0;
        }
    }
    
    /**
     * Check if the texture is loaded
     */
    public function isLoaded():Bool {
        return _loaded;
    }
}