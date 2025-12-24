package vupx.utils;

import switchLib.runtime.devices.Romfs_dev;

/**
 * Simple storage functions
 * 
 * Author: Slushi
 */
class VpStorage {
    private static final engineInternalFolders:Array<String> = ["engineLogs", "engineLogs/logs", "engineLogs/crashes", "engineLogs/shadersFails", "gameSaves"];

    /**
     * Initialize the RomFS storage
     */
    @:noCompletion
    public static function initRomFS():Void {
        var rc:ResultType = Romfs_dev.romfsInit();
        if (Result.R_FAILED(rc)) {
            VupxDebug.log("Failed to initialize RomFS: " + rc, ERROR);
        }
        else {
            VupxDebug.log("RomFS initialized", INFO);
        }
    }

    /**
     * Close the RomFS storage
     */
    @:noCompletion
    public static function exitRomFS():Void {
        var rc:ResultType = Romfs_dev.romfsExit();
        if (Result.R_FAILED(rc)) {
            VupxDebug.log("Failed to exit RomFS: " + rc, ERROR);
        }
        else {
            VupxDebug.log("RomFS exited", INFO);
        }
    }

    /////////////////////////////

    /**
     * Get the console SDMC path
     * @return String
     */
    public static function getSDMCPath():String {
        return "sdmc:/";
    }

    /**
     * Get the game folder from the SDMC path
     * @return String
     */
    public static function getGameSDMCPath():String {
        return "sdmc:/switch/" + VupxEngine.projectName + "/";
    }

    /**
     * Get the RomFS path
     * @return String The RomFS path
     */
    public static function getRomFSPath():String {
        return "romfs:/";
    }

    /**
     * Create the game folder in the SDMC
     */
    @:noCompletion
    public static function createGameFoldersInSDMC():Void {
        if (!FileSystem.exists("sdmc:/")) {
            throw "SDMC not found! Are you running Atmosphere on the eMMC without a SD card? Sorry but this is not supported at the moment...";
        }

        if (!FileSystem.exists("sdmc:/switch/")) {
            FileSystem.createDirectory("sdmc:/switch/");
            VupxDebug.log("Switch folder created witch normally it should already exist?", WARNING);
        }

        try {
            if (!FileSystem.exists("sdmc:/switch/" + VupxEngine.projectName + "/")) {
                FileSystem.createDirectory("sdmc:/switch/" + VupxEngine.projectName + "/");
                VupxDebug.log("Game folder " + VupxEngine.projectName + " created", INFO);
            }
            try {
                for (engineFolder in engineInternalFolders) {
                    if (!FileSystem.exists("sdmc:/switch/" + VupxEngine.projectName + "/" + engineFolder + "/")) {
                        FileSystem.createDirectory("sdmc:/switch/" + VupxEngine.projectName + "/" + engineFolder + "/");
                        VupxDebug.log("Engine folder " + engineFolder + " created", INFO);
                    }
                }
            }
            catch (e) {
                throw "Failed to create engine folders: " + e;
            }
        } catch (e) {
            throw "Failed to create game folder: " + e;
        }
    }
}