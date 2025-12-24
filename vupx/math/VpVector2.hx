package vupx.math;

class VpVector2 {
    public var x:Float;
    public var y:Float;
    
    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }
    
    public function set(x:Float, y:Float):VpVector2 {
        this.x = x;
        this.y = y;
        return this;
    }
    
    public function copy():VpVector2 {
        return new VpVector2(x, y);
    }
    
    public function add(v:VpVector2):VpVector2 {
        return new VpVector2(x + v.x, y + v.y);
    }
    
    public function subtract(v:VpVector2):VpVector2 {
        return new VpVector2(x - v.x, y - v.y);
    }
    
    public function multiply(scalar:Float):VpVector2 {
        return new VpVector2(x * scalar, y * scalar);
    }
    
    public function length():Float {
        return Math.sqrt(x * x + y * y);
    }
    
    public function normalize():VpVector2 {
        var len = length();
        if (len > 0) {
            return new VpVector2(x / len, y / len);
        }
        return new VpVector2();
    }
    
    public function dot(v:VpVector2):Float {
        return x * v.x + y * v.y;
    }
    
    public function cross(v:VpVector2):VpVector2 {
        return new VpVector2(v.y * this.x - v.x * this.y);
    }
    
    public static var zero(get, never):VpVector2;
    static function get_zero():VpVector2 {
        return new VpVector2(0, 0);
    }
    
    public static var one(get, never):VpVector2;
    static function get_one():VpVector2 {
        return new VpVector2(1, 1);
    }
    
    public static var up(get, never):VpVector2;
    static function get_up():VpVector2 {
        return new VpVector2(0, 1);
    }
    
    public static var forward(get, never):VpVector2;
    static function get_forward():VpVector2 {
        return new VpVector2(0, 0);
    }
}