package vupx.groups;

import vupx.VpBase;
import vupx.objects.VpBaseObject;
import vupx.core.renderer.batch.VpBatchManager;

/**
 * A group of objects, used to manage multiple objects at once
 */
class VpGroup<T:VpBase> extends VpBase {
    /**
     * List of objects in the group
     */
    public var objectsList:Array<T>;

    /**
     * The length of the group
     */
    public var length(get, never):Int;

    private function get_length():Int {
        if (objectsList == null) {
            return 0;
        }
        return objectsList.length;
    }
    
    /**
     * Flag to know if the group is registered (added to a state/substate)
     */
    private var _isRegistered:Bool = false;

    /**
     * Create a new group
     */
    public function new() {
        super();

        objectsList = new Array<T>();
    }

    /**
     * Add an object to the group
     * @param item The object to add
     */
    public function add(item:T):Void {
        if (item != null && !objectsList.contains(item)) {
            objectsList.push(item);
            
            // If the group is already registered, register the sprite immediately
            if (_isRegistered && Std.isOfType(item, VpBaseObject)) {
                var sprite:VpBaseObject = cast item;
                VpBatchManager.registerSprite(sprite);
            }
        }
    }

    /**
     * Remove an object from the group
     * @param item The object to remove
     */
    public function remove(item:T):Void {
        if (item == null) {
            return;
        }

        // If it's a sprite and the group is registered, unregister it
        if (_isRegistered && Std.isOfType(item, VpBaseObject)) {
            var sprite:VpBaseObject = cast item;
            VpBatchManager.unregisterSprite(sprite);
        }

        objectsList.remove(item);
    }

    /**
     * Get an object from the group by index
     * 
     * @param index The index of the object
     * @return T The object at the index, or null if the index is out of bounds
     */
    public function get(index:Int):T {
        if (index < 0 || index >= objectsList.length) {
            return null;
        }
        return objectsList[index];
    }

    override public function create():Void {
        super.create();

        for (obj in objectsList) {
            if (obj == null) {
                continue;
            }
            obj.create();
        }
    }

    override public function update(elapsed:Float):Void {
        for (obj in objectsList) {
            if (obj == null) {
                continue;
            }
            obj.update(elapsed);
        }
    }

    override public function render():Void {
        // Only render objects that are NOT VpBaseObject (in case there are other types)
        for (obj in objectsList) {
            if (obj == null) {
                continue;
            }
            
            if (!Std.isOfType(obj, VpBaseObject)) {
                obj.render();
            }
        }
    }

    override public function destroy():Void {
        super.destroy();

        // Unregister all sprites if the group was registered
        if (_isRegistered) {
            unregisterAllSprites();
        }

        for (obj in objectsList) {
            if (obj == null) {
                continue;
            }
            obj.destroy();
        }
        
        objectsList = [];
    }
    
    /**
     * Called when the group is added to a state/substate
     * 
     * Registers all sprites in the group to the batch manager
     */
    public function onRegistered():Void {
        if (_isRegistered) return;
        
        _isRegistered = true;
        registerAllSprites();
    }
    
    /**
     * Called when the group is removed from a state/substate
     * 
     * Unregisters all sprites in the group from the batch manager
     */
    public function onUnregistered():Void {
        if (!_isRegistered) return;
        
        _isRegistered = false;
        unregisterAllSprites();
    }
    
    /**
     * Register all sprites in the group to the batch manager
     */
    private function registerAllSprites():Void {
        for (obj in objectsList) {
            if (obj == null) continue;
            
            if (Std.isOfType(obj, VpBaseObject)) {
                var sprite:VpBaseObject = cast obj;
                VpBatchManager.registerSprite(sprite);
            }
        }
    }
    
    /**
     * Unregister all sprites in the group from the batch manager
     */
    private function unregisterAllSprites():Void {
        for (obj in objectsList) {
            if (obj == null) continue;
            
            if (Std.isOfType(obj, VpBaseObject)) {
                var sprite:VpBaseObject = cast obj;
                VpBatchManager.unregisterSprite(sprite);
            }
        }
    }
    
    /**
     * Clear all objects from the group
     */
    public function clear():Void {
        if (_isRegistered) {
            unregisterAllSprites();
        }
        
        for (obj in objectsList) {
            if (obj == null) continue;
            obj.destroy();
        }
        
        objectsList = [];
    }
}