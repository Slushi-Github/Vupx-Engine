package vupx.objects;

import vupx.core.graphics.VpTextureCache;
import vupx.core.renderer.batch.VpBatchManager;

/**
 * A sprite object for displaying graphics
 * 
 * Author: Slushi
 */
class VpSprite extends VpBaseObject {
    /**
     * Create a new sprite object
     * @param x X position of the sprite
     * @param y Y position of the sprite
     */
    public function new(x:Null<Float> = 0, y:Null<Float> = 0):Void {
        super();
        this.x = x;
        this.y = y;
        this.texture = null;
    }

    /**
     * Load an image from a PNG file
     * @param filePath Path to the image
     */
    public function loadImage(filePath:Null<String>):Void {
        this.texture = VpTextureCache.get(filePath);
        if (this.texture == null) {
            VupxDebug.log("Failed to load texture!", ERROR);
            return;
        }
        
        this.texture.isCached = true;
        this.isTextureFromCache = true;
        this.ownsTexture = false;
        this.readyToRender = true;
        this.visible = true;
        this.dirty = true;
    }

    /**
     * Create a new sprite from a color and size
     * @param width Width of the graphic
     * @param height Height of the graphic
     * @param color Color of the graphic
     */
    public function makeGraphic(width:Null<Int> = 1, height:Null<Int> = 1, color:Null<VpColor> = VpColor.WHITE):Void {
        this.texture = VpTextureCache.createGraphic(width, height, color);
        if (this.texture == null) {
            VupxDebug.log("Failed to create graphic", ERROR);
            return;
        }

        this.isTextureFromCache = false;
        this.ownsTexture = true;
        this.readyToRender = true;
        this.dirty = true; 
    }
}