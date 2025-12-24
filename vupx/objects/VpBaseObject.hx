package vupx.objects;

/**
 * Center mode of the object
 */
enum ScreenCenterMode {
    CENTER_X;
    CENTER_Y;
    CENTER_XY;
}

/**
 * Pivot point for X-axis rotation (vertical flip)
 */
enum RotationPivotX {
    TOP;  
    CENTER;   // Default
    BOTTOM;
}

/**
 * Pivot point for Y-axis rotation (horizontal flip)
 */
enum RotationPivotY {
    LEFT;
    CENTER;   // Default
    RIGHT;
}

/**
 * Pivot point for Z-axis rotation (Angle)
 */
enum RotationPivotAngle {
    TOP_LEFT;
    TOP_CENTER;
    TOP_RIGHT;
    CENTER_LEFT;
    CENTER;        // Default
    CENTER_RIGHT;
    BOTTOM_LEFT;
    BOTTOM_CENTER;
    BOTTOM_RIGHT;
}

/**
 * Shader parameter value structure
 */
typedef ShaderParamValue = {
    type:ShaderVariable,
    values:Array<Dynamic>
}

/**
 * Base class for all objects
 * 
 * Author: Slushi
 */
class VpBaseObject extends VpBase {
    /**
     * Height of the object.
     */
    public var width(get, set):Null<Int>;

    /**
     * Height of the object.
     */
    public var height(get, set):Null<Int>;

    /**
     * X coordinate of the object.
     */
    public var x(default, set):Null<Float>;

    /**
     * Y coordinate of the object.
     */
    public var y(default, set):Null<Float>;

    /**
     * Z coordinate of the object.
     */
    public var z(default, set):Null<Float> = 0;

    /**
     * Rotation X in 3D of the object.
     */
    public var rotationX(default, set):Null<Float> = 0;

    /**
     * Rotation Y in 3D of the object.
     */
    public var rotationY(default, set):Null<Float> = 0;

    /**
     * Rotation Z in 3D of the object.
     */
    public var rotationZ(default, set):Null<Float> = 0;

    /**
     * Width of the object.
     */
    public var angle(default, set):Null<Float> = 0;

    /**
     * Alpha of the object.
     */
    public var alpha(default, set):Null<Float> = 1;
    
    /**
     * If the object is enabled
     */
    public var enabled(default, set):Null<Bool> = true;

    /**
     * If the object is visible
     */
    public var visible(default, set):Null<Bool> = true;

    /**
     * If the object is ready to be rendered
     */
    public var readyToRender:Null<Bool> = false;

    /**
     * Scale of the object.
     */
    public var scale:Null<VpVector2> = new VpVector2(1, 1);

    /**
     * Scale X of the object.
     */
    public var scaleX(get, set):Null<Float>;

    /**
     * Scale Y of the object.
     */
    public var scaleY(get, set):Null<Float>;

    /**
     * The color of the object
     */
    public var color(default, set):Null<VpColor> = VpColor.WHITE;

    /**
     * The camera of the object
     */
    public var camera(get, set):Null<VpCamera>;

    /**
     * The texture of the object
     */
    public var shake:Null<VpShakeUtil> = null;

    /**
     * Texture of the sprite
     */
    public var texture:Null<VpTexture> = null;

    /**
     * Flip the texture horizontally
     */
    public var flipX(default, set):Bool = false;

    /**
     * Flip the texture vertically
     */
    public var flipY(default, set):Bool = false;

    /**
     * Is the object dirty
     */
    @:noCompletion
    public var dirty:Bool = false;

    /**
     * Index of this sprite in its batch
     */
    @:noCompletion
    public var batchIndex:Int = -1;

    /**
     * The batch this sprite belongs to
     */
    @:noCompletion
    public var currentBatch:Null<VpBatch> = null;

    /**
     * If the texture is from the cache
     */
    @:noCompletion
    public var isTextureFromCache:Bool = false;

    /**
     * If the texture is owned by this object
     */
    @:noCompletion
    public var ownsTexture:Bool = false;
    
    /**
     * Cached rotation matrix
     */
    @:noCompletion
    public var cachedRotMatrix:Array<Float32> = [];

    /**
     * If the rotation matrix is dirty
     */
    @:noCompletion
    public var rotMatrixDirty:Bool = true;

    /**
     * If the object is a child of another object
     */
    public var parent:Null<VpBaseObject> = null;

    /**
     * Custom UVs
     * Format: [u0, v0, u1, v1]
     */
    public var customUV:Array<Float> = null;

    /**
     * Strength of perspective effect for this object (0.0 = no perspective, 1.0 = full)
     */
    public var perspectiveStrength:Float = 0.5;

    /**
     * Pivot point for X-axis rotation
     */
    public var rotationPivotX:RotationPivotX = CENTER;

    /**
     * Pivot point for Y-axis rotation
     */
    public var rotationPivotY:RotationPivotY = CENTER;

    /**
     * Pivot point for Z-axis rotation
     */
    public var rotationPivotAngle:RotationPivotAngle = CENTER;

    /**
     * Skew X (horizontal shear)
     */
    public var skewX(default, set):Null<Float> = 0;

    /**
     * Skew Y (vertical shear)
     */
    public var skewY(default, set):Null<Float> = 0;
    
    /**
     * Custom post-process shader for this sprite
     */
    public var postShader(default, set):Null<VpShader> = null;
    
    /**
     * Shader parameters for the post-process shader
     */
    public var shaderParams:StringMap<ShaderParamValue> = new StringMap<ShaderParamValue>();
    
    /**
     * The camera of the object
     */
    private var _camera:Null<VpCamera> = null;

    /**
     * Custom width of the object
     */
    private var _customWidth:Null<Int> = null;

    /**
     * Custom height of the object
     */
    private var _customHeight:Null<Int> = null;

    /**
     * Flag to identify this as a text character
     */
    private var _isTextCharacter:Bool = false;

    /////////////////////////////

    public function new():Void {
        super();

        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.rotationX = 0;
        this.rotationY = 0;
        this.rotationZ = 0;
        this.width = 0;
        this.height = 0;
        this.angle = 0;
        this.scale = new VpVector2(1, 1);
        this.visible = true;
        this.alpha = 1.0;
        this.enabled = true;
        this.readyToRender = false;
        this.texture = null;
        this.flipX = false;
        this.flipY = false;
        this.skewX = 0;
        this.skewY = 0;

        this.color = VpColor.WHITE;
        this.camera = Vupx.camera;
        this.shake = new VpShakeUtil();
        this.dirty = false;
        
        this.shaderParams = new StringMap<ShaderParamValue>();
    }

    /**
     * Set a post-process shader for this sprite
     * @param shader The shader to use (null to remove)
     */
    public function setPostShader(shader:Null<VpShader>):Void {
        if (this.postShader == shader) return;
        
        var oldShader = this.postShader;
        this.postShader = shader;
        
        if (currentBatch != null) {
            VpBatchManager.onSpriteShaderChanged(this, oldShader, shader);
        }
    }
    
    /**
     * Set a shader parameter value
     * @param name Uniform name
     * @param type Shader variable type
     * @param values Variable arguments for the value
     */
    public function setShaderParam(name:String, type:ShaderVariable, ...values:Dynamic):Void {
        if (name == null || name == "") return;
        
        var paramValue:ShaderParamValue = {
            type: type,
            values: values
        };
        
        shaderParams.set(name, paramValue);
        
        if (currentBatch != null) {
            VpBatchManager.onSpriteShaderParamsChanged(this);
        }
    }
    
    /**
     * Get a shader parameter value
     * @param name Uniform name
     * @return ShaderParamValue or null
     */
    public function getShaderParam(name:String):Null<ShaderParamValue> {
        return shaderParams.get(name);
    }
    
    /**
     * Remove a shader parameter
     * @param name Uniform name
     */
    public function removeShaderParam(name:String):Void {
        if (!shaderParams.exists(name)) return;
        
        shaderParams.remove(name);
        
        if (currentBatch != null) {
            VpBatchManager.onSpriteShaderParamsChanged(this);
        }
    }
    
    /**
     * Clear all shader parameters
     */
    public function clearShaderParams():Void {
        if (Lambda.count(shaderParams) == 0) return;
        
        shaderParams = new StringMap<ShaderParamValue>();
        
        if (currentBatch != null) {
            VpBatchManager.onSpriteShaderParamsChanged(this);
        }
    }
    
    /**
     * Check if shader parameters are equal to another sprite
     */
    @:noCompletion
    public function hasSameShaderParams(other:VpBaseObject):Bool {
        if (other == null) return false;
        
        var thisKeys = [for (key in shaderParams.keys()) key];
        var otherKeys = [for (key in other.shaderParams.keys()) key];
        
        if (thisKeys.length != otherKeys.length) return false;
        
        for (key in thisKeys) {
            if (!other.shaderParams.exists(key)) return false;
            
            var thisParam = shaderParams.get(key);
            var otherParam = other.shaderParams.get(key);
            
            if (thisParam.type != otherParam.type) return false;
            if (thisParam.values.length != otherParam.values.length) return false;
            
            // Compare values with tolerance for floats
            for (i in 0...thisParam.values.length) {
                var thisVal = thisParam.values[i];
                var otherVal = otherParam.values[i];
                
                if (Std.isOfType(thisVal, Float) && Std.isOfType(otherVal, Float)) {
                    if (Math.abs(thisVal - otherVal) > 0.0001) return false;
                } else {
                    if (thisVal != otherVal) return false;
                }
            }
        }
        
        return true;
    }
    
    /**
     * Calculates the model matrix
     * @return Mat4
     */
    public function calculateModelMatrix():Mat4 {
        var finalX = this.x + (this.shake != null ? this.shake.getOffsetX() : 0);
        var finalY = this.y + (this.shake != null ? this.shake.getOffsetY() : 0);
        
        var spriteWidth = this.width * this.scale.x;
        var spriteHeight = this.height * this.scale.y;
        
        var model = GLM.mat4Identity();
        
        // Translation to final position
        model = GLM.translate(model, new Vec3(finalX, finalY, 0));
        
        // Scale
        model = GLM.scale(model, new Vec3(spriteWidth, spriteHeight, 1.0));
        
        // Calculate offset for angle pivot
        var pivotOffsetZ = getPivotOffsetAngle();
        
        // Descent to pivot
        model = GLM.translate(model, new Vec3(pivotOffsetZ.x, pivotOffsetZ.y, 0));
        
        // Add Z
        final finalZ = this.z / 500.0;
        model = GLM.translate(model, new Vec3(0, 0, finalZ));
        
        // Apply skew
        if (this.skewX != 0 || this.skewY != 0) {
            model = applySkew(model, this.skewX, this.skewY);
        }
        
        // Apply rotation
        var rad = Math.PI / 180.0;
        var angleX = this.rotationX * rad;
        var angleY = this.rotationY * rad;
        var angleZ = (this.rotationZ + this.angle) * rad;
        
        if (angleX != 0 || angleY != 0 || angleZ != 0) {
            if (angleX != 0 || angleY != 0) {
                var pivotOffsetX = getPivotOffsetX();
                var pivotOffsetY = getPivotOffsetY();
                
                model = GLM.translate(model, new Vec3(0, pivotOffsetX, 0));
                model = GLM.translate(model, new Vec3(pivotOffsetY, 0, 0));
                
                var rotMatrix = GLM.eulerAngleXYZ(angleX, angleY, angleZ);
                model = Mat4.mul(model, rotMatrix);
                
                model = GLM.translate(model, new Vec3(0, -pivotOffsetX, 0));
                model = GLM.translate(model, new Vec3(-pivotOffsetY, 0, 0));
            } else {
                GLM.rotate(model, angleZ, new Vec3(0, 0, 1));
            }
        }
        
        // Center
        model = GLM.translate(model, new Vec3(-pivotOffsetZ.x, -pivotOffsetZ.y, 0));
        
        return model;
    }

    
    /**
     * Checks if the object has any rotations
     */
    public function hasRotations():Bool {
        return rotationX != 0 || rotationY != 0 || rotationZ != 0 || angle != 0 || skewX != 0 || skewY != 0;
    }

    /**
     * Notify the batch manager of changes
     */
    @:noCompletion
    public function notifyBatch():Void {
        if (currentBatch != null) {
            currentBatch.markSpriteDirty(this);
        }
    }

    /**
     * Set the texture and handle batch reassignment
     */
    public function setTexture(newTexture:VpTexture, fromCache:Bool = false):Void {
        if (this.texture == newTexture) return;
        
        var oldTexture = this.texture;
        var wasFromCache = this.isTextureFromCache;
        
        this.texture = newTexture;
        this.isTextureFromCache = fromCache;
        
        // Release old texture if needed
        if (oldTexture != null) {
            if (wasFromCache) {
                VpTextureCache.release(oldTexture);
            } else if (ownsTexture) {
                oldTexture.destroy();
            }
        }

        if (oldTexture != null || newTexture != null) {
            VpBatchManager.onSpriteTextureChanged(this, oldTexture, newTexture);
        }
    }

    /**
     * Resize the object
     * @param scaleX The scale in the X direction
     * @param scaleY The scale in the Y direction
     */
    public function resize(scaleX:Null<Float> = 1, scaleY:Null<Float> = 1):Void {
        var newW = Std.int(this.width * scaleX ?? 1);
        var newH = Std.int(this.height * scaleY ?? 1);
        this.width = (newW > 0) ? newW : 1;
        this.height = (newH > 0) ? newH : 1;
        this.scale.set(scaleX ?? 1, scaleY ?? 1);
    }

    /**
     * Set the position of the object
     * @param x The X coordinate of the object
     * @param y The Y coordinate of the object
     */
    public function setPosition(x:Null<Float> = 0, y:Null<Float> = 0):Void {
        this.x = x ?? 0;
        this.y = y ?? 0;
    }

    /**
     * Center the object in the screen
     * @param centerMode The mode to center the object
     */
    public function center(?centerMode:Null<ScreenCenterMode> = ScreenCenterMode.CENTER_XY):Void {
        if (this.width <= 0 || this.height <= 0) {
            VupxDebug.log("Object dimensions invalid before centering", ERROR);
            return;
        }

        var realW = this.width * this.scale.x;
        var realH = this.height * this.scale.y;

        centerMode ??= ScreenCenterMode.CENTER_XY;

        switch (centerMode) {
            case ScreenCenterMode.CENTER_X:
                this.x = (Vupx.screenWidth - realW) / 2;
            case ScreenCenterMode.CENTER_Y:
                this.y = (Vupx.screenHeight - realH) / 2;
            case ScreenCenterMode.CENTER_XY:
                this.x = (Vupx.screenWidth - realW) / 2;
                this.y = (Vupx.screenHeight - realH) / 2;
            default:
                VupxDebug.log("Invalid center mode!", ERROR);
                return;
        }
    }

    /*
     * Disable the object
     */
    public function disable():Void {
        this.enabled = false;
        notifyBatch();
    }

    /**
     * Reset the object (enabled)
     */
    public function reset():Void {
        this.enabled = true;
        notifyBatch();
    }

    /**
     * Resize the object to fit the screen
     */
    public function resizeToFitScreen():Void {
        if (this.width <= 0 || this.height <= 0) {
            VupxDebug.log("Object dimensions invalid before resizing to fit screen", ERROR);
            return;
        }

        // Reset scale
        this.scale.x = 1;
        this.scale.y = 1;

        var scaleX = Vupx.screenWidth / this.width;
        var scaleY = Vupx.screenHeight / this.height;

        if (scaleX <= 0 || scaleY <= 0) {
            VupxDebug.log("Invalid scale values for resizing to fit screen", ERROR);
            return;
        }

        this.resize(scaleX, scaleY);
        this.center(CENTER_XY);
    }

    /**
     * Set the custom UV coordinates
     */
    public function setCustomUV(u0:Float, v0:Float, u1:Float, v1:Float):Void {
        if (customUV == null) customUV = [0, 0, 1, 1];
        customUV[0] = u0;
        customUV[1] = v0;
        customUV[2] = u1;
        customUV[3] = v1;
        notifyBatch();
    }

    /**
     * Set the custom size
     */
    public function setSize(width:Int, height:Int):Void {
        _customWidth = width;
        _customHeight = height;
        notifyBatch();
    }

    /////////////////////////////

    /**
     * Apply skew to a matrix
     */
    private function applySkew(matrix:Mat4, skewX:Float, skewY:Float):Mat4 {
        // Convert degrees to radians
        var rad = Math.PI / 180.0;
        var tanX = Math.tan(skewX * rad);
        var tanY = Math.tan(skewY * rad);
        
        // Create skew matrix
        // [  1   tanY  0  0 ]
        // [ tanX  1   0  0 ]
        // [  0    0   1  0 ]
        // [  0    0   0  1 ]
        var skewMatrix = GLM.mat4Identity();
        
        // Modify skew matrix data
        untyped __cpp__("
            {0}[0][1] = {1};  // skewX afecta a Y basado en X
            {0}[1][0] = {2};  // skewY afecta a X basado en Y
        ", skewMatrix, tanX, tanY);
        
        return Mat4.mul(matrix, skewMatrix);
    }

    private function get_camera():Null<VpCamera> {
        return _camera != null ? _camera : Vupx.camera;
    }
    
    private function set_camera(value:Null<VpCamera>):Null<VpCamera> {
        if (_camera == value) return value;
        
        var oldCamera = _camera;
        _camera = value;
        
        if (currentBatch != null) {
            VpBatchManager.onSpriteCameraChanged(this, oldCamera, value);
        }
        
        return value;
    }
    
    private function set_postShader(value:Null<VpShader>):Null<VpShader> {
        if (postShader == value) return value;
        
        var oldShader = postShader;
        postShader = value;
        
        if (currentBatch != null) {
            VpBatchManager.onSpriteShaderChanged(this, oldShader, value);
        }
        
        return value;
    }

    public function set_x(value:Null<Float>):Null<Float> {
        if (value == null || this.x == value) return value;
        this.x = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    public function set_y(value:Null<Float>):Null<Float> {
        if (value == null || this.y == value) return value;
        this.y = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    public function set_z(value:Null<Float>):Null<Float> {
        if (value == null || this.z == value) return value;
        this.z = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    public function set_rotationX(value:Null<Float>):Null<Float> {
        if (value == null || this.rotationX == value) return value;
        this.rotationX = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    public function set_rotationY(value:Null<Float>):Null<Float> {
        if (value == null || this.rotationY == value) return value;
        this.rotationY = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    public function set_rotationZ(value:Null<Float>):Null<Float> {
        if (value == null || this.rotationZ == value) return value;
        this.rotationZ = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    public function set_angle(value:Null<Float>):Null<Float> {
        if (value == null || this.angle == value) return value;
        this.angle = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    public function set_alpha(value:Null<Float>):Null<Float> {
        if (value == null || this.alpha == value) return value;
        this.alpha = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    public function set_enabled(value:Null<Bool>):Null<Bool> {
        if (this.enabled == value) return value;
        this.enabled = value;
        notifyBatch();
        return value;
    }

    public function set_visible(value:Null<Bool>):Null<Bool> {
        if (this.visible == value) return value;
        this.visible = value;
        notifyBatch();
        return value;
    }

    public function set_flipX(value:Bool):Bool {
        if (this.flipX == value) return value;
        this.flipX = value;
        notifyBatch();
        return value;
    }

    public function set_flipY(value:Bool):Bool {
        if (this.flipY == value) return value;
        this.flipY = value;
        notifyBatch();
        return value;
    }

    public function set_color(value:Null<VpColor>):Null<VpColor> {
        if (value == null || this.color == value) return value;
        this.color = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    private function get_width():Int {
        if (_customWidth != null) return _customWidth;
        if (texture == null) return 0;
        return texture.width;
    }

    private function get_height():Int {
        if (_customHeight != null) return _customHeight;
        if (texture == null) return 0;
        return texture.height;
    }

    private function set_width(value:Null<Int>):Null<Int> {
        if (value == null) return value;
        
        if (isTextureFromCache) {
            _customWidth = value;
            this.dirty = true;
            notifyBatch();
            return value;
        }
        
        if (texture != null) {
            texture.width = value;
        }
        
        this.dirty = true;
        notifyBatch();
        return value;
    }

    private function set_height(value:Null<Int>):Null<Int> {
        if (value == null) return value;
        
        if (isTextureFromCache) {
            _customHeight = value;
            this.dirty = true;
            notifyBatch();
            return value;
        }
        
        if (texture != null) {
            texture.height = value;
        }
        
        this.dirty = true;
        notifyBatch();
        return value;
    }

    private function set_scaleX(value:Null<Float>):Null<Float> {
        if (value == null || this.scale == null || this.scale.x == value) return value;
        this.scale.x = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    private function set_scaleY(value:Null<Float>):Null<Float> {
        if (value == null || this.scale == null || this.scale.y == value) return value;
        this.scale.y = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    private function get_scaleX():Null<Float> {
        if (this.scale == null) return 0;
        return this.scale.x;
    }

    private function set_skewX(value:Null<Float>):Null<Float> {
        if (value == null || this.skewX == value) return value;
        this.skewX = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    private function set_skewY(value:Null<Float>):Null<Float> {
        if (value == null || this.skewY == value) return value;
        this.skewY = value;
        this.dirty = true;
        notifyBatch();
        return value;
    }

    /**
     * Get pivot offset X
     */
    private function getPivotOffsetX():Float {
        return switch(rotationPivotX) {
            case TOP: -0.5;
            case CENTER: 0.0;
            case BOTTOM: 0.5;
        }
    }

    /**
     * Get pivot offset Y
     */
    private function getPivotOffsetY():Float {
        return switch(rotationPivotY) {
            case LEFT: -0.5;
            case CENTER: 0.0;
            case RIGHT: 0.5;
        }
    }

    /**
     * Get pivot offset angle
     */
    private function getPivotOffsetAngle():{x:Float, y:Float} {
        return switch(rotationPivotAngle) {
            case TOP_LEFT:      {x: 0.0, y: 0.0};
            case TOP_CENTER:    {x: 0.5, y: 0.0};
            case TOP_RIGHT:     {x: 1.0, y: 0.0};
            case CENTER_LEFT:   {x: 0.0, y: 0.5};
            case CENTER:        {x: 0.5, y: 0.5};
            case CENTER_RIGHT:  {x: 1.0, y: 0.5};
            case BOTTOM_LEFT:   {x: 0.0, y: 1.0};
            case BOTTOM_CENTER: {x: 0.5, y: 1.0};
            case BOTTOM_RIGHT:  {x: 1.0, y: 1.0};
        }
    }

    /**
     * Set pivot angle
     */
    public function setPivotZ(pivot:RotationPivotAngle):Void {
        if (this.rotationPivotAngle == pivot) return;
        this.rotationPivotAngle = pivot;
        this.dirty = true;
        notifyBatch();
    }

    /**
     * Set pivot X and Y
     */
    public function setPivotXY(pivotX:RotationPivotX, pivotY:RotationPivotY):Void {
        var changed = false;
        
        if (this.rotationPivotX != pivotX) {
            this.rotationPivotX = pivotX;
            changed = true;
        }
        
        if (this.rotationPivotY != pivotY) {
            this.rotationPivotY = pivotY;
            changed = true;
        }
        
        if (changed) {
            this.dirty = true;
            notifyBatch();
        }
    }

    private function get_scaleY():Null<Float> {
        if (this.scale == null) return 0;
        return this.scale.y;
    }

    override public function destroy():Void {
        super.destroy();

        if (currentBatch != null) {
            VpBatchManager.unregisterSprite(this);
        }

        this.angle = 0;
        this.rotationY = 0;
        this.rotationX = 0;
        this.scale = null;
        this.y = 0;
        this.x = 0;
        this.height = 0;
        this.width = 0;
        this.texture = null;
        this.enabled = false;
        this.visible = false;
        this.postShader = null;
        this.shaderParams = null;
    }
}