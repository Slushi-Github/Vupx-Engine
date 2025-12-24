package vupx.system;

import switchLib.applets.Swkbd;

/**
 * Keyboard presets
 */
enum VpKeyBoardPreset {
    /**
     * Default preset
     */
    KEYBOARD_DEFAULT;

    /**
     * Preset for passwords
     */
    KEYBOARD_PASSWORD;

    /**
     * Preset for usernames
     */
    KEYBOARD_USERNAME;
}

/**
 * Manages the screen keyboard of the console
 * 
 * This pauses the engine until the keyboard is closed
 * 
 * Author: Slushi
 */
class VpScreenKeyboard extends VpBase {
    /**
     * The output string of the user 
     */
    public var resultString(get, never):String;

    /**
     * The maximum length of the input string
     */
    public var maxLength(default, set):Null<Int>;

    /**
     * The minimum length of the input string
     */
    public var minLength(default, set):Null<Int>;

    /**
     * The header text of the keyboard
     */
    public var headerText(default, set):String;

    /**
     * The guide text of the keyboard
     */
    public var guideText(default, set):String;

    /**
     * The sub text of the keyboard
     */
    public var subText(default, set):String;

    /**
     * The initial text of the keyboard
     */
    public var initialText(default, set):String;

    /**
     * The OK button text of the keyboard
     */
    public var okButtonText(default, set):String;

    /**
     * The blur background of the keyboard
     */
    public var blurBackground(default, set):Null<Bool>;

    /**
     * The configuration of the keyboard
     */
    private var keyBoardConfig:SwkbdConfig;

    /**
     * The preset of the keyboard
     */
    private var preset:VpKeyBoardPreset;

    /**
     * Internal result buffer for the keyboard (C string buffer)
     */
    private var _resultBuffer:Pointer<Char>;

    /**
     * Internal result string of the keyboard
     */
    private var _resultString:String;

    /**
     * Current allocated buffer size
     */
    private var _bufferSize:Int;

    /**
     * Default maximum length if not specified
     */
    private static inline final DEFAULT_MAX_LENGTH:Int = 64;

    /**
     * Creates a new screen keyboard
     * @param preset The preset to use (default: KEYBOARD_DEFAULT)
     */
    public function new(preset:VpKeyBoardPreset = KEYBOARD_DEFAULT) {
        super();

        this.preset = preset;
        _resultString = "";
        _bufferSize = DEFAULT_MAX_LENGTH;
        
        // Allocate initial buffer
        _resultBuffer = Stdlib.malloc(_bufferSize);
        if (_resultBuffer == null) {
            VupxDebug.log("Failed to allocate memory for keyboard buffer", ERROR);
            return;
        }

        CPPHelpers.memset(cast _resultBuffer, 0, _bufferSize);

        // Create keyboard config
        keyBoardConfig = new SwkbdConfig();
        var result:ResultType = Swkbd.swkbdCreate(Pointer.addressOf(keyBoardConfig), 0);
        if (Result.R_FAILED(result)) {
            VupxDebug.log("Failed to create screen keyboard", ERROR);
            Stdlib.free(_resultBuffer);
            _resultBuffer = null;
            return;
        }

        // Apply preset
        applyPreset(preset);
        
        // Set default max length
        this.maxLength = DEFAULT_MAX_LENGTH;
    }

    /**
     * Shows the keyboard and waits for user input
     * @return True if user submitted text, false if cancelled
     */
    public function show():Bool {
        if (keyBoardConfig.isNull() || _resultBuffer == null) {
            VupxDebug.log("Keyboard not properly initialized", ERROR);
            return false;
        }

        // Clear buffer before showing
        CPPHelpers.memset(cast _resultBuffer, 0, _bufferSize);

        // Show keyboard with the buffer size
        var result:ResultType = Swkbd.swkbdShow(
            Pointer.addressOf(keyBoardConfig), 
            _resultBuffer, 
            cast _bufferSize  // Use the actual buffer size
        );

        if (Result.R_SUCCEEDED(result)) {
            // Convert C string to Haxe string
            _resultString = NativeString.fromPointer(_resultBuffer);
            return true;
        }

        // User cancelled or error occurred
        _resultString = "";
        return false;
    }

    /**
     * Changes the keyboard preset
     * @param preset The new preset to use
     */
    public function setPreset(preset:VpKeyBoardPreset = KEYBOARD_DEFAULT) {
        this.preset = preset;
        applyPreset(preset);
    }

    /**
     * Applies the specified preset to the keyboard
     * @param preset The preset to apply
     */
    private function applyPreset(preset:VpKeyBoardPreset) {
        if (keyBoardConfig.isNull()) return;

        switch (preset) {
            case KEYBOARD_DEFAULT:
                Swkbd.swkbdConfigMakePresetDefault(Pointer.addressOf(keyBoardConfig));
            case KEYBOARD_PASSWORD:
                Swkbd.swkbdConfigMakePresetPassword(Pointer.addressOf(keyBoardConfig));
            case KEYBOARD_USERNAME:
                Swkbd.swkbdConfigMakePresetUserName(Pointer.addressOf(keyBoardConfig));
        }
    }

    /**
     * Reallocates the result buffer with a new size
     * @param newSize The new buffer size
     */
    private function reallocateBuffer(newSize:Int) {
        if (_resultBuffer != null) {
            Stdlib.free(_resultBuffer);
        }

        _bufferSize = newSize;
        _resultBuffer = Stdlib.malloc(_bufferSize);
        
        if (_resultBuffer == null) {
            VupxDebug.log("Failed to reallocate keyboard buffer", ERROR);
            _bufferSize = 0;
            return;
        }

        CPPHelpers.memset(cast _resultBuffer, 0, _bufferSize);
    }

    /**
     * Destroys the keyboard and frees resources
     */
    override public function destroy() {
        // Free the result buffer
        if (_resultBuffer != null) {
            Stdlib.free(_resultBuffer);
            _resultBuffer = null;
        }

        // Close the keyboard config
        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdClose(Pointer.addressOf(keyBoardConfig));
        }

        _resultString = "";
        _bufferSize = 0;
    }

    ///////////
    // GETTERS & SETTERS
    ///////////

    private function get_resultString():String {
        return _resultString;
    }

    private function set_maxLength(value:Null<Int>):Null<Int> {
        if (value == null || value <= 0) {
            value = DEFAULT_MAX_LENGTH;
        }

        // Reallocate buffer if size changed
        if (value != _bufferSize) {
            reallocateBuffer(value);
        }

        // Set the max length in the keyboard config
        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdConfigSetStringLenMax(Pointer.addressOf(keyBoardConfig), value);
        }

        return maxLength = value;
    }

    private function set_minLength(value:Null<Int>):Null<Int> {
        if (value == null || value < 0) {
            value = 0;
        }

        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdConfigSetStringLenMin(Pointer.addressOf(keyBoardConfig), value);
        }

        return minLength = value;
    }

    private function set_headerText(value:String):String {
        if (value == null) {
            value = "";
        }

        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdConfigSetHeaderText(Pointer.addressOf(keyBoardConfig), value);
        }

        return headerText = value;
    }

    private function set_guideText(value:String):String {
        if (value == null) {
            value = "";
        }

        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdConfigSetGuideText(Pointer.addressOf(keyBoardConfig), value);
        }

        return guideText = value;
    }

    private function set_subText(value:String):String {
        if (value == null) {
            value = "";
        }

        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdConfigSetSubText(Pointer.addressOf(keyBoardConfig), value);
        }

        return subText = value;
    }

    private function set_okButtonText(value:String):String {
        if (value == null) {
            value = "";
        }

        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdConfigSetOkButtonText(Pointer.addressOf(keyBoardConfig), value);
        }

        return okButtonText = value;
    }

    private function set_initialText(value:String):String {
        if (value == null) {
            value = "";
        }

        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdConfigSetInitialText(Pointer.addressOf(keyBoardConfig), value);
        }

        return initialText = value;
    }

    private function set_blurBackground(value:Null<Bool>):Null<Bool> {
        if (value == null) {
            value = false;
        }

        if (!keyBoardConfig.isNull()) {
            Swkbd.swkbdConfigSetBlurBackground(Pointer.addressOf(keyBoardConfig), value ? 1 : 0);
        }

        return blurBackground = value;
    }
}