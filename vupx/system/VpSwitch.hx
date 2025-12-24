package vupx.system;

import switchLib.applets.Error;
import switchLib.applets.Error.ErrorApplicationConfig;
import switchLib.services.Set;
import switchLib.runtime.Hosversion;

// Yes, I was lazy about creating the bindings for these functions...
@:cppFileCode('
#include <switch.h>
#include <stdio.h>

/**
 * Returns the current memory usage in bytes.
 * Returns 0 if it fails.
 */
uint64_t get_current_memory_usage(void) {
    Result rc;
    uint64_t used_mem = 0;
    
    rc = svcGetInfo(&used_mem, InfoType_UsedNonSystemMemorySize, CUR_PROCESS_HANDLE, 0);
    if (R_FAILED(rc)) {
        rc = svcGetInfo(&used_mem, InfoType_UsedMemorySize, CUR_PROCESS_HANDLE, 0);
        if (R_FAILED(rc)) {
            return 0;
        }
    }
    
    return used_mem;
}

/**
 * Returns the total usable memory in bytes.
 * Returns 0 if it fails.
 */
uint64_t get_total_usable_memory(void) {
    Result rc;
    uint64_t total_mem = 0;
    
    rc = svcGetInfo(&total_mem, InfoType_TotalNonSystemMemorySize, CUR_PROCESS_HANDLE, 0);
    if (R_FAILED(rc)) {
        rc = svcGetInfo(&total_mem, InfoType_TotalMemorySize, CUR_PROCESS_HANDLE, 0);
        if (R_FAILED(rc)) {
            return 0;
        }
    }
    
    return total_mem;
}
')
/**
 * Utility class for Nintendo Switch functions.
 * 
 * Author: Slushi
 */
class VpSwitch {
    /**
     * The current version of the Nintendo Switch OS (horizon OS).
     */
    public static var SWITCH_VERSION(get, never):String;

    /**
     * The current version of the Nintendo Switch OS (horizon OS) as an integer.
     */
    public static var SWITCH_VERSION_INT(get, never):Null<Int>;

    /**
     * The current version of Atmosphère (Custom OS).
     */
    public static var ATMOSPHERE_VERSION(get, never):String;

    /**
     * The current version of Atmosphère (Custom OS) as an integer.
     */
    public static var ATMOSPHERE_VERSION_INT(get, never):Null<Int>;

    /**
     * Checks if the console is docked (TV mode).
     */
    public static var IS_DOCKED(get, never):Bool;

    /**
     * The current applet state.
     */
    public static var appState(get, never):VpAppletStateMode;

    /**
     * Checks if the application is running on Applet mode.
     * @return Bool
     */
    public static function isRunningAsApplet():Bool {
        return Applet.appletGetAppletType() != AppletType.AppletType_Application && Applet.appletGetAppletType() != AppletType.AppletType_SystemApplication;
    }

    /**
     * Shows an application error with the specified dialog message, full message, and error number.
     * 
     * If running as applet, will not show the error to avoid crashing Atmosphere.
     * 
     * @param errorNumber The error number to display
     * @param dialogMessage The dialog message to display
     * @param fullMessage The full message to display (optional, if it is null or empty, will not display full message ("Details" button)
     */
    public static function showNXApplicationError(errorNumber:Null<Int>, dialogMessage:String, fullMessage:String):Void {
        if (isRunningAsApplet()) {
            return; // Do not show error message with this method if running as applet, it crashes Atmosphere!
        }

        if (dialogMessage == null || dialogMessage == "") {
            dialogMessage = "An error has occurred. (no message specified)";
        }
        if (fullMessage == null || fullMessage == "") {
            fullMessage = null; // No full message
        }
        if (errorNumber == null || errorNumber < 0) {
            errorNumber = 0;
        }

        var config:ErrorApplicationConfig = new ErrorApplicationConfig();
        var result:ResultType = Error.errorApplicationCreate(Pointer.addressOf(config), dialogMessage, fullMessage);

        if (Result.R_SUCCEEDED(result)) {
            Error.errorApplicationSetNumber(Pointer.addressOf(config), errorNumber);
            Error.errorApplicationShow(Pointer.addressOf(config));
        }
    }

    /**
     * Gets the current time in seconds using the Switch ARM CPU counter.
     * 
     * (This could also be useful for knowing how long the console has been on, heh).
     * 
     * @return Float (seconds)
     */
    public static function getARMTimeNow():Float {
        var ticks = Counter.armGetSystemTick();
        var nanoseconds = Counter.armTicksToNs(ticks);
        return cast(nanoseconds, Float) / 1.0e9;
    }

    /**
     * Gets the current memory usage.
     * @return {used:UInt64, total:UInt64}
     */
    @:noCompletion
    public static function getCurrentMemoryUsage():{used:UInt64, total:UInt64} {
        var used:UInt64 = untyped __cpp__('get_current_memory_usage();');
        var total:UInt64 = untyped __cpp__('get_total_usable_memory();');
        return {used: used, total: total};
    }

    /**
     * Gets the current system language.
     * @return VpSystemLenguage
     */
    public function getSystemLanguage():VpSystemLenguage {
        var consoleLenguage:Pointer<SetLanguage> = null;
        var rc:ResultType = 0;
        var consoleLenguageCode:UInt64 = 0;
        rc = Set.setInitialize();
        if (Result.R_FAILED(rc)) {
            return VpSystemLenguage.ENGLISH_US;
            if (consoleLenguage != null) {
                consoleLenguage.destroy();
            }
        }
        Set.setGetSystemLanguage(Pointer.addressOf(consoleLenguageCode));
        rc = Set.setMakeLanguage(consoleLenguageCode, consoleLenguage);
        if (Result.R_FAILED(rc)) {
            return VpSystemLenguage.ENGLISH_US;
            if (consoleLenguage != null) {
                consoleLenguage.destroy();
            }
        }

        // Convert to VpSystemLenguage, let's not use libnx stuff directly.
        var result = switch (consoleLenguage.ptr) {
            case SetLanguage_JA: VpSystemLenguage.JAPONESE;
            case SetLanguage_ENUS: VpSystemLenguage.ENGLISH_US;
            case SetLanguage_FR: VpSystemLenguage.FRENCH;
            case SetLanguage_DE: VpSystemLenguage.GERMAN;
            case SetLanguage_IT: VpSystemLenguage.ITALIAN;
            case SetLanguage_ES: VpSystemLenguage.SPANISH;
            case SetLanguage_ZHCH: VpSystemLenguage.CHINESE;
            case SetLanguage_KO: VpSystemLenguage.KOREAN;
            case SetLanguage_NL: VpSystemLenguage.DUTCH;
            case SetLanguage_PT: VpSystemLenguage.PORTUGUESE;
            case SetLanguage_RU: VpSystemLenguage.RUSSIAN;
            case SetLanguage_ZHTW: VpSystemLenguage.CHINESE_TAIWANESE;
            case SetLanguage_ENGB: VpSystemLenguage.BRITISH_ENGLISH;
            case SetLanguage_FRCA: VpSystemLenguage.CANADIAN_FRENCH;
            case SetLanguage_ES419: VpSystemLenguage.LATIN_AMERICAN_SPANISH;
            case SetLanguage_ZHHANS: VpSystemLenguage.SIMPLIFIED_CHINESE;
            case SetLanguage_ZHHANT: VpSystemLenguage.TRADITIONAL_CHINESE;
            case SetLanguage_PTBR: VpSystemLenguage.BRAZILIAN_PORTUGUESE;
            default: VpSystemLenguage.ENGLISH_US; // Fallback if the language is not supported or unknown
        }

        // Cleanup
        Set.setExit();
        if (consoleLenguage != null) {
            consoleLenguage.destroy();
        }
        consoleLenguage = null;
        return result;
    }

    /**
     * Gets the current console model.
     * 
     * See VpConsoleModel for more information.
     * 
     * @return VpConsoleModel
     */
    public static function getConsoleModel():VpConsoleModel {
        var consoleModel:Pointer<SetSysProductModel> = null;
        var rc:ResultType = 0;
        rc = Set.setInitialize();
        if (Result.R_FAILED(rc)) {
            VupxDebug.log("Failed to initialize Set: " + rc, ERROR);
            return VpConsoleModel.UNKNOWN;
            if (consoleModel != null) {
                consoleModel.destroy();
            }
        }
        rc = Set.setGetSystemProductModel(consoleModel);
        if (Result.R_FAILED(rc)) {
            return VpConsoleModel.UNKNOWN;
            if (consoleModel != null) {
                consoleModel.destroy();
            }
        }

        // Convert to VpConsoleModel, let's not use libnx stuff directly.
        var result = switch (consoleModel.ptr) {
            case SetSysProductModel_Nx: VpConsoleModel.SWITCH_V1;
            case SetSysProductModel_Iowa: VpConsoleModel.SWITCH_V2;
            case SetSysProductModel_Hoag : VpConsoleModel.SWITCH_LITE;
            case SetSysProductModel_Aula: VpConsoleModel.SWITCH_OLED;
            default: VpConsoleModel.UNKNOWN; // Fallback if the model is unknown
        }

        // Cleanup
        Set.setExit();
        if (consoleModel != null) {
            consoleModel.destroy();
        }
        consoleModel = null;
        return result;      
    }

    //////////////////////////////

    private static function get_SWITCH_VERSION():String {
        var switchVersion:UInt32 = Hosversion.hosversionGet();
        var major:UInt32 = Hosversion.HOSVER_MAJOR(switchVersion);
        var minor:UInt32 = Hosversion.HOSVER_MINOR(switchVersion);
        var patch:UInt32 = Hosversion.HOSVER_MICRO(switchVersion);

        return major + "." + minor + "." + patch;
    }

    private static function get_SWITCH_VERSION_INT():Null<Int> {
        return Std.parseInt(SWITCH_VERSION.replace(".", ""));
    }

    private static function get_ATMOSPHERE_VERSION():String {
        var version:UInt64 = 0;
        if (Hosversion.hosversionIsAtmosphere()) { // No Atmosphere? is a "WTF" for me
            // Copied from https://github.com/impeeza/sys-patch/blob/2ca9ba8fc6fa9f02583a5d821ca75a5603937389/sysmod/src/main.cpp#L751
            untyped __cpp__("
            Result rc;
            uint64_t v;
            if (R_SUCCEEDED(rc = splInitialize())) {
                if (R_SUCCEEDED(rc = splGetConfig((SplConfigItem)65000, &v))) {
                    {0} = (v >> 40) & 0xFFFFFF;
                }
                splExit();
            }
            ", version);
        }

        if (version.toInt() > 0) {
            var major:UInt32 = (version.toInt() >> 16) & 0xFF;
            var minor:UInt32 = (version.toInt() >> 8) & 0xFF;
            var patch:UInt32 = version.toInt() & 0xFF;
            return major + "." + minor + "." + patch;
        }

        return "0.0.0";
    }

    private static function get_ATMOSPHERE_VERSION_INT():Null<Int> {
        return Std.parseInt(ATMOSPHERE_VERSION.replace(".", ""));
    }

    private static function get_IS_DOCKED():Bool {
        return Applet.appletGetOperationMode() == AppletOperationMode.AppletOperationMode_Console;
    }

    private static function get_appState():VpAppletStateMode {
        return switch (Applet.appletGetFocusState()) {
            case AppletFocusState.AppletFocusState_InFocus: VpAppletStateMode.APP_IN_FOCUS;
            case AppletFocusState.AppletFocusState_OutOfFocus: VpAppletStateMode.APP_OUT_OF_FOCUS;
            case AppletFocusState.AppletFocusState_Background: VpAppletStateMode.APP_SUSPENDED;
            default: VpAppletStateMode.APP_UNKNOWN;
        }
    }
}

/**
 * List of supported system languages
 */
enum VpSystemLenguage {
    JAPONESE;
    ENGLISH_US;
    FRENCH;
    GERMAN;
    ITALIAN;
    SPANISH;
    CHINESE;
    KOREAN;
    DUTCH;
    PORTUGUESE;
    RUSSIAN;
    CHINESE_TAIWANESE;
    BRITISH_ENGLISH;
    CANADIAN_FRENCH;
    LATIN_AMERICAN_SPANISH;
    SIMPLIFIED_CHINESE;
    TRADITIONAL_CHINESE;
    BRAZILIAN_PORTUGUESE;
}

/**
 * List of Nintendo Switch console models
 * 
 * ----
 * 
 * Switch V1: Original model released in 2017, code-named "Erista"
 * 
 * Switch V2: Revised model with RCM bug patched released in 2019, code-named "Mariko"
 * 
 * Switch Lite: Handheld-only model released in 2019
 * 
 * Switch OLED: Model with OLED screen released in 2021
 * 
 * ----
 * 
 * All Switch models released after 2019 are considered Switch V2 (Mariko) hardware revisions
 */
enum VpConsoleModel {
    SWITCH_V1;
    SWITCH_V2;
    SWITCH_LITE;
    SWITCH_OLED;
    UNKNOWN;
}

/**
 * States of the applet
 */
enum VpAppletStateMode {
    /**
     * The applet/program is in focus
     */
    APP_IN_FOCUS;

    /**
     * The applet/program is out of focus
     */
    APP_OUT_OF_FOCUS;

    /**
     * The applet/program is suspended (In HOME menu or the console is sleeping)
     */
    APP_SUSPENDED;

    /**
     * Unknown state
     */
    APP_UNKNOWN;
}