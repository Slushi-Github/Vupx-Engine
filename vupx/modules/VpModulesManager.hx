package vupx.modules;

/**
 * Structure for modules
 */
@:structInit
class VpModuleStruct {
    /**
     * The name of the module
     */
    public var moduleName:String;
    // General //
    /**
     * Calls after the engine is fully initialized
     */
    public var initFuncion:Null<Void->Void>;

    /**
     * Calls every frame after the engine main calls
     */
    public var generalUpdateFunction:Null<Void->Void>;

    /**
     * Calls before the main engine rendering is done
     */
    public var generalBeforeMainRenderFunction:Null<Void->Void>;

    /**
     * Calls after the main engine rendering is done
     */
    public var generalAfterMainRenderFunction:Null<Void->Void>;

    /**
     * Calls when the engine is about to exit
     */
    public var generalExitFunction:Null<Void->Void>;

    /**
     * Calls when the engine crashes
     */
    public var generalCrashFunction:Null<Void->Void>;
    // States //
    /**
     * Calls when a state is created
     */
    public var stateCreateFunction:Null<Void->Void>;
    /**
     * Calls every update call of a state
     */
    public var stateUpdateFunction:Null<Float->Void>;

    /**
     * Calls every after main render call of a state
     */
    public var stateRenderFunction:Null<Void->Void>;

    /**
     * Calls when a state is destroyed
     */
    public var stateDestroyFunction:Null<Void->Void>;

    /**
     * Calls when a state is changing
     */
    public var stateChangeFunction:Null<Void->Void>;
    // SubStates //

    /**
     * Calls when a substate is created
     */
    public var subStateCreateFunction:Null<Void->Void>;

    /**
     * Calls every update call of a substate
     */
    public var subStateUpdateFunction:Null<Float->Void>;

    /**
     * Calls every after main render call of a substate
     */
    public var subStateRenderFunction:Null<Void->Void>;

    /**
     * Calls when a substate is destroyed
     */
    public var subStateDestroyFunction:Null<Void->Void>;

    /**
     * Calls when a substate is closed
     */
    public var subStateCloseFunction:Null<Void->Void>;  

    public function new():Void {};
}

/**
 * Function types of modules
 */
enum FuncType {
    INIT;
    GENERAL_UPDATE;
    GENERAL_BEFORE_MAIN_RENDER;
    GENERAL_AFTER_MAIN_RENDER;
    EXIT;
    GENERAL_CRASH;
    STATE_CREATE;
    STATE_UPDATE;
    STATE_RENDER;
    STATE_DESTROY;
    STATE_CHANGE;
    SUB_STATE_CREATE;
    SUB_STATE_UPDATE;
    SUB_STATE_RENDER;
    SUB_STATE_DESTROY;
    SUB_STATE_CLOSE;
} 

/**
 * A manager for modules
 * 
 * This allows external code to be executed in normal engine 
 * locations, such as a ``VpState``, without having to override a function by 
 * extending it in another class. You can create a module that is 
 * configured to directly execute code in that function of an original engine ``VpState``.
 * 
 * Modules are executed in the order they are added
 * 
 * Author: Slushi
 */
class VpModulesManager {
    /**
     * List of modules
     */
    private static var modules:Array<VpModuleStruct> = new Array<VpModuleStruct>();

    /**
     * Maximum number of crashes allowed per function before disabling it
     */
    private static final MAX_CRASHES_PER_FUNCTION:Int = 10;

    /**
     * Crash counter per module and function
     * Key format: "moduleName:FuncType"
     */
    private static var crashCounter:Map<String, Int> = new Map<String, Int>();

    /**
     * Disabled functions per module
     * Key format: "moduleName:FuncType"
     */
    private static var disabledFunctions:Map<String, Bool> = new Map<String, Bool>();

    /**
     * Add a module to the list
     * @param module The module 
     */
    public static function addModule(module:Null<VpModuleStruct>):Void {
        #if !VUPX_DISABLE_MODULES
        if (modules == null || module == null || modules.contains(module)) return;

        if (module.moduleName == null || module.moduleName.length == 0) {
            VupxDebug.log("Module has no name, cannot be added", ERROR);
            return;
        }

        modules.push(module);
        #end
    }

    /**
     * Add multiple modules to the list
     * @param modules The modules to add
     */
    public static function addModules(modulesToAdd:Array<VpModuleStruct>):Void {
        #if !VUPX_DISABLE_MODULES
        if (modules == null || modules.length == 0 || modulesToAdd == null) return;
        for (module in modulesToAdd) {
            if (module == null) continue;
            addModule(module);
        }
        #end
    }

    /**
     * Remove a module from the list
     * @param module The module 
     */
    public static function removeModule(module:Null<VpModuleStruct>):Void {
        #if !VUPX_DISABLE_MODULES
        if (modules == null || module == null || !modules.contains(module)) return;
        modules.remove(module);
        #end
    }

    /**
     * Get all modules
     */
    public static function getModules():Array<VpModuleStruct> {
        #if !VUPX_DISABLE_MODULES
        return modules;
        #else
        return null;
        #end
    }

    /**
     * Reset crash counter for a specific module and function
     * @param moduleName The module name
     * @param funcType The function type
     */
    public static function resetCrashCounter(moduleName:String, funcType:FuncType):Void {
        #if !VUPX_DISABLE_MODULES
        var key:String = _getKey(moduleName, funcType);
        crashCounter.remove(key);
        disabledFunctions.remove(key);
        #end
    }

    /**
     * Reset all crash counters for a module
     * @param moduleName The module name
     */
    public static function resetModuleCrashCounters(moduleName:String):Void {
        #if !VUPX_DISABLE_MODULES
        var keysToRemove:Array<String> = [];
        
        for (key in crashCounter.keys()) {
            if (key.indexOf(moduleName + ":") == 0) {
                keysToRemove.push(key);
            }
        }
        
        for (key in keysToRemove) {
            crashCounter.remove(key);
            disabledFunctions.remove(key);
        }
        #end
    }

    /**
     * Get crash count for a specific module function
     * @param moduleName The module name
     * @param funcType The function type
     * @return The crash count
     */
    public static function getCrashCount(moduleName:String, funcType:FuncType):Int {
        #if !VUPX_DISABLE_MODULES
        var key:String = _getKey(moduleName, funcType);
        return crashCounter.exists(key) ? crashCounter.get(key) : 0;
        #else
        return 0;
        #end
    }

    /**
     * Check if a function is disabled for a module
     * @param moduleName The module name
     * @param funcType The function type
     * @return True if disabled
     */
    public static function isFunctionDisabled(moduleName:String, funcType:FuncType):Bool {
        #if !VUPX_DISABLE_MODULES
        var key:String = _getKey(moduleName, funcType);
        return disabledFunctions.exists(key) && disabledFunctions.get(key);
        #else
        return false;
        #end
    }

    /**
     * Destroy all modules
     */
    public static function destroy():Void {
        #if !VUPX_DISABLE_MODULES
        callModulesFunction(FuncType.EXIT);
        modules = null;
        crashCounter.clear();
        disabledFunctions.clear();
        #end
    }

    /////////////////////////////////////////////////

    /**
     * Call a function on all modules
     * @param func The function to call
     * @param args The arguments to pass to the function if needed
     */
    public static function callModulesFunction(func:FuncType, ...args:Dynamic):Void {
        #if !VUPX_DISABLE_MODULES
        if (modules == null || modules.length == 0 || func == null) return;

        switch (func) {
            // General //
            case FuncType.INIT:
                _safeCall(func, m -> m.initFuncion);
                
            case FuncType.GENERAL_UPDATE:
                _safeCall(func, m -> m.generalUpdateFunction);
                
            case FuncType.GENERAL_BEFORE_MAIN_RENDER:
                _safeCall(func, m -> m.generalBeforeMainRenderFunction);
                
            case FuncType.GENERAL_AFTER_MAIN_RENDER:
                _safeCall(func, m -> m.generalAfterMainRenderFunction);
                
            case FuncType.EXIT:
                _safeCall(func, m -> m.generalExitFunction);

            case FuncType.GENERAL_CRASH:
                _safeCall(func, m -> m.generalCrashFunction);

            // States //
            case FuncType.STATE_CREATE:
                _safeCall(func, m -> m.stateCreateFunction);
                
            case FuncType.STATE_UPDATE:
                _safeCall(func, m -> m.stateUpdateFunction, args);
                
            case FuncType.STATE_RENDER:
                _safeCall(func, m -> m.stateRenderFunction);
                
            case FuncType.STATE_DESTROY:
                _safeCall(func, m -> m.stateDestroyFunction);
                
            case FuncType.STATE_CHANGE:
                _safeCall(func, m -> m.stateChangeFunction);

            // SubStates //
            case FuncType.SUB_STATE_CREATE:
                _safeCall(func, m -> m.subStateCreateFunction);
                
            case FuncType.SUB_STATE_UPDATE:
                _safeCall(func, m -> m.subStateUpdateFunction, args);
                
            case FuncType.SUB_STATE_RENDER:
                _safeCall(func, m -> m.subStateRenderFunction);
                
            case FuncType.SUB_STATE_DESTROY:
                _safeCall(func, m -> m.subStateDestroyFunction);
                
            case FuncType.SUB_STATE_CLOSE:
                _safeCall(func, m -> m.subStateCloseFunction);
        }
        #end
    }

    /**
     * Generate a unique key for crash tracking
     * @param moduleName The module name
     * @param funcType The function type
     * @return The key
     */
    private static function _getKey(moduleName:String, funcType:FuncType):String {
        return moduleName + ":" + funcType;
    }

    /**
     * Calls a function on all modules catching errors
     * @param funcType The function type
     * @param getFunc Function to get the module's function
     */
    private static function _safeCall(funcType:FuncType, getFunc:VpModuleStruct->Null<Dynamic>, ...args:Dynamic):Void {
        for (module in modules) {
            if (module == null) continue;
            
            var key:String = _getKey(module.moduleName, funcType);
            
            // Check if function is disabled
            if (disabledFunctions.exists(key) && disabledFunctions.get(key)) {
                continue;
            }
            
            var funcToCall:Null<Dynamic> = getFunc(module);

            if (funcToCall != null) {
                try {
                    switch (funcType) {
                        case STATE_UPDATE:
                            funcToCall(args[0]);
                        case SUB_STATE_UPDATE:
                            funcToCall(args[0]);
                        default:
                            funcToCall();
                    }
                } catch (e:Dynamic) {
                    // Increment crash counter
                    var currentCrashes:Int = crashCounter.exists(key) ? crashCounter.get(key) : 0;
                    currentCrashes++;
                    crashCounter.set(key, currentCrashes);
                    
                    VupxDebug.log("Error calling on module [" + module.moduleName + "] while calling function [" + funcType + "]: " + e + " (Crash count: " + currentCrashes + ")", ERROR);
                    
                    // Disable function if max crashes reached
                    if (currentCrashes >= MAX_CRASHES_PER_FUNCTION) {
                        disabledFunctions.set(key, true);
                        VupxDebug.log("Module [" + module.moduleName + "] function [" + funcType + "] has been DISABLED after " + currentCrashes + " crashes", WARNING);
                    }
                }
            }
        }
    }
    /////////////////////////////////////////////////
}