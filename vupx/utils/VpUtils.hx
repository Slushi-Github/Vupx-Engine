package vupx.utils;

/**
 * Some utility functions
 * 
 * Author: Slushi
 */
class VpUtils {
    /**
     * Converts bytes to a human readable format (eg. 1024 bytes = 1.00 KB)
     * @param bytes The bytes to convert
     * @param decimals The number of decimals to round to
     * 
     * @return The human readable format
     */
    public static function convertBytesWithCast(bytes:UInt64, decimals:UInt64 = 2):String {
        if ((cast bytes) == 0) return "0 Bytes";
        
        var k:Float = 1024;
        var sizes:Array<String> = ["Bytes", "KB", "MB", "GB", "TB", "PB"];
        var i:Int = Math.floor(Math.log(cast bytes) / Math.log(k));
        
        var value:Float = (cast bytes) / Math.pow(k, i);
        var rounded:Float = Math.round(value * Math.pow(10, cast decimals)) / Math.pow(10, cast decimals);
        
        return rounded + " " + sizes[i];
    }

    /**
     * Causes a crash
     */
    public static function causeACrash():Void {
        throw "Crash test!";
    }
}

