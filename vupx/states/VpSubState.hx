package vupx.states;

import vupx.core.renderer.batch.VpBatchManager;
import vupx.objects.VpBaseObject;
import vupx.groups.VpGroup;

/**
 * The base class for all subStates in the game
 * 
 * Author: Slushi
 */
class VpSubState extends VpBase {
    /**
     * The list of objects in the subState
     */
    private var _objects:Array<VpBase> = [];

    public var active:Bool = false;

    public function new() {
        super();
    }

    override public function create():Void {
        super.create();

        VpModulesManager.callModulesFunction(SUB_STATE_CREATE);

        for (obj in _objects) {
            if (obj == null) continue;
            obj.create();
        }
        
        // Register all sprites and groups when the substate is created
        registerAllSpritesAndGroups();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (!active) return;

        for (obj in _objects) {
            if (obj == null) continue;
            obj.update(elapsed);
        }
    }

    override public function render():Void {
        super.render();

        if (!active) return;

        VpModulesManager.callModulesFunction(SUB_STATE_RENDER);
    }

    override public function destroy():Void {
        super.destroy();

        VpModulesManager.callModulesFunction(SUB_STATE_DESTROY);

        // Unregister all sprites and groups before destroying
        unregisterAllSpritesAndGroups();

        for (obj in _objects) {
            if (obj == null) continue;
            obj.destroy();
        }

        _objects = [];
    }

    /////////////////////////////

    /**
     * Add an object to the subState
     * @param obj The object to add
     */
    public function add(obj:Null<VpBase>):Void {
        if (obj == null) return;
        
        _objects.push(obj);
        
        if (active) {
            // If it's a VpGroup, register all its sprites
            if (Std.isOfType(obj, VpGroup)) {
                var group:VpGroup<Dynamic> = cast obj;
                group.onRegistered();
            }
            // If it's a VpBaseObject (sprite), register it
            else if (Std.isOfType(obj, VpBaseObject)) {
                var sprite:VpBaseObject = cast obj;
                VpBatchManager.registerSprite(sprite);
            }
        }
    }

    /**
     * Remove an object from the subState
     * @param obj The object to remove
     */
    public function remove(obj:Null<VpBase>):Void {
        if (obj == null) return;
        
        // If it's a VpGroup, unregister all its sprites
        if (Std.isOfType(obj, VpGroup)) {
            var group:VpGroup<Dynamic> = cast obj;
            group.onUnregistered();
        }
        // If it's a VpBaseObject (sprite), unregister it from the batch
        else if (Std.isOfType(obj, VpBaseObject)) {
            var sprite:VpBaseObject = cast obj;
            VpBatchManager.unregisterSprite(sprite);
        }
        
        obj.destroy();
        _objects.remove(obj);
    }

    /**
     * Insert an object before another
     * @param behindObj The object to insert before
     * @param obj The object to insert
     */
    public function insert(behindObj:Null<VpBase>, obj:Null<VpBase>):Void {
        if (behindObj == null || obj == null) return;
        
        _objects.insert(_objects.indexOf(behindObj), obj);
        
        if (active) {
            // Register group or sprite
            if (Std.isOfType(obj, VpGroup)) {
                var group:VpGroup<Dynamic> = cast obj;
                group.onRegistered();
            }
            else if (Std.isOfType(obj, VpBaseObject)) {
                var sprite:VpBaseObject = cast obj;
                VpBatchManager.registerSprite(sprite);
            }
        }
    }

    /**
     * Insert an object after another
     * @param afterObj The object to insert after
     * @param obj The object to insert
     */
    public function insertAfter(afterObj:Null<VpBase>, obj:Null<VpBase>):Void {
        if (afterObj == null || obj == null) return;
        
        _objects.insert(_objects.indexOf(afterObj) + 1, obj);
        
        if (active) {
            // Register group or sprite
            if (Std.isOfType(obj, VpGroup)) {
                var group:VpGroup<Dynamic> = cast obj;
                group.onRegistered();
            }
            else if (Std.isOfType(obj, VpBaseObject)) {
                var sprite:VpBaseObject = cast obj;
                VpBatchManager.registerSprite(sprite);
            }
        }
    }

    /**
     * Close the substate
     */
    public function close():Void {
        // Unregister all sprites and groups before closing
        VpModulesManager.callModulesFunction(SUB_STATE_CLOSE);
        unregisterAllSpritesAndGroups();
        destroy();
        active = false;
    }
    
    /**
     * Register all sprites and groups in the substate to the batch manager
     */
    private function registerAllSpritesAndGroups():Void {
        for (obj in _objects) {
            if (obj == null) continue;
            
            if (Std.isOfType(obj, VpGroup)) {
                var group:VpGroup<Dynamic> = cast obj;
                group.onRegistered();
            }
            else if (Std.isOfType(obj, VpBaseObject)) {
                var sprite:VpBaseObject = cast obj;
                VpBatchManager.registerSprite(sprite);
            }
        }
    }
    
    /**
     * Unregister all sprites and groups in the substate from the batch manager
     */
    private function unregisterAllSpritesAndGroups():Void {
        for (obj in _objects) {
            if (obj == null) continue;
            
            if (Std.isOfType(obj, VpGroup)) {
                var group:VpGroup<Dynamic> = cast obj;
                group.onUnregistered();
            }
            else if (Std.isOfType(obj, VpBaseObject)) {
                var sprite:VpBaseObject = cast obj;
                VpBatchManager.unregisterSprite(sprite);
            }
        }
    }
}