package vupx.bindings.stb_vorbis;

import cpp.Pointer;
import cpp.ConstCharStar;
import cpp.ConstPointer;

@:include("stb_vorbis/source/stb_vorbis.c")
extern class Stb_VorbisClass {
    @:native("stb_vorbis_open_filename")
    extern public static function stb_vorbis_open_filename(
        filename:ConstCharStar, 
        error:Pointer<Int>, 
        alloc:ConstPointer<Stb_vorbis_alloc>
    ):Pointer<Stb_Vorbis>;

    @:native("stb_vorbis_open_memory")
    extern public static function stb_vorbis_open_memory(
        data:Pointer<UInt8>,
        len:Int,
        error:Pointer<Int>,
        alloc:ConstPointer<Stb_vorbis_alloc>
    ):Pointer<Stb_Vorbis>;

    @:native("stb_vorbis_stream_length_in_seconds")
    extern public static function stb_vorbis_stream_length_in_seconds(f:Pointer<Stb_Vorbis>):Float;

    @:native("stb_vorbis_stream_length_in_samples")
    extern public static function stb_vorbis_stream_length_in_samples(f:Pointer<Stb_Vorbis>):UInt32;

    @:native("stb_vorbis_close")
    extern public static function stb_vorbis_close(f:Pointer<Stb_Vorbis>):Void;

    @:native("stb_vorbis_get_info")
    extern public static function stb_vorbis_get_info(f:Pointer<Stb_Vorbis>):Stb_vorbis_info;

    @:native("stb_vorbis_get_error")
    extern public static function stb_vorbis_get_error(f:Pointer<Stb_Vorbis>):Int;
}

@:native("stb_vorbis")
@:structAccess
extern class Stb_Vorbis {}

@:native("stb_vorbis_alloc")
@:structAccess
extern class Stb_vorbis_alloc {
    extern public var alloc_buffer:Pointer<Char>;
    extern public var alloc_buffer_length_in_bytes:Int;
}

@:native("stb_vorbis_info")
@:structAccess
extern class Stb_vorbis_info {
    extern public var sample_rate:UInt32;
    extern public var channels:Int;
    extern public var setup_memory_required:UInt32;
    extern public var setup_temp_memory_required:UInt32;
    extern public var temp_memory_required:UInt32;
    extern public var max_frame_size:Int;
}