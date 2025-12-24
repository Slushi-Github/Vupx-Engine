package vupx;

import vupx.bindings.glm.GLM;
import vupx.bindings.glm.Mat4;
import vupx.bindings.glm.Vec3;

/**
 * A 2D camera for objects
 * 
 * Author: Slushi
 */
class VpCamera extends VpBase {
    /**
     * X position of the camera
     */
    public var x(default, set):Float;

    /**
     * Y position of the camera
     */
    public var y(default, set):Float;

    /**
     * Z position of the camera
     */
    public var z(default, set):Float;

    /**
     * Zoom of the camera
     */
    public var zoom(default, set):Float;

    /**
     * Angle of the camera
     */
    public var angle(default, set):Float;

    /**
     * Alpha of the camera
     */
    public var alpha:Float = 1.0;

    /**
     * Rotation X in 3D of the camera
     */
    public var rotationX:Float = 0.0;

    /**
     * Rotation Y in 3D of the camera
     */
    public var rotationY:Float = 0.0;

    /**
     * Rotation Z in 3D of the camera
     */
    public var rotationZ:Float = 0.0;

    /**
     * Width of the camera
     */
    public var width:Int = 0;

    /**
     * Height of the camera
     */
    public var height:Int = 0;

    /**
     * Shake of the camera
     */
    public var shake:VpShakeUtil = null;

    /**
     * Minimum and maximum Z coordinates before it stops rendering
     */
    public var MIN_MAX_Z_COORD:Null<Float> = 7000.0;

    /**
     * ID of the camera
     */
    @:noCompletion
    public var id:Int;

    /**
     * Matrix of the camera
     */
    @:noCompletion
    public var matrix:Mat4;

    /**
     * Next ID available
     */
    private static var _nextID:Int = 0;

    /**
     * View matrix of the camera
     */
    private var _viewMatrix:Mat4;

    /**
     * Projection matrix of the camera
     */
    private var _projectionMatrix:Mat4;

    /**
     * Matrix dirty flag
     */
    private var _matrixDirty:Bool = true;

    /**
     * Create a new 2D camera
     * @param x X Position of the camera
     * @param y Y Position of the camera
     * @param width Width of the camera
     * @param height Height of the camera
     */
    public function new(x:Null<Float> = 0, y:Null<Float> = 0, ?width:Null<Int> = 0, ?height:Null<Int> = 0):Void {
        super();
        this.x = x ?? 0;
        this.y = y ?? 0;
        this.z = 0;
        this.zoom = 1.0;
        this.angle = 0.0;
        this.alpha = 1.0;
        this.rotationX = 0.0;
        this.rotationY = 0.0;
        this.shake = new VpShakeUtil();
        this.id = _nextID++;

        if (width == null || height == null || width <= 0 || height <= 0) {
            width = Vupx.screenWidth;
            height = Vupx.screenHeight;
        }
        
        this.width = width;
        this.height = height;
        
        MIN_MAX_Z_COORD == null || MIN_MAX_Z_COORD <= 0 ? MIN_MAX_Z_COORD = 7000.0 : MIN_MAX_Z_COORD;
        
        _projectionMatrix = GLM.ortho(0, width, height, 0, -MIN_MAX_Z_COORD, MIN_MAX_Z_COORD);
        _viewMatrix = GLM.mat4Identity();
    }

    /**
     * Set the position of the camera
     * @param x 
     * @param y 
     */
    public function setPosition(x:Float, y:Float, z:Float = 0):Void {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    /**
     * Set the zoom of the camera
     * @param zoom 
     */
    public function setZoom(zoom:Float):Void {
        this.zoom = (zoom > 0) ? zoom : 0.001;
    }
    
    /**
     * Get the projection matrix
     * @return Mat4
     */
    public function getProjectionMatrix():Mat4 {
        return _projectionMatrix;
    }
    
    /**
     * Get the view matrix
     * @return Mat4
     */
    public function getViewMatrix():Mat4 {
        if (_matrixDirty) {
            rebuildMatrix();
        }
        return _viewMatrix;
    }

    /**
     * Rebuild the view matrix for the camera using GLM
     */
    private function rebuildMatrix():Void {
        final finalX = x + shake?.getOffsetX();
        final finalY = y + shake?.getOffsetY();

        _viewMatrix = GLM.mat4Identity();
        
        _viewMatrix = GLM.translate(_viewMatrix, new Vec3(Vupx.screenWidth / 2, Vupx.screenHeight / 2, 0));
        
        _viewMatrix = GLM.scale(_viewMatrix, new Vec3(zoom, zoom, 1));
        
        if (angle != 0) {
            var angleRad = angle * (Math.PI / 180.0);
            _viewMatrix = GLM.rotate(_viewMatrix, angleRad, new Vec3(0, 0, 1));
        }
        
        _viewMatrix = GLM.translate(_viewMatrix, new Vec3(-Vupx.screenWidth / 2, -Vupx.screenHeight / 2, 0));
        
        _viewMatrix = GLM.translate(_viewMatrix, new Vec3(finalX, finalY, 0));
        
        _matrixDirty = false;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (shake != null) {
            shake.update(elapsed);
        }
    }

    override public function destroy():Void {
        super.destroy();

        if (shake != null) shake = null;
    }

    ////////////////////

    private function set_x(value:Float):Float {
        x = value;
        _matrixDirty = true;
        return value;
    }

    private function set_y(value:Float):Float {
        y = value;
        _matrixDirty = true;
        return value;
    }

    private function set_z(value:Float):Float {
        z = value;
        _matrixDirty = true;
        return value;
    }

    private function set_zoom(value:Float):Float {
        zoom = value;
        _matrixDirty = true;
        return value;
    }

    private function set_angle(value:Float):Float {
        angle = value;
        _matrixDirty = true;
        return value;
    }
}