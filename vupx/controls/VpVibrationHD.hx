package vupx.controls;


/**
 * A struct for holding vibration data
 */
typedef VpVibrationData = {
    var joycon:VpJoyCon;
    var duration:Float;
    var amplitude_low:Float;
    var frequency_low:Float;
    var amplitude_high:Float;
    var frequency_high:Float;
}

/**
 * Raw JSON vibration data structure
 */
typedef VpVibrationDataJson = {
    var joycon:Int;
    var duration:Float;
    var amplitude_low:Float;
    var frequency_low:Float;
    var amplitude_high:Float;
    var frequency_high:Float;
    var waitForNext:Float;
}

/**
 * JSON structure for vibration sequences
 */
typedef VpVibrationSequence = {
    var data:Array<VpVibrationDataJson>;
}

/**
 * A class for handling Joy-Con vibrations
 *
 * Author: Slushi
 */
class VpVibrationHD {
    public var isRunning:Bool = false;
    
    private var handlesPtr:RawPointer<HidVibrationDeviceHandle>;
    private var vibrationData:HidVibrationValue;
    private var currentMode:Int = 0;
    private var sequenceRunning:Bool = false;

    public function new() {
        handlesPtr = untyped __cpp__("(HidVibrationDeviceHandle*)malloc(4 * sizeof(HidVibrationDeviceHandle))");
        
        Hid.hidInitializeVibrationDevices(
            handlesPtr,
            2,
            HidNpadIdType.HidNpadIdType_Handheld,
            HidNpadStyleTag.HidNpadStyleTag_NpadHandheld
        );

        var dockedPtr:RawPointer<HidVibrationDeviceHandle> = untyped __cpp__("{0} + 2", handlesPtr);
        Hid.hidInitializeVibrationDevices(
            dockedPtr,
            2,
            HidNpadIdType.HidNpadIdType_No1,
            HidNpadStyleTag.HidNpadStyleTag_NpadJoyDual
        );

        vibrationData = new HidVibrationValue();
    }

    private inline function getHandle(joycon:VpJoyCon):HidVibrationDeviceHandle {
        var joyconIndex = (joycon == VpJoyCon.LEFT) ? 0 : 1;
        var index = currentMode * 2 + joyconIndex;
        return handlesPtr[index];
    }

    private inline function getHandlePtr(joycon:VpJoyCon):RawPointer<HidVibrationDeviceHandle> {
        var joyconIndex = (joycon == VpJoyCon.LEFT) ? 0 : 1;
        var index = currentMode * 2 + joyconIndex;
        return untyped __cpp__("{0} + {1}", handlesPtr, index);
    }

    public function updateMode(isHandheld:Bool) {
        currentMode = isHandheld ? 0 : 1;
    }

    /**
     * Vibrate a single Joy-Con
     * @param data
     */
    public function vibrate(data:VpVibrationData) {
        vibrationData.amp_low = data.amplitude_low;
        vibrationData.freq_low = data.frequency_low;
        vibrationData.amp_high = data.amplitude_high;
        vibrationData.freq_high = data.frequency_high;

        var handle = getHandle(data.joycon);
        Hid.hidSendVibrationValue(handle, Pointer.addressOf(vibrationData));

        // if duration is > 0, start a timer to stop the vibration
        if (data.duration > 0) {
            isRunning = true;
            VpTimer.after(data.duration, function() {
                stop(data.joycon);
                isRunning = false;
            });
        }
    }

    /**
     * Stop a single Joy-Con
     * @param joycon
     */
    public function stop(joycon:VpJoyCon) {
        var stopValue = new HidVibrationValue();
        stopValue.amp_low = 0;
        stopValue.amp_high = 0;
        stopValue.freq_low = 160.0;
        stopValue.freq_high = 320.0;

        var handle = getHandle(joycon);
        Hid.hidSendVibrationValue(handle, Pointer.addressOf(stopValue));
    }

    /**
     * Vibrate both Joy-Cons
     * @param data
     */
    public function vibrateBoth(data:VpVibrationData) {
        var values:Array<HidVibrationValue> = [
            createVibrationValue(data),
            createVibrationValue(data)
        ];

        var baseHandlePtr:RawPointer<HidVibrationDeviceHandle> = untyped __cpp__("{0} + {1}", handlesPtr, currentMode * 2);
        
        Hid.hidSendVibrationValues(
            baseHandlePtr,
            Pointer.arrayElem(values, 0),
            2
        );

        // if duration is > 0, start a timer to stop the vibration
        if (data.duration > 0) {
            isRunning = true;
            VpTimer.after(data.duration, function() {
                stop(LEFT);
                stop(RIGHT);
                isRunning = false;
            });
        }
    }

    /**
     * Load and play a vibration sequence from a JSON file
     * @param jsonPath Path to the JSON file
     * @return Bool True if loaded successfully, false otherwise
     */
    public function loadSequenceFromJson(jsonPath:String):Bool {

        if (!FileSystem.exists(jsonPath)) {
            trace("File not found: " + jsonPath);
            return false;
        }
        else if (jsonPath == "" || jsonPath == null) {
            trace("Invalid file path");
            return false;
        }

        try {
            var jsonContent = File.getContent(jsonPath);
            var sequence:VpVibrationSequence = Json.parse(jsonContent);
            playSequence(sequence.data);
            return true;
        } catch (e:Dynamic) {
            trace("Error loading vibration sequence: " + e);
            return false;
        }
    }

    /**
     * Load and play a vibration sequence from a JSON string
     * @param jsonString JSON string containing vibration data
     * @return Bool True if loaded successfully, false otherwise
     */
    public function loadSequenceFromString(jsonString:String):Bool {
        try {
            var sequence:VpVibrationSequence = Json.parse(jsonString);
            playSequence(sequence.data);
            return true;
        } catch (e:Dynamic) {
            trace("Error parsing vibration sequence: " + e);
            return false;
        }
    }

    /**
     * Play a sequence of vibrations
     * @param sequence Array of raw vibration data
     */
    private function playSequence(sequence:Array<VpVibrationDataJson>) {
        if (sequenceRunning) {
            trace("A sequence is already running");
            return;
        }

        sequenceRunning = true;
        executeSequenceStep(sequence, 0);
    }

    /**
     * Execute a single step in the vibration sequence
     * @param sequence The complete sequence array
     * @param index Current step index
     */
    private function executeSequenceStep(sequence:Array<VpVibrationDataJson>, index:Int) {
        if (index >= sequence.length) {
            sequenceRunning = false;
            return;
        }

        var step = sequence[index];
        
        // Convert raw data to VpVibrationData
        var vibData:VpVibrationData = {
            joycon: (step.joycon == 0) ? VpJoyCon.LEFT : VpJoyCon.RIGHT,
            duration: step.duration,
            amplitude_low: step.amplitude_low,
            frequency_low: step.frequency_low,
            amplitude_high: step.amplitude_high,
            frequency_high: step.frequency_high
        };

        // Execute vibration
        vibrate(vibData);

        // Wait for the duration + waitForNext time before the next step
        var totalWait = step.duration + step.waitForNext;
        if (totalWait > 0) {
            Timer.delay(() -> {
                executeSequenceStep(sequence, index + 1);
            }, Std.int(totalWait * 1000));
        } else {
            // If no wait time, execute next step immediately
            executeSequenceStep(sequence, index + 1);
        }
    }

    /**
     * Stop the current sequence
     */
    public function stopSequence() {
        sequenceRunning = false;
        stop(VpJoyCon.LEFT);
        stop(VpJoyCon.RIGHT);
    }

    /**
     * Create a HidVibrationValue
     * @param data
     * @return HidVibrationValue
     */
    private function createVibrationValue(data:VpVibrationData):HidVibrationValue {
        var val = new HidVibrationValue();
        val.amp_low = data.amplitude_low;
        val.freq_low = data.frequency_low;
        val.amp_high = data.amplitude_high;
        val.freq_high = data.frequency_high;
        return val;
    }
    
    public function destroy() {
        untyped __cpp__("free({0})", handlesPtr);
    }
}