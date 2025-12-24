package vupx.backend.other;

/**
 * Builds a string with information about the HXCPP garbage collector.
 */
class MemoryUtil
{
    public static function buildGCInfo():String
    {
        #if cpp
        var result:String = 'HXCPP-Immix:';
        result += '\n- Memory Used: ${Gc.memInfo(Gc.MEM_INFO_USAGE)} bytes';
        result += '\n- Memory Reserved: ${Gc.memInfo(Gc.MEM_INFO_RESERVED)} bytes';
        result += '\n- Memory Current Pool: ${Gc.memInfo(Gc.MEM_INFO_CURRENT)} bytes';
        result += '\n- Memory Large Pool: ${Gc.memInfo(Gc.MEM_INFO_LARGE)} bytes';
        result += '\n- HXCPP Debugger: ${#if HXCPP_DEBUGGER 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Exp Generational Mode: ${#if HXCPP_GC_GENERATIONAL 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Exp Moving GC: ${#if HXCPP_GC_MOVING 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Exp Moving GC: ${#if HXCPP_GC_DYNAMIC_SIZE 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Exp Moving GC: ${#if HXCPP_GC_BIG_BLOCKS 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Debug Link: ${#if HXCPP_DEBUG_LINK 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Stack Trace: ${#if HXCPP_STACK_TRACE 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Stack Trace Line Numbers: ${#if HXCPP_STACK_LINE 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Pointer Validation: ${#if HXCPP_CHECK_POINTER 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Profiler: ${#if HXCPP_PROFILER 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP Local Telemetry: ${#if HXCPP_TELEMETRY 'Enabled' #else 'Disabled' #end}';
        result += '\n- HXCPP C++11: ${#if HXCPP_CPP11 'Enabled' #else 'Disabled' #end}';

        // Nintendo Switch specific flags
        result += '\nCustom:\n- HXCPP HX_NX: ${#if HX_NX 'Enabled' #else 'Disabled (Huh?)' #end}';

        // Slushi specific flags
        result += '\n- HXCPP Slushi Detail Null Reference: ${#if HXCPP_SL_DETAIL_NULL_REF 'Enabled' #else 'Disabled' #end}';

        #else
        var result:String = 'Unknown GC';
        #end

        return result;
    }
}