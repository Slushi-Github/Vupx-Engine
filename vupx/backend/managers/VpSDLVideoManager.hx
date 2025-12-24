package vupx.backend.managers;

/**
 * A class to manage SDL_Video
 * 
 * Author: Slushi
 */
class VpSDLVideoManager {

    /**
     *  Initializes SDL_Video
     */
    public static function init():Void {
        if (SDL.SDL_Init(SDL.SDL_INIT_VIDEO) != 0) {
            throw "Failed to initialize SDL_Video: " + SDL_Error.SDL_GetError();
        }

        VupxDebug.log("SDL_Video initialized!", INFO);
    }

    /**
     * Quits SDL_Video
     */
    public static function quit():Void {
        SDL_Video.SDL_VideoQuit();
        VupxDebug.log("SDL_Video quit!", INFO);
    }
}