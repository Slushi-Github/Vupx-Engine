package vupx.backend.managers;

/**
 * A class to manage SDL_Image
 * 
 * Author: Slushi
 */
class VpSDLImageManager {
    
    /**
     * Initializes SDL_Image
     */
    public static function init():Void {
        if (SDL_Image.IMG_Init(IMG_INIT_PNG) < 0) {
            throw "Failed to initialize SDL_Image: " + SDL_Image.IMG_GetError();
        }

        VupxDebug.log("SDL_Image initialized!", INFO);
    }

    /**
     * Quits SDL_Image
     */
    public static function quit():Void {
        SDL_Image.IMG_Quit();
        VupxDebug.log("SDL_Image quit!", INFO);
    }
}