package vupx.objects;


/**
 * Text alignment options
 */
enum TextAlignment {
    LEFT;
    CENTER;
    RIGHT;
}

/**
 * Line information for a line of text
 */
private typedef LineInfo = {
    text:String,
    width:Float,
    yOffset:Float,
    startIndex:Int,
    endIndex:Int
}

/**
 * Individual character information
 */
private typedef CharInfo = {
    localX:Float,
    localY:Float,
    charWidth:Float,
    charHeight:Float,
    s0:Float,
    t0:Float,
    s1:Float,
    t1:Float
}

/**
 * Text object for rendering text
 * 
 * Author: Slushi
 */
class VpText extends VpBaseObject {
    /**
     * Font to use
     */
    public var font:VpTextFont;

    /**
     * Text alignment
     */
    public var alignment(default, set):TextAlignment;
    
    /**
     * Maximum width of the text
     */
    public var maxWidth(default, set):Null<Float> = null;
    
    /**
     * Text of this text object
     */
    public var text(get, set):String;

    /**
     * Text of this text object
     */
    private var _text:String = "";
    
    /**
     * Array of character sprites
     */
    private var charSprites:Array<VpTextCharacter> = [];
    
    /**
     * Valid character indices for this text
     */
    private var validIndices:Array<Int> = [];
    
    /**
     * Text model matrix
     */
    private var cachedModelMatrix:Mat4;

    /**
     * Matrix dirty flag
     */
    private var matrixDirty:Bool = true;
    
    /**
     * Text width
     */
    private var textWidth:Float = 0;

    /**
     * Text height
     */
    private var textHeight:Float = 0;
    
    /**
     * Minimum Xcoordinate of the text
     */
    private var minX:Float = 0;

    /**
     * Minimum Y coordinate of the text
     */
    private var minY:Float = 0;

    /**
     * Perspective strength of the text
     */
    private final textCharPerspectiveStrength:Float = 0.5;
    
    /**
     * Create a new text object
     * 
     * Example:
     * ```
     * var text = new VpText(0, 0, "Hello world", "assets/fonts/arial.ttf", 32);
     * ```
     * 
     * -----
     * 
     * @param x 
     * @param y 
     * @param text 
     * @param fontPath 
     * @param fontSize 
     */
    public function new(x:Float, y:Float, text:String, fontPath:String, fontSize:Float) {
        super();
        
        this.x = x;
        this.y = y;
        
        font = VpTextFont.get(fontPath, fontSize);
        
        if (font == null || font.atlasTexture == null) {
            VupxDebug.log("Failed to load text font", ERROR);
            return;
        }
        
        this.texture = null;
        this.isTextureFromCache = false;
        this.readyToRender = false;
        
        setText(text);
    }
    
    /**
     * Set the text of this text object
     * @param newText 
     */
    public function setText(newText:String):Void {
        if (_text == newText) return;
        _text = newText != null ? newText : "";
        
        clearCharSprites();
        
        if (_text == "") {
            validIndices = [];
            textWidth = 0;
            textHeight = 0;
            minX = 0;
            minY = 0;
            matrixDirty = true;
            return;
        }
        
        buildValidIndices();
        
        var lines:Array<LineInfo> = calculateLines();
        
        var allChars:Array<CharInfo> = [];
        for (line in lines) {
            collectCharsForLine(line, allChars);
        }
        
        calculateBoundingBox(allChars);
        
        for (char in allChars) {
            createCharSprite(char);
        }
        
        this.dirty = true;
        matrixDirty = true;
    }
    
    /**
     * Builds an array of valid character indices
     */
    private function buildValidIndices():Void {
        validIndices = [];
        
        for (i in 0..._text.length) {
            var charCode = _text.charCodeAt(i);
            
            // Detect line breaks
            if (charCode == 10) continue;
            if (charCode < font.firstChar || charCode >= font.firstChar + font.numChars) continue;
            
            validIndices.push(i);
        }
    }
    
    /**
     * Calculate the lines of the text
     */
    private function calculateLines():Array<LineInfo> {
        var lines:Array<LineInfo> = [];
        var currentLine:String = "";
        var currentWidth:Float = 0;
        var yPos:Float = 0;
        var lineStartIndex:Int = 0;
        var xPos:Float = 0;
        var validIndexCounter:Int = 0;
        
        for (i in 0..._text.length) {
            var charCode = _text.charCodeAt(i);
            
            // line break
            if (charCode == 10) {
                lines.push({
                    text: currentLine,
                    width: currentWidth,
                    yOffset: yPos,
                    startIndex: lineStartIndex,
                    endIndex: validIndexCounter
                });
                
                currentLine = "";
                currentWidth = 0;
                xPos = 0;
                yPos += font.fontSize;
                lineStartIndex = validIndexCounter;
                continue;
            }
            
            // Check if it's a valid character
            if (charCode < font.firstChar || charCode >= font.firstChar + font.numChars) {
                continue;
            }
            
            var charWidth = getCharWidth(charCode, xPos);
            xPos += charWidth;
            currentWidth = xPos;
            currentLine += String.fromCharCode(charCode);
            validIndexCounter++;
        }
        
        if (currentLine != "") {
            lines.push({
                text: currentLine,
                width: currentWidth,
                yOffset: yPos,
                startIndex: lineStartIndex,
                endIndex: validIndexCounter
            });
        }
        
        return lines;
    }
    
    /**
     * Get the width of a character
     */
    private function getCharWidth(charCode:Int, currentX:Float):Float {
        var quadPtr:Pointer<Stbtt_aligned_quad> = Stdlib.malloc(Stdlib.sizeof(Stbtt_aligned_quad));
        var xFloatPtr:Pointer<Float32> = Stdlib.malloc(Stdlib.sizeof(Float32));
        var yFloatPtr:Pointer<Float32> = Stdlib.malloc(Stdlib.sizeof(Float32));
        
        xFloatPtr[0] = cast currentX;
        yFloatPtr[0] = 0;
        
        Stb_TrueType.GetBakedQuad(
            font.charData,
            font.atlasSize,
            font.atlasSize,
            charCode - font.firstChar,
            xFloatPtr,
            yFloatPtr,
            quadPtr,
            1
        );
        
        var newX = xFloatPtr[0];
        var width = newX - currentX;
        
        Stdlib.free(quadPtr);
        Stdlib.free(xFloatPtr);
        Stdlib.free(yFloatPtr);
        
        return width;
    }
    
    /**
     * Collect all characters for a line
     */
    private function collectCharsForLine(line:LineInfo, allChars:Array<CharInfo>):Void {
        var xOffset:Float = calculateXOffset(line.width);
        var xPos:Float = 0;
        
        for (i in line.startIndex...line.endIndex) {
            if (i >= validIndices.length) {
                VupxDebug.log('Index out of bounds: $i >= ${validIndices.length}', WARNING);
                break;
            }
            
            var textIndex = validIndices[i];
            var charCode = _text.charCodeAt(textIndex);
            
            var quadPtr:Pointer<Stbtt_aligned_quad> = Stdlib.malloc(Stdlib.sizeof(Stbtt_aligned_quad));
            var xFloatPtr:Pointer<Float32> = Stdlib.malloc(Stdlib.sizeof(Float32));
            var yFloatPtr:Pointer<Float32> = Stdlib.malloc(Stdlib.sizeof(Float32));
            
            xFloatPtr[0] = cast xPos;
            yFloatPtr[0] = 0;
            
            Stb_TrueType.GetBakedQuad(
                font.charData,
                font.atlasSize,
                font.atlasSize,
                charCode - font.firstChar,
                xFloatPtr,
                yFloatPtr,
                quadPtr,
                1
            );
            
            var x0 = quadPtr.ptr.x0;
            var y0 = quadPtr.ptr.y0;
            var x1 = quadPtr.ptr.x1;
            var y1 = quadPtr.ptr.y1;
            var s0 = quadPtr.ptr.s0;
            var t0 = quadPtr.ptr.t0;
            var s1 = quadPtr.ptr.s1;
            var t1 = quadPtr.ptr.t1;
            
            xPos = xFloatPtr[0];
            
            Stdlib.free(quadPtr);
            Stdlib.free(xFloatPtr);
            Stdlib.free(yFloatPtr);
            
            allChars.push({
                localX: x0 + xOffset,
                localY: y0 + line.yOffset,
                charWidth: x1 - x0,
                charHeight: y1 - y0,
                s0: s0,
                t0: t0,
                s1: s1,
                t1: t1
            });
        }
    }
    
    /**
     * Calculate the bounding box
     */
    private function calculateBoundingBox(chars:Array<CharInfo>):Void {
        if (chars.length == 0) {
            textWidth = 0;
            textHeight = 0;
            minX = 0;
            minY = 0;
            return;
        }
        
        var maxX:Float = Math.NEGATIVE_INFINITY;
        var maxY:Float = Math.NEGATIVE_INFINITY;
        minX = Math.POSITIVE_INFINITY;
        minY = Math.POSITIVE_INFINITY;
        
        for (char in chars) {
            var x0 = char.localX;
            var y0 = char.localY;
            var x1 = char.localX + char.charWidth;
            var y1 = char.localY + char.charHeight;
            
            if (x0 < minX) minX = x0;
            if (y0 < minY) minY = y0;
            if (x1 > maxX) maxX = x1;
            if (y1 > maxY) maxY = y1;
        }
        
        textWidth = maxX - minX;
        textHeight = maxY - minY;
    }
    
    /**
     * Create a character sprite
     */
    private function createCharSprite(char:CharInfo):Void {
        var adjustedX = char.localX - minX;
        var adjustedY = char.localY - minY;
        
        var charSprite = new VpTextCharacter(this, adjustedX, adjustedY, char.charWidth, char.charHeight);
        charSprite.setCustomUV(char.s0, char.t0, char.s1, char.t1);
        
        charSprite.alpha = this.alpha;
        charSprite.color = this.color;
        charSprite.camera = this.camera;
        charSprite.visible = this.visible;
        charSprite.enabled = this.enabled;
        charSprite.flipX = this.flipX;
        charSprite.flipY = this.flipY;
        
        charSprites.push(charSprite);
        VpBatchManager.registerSprite(charSprite);
    }
    
    /**
     * Calculate the X offset
     */
    private function calculateXOffset(lineWidth:Float):Float {
        var targetWidth = maxWidth != null ? maxWidth : lineWidth;
        final finalAlignment = alignment != null ? alignment : TextAlignment.LEFT;
        
        switch (finalAlignment) {
            case LEFT:
                return 0;
            case CENTER:
                return (targetWidth - lineWidth) / 2;
            case RIGHT:
                return targetWidth - lineWidth;
        }
    }

    /**
     * Calculate the model matrix
     * @return Mat4 The model matrix
     */
    public function getTextModelMatrix():Mat4 {
        if (!matrixDirty) return cachedModelMatrix;
        
        var finalX = this.x + (this.shake != null ? this.shake.getOffsetX() : 0);
        var finalY = this.y + (this.shake != null ? this.shake.getOffsetY() : 0);
        
        // Scale
        var scaledWidth = textWidth * this.scale.x;
        var scaledHeight = textHeight * this.scale.y;
        
        var model = GLM.mat4Identity();
        
        // Translate to final position
        model = GLM.translate(model, new Vec3(finalX, finalY, 0));
        
        // Add scale
        model = GLM.scale(model, new Vec3(scaledWidth, scaledHeight, 1.0));
        
        // Add angle
        var pivotOffsetAngle = getPivotOffsetAngle();
        
        // Translate to pivot point
        model = GLM.translate(model, new Vec3(pivotOffsetAngle.x, pivotOffsetAngle.y, 0));
        
        // Add Z
        final zCompensation = 0.5 / textCharPerspectiveStrength;
        final finalZ = (this.z / 500.0) * zCompensation;
        model = GLM.translate(model, new Vec3(0, 0, finalZ));
        
        // Add skew
        if (this.skewX != 0 || this.skewY != 0) {
            model = applySkew(model, this.skewX, this.skewY);
        }
        
        // Add 3D perspective 
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
                model = GLM.rotate(model, angleZ, new Vec3(0, 0, 1));
            }
        }
        
        model = GLM.translate(model, new Vec3(-pivotOffsetAngle.x, -pivotOffsetAngle.y, 0));
        
        cachedModelMatrix = model;
        matrixDirty = false;
        
        return model;
    }
    
    /**
     * Mark the matrix as dirty
     */
    private function markMatrixDirty():Void {
        matrixDirty = true;
        for (sprite in charSprites) {
            sprite.notifyBatch();
        }
    }
    
    /**
     * Clear the character sprites
     */
    private function clearCharSprites():Void {
        for (sprite in charSprites) {
            VpBatchManager.unregisterSprite(sprite);
            sprite.destroy();
        }
        charSprites = [];
    }

    override public function set_x(value:Null<Float>):Null<Float> {
        if (value == null || this.x == value) return value;
        super.set_x(value);
        markMatrixDirty();
        return value;
    }
    
    override public function set_y(value:Null<Float>):Null<Float> {
        if (value == null || this.y == value) return value;
        super.set_y(value);
        markMatrixDirty();
        return value;
    }
    
    override public function set_z(value:Null<Float>):Null<Float> {
        if (value == null || this.z == value) return value;
        super.set_z(value);
        markMatrixDirty();
        return value;
    }
    
    override public function set_alpha(value:Null<Float>):Null<Float> {
        if (value == null || this.alpha == value) return value;
        super.set_alpha(value);
        for (sprite in charSprites) if (sprite != null) sprite.alpha = value;
        return value;
    }
    
    override public function set_color(value:Null<VpColor>):Null<VpColor> {
        if (value == null || this.color == value) return value;
        super.set_color(value);
        for (sprite in charSprites) if (sprite != null) sprite.color = value;
        return value;
    }
    
    override public function set_visible(value:Null<Bool>):Null<Bool> {
        if (this.visible == value) return value;
        super.set_visible(value);
        for (sprite in charSprites) if (sprite != null) sprite.visible = value;
        return value;
    }
    
    override public function set_enabled(value:Null<Bool>):Null<Bool> {
        if (this.enabled == value) return value;
        super.set_enabled(value);
        for (sprite in charSprites) if (sprite != null) sprite.enabled = value;
        return value;
    }
    
    override public function set_angle(value:Null<Float>):Null<Float> {
        if (value == null || this.angle == value) return value;
        super.set_angle(value);
        markMatrixDirty();
        return value;
    }
    
    override public function set_camera(value:Null<VpCamera>):Null<VpCamera> {
        if (_camera == value) return value;
        super.set_camera(value);
        for (sprite in charSprites) if (sprite != null) sprite.camera = value;
        return value;
    }
    
    override public function set_scaleX(value:Null<Float>):Null<Float> {
        if (value == null || this.scale.x == value) return value;
        super.set_scaleX(value);
        for (sprite in charSprites) if (sprite != null) sprite.scaleX = value;
        markMatrixDirty();
        return value;
    }
    
    override public function set_scaleY(value:Null<Float>):Null<Float> {
        if (value == null || this.scale.y == value) return value;
        super.set_scaleY(value);
        for (sprite in charSprites) if (sprite != null) sprite.scaleY = value;
        markMatrixDirty();
        return value;
    }
    
    override public function set_rotationX(value:Null<Float>):Null<Float> {
        if (value == null || this.rotationX == value) return value;
        super.set_rotationX(value);
        markMatrixDirty();
        return value;
    }
    
    override public function set_rotationY(value:Null<Float>):Null<Float> {
        if (value == null || this.rotationY == value) return value;
        super.set_rotationY(value);
        markMatrixDirty();
        return value;
    }

    override public function set_skewX(value:Null<Float>):Null<Float> {
        if (value == null || this.rotationX == value) return value;
        super.set_skewX(value);
        markMatrixDirty();
        return value;
    }

    override public function set_skewY(value:Null<Float>):Null<Float> {
        if (value == null || this.rotationY == value) return value;
        super.set_skewY(value);
        markMatrixDirty();
        return value;
    }
    
    override public function set_rotationZ(value:Null<Float>):Null<Float> {
        if (value == null || this.rotationZ == value) return value;
        super.set_rotationZ(value);
        markMatrixDirty();
        return value;
    }
    
    override public function set_flipX(value:Bool):Bool {
        if (this.flipX == value) return value;
        super.set_flipX(value);
        for (sprite in charSprites) if (sprite != null) sprite.flipX = value;
        return value;
    }
    
    override public function set_flipY(value:Bool):Bool {
        if (this.flipY == value) return value;
        super.set_flipY(value);
        for (sprite in charSprites) if (sprite != null) sprite.flipY = value;
        return value;
    }

    override private function get_width():Int {
        return Math.round(textWidth);
    }
    
    override private function get_height():Int {
        return Math.round(textHeight);
    }
    
    private function get_text():String return _text;
    private function set_text(value:String):String {
        setText(value);
        return _text;
    }
    
    public function set_alignment(newAlignment:TextAlignment):TextAlignment {
        if (alignment == newAlignment || newAlignment == null) return alignment;
        alignment = newAlignment;
        
        // Recalculate the text
        setText(_text);
        
        return alignment;
    }
    
    /**
     * Set the maximum width of the text
     */
    public function set_maxWidth(value:Float):Float {
        maxWidth = value;
        setText(_text);
        return maxWidth;
    }
    
    /**
     * Get the width of the text
     */
    public function getTextWidth():Float {
        return textWidth;
    }
    
    /**
     * Get the height of the text
     */
    public function getTextHeight():Float {
        return textHeight;
    }
    
    override public function destroy():Void {
        clearCharSprites();
        validIndices = [];
        super.destroy();
    }
}

/**
 * Character sprite
 */
@:access(vupx.objects.VpBaseObject)
@:access(vupx.objects.VpText)
private class VpTextCharacter extends VpSprite {
    /**
     * Parent text object of the character
     */
    public var parentText:VpText;

    /**
     * Local X position of the character
     */
    public var localX:Float;

    /**
     * Local Y position of the character
     */
    public var localY:Float;

    /**
     * Base width of the character
     */
    public var baseWidth:Float;

    /**
     * Base height of the character
     */
    public var baseHeight:Float;
    
    public function new(parentText:VpText, localX:Float, localY:Float, baseWidth:Float, baseHeight:Float) {
        super(0, 0);
        this._isTextCharacter = true;
        this.parentText = parentText;
        this.localX = localX;
        this.localY = localY;
        this.baseWidth = baseWidth;
        this.baseHeight = baseHeight;
        
        this.angle = 0;
        this.rotationX = 0;
        this.rotationY = 0;
        this.rotationZ = 0;
        
        this.texture = parentText.font.atlasTexture;
        this.isTextureFromCache = false;
        this.readyToRender = true;

        this.perspectiveStrength = parentText.textCharPerspectiveStrength;
    }
    
    /**
     * Calculate the model matrix of the character
     */
    override public function calculateModelMatrix():Mat4 {
        // Get the model matrix of the parent text
        var parentMatrix = parentText.getTextModelMatrix();
        
        var normalizedX:Float = localX / parentText.textWidth;
        var normalizedY:Float = localY / parentText.textHeight;
        var normalizedWidth:Float = baseWidth / parentText.textWidth;
        var normalizedHeight:Float = baseHeight / parentText.textHeight;

        var localMatrix = GLM.mat4Identity();
        
        localMatrix = GLM.translate(localMatrix, new Vec3(normalizedX, normalizedY, 0));
        
        localMatrix = GLM.scale(localMatrix, new Vec3(normalizedWidth, normalizedHeight, 1.0));
        
        localMatrix = GLM.translate(localMatrix, new Vec3(0.5, 0.5, 0));
        
        localMatrix = GLM.translate(localMatrix, new Vec3(-0.5, -0.5, 0));
        
        return Mat4.mul(parentMatrix, localMatrix);
    }
    
    override public function hasRotations():Bool {
        return parentText.rotationX != 0 || parentText.rotationY != 0 || 
                parentText.rotationZ != 0 || parentText.angle != 0 ||
                parentText.skewX != 0 || parentText.skewY != 0 ||
                parentText.rotationPivotX != CENTER || 
                parentText.rotationPivotY != CENTER ||
                parentText.rotationPivotAngle != CENTER;
    }
    
    override public function get_width():Int {
        return Math.round(baseWidth * parentText.scale.x);
    }
    
    override public function get_height():Int {
        return Math.round(baseHeight * parentText.scale.y);
    }
    
    /**
     * Sync the character with the parent text
     */
    public function syncWithParent():Void {
        this.alpha = parentText.alpha;
        this.color = parentText.color;
        this.camera = parentText.camera;
        this.visible = parentText.visible;
        this.enabled = parentText.enabled;
        this.flipX = parentText.flipX;
        this.flipY = parentText.flipY;
        this.scale.x = parentText.scale.x;
        this.scale.y = parentText.scale.y;
    }
}