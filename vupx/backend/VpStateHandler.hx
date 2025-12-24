package vupx.backend;

/**
 * Vupx state handler, used to switch between states and manage the current state
 * 
 * Author: Slushi
 */
class VpStateHandler {
    private static var currentState:Null<VpState> = null;

    /**
     * Returns the current state
     * @return VpState The current state
     */
    public static function getCurrentState():Null<VpState> {
        return currentState;
    }

    /**
     * Initializes the first state in the engine initialization
     * @param newState The initial state
     */
    public static function initFirstState(newState:Null<VpState>):Void {
        Vupx.currentState = newState;
        currentState = newState;
        currentState.create();
    }

    /**
     * Destroys the current state
     */
    public static function destroyCurrentState():Void {
        if (currentState != null) {
            VpTweenManager.clear();
            Vupx.clearCameras();
            currentState.destroy();
            currentState = null;
            Vupx.currentState = null;
        }
    }

    /**
     * Changes the current state to the new state
     * @param newState The new state
     */
    public static function changeState(newState:Null<VpState>):Void {
        VupxDebug.log("Changing state...", INFO);
        destroyCurrentState();
        currentState = newState;
        Vupx.currentState = currentState;
        VpModulesManager.callModulesFunction(STATE_CHANGE);
        currentState.create();
        VupxDebug.log("State changed!", INFO);
    }

    /**
     * Updates the current state
     * @param elapsed
     */
    public static function updateState(elapsed:Float):Void {
        if (currentState != null) {
            currentState.update(elapsed);
        }
    }
}