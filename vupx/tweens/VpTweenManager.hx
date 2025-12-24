package vupx.tweens;

/**
 * A class that manages all VpTweens
 * 
 * Inspired in part of FlxTween of HaxeFlixel
 *
 * Author: Slushi
 */
class VpTweenManager {
    private static var tweens:Array<VpTween> = [];
    private static var isRunning:Bool = false;

    /**
     * Initializes the Tween Manager
     */
    public static function init():Void {
        tweens = new Array<VpTween>();
        isRunning = false;
    }
    
    /**
     * Adds a tween to the manager
     * @param tween 
     */
    public static function add(tween:VpTween):Void {
        if (tween == null) return;
        tweens.push(tween);
        start();
    }
    
    /**
     * Removes a tween from the manager
     * @param tween 
     */
    public static function remove(tween:VpTween):Void {
        if (tween == null) return;
        tweens.remove(tween);
    }
    
    /**
     * Cancels all tweens of a target
     * @param target 
     */
    public static function cancelTweensOf(target:Dynamic):Void {
        target ?? return;
        for (tween in tweens) {
            if (tween.target == target) {
                tween.cancel();
            }
        }
    }
    
    /**
     * Clears all tweens
     */
    public static function clear():Void {
        for (tween in tweens) {
            tween ?? continue;
            tween.cancel();
        }
        tweens = [];
    }
    
    /**
     * Starts the manager
     */
    private static function start():Void {
        if (isRunning) return;
        isRunning = true;
    }
    
    /**
     * Stops the manager
     */
    private static function stop():Void {
        if (!isRunning) return;
        
        isRunning = false;
        for (tween in tweens) {
            tween ?? continue;
            tween.cancel();
        }
        tweens = [];
    }
    
    /**
     * Updates all tweens
     * @param elapsed 
     */
    public static function update(elapsed:Float):Void {
        var dt = elapsed;

        if (tweens == null) {
            VupxDebug.log("Tweens not initialized", ERROR);
            return;
        }

        if (tweens.length == 0) {
            stop();
            return;
        }
        
        var i = tweens.length - 1;
        while (i >= 0) {
            var tween = tweens[i];
            if (tween == null) continue;
            if (tween.active) {
                tween.update();
                if (tween.finished) {
                    tweens.splice(i, 1);
                }
            } else {
                tweens.splice(i, 1);
            }
            i--;
        }
    }
    
    /**
     * Gets the number of active tweens
     * @return Int
     */
    public static function getTweenCount():Int {
        return tweens.length;
    }
    
    /**
     * Gets all active tweens of a target
     * @param target 
     * @return Array<VpTween>
     */
    public static function getActiveTweensOf(target:Dynamic):Array<VpTween> {
        target ?? return null;
        var result = [];
        for (tween in tweens) {
            tween ?? continue;
            if (tween.target == target && tween.active) {
                result.push(tween);
            }
        }
        return result;
    }
}