package vupx.controls;

import haxe.ds.Vector;
/**
 * Object representing a touch With data of that touch
 */
typedef VpTouch = {
    id:Int,
    x:Float,
    y:Float,
    diameter_x:Float,
    diameter_y:Float,
    rotation_angle:Float
}

/**
 * A class for handling Switch touch screen input
 * 
 * Author: Slushi
 */
class VpTouchScreen {
    /**
     * Current touches on the touch screen
     */
    public var touches(get, never):Vector<VpTouch>;

    /**
     * State of the touch screen
     */
    private var _touchStates:HidTouchScreenState;
    
    /**
     * Number of touches on the touch screen
     */
    private var _touchCount:Int32 = 0;

    /**
     * Previous touch count from last frame
     */
    private var _previousTouchCount:Int32 = 0;

    /**
     * List of touches on the touch screen
     */
    private var _touches:Vector<VpTouch>;

    /**
     * Previous frame touch IDs for tracking justPressed/justReleased
     */
    private var _previousTouchIds:Array<Int>;

    /**
     * Current frame touch IDs
     */
    private var _currentTouchIds:Array<Int>;

    /**
     * Initialize the touch screen and get the current touch states
     */
    public function new() {
        _touchStates = new HidTouchScreenState();
        _touchCount = 0;
        _previousTouchCount = 0;
        // The Switch touch screen has a maximum of 10 touches, so we can store up to 10
        _touches = new Vector<VpTouch>(10);
        _previousTouchIds = [];
        _currentTouchIds = [];

        Hid.hidInitializeTouchScreen();
        Hid.hidGetTouchScreenStates(Pointer.addressOf(_touchStates), 1);
    }

    /**
     * Update the current touch states
     */
    public function update() {
        // Store previous state
        _previousTouchCount = _touchCount;
        _previousTouchIds = _currentTouchIds.copy();
        
        // Get new state
        Hid.hidGetTouchScreenStates(Pointer.addressOf(_touchStates), 1);
        _touchCount = _touchStates.count;
        
        // Update current touch IDs
        _currentTouchIds = [];
        for (i in 0..._touchCount) {
            _currentTouchIds.push(_touchStates.touches[i].finger_id);
        }
    }

        /**
     * Check if a touch with specific ID is currently pressed
     * @param id Touch finger ID
     * @return Bool
     */
    public function isPressed(id:Int):Bool {
        return _currentTouchIds.indexOf(id) != -1;
    }

    /**
     * Check if a touch with specific ID was just pressed this frame
     * @param id Touch finger ID
     * @return Bool
     */
    public function isJustPressed(id:Int):Bool {
        return _currentTouchIds.indexOf(id) != -1 && _previousTouchIds.indexOf(id) == -1;
    }

    /**
     * Check if a touch with specific ID is currently released
     * @param id Touch finger ID
     * @return Bool
     */
    public function isReleased(id:Int):Bool {
        return _currentTouchIds.indexOf(id) == -1;
    }

    /**
     * Check if a touch with specific ID was just released this frame
     * @param id Touch finger ID
     * @return Bool
     */
    public function isJustReleased(id:Int):Bool {
        return _currentTouchIds.indexOf(id) == -1 && _previousTouchIds.indexOf(id) != -1;
    }

    /**
     * Check if there are any touches currently active
     * @return Bool
     */
    public function anyPressed():Bool {
        return _touchCount > 0;
    }

    /**
     * Check if ANY touch was just pressed this frame
     * @return Bool
     */
    public function anyJustPressed():Bool {
        return _touchCount > 0 && _previousTouchCount == 0;
    }

    /**
     * Check if there are any touches currently released
     * @return Bool
     */
    public function anyReleased():Bool {
        return _touchCount == 0 && _previousTouchCount > 0;
    }

    /**
     * Check if ALL touches were just released this frame
     * @return Bool
     */
    public function anyJustReleased():Bool {
        return _touchCount == 0 && _previousTouchCount > 0;
    }

    /**
     * Checks if the touchscreen is touching a specific object
     * @param object The object to check
     * @return Bool
     */
    public function isTouchingAObject(object:VpBaseObject):Bool {
        if (!anyPressed() || object == null) return false;

        var touchX = getById(0).x;
        var touchY = getById(0).y;

        return (touchX >= object.x &&
                touchX <= object.x + object.width &&
                touchY >= object.y &&
                touchY <= object.y + object.height);
    }

    /**
     * Estimate the pressure of a touch
     * 
     * THIS METHOD IS EXTREMELY EXPERIMENTAL AND IS AN **APPROXIMATION**. 
     * THE CONSOLE'S TOUCHSCREEN WAS NOT DESIGNED WITH THIS IN MIND
     * 
     * @param touch The touch to estimate
     * @return Float The pressure of the touch between 0.0 and 1.0
     */
    public function estimatePressure(touchId:Null<Int>):Float {
        if (touchId < 0 || touchId > 10 || touchId == null) {
            return 0.0;
        }

        // Get touch data
        for (i in 0..._touchCount) {
            if (_touchStates.touches[i].finger_id == touchId) {
                var touchData = _touchStates.touches[i];
                var area = (touchData.diameter_x * touchData.diameter_y);
                
                // Define pressure range
                var minArea = 100.0;
                var maxArea = 10000.0;
                
                // Calculate pressure
                var pressure = (area - minArea) / (maxArea - minArea);
                return Math.max(0.0, Math.min(1.0, pressure));
            }
        }
        return 0.0; // Touch not found
    }

    /**
     * Get a touch by id 
     * @param id Touch ID
     * @return VpTouch The touch data, or null if not found
     */
    public function getById(id:Null<Int>):Null<VpTouch> {
        if (id < 0 || id > 10 || id == null) {
            return null;
        }

        for (i in 0..._touchCount) {
            if (_touchStates.touches[i].finger_id == id) {
                return {
                    id: _touchStates.touches[i].finger_id,
                    x: _touchStates.touches[i].x,
                    y: _touchStates.touches[i].y,
                    diameter_x: _touchStates.touches[i].diameter_x,
                    diameter_y: _touchStates.touches[i].diameter_y,
                    rotation_angle: _touchStates.touches[i].rotation_angle
                };
            }
        }
        return null;
    }

    ////////////////////////////////////

    /**
     * Get the current touches
     * @return Vector<VpTouch>
     */
    private function get_touches():Vector<VpTouch> {
        _touches = new Vector<VpTouch>(_touchCount);
        
        for (i in 0..._touchCount) {
            for (j in 0..._touches.length) {
                id: _touchStates.touches[i].finger_id,
                x: _touchStates.touches[i].x,
                y: _touchStates.touches[i].y,
                diameter_x: _touchStates.touches[i].diameter_x,
                diameter_y: _touchStates.touches[i].diameter_y,
                rotation_angle: _touchStates.touches[i].rotation_angle
            };
        }
        
        return _touches;
    }
}