package vupx.utils;

/**
 * Simple shake effect
 * 
 * Author: Slushi
 */
class VpShakeUtil {
    public var intensity:Float = 0;
    public var duration:Float = 0;
    public var active(get, never):Bool;
    
    private var _timer:Float = 0;
    private var _offsetX:Float = 0;
    private var _offsetY:Float = 0;
    
    public function new() {}
    
    /**
     * Start a shake effect
     * @param intensity How strong the shake is (in pixels)
     * @param duration How long it lasts (in seconds)
     */
    public function shake(intensity:Float = 5, duration:Float = 0.3):Void {
        this.intensity = intensity;
        this.duration = duration;
        this._timer = 0;
    }
    
    /**
     * Update the shake
     * @param elapsed Time since last frame
     */
    public function update(elapsed:Float):Void {
        if (!active) return;
        
        _timer += elapsed;
        
        // Random offset
        _offsetX = (Math.random() * 2 - 1) * intensity;
        _offsetY = (Math.random() * 2 - 1) * intensity;
        
        // Decay over time
        var progress = _timer / duration;
        intensity *= (1 - progress * 0.1);
        
        if (_timer >= duration) {
            stop();
        }
    }
    
    public function getOffsetX():Float {
        return active ? _offsetX : 0;
    }
    
    public function getOffsetY():Float {
        return active ? _offsetY : 0;
    }
    
    public function stop():Void {
        intensity = 0;
        _timer = duration;
        _offsetX = 0;
        _offsetY = 0;
    }
    
    private function get_active():Bool {
        return _timer < duration && intensity > 0.1;
    }
}