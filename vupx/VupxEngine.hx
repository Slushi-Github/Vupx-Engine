package vupx;

#if !HX_NX
#error "This library is only for the Nintendo Switch target!"
#end                                                                                                                        

import switchLib.runtime.devices.Console;

/**
 * TODO:
 * - Add Applet mode support When a solution is found 
 * for the crash caused by HXCPP's GC when closing the program.
 */
/**
 * VupxEngine class is the main class of the engine, it is used to start the engine
 * and initialize the entire modules of the engine
 * 
 * Author: Slushi
 */
class VupxEngine {
    /**
     * The version of the engine
     */
    public static final VERSION:String = "1.0.0";

    /**
     * Function to be called when the engine exits
     */
    public static var onEngineExit:Null<Void->Void> = null;

    /**
     * Function to be called when the engine is initialized pre start the first state
     */
    public static var onEngineInitialized:Null<Void->Void> = null;

    /**
     * Function to be called when the engine crashes
     */
    public static var onEngineCrashed:Null<Dynamic->Void> = VupxCrashHandler.onUncaughtError;

    /**
     * The name of the project using the engine
     */
    public static var projectName(get, never):Null<String>;

    /**
     * Is the engine running?
     */
    private static var _isRunning:Bool = false;

    /**
     * The initial state
     */
    private static var _initialState:Null<VpState> = null;

    /**
     * The game name
     */
    private static var _gameProjectName:Null<String> = null;

    /**
     * Initialize the engine
     * 
     * Example usage:
     * ```haxe
     * VupxEngine.init("My Game", new MyInitialState(), false);
     * ```
     * 
     * @param gameName The name of the game using the engine (Used for logging and game directories on the SDMC)
     * @param initialState The initial state
     * @param skipSplash Skip the splash screen on startup
     */
    public static function init(gameName:Null<String> = "", initialState:Null<VpState> = null, ?skipSplash:Bool = false):Void {
        try {
            VupxCrashHandler.initHXCPPCrashHandler();

            #if !VUPX_BYPASS_APPLET_BLOCK
            // Check if we are running in applet mode, this is not supported for now...
            if (VpSwitch.isRunningAsApplet()) {
                /**
                 * We can't use the Console API after inializing OpenGL
                 * so we need to initialize it here
                 */

                Console.consoleInit(null);

                Pad.padConfigureInput(1, HidNpadStyleTag.HidNpadStyleSet_NpadStandard);
                var pad:PadState = new PadState();
                Pad.padInitializeDefault(Pointer.addressOf(pad));

                Sys.println("\x1b[38;5;196mApplet mode\033[0m detected! This is not supported in Vupx Engine for now, sorry!");
                Sys.println("Please run the project from a launched game (Press the R button on the right Joy-Con while starting a game from the HOME menu).");
                Sys.println("Press the + button on the right Joy-Con to exit and wait a possible crash.");

                Console.consoleUpdate(null);

                // Block with a loop!
                while (Applet.appletMainLoop()) {
                    Pad.padUpdate(Pointer.addressOf(pad));
                    var kDown:Int = Pad.padGetButtonsDown(Pointer.addressOf(pad)).toInt();
                    if (kDown & HidNpadButton.HidNpadButton_Plus != 0) {
                        break;
                    }
                }

                Console.consoleExit(null);
                return;
            }
            #else
            VupxDebug.log("APPLET MODE BLOCK CHECK SKIPPED! THIS IS NOT RECOMMENDED!", WARNING);
            #end

            // Set the game name
            if (gameName == null || gameName == "") {
                VupxDebug.log("No game name provided, using default name: \"Vupx Engine Project\"", WARNING);
                _gameProjectName = gameName = "Vupx Engine Project";
            }
            else {
                _gameProjectName = gameName;
            }

            // Initialize the logger
            VupxDebug.initLogger();

            VupxDebug.printToLogFileDirectly("Initializing Vupx Engine v" + VupxEngine.VERSION + "...\n");
            VupxDebug.printToLogFileDirectly("------------------------------------\n");

            VupxDebug.printToLogFileDirectly("Project name: " + projectName + " -> " + VpStorage.getGameSDMCPath() + " \n");

            #if debug
            VupxDebug.printToLogFileDirectly("Haxe debug mode enabled! More logs will be printed!\n");
            #end

            if (initialState == null) {
                throw "The initial state cannot be null!";
            }

            // Set the initial state
            if (!skipSplash) {
                _initialState = new VupxIntro(initialState);
            }
            else {
                _initialState = initialState;
            }

            // Create the game folder
            VpStorage.createGameFoldersInSDMC();
            // Initialize RomFS
            VpStorage.initRomFS();

            // Initialize modules
            VpSDLMixerManager.init();
            VpSDLVideoManager.init();
            VpSDLImageManager.init();
            VpGLRendererSetup.setupSDLOpenGL();
            VpSDLWindow.createWindow();
            VpGLRendererSetup.applyOpenGLToSDLWindow();
            VpGLRendererSetup.initGLADAndOpenGLAttributes();
            VpTimer.init();
            Vupx.init();
            /////////////////////////

            VupxDebug.printToLogFileDirectly("Vupx Engine v" + VupxEngine.VERSION + " has started\n");

            VpModulesManager.callModulesFunction(INIT);

            if (onEngineInitialized != null) {
                try {
                    onEngineInitialized();
                }
                catch (e) {
                    VupxDebug.log("Failed to call onEngineInitialized: " + e, ERROR);
                }
            }

            VupxDebug.printToLogFileDirectly("-- Initializing first state [" + Type.getClassName(Type.getClass(_initialState)) + "]... ------------\n");

            VpStateHandler.initFirstState(_initialState);

            /////////////////////////////

            _isRunning = Applet.appletMainLoop();
            while (_isRunning) {
                VupxDebug.updateLogTime();
                Vupx.update();
                VpGLRenderer.updateRenderer();
                _isRunning = Applet.appletMainLoop();

                VpModulesManager.callModulesFunction(GENERAL_UPDATE);
                
                #if VUPX_EXIT_PRESSING_PLUS_BUTTON
                if (Vupx.controller != null && Vupx.controller.isJustPressed(PLUS)) {
                    break;
                }
                #end
            }

            /////////////////////////////

            finalizeEngine();
        }
        catch (e) {
            if (onEngineCrashed != null) {
                onEngineCrashed(e);
            }
            else {
                VupxCrashHandler.onUncaughtError(e);
            }
        }
    }


    /**
     * Finalize the engine safely for a clean exit (if not we will crash the system)
     */
    public static function finalizeEngine():Void {
        VupxDebug.printToLogFileDirectly("-- Finalizing engine... ------------\n");

        // Commented because posible crash on emulators
        // VupxDebug.log("Locking HOS exit...", INFO);
        // Applet.appletLockExit();

        VpModulesManager.callModulesFunction(EXIT);

        if (onEngineExit != null) {
            try {
                onEngineExit();
            }
            catch (e) {
                VupxDebug.log("Failed to call onEngineExit: " + e, ERROR);
            }
        }

        VpStateHandler.destroyCurrentState();
        VpSDLMixerManager.quit();
        VpSDLVideoManager.quit();
        VpSDLImageManager.quit();
        VpSDLWindow.quit();
        VpGLRendererSetup.quit();
        SDL.SDL_QuitSubSystem(SDL.SDL_INIT_AUDIO | SDL.SDL_INIT_VIDEO);
        SDL.SDL_Quit();
        VpStorage.exitRomFS();
        Vupx.destroy();

        VupxDebug.log("Calling HXCPP garbage collector for a clean exit...", INFO);

        for (i in 0...5) {
            Gc.compact();
            Gc.run(true);
            VupxDebug.log("GC memory: Current: " + Gc.MEM_INFO_USAGE + " bytes  -- Reserved: " + Gc.MEM_INFO_RESERVED + " bytes -- Current Pool: " + Gc.MEM_INFO_CURRENT + " bytes" + " (" + i + "/5)", INFO);
        }

        VupxDebug.printToLogFileDirectly("Vupx Engine v" + VupxEngine.VERSION + " has shutdown" + "\n");

        VupxDebug.stopLogger();

        // Commented because posible crash on emulators
        // Applet.appletUnlockExit();
        // Sys.println("Unlock HOS exit");
    }


    //////////////////////////////

    private static function get_projectName():Null<String> {
        return _gameProjectName;
    }
}