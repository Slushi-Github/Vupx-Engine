package vupx;

/**
 * Main Vupx engine class
 * 
 * This class is used to access the important modules of the engine
 * 
 * Author: Slushi
 */
class Vupx {
    /**
     * The time since the last update
     */
    public static var deltaTime(get, never):Float;

    /**
     * The time since the engine started
     */
    public static var elapsedTime(get, never):Float;

    /**
     * The width of the default screen
     */
    public static var screenWidth(get, never):Int;

    /**
     * The height of the default screen
     */
    public static var screenHeight(get, never):Int;

    /**
     * The audio engine
     */
    public static var audio:Null<VpAudioManager> = null;

    /**
     * The controller manager
     */
    public static var controller:Null<VpControl> = null;

    /**
     * The touch screen of the console
     */
    public static var touchScreen:Null<VpTouchScreen> = null;

    /**
     * The screen backlight of the console
     */
    public static var screenBackLight:Null<VpScreenBackLight> = null;

    /**
     * Is the engine paused
     */
    public static var paused(get, never):Bool;

    /**
     * Current state
     */
    public static var currentState:Null<VpState> = null;


    /**
     * The main camera object
     */
    public static var camera:Null<VpCamera> = null;

    /**
     * The list of cameras
     */
    public static var cameras:Null<Array<VpCamera>> = null;

    /**
     * The save manager
     */
    public static var save:Null<VpSaveUtil> = null;

    ///////////////////////////

    public static function init():Void {
        // Create the main cameras and camera list
        camera = new VpCamera();
        cameras = new Array<VpCamera>();
        addCamera(camera);

        controller = new VpControl();
        touchScreen = new VpTouchScreen();
        screenBackLight = new VpScreenBackLight();
        save = new VpSaveUtil();
        VpTweenManager.init();
    }

    /**
     * Switches the current state
     * @param state 
     */
    public static function switchState(state:Null<VpState>):Void {
        state ?? return;
        VpStateHandler.changeState(state);
    }

    /**
     * Resets the current state (Switching to the same current state)
     * @param state 
     */
    public static function resetState():Void {
        currentState ?? return;
        VpStateHandler.changeState(currentState);
    }

    /**
     * Adds a camera to the list
     * @param cam The camera to add
     */
    public static function addCamera(cam:Null<VpCamera>):Void {
        cam ?? return;
        if (cam == camera && cameras.contains(cam) && cameras.contains(cam)) return; // Don't allow to re add the main camera (it's already there)
        if (cameras.contains(cam)) return;
        cameras.push(cam);
    }

    /**
     * Removes a camera from the list
     * @param cam The camera to remove
     */
    public static function removeCamera(cam:Null<VpCamera>):Void {
        cam ?? return;
        if (cam == camera) return; // Don't allow to remove the main camera
        if (!cameras.contains(cam)) return;
        cameras.remove(cam);
    }

    /**
     * Clears all cameras except the main ones
     */
    @:noCompletion
    public static function clearCameras():Void {
        for (cam in cameras) {
            if (cam == camera) continue; // Don't remove the main camera
            if (cam == null) continue;
            cam.destroy();
            cameras.remove(cam);
        }
    }

    /**
     * Updates the Vupx class
     */
    public static function update():Void {
        VpTimer.update();
        VpStateHandler.updateState(deltaTime);
        VpTweenManager.update(deltaTime);
        if (controller != null) controller.update();
        if (touchScreen != null) touchScreen.update();

        if (camera != null) camera.update(deltaTime);
        for (cam in cameras) {
            cam ?? continue;
            cam.update(deltaTime);
        }
    }

    public static function destroy():Void {
        if (controller != null) controller.destroy();
        if (screenBackLight != null) screenBackLight.destroy();

        for (cam in cameras) {
            cam ?? continue;
            cam.destroy();
        }
        cameras = null;
        camera = null;

        save = null;
        touchScreen = null;
        controller = null;
    }

    ///////////////////////////

    private static function get_screenWidth():Int {
        return 1280; // Hardcoded for now
    }

    private static function get_screenHeight():Int {
        return 720; // Hardcoded for now
    }

    private static function get_deltaTime():Float {
        return VpTimer.deltaTime;
    }

    private static function get_elapsedTime():Float {
        return VpTimer.elapsedTime;
    }

    private static function get_paused() {
        return VpSwitch.appState == VpAppletStateMode.APP_SUSPENDED;
    }
}