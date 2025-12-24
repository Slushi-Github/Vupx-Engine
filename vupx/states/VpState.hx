package vupx.states;

import vupx.core.renderer.batch.VpBatchManager;
import vupx.objects.VpBaseObject;
import vupx.groups.VpGroup;

/**
 * The base class for all states in the game
 * 
 * Author: Slushi
 */
class VpState extends VpBase {
    /**
     * The list of objects in the state
     */
    private var _objects:Array<VpBase> = [];

    /**
     * The sub state of the current state
     */
    public var subState:Null<VpSubState> = null;

    public function new() {
        super();
    }

    override public function create():Void {
        super.create();

        for (obj in _objects) {
            if (obj == null) continue;
            obj.create();
        }

        if (subState != null) {
            subState.create();
        }

        VpModulesManager.callModulesFunction(STATE_CREATE);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        for (obj in _objects) {
            if (obj == null) continue;
            obj.update(elapsed);
        }

        if (subState != null) {
            subState.update(elapsed);
        }

        VpModulesManager.callModulesFunction(STATE_UPDATE, elapsed);
    }

    override public function render():Void {
        super.render();

        VpBatchManager.renderAll();

        // Only render objects that are NOT VpBaseObject (in case there are other types)
        for (obj in _objects) {
            if (obj == null) {
                continue;
            }
            
            if (!Std.isOfType(obj, VpBaseObject)) {
                obj.render();
            }
        }

        VpModulesManager.callModulesFunction(STATE_RENDER);

        if (subState != null) {
            subState.render();
        }
    }

    override public function destroy():Void {
        super.destroy();
        
        for (obj in _objects) {
            if (obj == null) continue;
            obj.destroy();
        }
        
        if (subState != null) {
            subState.destroy();
        }

        VpModulesManager.callModulesFunction(STATE_DESTROY);
        
        // Clear batches
        VpBatchManager.clear();
        
        _objects = [];
    }

    /////////////////////////////

    /**
     * Add an object to the state
     * @param obj The object to add
     */
    public function add(obj:Null<VpBase>):Void {
        if (obj == null) return;
        
        _objects.push(obj);
        
        // If it's a VpGroup, register all its sprites
        if (Std.isOfType(obj, VpGroup)) {
            var group:VpGroup<Dynamic> = cast obj;
            group.onRegistered();
        }
        // If it's a VpBaseObject (sprite), register it to the batch
        else if (Std.isOfType(obj, VpBaseObject)) {
            var sprite:VpBaseObject = cast obj;
            VpBatchManager.registerSprite(sprite);
        }
    }

    /**
     * Remove an object from the state
     * @param obj The object to remove
     */
    public function remove(obj:Null<VpBase>):Void {
        if (obj == null) return;
        
        // If it's a VpGroup, unregister all its sprites
        if (Std.isOfType(obj, VpGroup)) {
            var group:VpGroup<Dynamic> = cast obj;
            group.onUnregistered();
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

    /**
     * Insert an object after another
     * @param afterObj The object to insert after
     * @param obj The object to insert
     */
    public function insertAfter(afterObj:Null<VpBase>, obj:Null<VpBase>):Void {
        if (afterObj == null || obj == null) return;
        
        _objects.insert(_objects.indexOf(afterObj) + 1, obj);
        
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
    
    /**
     * Initialize the sub state
     * @param subState The substate to initialize
     */
    public function initSubState(subState:Null<VpSubState>):Void {
        if (subState == null) return;

        if (this.subState != null) {
            this.subState.destroy();
        }

        this.subState = subState;
        this.subState.active = true;
        this.subState.create();
    }

    /**
     * Close the sub state
     */
    public function closeSubState():Void {
        if (subState != null) {
            subState.close();
            subState = null;
        }
    }
}