




package vupx.utils;

/**
 * Utility class for saving and loading game saves saved in JSON files in the SDMC
 * 
 * I have to admit that I am satisfied with this class...
 * 
 * Author: Slushi
 */
class VpSaveUtil {
    private var loaded:Null<Dynamic> = null;

    public function new() {
        this.loaded = null;
    }

    /**
     * Load a save file
     * @param fileName Name of the save file
     */
    public function load(fileName:Null<String>):Null<Dynamic> {
        if (fileName == null || fileName == "") {
            VupxDebug.log("Invalid save file name!", ERROR);
            return null;
        }

        var filePath = VpStorage.getGameSDMCPath() + "/gameSaves/" + fileName + ".vpSave";
        if (!FileSystem.exists(filePath)) {
            VupxDebug.log("Save file not found!", ERROR);
            return null;
        }

        try {
            var jsonString = File.getContent(filePath);
            this.loaded = Json.parse(jsonString);
            VupxDebug.log("Save file [" + fileName + "] loaded!", INFO);
            return this.loaded;
        }
        catch (e:Dynamic) {
            VupxDebug.log("Error loading save file [" + fileName + "]: " + e, ERROR);
        }
        return null;
    }

    /**
     * Save the current save data to a file
     * @param fileName Name of the save file
     */
    public function save(fileName:Null<String>):Null<Dynamic> {
        if (fileName == null || fileName == "") {
            VupxDebug.log("Invalid save file name!", ERROR);
            return null;
        }

        var savePath = VpStorage.getGameSDMCPath() + "/gameSaves/";
        if (!FileSystem.exists(savePath)) {
            FileSystem.createDirectory(savePath);
        }

        var filePath = savePath + fileName + ".vpSave";
        try {
            File.saveContent(filePath, Json.stringify(this.loaded, null, "  "));
            VupxDebug.log("Save file [" + fileName + "] saved!", INFO);
            return this.loaded;
        }
        catch (e:Dynamic) {
            VupxDebug.log("Error saving save file [" + fileName + "]: " + e, ERROR);
        }
        return null;
    }

    /**
     * Gets an object using dot notation (e.g.: "player.xOffset")
     * @param fieldPath Field path separated by dots
     * @param defaultValue Default value if the field doesn't exist
     * @return The found value or defaultValue
     */
    public function getObject<T>(fieldPath:Null<String>, ?defaultValue:T):Null<T> {
        if (fieldPath == null || fieldPath == "") {
            VupxDebug.log("Invalid field path!", ERROR);
            return defaultValue;
        }
        if (this.loaded == null) {
            VupxDebug.log("Save file not loaded!", ERROR);
            return defaultValue;
        }

        var parts = fieldPath.split(".");
        var current:Dynamic = this.loaded;

        for (i in 0...parts.length) {
            var part = parts[i];
            
            if (!Reflect.hasField(current, part)) {
                VupxDebug.log('Field "$fieldPath" not found (missing: $part)', WARNING);
                return defaultValue;
            }

            current = Reflect.field(current, part);
            
            if (current == null && i < parts.length - 1) {
                VupxDebug.log('Field "$fieldPath" is null at: $part', WARNING);
                return defaultValue;
            }
        }

        return current;
    }

    /**
     * Sets an object using dot notation (ej: "player.xOffset")
     * If the object doesn't exist, it will be created
     * @param fieldPath Field path separated by dots
     * @param value Value to set
     * @return The set value
     */
    public function setObject(fieldPath:Null<String>, value:Dynamic):Null<Dynamic> {
        if (fieldPath == null || fieldPath == "") {
            VupxDebug.log("Invalid field path!", ERROR);
            return null;
        }
        if (this.loaded == null) {
            VupxDebug.log("Save file not loaded!", ERROR);
            return null;
        }

        var parts = fieldPath.split(".");
        var current:Dynamic = this.loaded;

        for (i in 0...parts.length - 1) {
            var part = parts[i];
            
            if (!Reflect.hasField(current, part)) {
                // Create intermediate object if it doesn't exist
                Reflect.setField(current, part, {});
                VupxDebug.log('Created intermediate object: $part', DEBUG);
            }
            
            current = Reflect.field(current, part);
            
            if (current == null) {
                VupxDebug.log('Cannot set field "$fieldPath": null at $part', ERROR);
                return null;
            }
        }
        var finalField = parts[parts.length - 1];
        Reflect.setField(current, finalField, value);
        VupxDebug.log('Set field "$fieldPath" = $value', DEBUG);
        
        return value;
    }

    /**
     * Checks if a field exists (using dot notation)
     * @param fieldPath Path to the field
     * @return true if the field exists
     */
    public function hasField(fieldPath:Null<String>):Bool {
        if (fieldPath == null || fieldPath == "" || this.loaded == null) {
            return false;
        }

        var parts = fieldPath.split(".");
        var current:Dynamic = this.loaded;

        for (part in parts) {
            if (!Reflect.hasField(current, part)) {
                return false;
            }
            current = Reflect.field(current, part);
            if (current == null) {
                return false;
            }
        }

        return true;
    }

    /**
     * deletes a field (using dot notation)
     * @param fieldPath Path to the field
     * @return true if the field was deleted
     */
    public function deleteField(fieldPath:Null<String>):Bool {
        if (fieldPath == null || fieldPath == "" || this.loaded == null) {
            return false;
        }

        var parts = fieldPath.split(".");
        var current:Dynamic = this.loaded;

        for (i in 0...parts.length - 1) {
            var part = parts[i];
            if (!Reflect.hasField(current, part)) {
                return false;
            }
            current = Reflect.field(current, part);
            if (current == null) {
                return false;
            }
        }

        var finalField = parts[parts.length - 1];
        if (Reflect.hasField(current, finalField)) {
            Reflect.deleteField(current, finalField);
            VupxDebug.log('Deleted field: $fieldPath', INFO);
            return true;
        }

        return false;
    }

    /**
     * Get the fields of an object
     * @param fieldPath 
     * @return Array<String>
     */
    public function getFields(fieldPath:String = ""):Array<String> {
        if (this.loaded == null) {
            return [];
        }

        var target:Dynamic = this.loaded;
        
        if (fieldPath != "") {
            var parts = fieldPath.split(".");
            for (part in parts) {
                if (!Reflect.hasField(target, part)) {
                    return [];
                }
                target = Reflect.field(target, part);
                if (target == null) {
                    return [];
                }
            }
        }

        return Reflect.fields(target);
    }

    /**
     * Create a new save file
     */
    public function createNew():Void {
        this.loaded = {};
        VupxDebug.log("New save file created!", INFO);
    }

    /**
     * Check if the save file is loaded
     */
    public function isLoaded():Bool {
        return this.loaded != null;
    }

    /**
     * Get the root object
     */
    public function getRootObject():Null<Dynamic> {
        return this.loaded;
    }

    /**
     * Sets the root object
     */
    public function setRootObject(data:Dynamic):Void {
        if (data == null) {
            VupxDebug.log("Invalid root object!", ERROR);
            return;
        }
        this.loaded = data;
        VupxDebug.log("Root object updated!", INFO);
    }
}