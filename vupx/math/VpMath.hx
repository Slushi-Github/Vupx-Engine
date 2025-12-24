package vupx.math;

/**
 * Simple math functions
 * 
 * Author: Slushi
 */
class VpMath {
    /**
     * Clamp a value between min and max
     * @param value The value to clamp
     * @param min The minimum value
     * @param max The maximum value
     * @return Float The clamped value
     */
    public static function clamp(value:Null<Float>, min:Null<Float>, max:Null<Float>):Float {
        if (value == null || min == null || max == null) return 0;
        return Math.min(Math.max(value, min), max);
    }

    /**
     * Get the sign of a number
     * @param n The number
     * @return Int The sign
     */
    public static function sign(n:Null<Float>):Int {
        if (n == 0 || n == null) return 0;
        return n > 0 ? 1 : (n < 0 ? -1 : 0);
    }
}