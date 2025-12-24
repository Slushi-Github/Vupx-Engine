package vupx.core;

/**
 * Contains constant or defaults values or data used throughout the Vupx Engine
 * 
 * Author: Slushi
 */
class VpConstants {
    /**
     * Base vertex shader source code for batches
     */
    public static var VUPX_BATCH_BASE_VERTEX_SHADER(get, never):String;

    /**
     * Base fragment shader source code for batches
     */
    public static var VUPX_BATCH_BASE_FRAGMENT_SHADER(get, never):String;

    /**
     * Post process vertex shader source code
     */
    public static var VUPX_POST_PROCESS_VERTEX_SHADER(get, never):String;

    /**
     * Post process fragment shader source code
     */
    public static var VUPX_POST_PROCESS_FRAGMENT_SHADER(get, never):String;

    /**
     * Default font path for texts
     */
    public static var VUPX_DEFAULT_FONT_PATH(get, never):String;

    /**
     * Spartan MB Extra Bold font path
     */
    public static var VUPX_SPARTAN_MB_EXTB_FONT_PATH(get, never):String;

    ///////////////////////////////////////////

    private static function get_VUPX_BATCH_BASE_VERTEX_SHADER():String {
        return File.getContent(VpStorage.getRomFSPath() + "VUPX_ASSETS/shaders/baseShaders/BaseVertexInstancedBatchShader.vert");
    }

    private static function get_VUPX_BATCH_BASE_FRAGMENT_SHADER():String {
        return File.getContent(VpStorage.getRomFSPath() + "VUPX_ASSETS/shaders/baseShaders/BaseFragmentInstancedBatchShader.frag");
    }

    private static function get_VUPX_POST_PROCESS_VERTEX_SHADER():String {
        return File.getContent(VpStorage.getRomFSPath() + "VUPX_ASSETS/shaders/baseShaders/BaseVertexPostProcessShader.vert");
    }

    private static function get_VUPX_POST_PROCESS_FRAGMENT_SHADER():String {
        return File.getContent(VpStorage.getRomFSPath() + "VUPX_ASSETS/shaders/baseShaders/BaseFragmentPostProcessShader.frag");
    }

    private static function get_VUPX_DEFAULT_FONT_PATH():String {
        return VpStorage.getRomFSPath() + "VUPX_ASSETS/fonts/nokiafc22.ttf";
    }

    private static function get_VUPX_SPARTAN_MB_EXTB_FONT_PATH():String {
        return VpStorage.getRomFSPath() + "VUPX_ASSETS/fonts/spartan-mb.extrabold.ttf";
    }
}