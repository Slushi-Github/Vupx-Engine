package vupx.backend.logging;

import sys.io.FileOutput;
import haxe.macro.Compiler;
import haxe.PosInfos;
import haxe.Log;

import switchLib.runtime.Nxlink;
import switchLib.runtime.devices.Socket;

/**
 * The log level
 */
enum LogLevel {
    INFO;
    WARNING;
    ERROR;
    DEBUG;
}

/**
 * The debug class, used for logging
 * 
 * Author: Slushi
 */
@:cppInclude("arpa/inet.h") // Yeah.. I prefer use sys.net.Socket directly, but it don't have the things I need I guess
class VupxDebug {
    /**
     * The path to the logs directory
     */
    private static var logsPath:String = "";

    /**
     * The current log file
     */
    private static var currentLogFilePath:String = "";

    /**
     * The start time of the logger
     */
    private static var startTime:Float = Sys.time();

    /**
     * Whether the logger has started
     */
    private static var started:Bool = false;

    /**
     * The file output for the log file
     */
    private static var file:FileOutput;

    /**
     * The elapsed time from the start of the engine
     */
    public static var elapsedTime:Float = 0.0;

    /**
     * Whether to redirect logs to NXLink server
     */
    public static var redirectToNXLink:Bool = true;

    /**
     * Whether to save the logs
     * 
     * Use this if you don't want to save the logs to the 
     * log file, it should help with tests where many logs 
     * are printed that you will see on the NXLink server, as 
     * well as not having to saturate the SD card by saving data 
     * so many times. 
     */
    public static var DONT_SAVE_LOGS:Bool = false;

    /**
     * Log a message to the log file
     * @param message The message to log
     * @param level The log level
     */
    public static function log(message:Null<Dynamic>, level:Null<LogLevel> = LogLevel.INFO, ?pos:PosInfos):Void {
        #if !debug
        if (level != null && level == LogLevel.DEBUG) {
            return;
        }
        #end

        var formattedMessage:String = prepareText(Std.string(message), level ??= LogLevel.INFO, false, pos);
        var formattedMessageForNxlink:String = prepareText(Std.string(message), level ??= LogLevel.INFO, true, pos);

        if (!started) {
            Sys.println(formattedMessage);
            return;
        }

        if (redirectToNXLink) {
            Sys.println(formattedMessageForNxlink);
        }
        else {
            Sys.println(formattedMessage);
        }

        if (file != null && !DONT_SAVE_LOGS) {
            file.writeString(formattedMessage);
            file.flush();
            file.flush();
        }
    }

    /**
     * Print a message to the log file directly, without any formatting
     * @param msg The message to log
     */
    public static function printToLogFileDirectly(msg:Null<Dynamic>):Void {
        if (!started) {
            return;
        }

        if (file != null) {
            file.writeString(Std.string(msg));
            file.flush();
            file.flush();
        }

        Sys.println(msg);
    }

    /**
     * Start the logger
     */
    @:noCompletion
    public static function initLogger():Void {
        if (started) return;

        logsPath = VpStorage.getGameSDMCPath() + "engineLogs/logs/";

        try {
            if (!FileSystem.exists(logsPath)) {
                FileSystem.createDirectory(logsPath);
            }
        }
        catch (e:Dynamic) {
            throw "Error creating logs directory: " + e;
            return;
        }

        var haxenxcompilerDefinedProjectName:Null<String> = Compiler.getDefine("HAXENXCOMPILER_XML_SWITCH_PROJECTNAME");
        var haxenxcompilerDefinedVersion:Null<String> = Compiler.getDefine("HAXENXCOMPILER_VERSION");

        if (haxenxcompilerDefinedProjectName == null) {
            haxenxcompilerDefinedProjectName = "CANT_GET_HAXENXCOMPILER_XML_SWITCH_PROJECTNAME";
        }
        else {
            haxenxcompilerDefinedProjectName = haxenxcompilerDefinedProjectName.replace('"', '');
        }
        if (haxenxcompilerDefinedVersion == null) {
            haxenxcompilerDefinedVersion = "CANT_GET_HAXENXCOMPILER_VERSION";
        }
        else {
            haxenxcompilerDefinedVersion = haxenxcompilerDefinedVersion.replace('"', '');
        }

        var dateNow:String = Date.now().toString().replace(" ", "_").replace(":", "-");

        final initialFileName = haxenxcompilerDefinedProjectName == "CANT_GET_HAXENXCOMPILER_XML_SWITCH_PROJECTNAME" ? "NoProjectName" : haxenxcompilerDefinedProjectName;
        file = File.write(logsPath + initialFileName +  "_" + "VupxLog_" + dateNow + ".txt", false);   

        started = true;

        var currentDateStr:String = Date.now().toString();
        var currentTimeStr:String = getCurrentTimeString();

        // Override the Haxe Log.trace function to use our logger
        Log.trace = function(v:Dynamic, ?infos:PosInfos) {
            log(v, LogLevel.DEBUG, infos);
        }

        file.writeString("Vupx Engine [" + VupxEngine.VERSION + "] Log File\n" + " - " + currentDateStr + " | " + currentTimeStr + "\n - HaxeNXCompiler project name: " + haxenxcompilerDefinedProjectName + "\n - Compilated with HaxeNXCompiler v" + haxenxcompilerDefinedVersion + "\n-------------------\n\n");
        file.flush();
        file.flush();

        if (redirectToNXLink) {
            var rc:ResultType = Socket.socketInitializeDefault();
            if (Result.R_SUCCEEDED(rc)) {
                printToLogFileDirectly("Redirecting logs to NXLink IP: " + untyped __cpp__("inet_ntoa({0})", Nxlink.nxlink_host) + "\n");
            }

            if (Nxlink.nxlinkStdio() < 0) {
                printToLogFileDirectly("Failed to redirect logs to NXLink! Maybe it's not running or not required?\n");
            }

            printToLogFileDirectly("-------------\n");
        }

        printToLogFileDirectly("Vupx Engine logger has started!\n");
    }

    /**
     * Stop the logger
     */
    @:noCompletion
    public static function stopLogger():Void {
        if (file != null) {
            file.close();
            file = null;
        }
    }

    /**
     * Update the elapsed time
     */
    @:noCompletion
    public static function updateLogTime():Void {
        var currentTime:Float = Sys.time();
        var tempTime:Float = currentTime - startTime;
        elapsedTime = Math.fround(tempTime * 10) / 10;
    }

    /**
     * Get the current time as a string: HH:MM:SS
     * @return String
     */
    @:noCompletion
    public static function getCurrentTimeString():String {
        var now = Date.now();
        
        var hours = now.getHours();
        var minutes = now.getMinutes();
        var seconds = now.getSeconds();
        
        var hoursStr = padZero(hours, 2);
        var minutesStr = padZero(minutes, 2);
        var secondsStr = padZero(seconds, 2);
        
        return '${hoursStr}:${minutesStr}:${secondsStr}';
    }
    
    /**
     * Pad a number with zeros
     * @param value 
     * @param length 
     * @return String
     */
    private static function padZero(value:Int, length:Int):String {
        var str = Std.string(value);
        while (str.length < length) {
            str = "0" + str;
        }
        return str;
    }

    /**
     * Get the Haxe file position from PosInfos
     * @param pos 
     * @return String
     */
    private static function getHaxeFilePos(pos:PosInfos):String {
        if (pos == null) {
            return "UnknownPosition";
        }

		return pos.className + "/" + pos.methodName + ":" + pos.lineNumber;
	}

    /**
     * Prepare the text to be logged
     * @param text 
     * @param logLevel 
     * @param pos 
     * @param fornxlink
     * @return String
     */
    private static function prepareText(text:String, logLevel:LogLevel, fornxlink:Bool = false, ?pos:PosInfos):String {
        var returnText:String = "[" + getCurrentTimeString() + " (" + elapsedTime + ") | " + Std.string(logLevel) + " - " + getHaxeFilePos(pos) + "] " + text + "\n";

        // Color the log level text if we're redirecting to NXLink
        if (fornxlink) {
            var finalLogLevel:String = "";
            switch (logLevel) {
                case INFO:
                    finalLogLevel = "\x1b[38;5;7m" + Std.string(logLevel) + "\x1b[0m";
                case WARNING:
                    finalLogLevel = "\x1b[38;5;3m" + Std.string(logLevel) + "\x1b[0m";
                case ERROR:
                    finalLogLevel = "\x1b[38;5;1m" + Std.string(logLevel) + "\x1b[0m";
                case DEBUG:
                    finalLogLevel = "\x1b[38;5;5m" + Std.string(logLevel) + "\x1b[0m";
            }

            returnText = "[" + getCurrentTimeString() + " (" + elapsedTime + ") | " + finalLogLevel + " - " + getHaxeFilePos(pos) + "] " + text + "\n";
        }

        return returnText;
    }
}