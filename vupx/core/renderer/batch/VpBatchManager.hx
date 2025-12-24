package vupx.core.renderer.batch;

/**
 * Batch manager, manages all batches and their sprites
 * 
 * Author: Slushi
 */
class VpBatchManager {

    /**
     * Map of batches
     */
    private static var batches:StringMap<VpBatch> = new StringMap<VpBatch>();

    /**
     * List of batches
     */
    private static var batchList:Array<VpBatch> = [];
    
    /**
     * Register sprite with all its properties (texture, camera, shader, params)
     */
    public static function registerSprite(sprite:VpBaseObject):Void {
        if (sprite == null || sprite.texture == null) return;
        
        var camera = sprite.camera != null ? sprite.camera : Vupx.camera;
        var batchKey = getBatchKey(sprite.texture, camera, sprite.postShader, sprite);
        var batch = batches.get(batchKey);
        
        if (batch == null) {
            batch = new VpBatch(sprite.texture, camera, sprite.postShader, sprite.shaderParams);
            batches.set(batchKey, batch);
            batchList.push(batch);
        }
        
        batch.addSprite(sprite);
    }
    
    /**
     * Unregister sprite
     */
    public static function unregisterSprite(sprite:VpBaseObject):Void {
        if (sprite == null || sprite.currentBatch == null) return;
        
        var batch = sprite.currentBatch;
        batch.removeSprite(sprite);
        
        // If batch is empty, remove it
        if (batch.sprites.length == 0) {
            var camera = batch.camera != null ? batch.camera : Vupx.camera;
            var batchKey = getBatchKey(batch.texture, camera, batch.postShader, null, batch.shaderParams);
            batches.remove(batchKey);
            batchList.remove(batch);
            batch.destroy();
        }
    }
    
    /**
     * Handle camera change for a sprite
     */
    public static function onSpriteCameraChanged(sprite:VpBaseObject, oldCamera:VpCamera, newCamera:VpCamera):Void {
        // Remove from old batch
        if (sprite.currentBatch != null) {
            unregisterSprite(sprite);
        }
        
        // Add to new batch (with new camera)
        registerSprite(sprite);
    }
    
    /**
     * Handle texture change
     */
    public static function onSpriteTextureChanged(sprite:VpBaseObject, oldTexture:VpTexture, newTexture:VpTexture):Void {
        if (sprite.currentBatch != null) {
            unregisterSprite(sprite);
        }
        registerSprite(sprite);
    }
    
    /**
     * Handle shader change for a sprite
     */
    public static function onSpriteShaderChanged(sprite:VpBaseObject, oldShader:VpShader, newShader:VpShader):Void {
        // Remove from old batch
        if (sprite.currentBatch != null) {
            unregisterSprite(sprite);
        }
        
        // Add to new batch (with new shader)
        registerSprite(sprite);
    }
    
    /**
     * Handle shader params change for a sprite
     */
    public static function onSpriteShaderParamsChanged(sprite:VpBaseObject):Void {
        // Check if params changed enough to warrant batch reassignment
        if (sprite.currentBatch != null) {
            // Check if current batch has same shader params
            var sameParams = true;
            
            // Simple check: compare with batch's first sprite params
            if (sprite.currentBatch.sprites.length > 0) {
                var firstSprite = sprite.currentBatch.sprites[0];
                if (firstSprite != sprite) {
                    sameParams = sprite.hasSameShaderParams(firstSprite);
                }
            }
            
            // If params differ, reassign to correct batch
            if (!sameParams) {
                unregisterSprite(sprite);
                registerSprite(sprite);
            } else {
                // Just mark as dirty if params are same but values changed
                sprite.currentBatch.markSpriteDirty(sprite);
            }
        }
    }
    
    /**
     * Force update all batches (when camera changes significantly)
     */
    public static function forceUpdateAllBatches():Void {
        for (batch in batchList) {
            batch.forceUpdateAll();
        }
    }
    
    /**
     * Render all batches
     */
    public static function renderAll():Void {
        for (batch in batchList) {
            batch.render();
        }
    }
    
    /**
     * Get unique key for texture + camera + shader + params combination
     */
    private static function getBatchKey(
        texture:VpTexture, 
        camera:VpCamera, 
        shader:Null<VpShader>,
        sprite:Null<VpBaseObject> = null,
        shaderParams:Null<StringMap<ShaderParamValue>> = null
    ):String {
        var texID = Std.string(texture.id);
        var camID = camera != null ? Std.string(camera.id) : "main";
        var shaderID = shader != null ? Std.string(shader.tag) : "none";
        
        // Build params hash
        var paramsHash = "0";
        if (sprite != null && shader != null && Lambda.count(sprite.shaderParams) > 0) {
            paramsHash = buildParamsHash(sprite.shaderParams);
        } else if (shaderParams != null && Lambda.count(shaderParams) > 0) {
            paramsHash = buildParamsHash(shaderParams);
        }
        
        return '${texID}_${camID}_${shaderID}_${paramsHash}';
    }
    
    /**
     * Build a hash string from shader parameters
     */
    private static function buildParamsHash(params:StringMap<ShaderParamValue>):String {
        if (params == null || Lambda.count(params) == 0) return "0";
        
        var keys = [for (key in params.keys()) key];
        keys.sort(function(a, b) return a < b ? -1 : 1);
        
        var hash = "";
        for (key in keys) {
            var param = params.get(key);
            hash += key + ":";
            
            for (i in 0...param.values.length) {
                var val = param.values[i];
                if (Std.isOfType(val, Float)) {
                    // Round floats to 4 decimals for hashing
                    hash += Std.string(Math.round(val * 10000) / 10000);
                } else {
                    hash += Std.string(val);
                }
                if (i < param.values.length - 1) hash += ",";
            }
            hash += ";";
        }
        
        // Simple hash function
        var hashCode = 0;
        for (i in 0...hash.length) {
            hashCode = ((hashCode << 5) - hashCode) + hash.charCodeAt(i);
            hashCode = hashCode & hashCode; // Convert to 32bit integer
        }
        
        return Std.string(Math.abs(hashCode));
    }
    
    public static function clear():Void {
        for (batch in batchList) {
            batch.destroy();
        }
        
        batches = new StringMap<VpBatch>();
        batchList = [];
    }
    
    public static function getDebugInfo():String {
        var totalSprites = 0;
        var cameraGroups:Map<VpCamera, Int> = new Map();
        var shaderGroups:Map<String, Int> = new Map();
        
        for (batch in batchList) {
            totalSprites += batch.sprites.length;
            
            var cam = batch.camera != null ? batch.camera : Vupx.camera;
            if (!cameraGroups.exists(cam)) cameraGroups.set(cam, 0);
            cameraGroups.set(cam, cameraGroups.get(cam) + 1);
            
            var shaderName = batch.postShader != null ? batch.postShader.tag : "default";
            if (!shaderGroups.exists(shaderName)) shaderGroups.set(shaderName, 0);
            shaderGroups.set(shaderName, shaderGroups.get(shaderName) + 1);
        }
        
        return 'Batches: ${batchList.length}, Sprites: ${totalSprites}, Cameras: ${Lambda.count(cameraGroups)}, Shaders: ${Lambda.count(shaderGroups)}';
    }
}