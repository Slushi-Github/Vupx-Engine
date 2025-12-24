package vupx.tweens;

/**
 * Options for VpTween
 */
@:noCompletion
typedef TweenOptions = {
    ?onComplete: VpTween -> Void,
    ?onUpdate: VpTween -> Void,
    ?onStart: VpTween -> Void
}

/**
 * A class that handles tweening objects
 * 
 * Inspired in part of FlxTween of HaxeFlixel
 * 
 * Author: Slushi
 */
class VpTween {
    public var active:Bool = true;
    public var finished:Bool = false;
    
    public var target:Dynamic;
    private var properties:Dynamic;
    private var duration:Float;
    private var ease:Float -> Float;
    private var options:TweenOptions;
    
    private var startValues:Map<String, Float>;
    private var endValues:Map<String, Float>;
    private var elapsed:Float = 0;
    private var started:Bool = false;

    public function new(target:Dynamic, properties:Null<Dynamic>, duration:Null<Float>, ease:Null<Float -> Float>, ?options:Null<TweenOptions>) {
        if (target == null) {
            VupxDebug.log("Target cannot be null", ERROR);
            active = false;
            return;
        }
        if (!Reflect.isObject(properties)) {
            VupxDebug.log("Properties must be an object: (example: {x: 0, y: 0})", ERROR);
            active = false;
            return;
        }
        else if (duration <= 0 || duration == null) {
            VupxDebug.log("Duration must be greater than 0 or not null", ERROR);
            active = false;
            return;
        }

        this.target = target;
        this.properties = properties;
        this.duration = duration;
        this.ease = ease != null ? ease : VpEase.linear;
        this.options = options != null ? options : {};
        
        startValues = new Map<String, Float>();
        endValues = new Map<String, Float>();
        
        for (field in Reflect.fields(properties)) {

            if (Reflect.getProperty(target, field) == null) {
                VupxDebug.log("Property " + field + " not found in target " + target + ", skipping", WARNING);
                continue;
            }

            var startValue = Reflect.getProperty(target, field);
            var endValue = Reflect.getProperty(properties, field);
            if (Math.isNaN(endValue)) {
                VupxDebug.log("Property " + field + " of target " + target + " is not a number, skipping", WARNING);
                continue;
            }
            
            if (Std.isOfType(startValue, Float) || Std.isOfType(startValue, Int)) {
                startValues.set(field, cast startValue);
                endValues.set(field, cast endValue);
            }
        }
    }

    public static function tween(target:Null<Dynamic>, properties:Null<Dynamic>, duration:Null<Float>, ease:Null<Float -> Float>, ?options:Null<TweenOptions>):VpTween {
        var tween = new VpTween(target, properties, duration, ease, options);
        VpTweenManager.add(tween);
        return tween;
    }
    
    public function update():Void {
        if (!active) return;
        
        if (!started) {
            started = true;
            if (options.onStart != null) {
                options.onStart(this);
            }
        }
        
        elapsed += VpTimer.deltaTime;

        if (elapsed >= duration) {
            elapsed = duration;
            finished = true;
        }
        
        var t = elapsed / duration;
        var eased = ease(t);
        
        for (field in startValues.keys()) {
            var start = startValues.get(field);
            var end = endValues.get(field);
            var current = start + (end - start) * eased;
            Reflect.setProperty(target, field, current);
        }
        
        if (options.onUpdate != null) {
            options.onUpdate(this);
        }
        
        if (finished && options.onComplete != null) {
            options.onComplete(this);
        }
    }
    
    public function cancel():Void {
        active = false;
        finished = true;
    }
}