package vupx.core.renderer;

/**
 * Class for setting up and initializing OpenGL and Glad
 * 
 * Author: Slushi
 */
@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("glad/glad.h")
@:cppInclude("glad/glad.h")
class VpGLRendererSetup {
    /**
     * The SDL OpenGL context
     */
    public static var glContext(get, never):SDL_GLContext;

    private static var _glContext:SDL_GLContext;

    /**
     * Sets up SDL OpenGL attributes
     */
    public static function setupSDLOpenGL():Void {
        SDL_Video.SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
        SDL_Video.SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
        SDL_Video.SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
        SDL_Video.SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_Video.SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
        SDL_Video.SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8);
        VupxDebug.log("SDL OpenGL attributes configured for OpenGL 4.3", INFO);
    }

    /**
     * Creates the SDL OpenGL context
     */
    public static function applyOpenGLToSDLWindow():Void {
        VupxDebug.log("Creating SDL OpenGL context...", INFO);
        if (VpSDLWindow.mainWindow == null) {
            throw "There is no SDL window to create OpenGL context";
        }
        _glContext = SDL_Video.SDL_GL_CreateContext(VpSDLWindow.mainWindow);
        if (_glContext == null) {
            throw "Failed to create SDL OpenGL context: " + SDL_Error.SDL_GetError();
        }
        VupxDebug.log("SDL OpenGL context created", INFO);

        if (SDL_Video.SDL_GL_SetSwapInterval(1) < 0) {
            VupxDebug.log("Unable to set VSync!: " + SDL_Error.SDL_GetError(), ERROR);
        } else {
            VupxDebug.log("VSync enabled (60 FPS)", INFO);
        }
    }

    /**
     * Initializes GLAD and sets up OpenGL attributes
     */ 
    public static function initGLADAndOpenGLAttributes():Void {
        VupxDebug.log("Initializing GLAD...", INFO);
        try {
            if (untyped __cpp__("gladLoadGLLoader((GLADloadproc)SDL_GL_GetProcAddress)") == 0) {
                throw "Failed to initialize GLAD";
            }
            VupxDebug.log("GLAD initialized", INFO);
        }
        catch (e) {
            throw "Failed to initialize GLAD: " + e;
        }

        GL.glViewport(0, 0, 1280, 720);

        GL.glEnable(GL.GL_DEPTH_TEST);
        GL.glDepthFunc(GL.GL_LESS);

        GL.glDepthMask(true);
        GL.glDepthRange(0.0, 1.0);

        GL.glEnable(GL.GL_BLEND);
        GL.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA);

        VupxDebug.log("OpenGL initialized!", INFO);
    }

    /**
     * Destroys the OpenGL context
     */
    public static function quit():Void {
        VupxDebug.log("Destroying OpenGL context...", INFO);
        SDL_Video.SDL_GL_DeleteContext(glContext);
        VupxDebug.log("OpenGL context destroyed!", INFO);
    }

    private static function get_glContext():SDL_GLContext {
        return _glContext;
    }
}