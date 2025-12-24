package vupx.math;

/**
 * Simple 2D rectangle
 *
 * Author: Slushi
 */
class VpRect {
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}