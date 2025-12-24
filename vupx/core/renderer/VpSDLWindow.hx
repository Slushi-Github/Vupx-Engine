package vupx.core.renderer;

/**
 * The SDL window for the engine
 * 
 * Author: slushi
 */
class VpSDLWindow {
    /**
     * The main SDL window
     */
    public static var mainWindow(get, never):Pointer<SDL_Window>;

    private static var _window:Pointer<SDL_Window>;

    /**
     * Create the SDL window
     */
    public static function createWindow():Void {
        _window = SDL_Video.SDL_CreateWindow("Vupx Engine SDL Window", SDL_Video.SDL_WINDOWPOS_CENTERED, SDL_Video.SDL_WINDOWPOS_CENTERED, 1280, 720, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN | SDL_WINDOW_FULLSCREEN);
        if (mainWindow == null) {
            throw "Failed to create SDL window. SDL error: " + SDL_Error.SDL_GetError();
        }
        VupxDebug.log("SDL window created", INFO);
    }

    /**
     * Destroy the SDL window
     */
    public static function quit():Void {
        if (mainWindow != null) {
            SDL_Video.SDL_DestroyWindow(mainWindow);
        }
    }

    private static function get_mainWindow():Pointer<SDL_Window> {
        return _window;
    }
}