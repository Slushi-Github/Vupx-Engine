package vupx.math;

class VpVector3 {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    
    public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    /**
     * Add two vectors
     */
    public function add(other:VpVector3):VpVector3 {
        return new VpVector3(x + other.x, y + other.y, z + other.z);
    }
    
    /**
     * Subtract two vectors
     */
    public function subtract(other:VpVector3):VpVector3 {
        return new VpVector3(x - other.x, y - other.y, z - other.z);
    }
    
    /**
     * Scale vector by scalar
     */
    public function scale(scalar:Float):VpVector3 {
        return new VpVector3(x * scalar, y * scalar, z * scalar);
    }
    
    /**
     * Dot product
     */
    public function dot(other:VpVector3):Float {
        return x * other.x + y * other.y + z * other.z;
    }
    
    /**
     * Cross product
     */
    public function cross(other:VpVector3):VpVector3 {
        return new VpVector3(
            y * other.z - z * other.y,
            z * other.x - x * other.z,
            x * other.y - y * other.x
        );
    }
    
    /**
     * Length of vector
     */
    public function length():Float {
        return Math.sqrt(x * x + y * y + z * z);
    }
    
    /**
     * Squared length (faster than length)
     */
    public function lengthSquared():Float {
        return x * x + y * y + z * z;
    }
    
    /**
     * Normalize vector (unit vector)
     */
    public function normalize():VpVector3 {
        var len = length();
        if (len == 0) return new VpVector3(0, 0, 0);
        return new VpVector3(x / len, y / len, z / len);
    }
    
    /**
     * Distance to another vector
     */
    public function distanceTo(other:VpVector3):Float {
        return subtract(other).length();
    }
    
    /**
     * Linear interpolation
     */
    public function lerp(other:VpVector3, t:Float):VpVector3 {
        return new VpVector3(
            x + (other.x - x) * t,
            y + (other.y - y) * t,
            z + (other.z - z) * t
        );
    }
    
    /**
     * Copy vector
     */
    public function copy():VpVector3 {
        return new VpVector3(x, y, z);
    }
    
    /**
     * Set values
     */
    public function set(x:Float, y:Float, z:Float):Void {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    /**
     * String representation
     */
    public function toString():String {
        return '$x, $y, $z';
    }
}