package vupx.core.renderer;

/**
 * Class for rendering the screen and frame buffers
 * 
 * Author: Slushi
 */
class VpGLRenderer {
    /**
     * Background color
     */
    public static var backgroundColor:VpColor = VpColor.BLACK;

    /**
     * Update the OpenGL renderer
     */
    public static function updateRenderer():Void {
        GL.glClearColor(backgroundColor.red ?? 0.0, backgroundColor.green ?? 0.0, backgroundColor.blue ?? 0.0, backgroundColor.alpha ?? 1.0);
        GL.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);

        VpModulesManager.callModulesFunction(GENERAL_BEFORE_MAIN_RENDER);

        if (Vupx.currentState != null)
            Vupx.currentState.render();

        VpModulesManager.callModulesFunction(GENERAL_AFTER_MAIN_RENDER);

        SDL_Video.SDL_GL_SwapWindow(VpSDLWindow.mainWindow);
    }

    ///////////////////////////////////////
}