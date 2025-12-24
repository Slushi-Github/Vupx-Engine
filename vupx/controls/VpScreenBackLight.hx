package vupx.controls;

import switchLib.services.Lbl;

/**
 * Backlight switch status
 */
enum VpBacklightSwitchStatus {
    DISABLED;
    ENABLED;
    ENABLING;
    DISABLING;
}

/**
 * Controls the screen backlight of the console
 * 
 * Author: Slushi
 */
class VpScreenBackLight {
    /**
     * Saved brightness setting
     */
    private var systemBrightnessConfigured(get, never):Float;

    /**
     * Current brightness setting in hardware
     */
    private var hardwareBacklightBrightness(get, never):Float;

    /**
     * Current backlight status
     */
    private var backlightStatus(get, never):VpBacklightSwitchStatus;

    /**
     * Current dimming mode status
     */
    private var isDimmingEnabled(get, never):Bool;
    
    /**
     * Constructor - initializes the LBL service
     */
    public function new() {
        var result = Lbl.lblInitialize();
        if (result != 0) {
            VupxDebug.log('Failed to initialize LBL service: 0x${StringTools.hex(result)}', ERROR);
        }
    }
    
    /**
     * Sets the old brightness saved and closes the LBL service
     */
    public function destroy():Void {
        // Activate backlight
        if (backlightStatus == VpBacklightSwitchStatus.DISABLING || backlightStatus == VpBacklightSwitchStatus.DISABLED) {
            switchBacklightOn();
        }

        // Restore system brightness
        Lbl.lblLoadCurrentSetting();
        Lbl.lblApplyCurrentBrightnessSettingToBacklight();

        Lbl.lblExit();
    }
    
    /**
     * Sets the screen brightness (0.0 - 1.0)
     * @param brightness Brightness value between 0.0 (minimum) and 1.0 (maximum)
     * @param apply If true, applies immediately to hardware
     */
    public function setBrightness(brightness:Null<Float>, apply:Bool = true):Void {
        if (brightness == null) {
            brightness = 1.0;
        }
        else if (brightness < 0.0) {
            brightness = 0.0;
        }
        else if (brightness > 1.0) {
            brightness = 1.0;
        }

        var result = Lbl.lblSetCurrentBrightnessSetting(brightness);
        if (result != 0) {
            VupxDebug.log('Failed to set brightness: 0x${StringTools.hex(result)}', WARNING);
            return;
        }
        
        if (apply) {
            result = Lbl.lblApplyCurrentBrightnessSettingToBacklight();
            if (result != 0) {
                VupxDebug.log('Failed to apply brightness: 0x${StringTools.hex(result)}', WARNING);
            }
        }
    }

    /**
     * Gets the current screen brightness
     */
    public function getBrightness():Float {
        var result:Float32 = 0.0;
        var rc = Lbl.lblGetCurrentBrightnessSetting(result.toPointer());
        if (rc != 0) {
            VupxDebug.log('Failed to get brightness: 0x${StringTools.hex(rc)}', WARNING);
            return 1.0;
        }
        return result;
    }

    /**
     * Loads the saved brightness setting
     * @return true if loaded successfully
     */
    public function loadBrightnessSetting():Bool {
        var result = Lbl.lblLoadCurrentSetting();
        if (result != 0) {
            VupxDebug.log('Failed to load brightness setting: 0x${StringTools.hex(result)}', WARNING);
            return false;
        }
        return true;
    }
    
    /**
     * Applies the configured brightness to the physical backlight
     * @return true if applied successfully
     */
    public function applyBrightnessToBacklight():Bool {
        var result = Lbl.lblApplyCurrentBrightnessSettingToBacklight();
        if (result != 0) {
            VupxDebug.log('Failed to apply brightness to backlight: 0x${StringTools.hex(result)}', WARNING);
            return false;
        }
        return true;
    }
    
    /**
     * Turns on the backlight with fade effect
     * @param fadeTimeSeconds Duration of the fade in seconds (0 = instant)
     * @return true if executed successfully
     */
    public function switchBacklightOn(fadeTimeSeconds:Float = 0.0):Bool {
        var fadeTimeNanos:UInt64 = cast (fadeTimeSeconds * 1000000000.0);
        var result = Lbl.lblSwitchBacklightOn(fadeTimeNanos);
        if (result != 0) {
            VupxDebug.log('Failed to switch backlight on: 0x${StringTools.hex(result)}', WARNING);
            return false;
        }
        return true;
    }
    
    /**
     * Turns off the backlight with fade effect
     * @param fadeTimeSeconds Duration of the fade in seconds (0 = instant)
     * @return true if executed successfully
     */
    public function switchBacklightOff(fadeTimeSeconds:Float = 0.0):Bool {
        var fadeTimeNanos:UInt64 = cast (fadeTimeSeconds * 1000000000.0);
        var result = Lbl.lblSwitchBacklightOff(fadeTimeNanos);
        if (result != 0) {
            VupxDebug.log('Failed to switch backlight off: 0x${StringTools.hex(result)}', WARNING);
            return false;
        }
        return true;
    }
    
    /**
     * Enables automatic dimming (screen dims after inactivity)
     * @param mode True to enable, false to disable
     * @return true if enabled successfully
     */
    public function setDimming(mode:Bool):Bool {
        var result:ResultType = 0;

        if (mode) {
            result = Lbl.lblEnableDimming();
        } else {
            result = Lbl.lblDisableDimming();
        }

        if (result != 0) {
            VupxDebug.log('Failed to enable dimming: 0x${StringTools.hex(result)}', WARNING);
            return false;
        }
        return true;
    }
    
    /**
     * Checks if the backlight is fully on
     * @return true if backlight is enabled
     */
    public function isBacklightOn():Bool {
        return backlightStatus == VpBacklightSwitchStatus.ENABLED;
    }
    
    /**
     * Checks if the backlight is transitioning (fading in/out)
     * @return true if enabling or disabling
     */
    public function isBacklightTransitioning():Bool {
        var status = backlightStatus;
        return status == VpBacklightSwitchStatus.ENABLING || 
                status == VpBacklightSwitchStatus.DISABLING;
    }

    // Getters
    
    private function get_systemBrightnessConfigured():Float {
        var result:Float32 = 0.0;
        var rc = Lbl.lblGetCurrentBrightnessSetting(result.toPointer());
        if (rc != 0) {
            VupxDebug.log('Failed to get configured brightness: 0x${StringTools.hex(rc)}', WARNING);
            return 1.0;
        }
        return result;
    }

    private function get_hardwareBacklightBrightness():Float {
        var result:Float32 = 0.0;
        var rc = Lbl.lblGetBrightnessSettingAppliedToBacklight(result.toPointer());
        if (rc != 0) {
            VupxDebug.log('Failed to get backlight brightness: 0x${StringTools.hex(rc)}', WARNING);
            return 1.0;
        }
        return result;
    }
    
    private function get_backlightStatus():VpBacklightSwitchStatus {
        var result:LblBacklightSwitchStatus = LblBacklightSwitchStatus.LblBacklightSwitchStatus_Disabled;
        var rc = Lbl.lblGetBacklightSwitchStatus(untyped __cpp__("&{0}", result));
        if (rc != 0) {
            VupxDebug.log('Warning: Failed to get backlight status: 0x${StringTools.hex(rc)}', WARNING);
        }

        if (result == LblBacklightSwitchStatus.LblBacklightSwitchStatus_Disabled) {
            return VpBacklightSwitchStatus.DISABLED;
        } else if (result == LblBacklightSwitchStatus.LblBacklightSwitchStatus_Enabled) {
            return VpBacklightSwitchStatus.ENABLED;
        } else if (result == LblBacklightSwitchStatus.LblBacklightSwitchStatus_Enabling) {
            return VpBacklightSwitchStatus.ENABLING;
        } else if (result == LblBacklightSwitchStatus.LblBacklightSwitchStatus_Disabling) {
            return VpBacklightSwitchStatus.DISABLING;
        }
        return VpBacklightSwitchStatus.DISABLED;
    }
    
    private function get_isDimmingEnabled():Bool {
        var result:Bool = false;
        var rc = Lbl.lblIsDimmingEnabled(result.toPointer());
        if (rc != 0) {
            VupxDebug.log('Failed to get dimming status: 0x${StringTools.hex(rc)}', WARNING);
        }
        return result;
    }
}