package vupx.utils;

/**
 * Class representing an RGBA color
 * 
 * Inspired by HaxeFlixel
 * 
 * Author: Slushi
 */
abstract VpColor(Int) from Int to Int {

	public static inline final TRANSPARENT:VpColor = 0x00000000;
	public static inline final BLACK:VpColor       = 0x000000FF;
	public static inline final WHITE:VpColor       = 0xFFFFFFFF;
	public static inline final RED:VpColor         = 0xFF0000FF;
	public static inline final GREEN:VpColor       = 0x00FF00FF;
	public static inline final BLUE:VpColor        = 0x0000FFFF;
	public static inline final YELLOW:VpColor      = 0xFFFF00FF;
	public static inline final CYAN:VpColor        = 0x00FFFFFF;
	public static inline final MAGENTA:VpColor     = 0xFF00FFFF;
	public static inline final GRAY:VpColor        = 0x808080FF;

	public var red(get, set):Int;
	public var green(get, set):Int;
	public var blue(get, set):Int;
	public var alpha(get, set):Int;

	public function new(value:Int = 0) {
		this = value & 0xFFFFFFFF; // 32 bits (RGBA)
	}

	/**
	 * Creates a color from RGBA
	 * @param r The red channel
	 * @param g The green channel
	 * @param b The blue channel
	 * @param a The alpha channel
	 * @return VpColor
	 */
	public static inline function fromRGBA(r:Int, g:Int, b:Int, a:Int = 255):VpColor {
		return new VpColor(
			(bound(r) << 24) | (bound(g) << 16) | (bound(b) << 8) | bound(a)
		);
	}

	/**
	 * Creates a color from an integer
	 */
	public static inline function fromInt(value:Int):VpColor {
		return new VpColor(value);
	}

	/**
	 * Creates a color from a hex string (#RRGGBB or #RRGGBBAA)
	 */
	public static inline function fromHexString(hex:String):VpColor {
		var clean = hex.startsWith("#") ? hex.substr(1) : hex;
		var value = Std.parseInt("0x" + clean);
		// if #RRGGBB -> set alpha = 0xFF
		if (clean.length <= 6) value = (value << 8) | 0xFF;
		return new VpColor(value);
	}

	// Getters
	inline function get_red():Int   return (this >> 24) & 0xFF;
	inline function get_green():Int return (this >> 16) & 0xFF;
	inline function get_blue():Int  return (this >> 8) & 0xFF;
	inline function get_alpha():Int return this & 0xFF;

	// Setters
	inline function set_red(v:Int):Int {
		this = (this & 0x00FFFFFF) | (bound(v) << 24);
		return v;
	}

	inline function set_green(v:Int):Int {
		this = (this & 0xFF00FFFF) | (bound(v) << 16);
		return v;
	}

	inline function set_blue(v:Int):Int {
		this = (this & 0xFFFF00FF) | (bound(v) << 8);
		return v;
	}

	inline function set_alpha(v:Int):Int {
		this = (this & 0xFFFFFF00) | bound(v);
		return v;
	}

	/**
	 * Returns the color as an integer
	 */
	public inline function toInt():Int return this;
	
	/**
	 * Returns the color as a hex string (#RRGGBBAA or #RRGGBB)
	 */
	public inline function toHex(withAlpha:Bool = true):String {
		return withAlpha 
			? StringTools.hex(this, 8)
			: StringTools.hex(this >>> 8, 6);
	}

    public inline function clone():VpColor return new VpColor(this);
    
    public inline function toString():String {
        return "Color: " + toHex() + " (R: " + get_red() + 
				", G: " + get_green() + ", B: " + get_blue() + 
				", A: " + get_alpha() + ")";
    }

    @:noCompletion
	static inline function bound(v:Int):Int return v < 0 ? 0 : (v > 255 ? 255 : v);
}
