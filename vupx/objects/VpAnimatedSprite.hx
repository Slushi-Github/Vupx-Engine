package vupx.objects;

import haxe.xml.Access;
import sys.io.File;
import sys.FileSystem;
import vupx.core.graphics.VpTextureCache;
import vupx.core.renderer.batch.VpBatchManager;
import vupx.backend.logging.VupxDebug;

/**
 * Frame data for spritesheet animations
 */
typedef VpSpriteFrame = {
    var name:String;
    var x:Int;
    var y:Int;
    var width:Int;
    var height:Int;
    var frameX:Int;
    var frameY:Int;
    var frameWidth:Int;
    var frameHeight:Int;
    var u1:Float;
    var v1:Float;
    var u2:Float;
    var v2:Float;
}

/**
 * VpAnimation definition
 */
typedef VpAnimation = {
    var name:String;
    var frames:Array<String>;
    var frameRate:Float;
    var looped:Bool;
}

/**
 * Animated sprite with spritesheet support
 * 
 * Supports XML texture atlases (Sparrow/Starling format)
 * 
 * Author: Slushi
 */
class VpAnimatedSprite extends VpBaseObject {
    /**
     * All loaded frames from the spritesheet
     */
    public var frames:Map<String, VpSpriteFrame>;
    
    /**
     * Defined animations
     */
    public var animations:Map<String, VpAnimation>;
    
    /**
     * Currently playing animation
     */
    public var currentAnimation:Null<VpAnimation>;
    
    /**
     * Current frame index in animation
     */
    public var currentFrameIndex:Int = 0;
    
    /**
     * Time accumulator for frame timing
     */
    public var frameTimer:Float = 0;
    
    /**
     * Current displayed frame
     */
    public var currentFrame:Null<VpSpriteFrame>;
    
    /**
     * Is animation playing
     */
    public var isPlaying:Bool = false;
    
    /**
     * Is animation finished (for non-looped animations)
     */
    public var finished:Bool = false;
    
    /**
     * Callback when animation finishes
     */
    public var onAnimationComplete:Null<Void->Void>;
    
    /**
     * Width and height of the spritesheet texture
     */
    public var textureWidth:Int = 0;
    public var textureHeight:Int = 0;
    
    /**
     * Create a new animated sprite
     */
    public function new(x:Null<Float> = 0, y:Null<Float> = 0):Void {
        super();
        
        this.x = x ?? 0;
        this.y = y ?? 0;
        
        frames = new Map<String, VpSpriteFrame>();
        animations = new Map<String, VpAnimation>();
        currentAnimation = null;
        currentFrame = null;
    }
    
    /**
     * Load a spritesheet from XML and texture
     * @param xmlPath Path to the XML file (Sparrow/Starling format)
     * @param imagePath Path to the texture image
     */
    public function loadSpritesheet(xmlPath:String, imagePath:String):Void {
        if (!FileSystem.exists(xmlPath)) {
            VupxDebug.log('XML file not found: ${xmlPath}', ERROR);
            return;
        }
        
        if (!FileSystem.exists(imagePath)) {
            VupxDebug.log('Image file not found: ${imagePath}', ERROR);
            return;
        }
        
        this.texture = VpTextureCache.get(imagePath);
        if (this.texture == null) {
            VupxDebug.log('Failed to load texture: ${imagePath}', ERROR);
            return;
        }
        
        this.isTextureFromCache = true;
        this.ownsTexture = false;
        
        textureWidth = this.texture.width;
        textureHeight = this.texture.height;
        
        // Parse XML
        try {
            var xmlContent = File.getContent(xmlPath);
            var xml = Xml.parse(xmlContent);
            var fast = new Access(xml.firstElement());
            
            // Get texture atlas dimensions if specified
            if (fast.has.width) textureWidth = Std.parseInt(fast.att.width);
            if (fast.has.height) textureHeight = Std.parseInt(fast.att.height);
            
            // Parse all SubTexture elements
            for (subTexture in fast.nodes.SubTexture) {
                var frame:VpSpriteFrame = {
                    name: subTexture.att.name,
                    x: Std.parseInt(subTexture.att.x),
                    y: Std.parseInt(subTexture.att.y),
                    width: Std.parseInt(subTexture.att.width),
                    height: Std.parseInt(subTexture.att.height),
                    frameX: subTexture.has.frameX ? Std.parseInt(subTexture.att.frameX) : 0,
                    frameY: subTexture.has.frameY ? Std.parseInt(subTexture.att.frameY) : 0,
                    frameWidth: subTexture.has.frameWidth ? Std.parseInt(subTexture.att.frameWidth) : Std.parseInt(subTexture.att.width),
                    frameHeight: subTexture.has.frameHeight ? Std.parseInt(subTexture.att.frameHeight) : Std.parseInt(subTexture.att.height),
                    u1: 0.0,
                    v1: 0.0,
                    u2: 0.0,
                    v2: 0.0
                };
                
                // Calculate UV coordinates
                frame.u1 = frame.x / textureWidth;
                frame.v1 = frame.y / textureHeight;
                frame.u2 = (frame.x + frame.width) / textureWidth;
                frame.v2 = (frame.y + frame.height) / textureHeight;
                
                frames.set(frame.name, frame);
            }

            var framesLength:Int = 0;
            for (frame in frames.keys()) {
                framesLength++;
            }
            
            if (framesLength == 0) {
                VupxDebug.log('No frames found in XML: ${xmlPath}', ERROR);
                return;
            }
            
            VupxDebug.log('Spritesheet loaded: ${framesLength} frames', DEBUG);
            
            // Set ready to render
            this.readyToRender = true;
            this.visible = true;
            
            // Set first frame if available
            var firstFrameName = frames.keys().next();
            if (firstFrameName != null) {
                setFrame(firstFrameName);
            }
            
        } catch (e:Dynamic) {
            VupxDebug.log('Failed to parse XML: ${xmlPath} - ${e}', ERROR);
        }
    }
    
    /**
     * Add an animation
     * @param name VpAnimation name
     * @param prefix Frame name prefix (e.g., "idle" for "idle0000", "idle0001", etc.)
     * @param frameRate Frames per second
     * @param looped Should the animation loop
     * @param indices Optional specific frame indices (e.g., [0, 1, 2, 3])
     */
    public function addAnimation(name:String, prefix:String, frameRate:Float = 24, looped:Bool = true, ?indices:Array<Int>):Void {
        var frameNames:Array<String> = [];
        
        if (indices != null && indices.length > 0) {
            // Use specific indices
            for (index in indices) {
                var frameName = '${prefix}${StringTools.lpad(Std.string(index), "0", 4)}';
                if (frames.exists(frameName)) {
                    frameNames.push(frameName);
                }
            }
        } else {
            // Auto-detect all frames with prefix
            var sortedFrames:Array<String> = [];
            for (frameName in frames.keys()) {
                if (StringTools.startsWith(frameName, prefix)) {
                    sortedFrames.push(frameName);
                }
            }
            
            // Sort frames numerically
            sortedFrames.sort((a, b) -> {
                var numA = Std.parseInt(a.substr(prefix.length));
                var numB = Std.parseInt(b.substr(prefix.length));
                return numA - numB;
            });
            
            frameNames = sortedFrames;
        }
        
        if (frameNames.length == 0) {
            VupxDebug.log('No frames found for animation: ${name} with prefix: ${prefix}', WARNING);
            return;
        }
        
        var anim:VpAnimation = {
            name: name,
            frames: frameNames,
            frameRate: frameRate,
            looped: looped
        };
        
        animations.set(name, anim);
        VupxDebug.log('VpAnimation added: ${name} (${frameNames.length} frames)', DEBUG);
    }
    
    /**
     * Play an animation
     * @param name VpAnimation name
     * @param forced Force restart if already playing
     * @param startFrame Starting frame index
     */
    public function playAnimation(name:String, forced:Bool = false, startFrame:Int = 0):Void {
        if (!animations.exists(name)) {
            VupxDebug.log('VpAnimation not found: ${name}', WARNING);
            return;
        }
        
        var anim = animations.get(name);
        
        // Don't restart if already playing (unless forced)
        if (!forced && currentAnimation != null && currentAnimation.name == name && isPlaying) {
            return;
        }
        
        currentAnimation = anim;
        currentFrameIndex = startFrame;
        frameTimer = 0;
        isPlaying = true;
        finished = false;
        
        // Set initial frame
        if (anim.frames.length > 0) {
            setFrame(anim.frames[currentFrameIndex]);
        }
    }
    
    /**
     * Stop current animation
     */
    public function stopAnimation():Void {
        isPlaying = false;
    }
    
    /**
     * Pause current animation
     */
    public function pauseAnimation():Void {
        isPlaying = false;
    }
    
    /**
     * Resume current animation
     */
    public function resumeAnimation():Void {
        if (currentAnimation != null) {
            isPlaying = true;
        }
    }
    
    /**
     * Set a specific frame by name
     * Updates the custom UV coordinates and size for batched rendering
     */
    public function setFrame(frameName:String):Void {
        if (!frames.exists(frameName)) {
            VupxDebug.log('Frame not found: ${frameName}', WARNING);
            return;
        }
        
        currentFrame = frames.get(frameName);
        
        // Update custom UV coordinates for batched rendering
        setCustomUV(currentFrame.u1, currentFrame.v1, currentFrame.u2, currentFrame.v2);
        
        // Update size using the custom size system
        setSize(currentFrame.frameWidth, currentFrame.frameHeight);
        
        // Mark as dirty to update batch
        this.dirty = true;
        notifyBatch();
    }
    
    /**
     * Get current frame name
     */
    public function getCurrentFrameName():Null<String> {
        return currentFrame != null ? currentFrame.name : null;
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (!isPlaying || currentAnimation == null || currentAnimation.frames.length == 0) {
            return;
        }
        
        frameTimer += elapsed;
        
        var frameDuration = 1.0 / currentAnimation.frameRate;
        
        while (frameTimer >= frameDuration) {
            frameTimer -= frameDuration;
            currentFrameIndex++;
            
            // Check if animation finished
            if (currentFrameIndex >= currentAnimation.frames.length) {
                if (currentAnimation.looped) {
                    currentFrameIndex = 0;
                } else {
                    currentFrameIndex = currentAnimation.frames.length - 1;
                    isPlaying = false;
                    finished = true;
                    
                    if (onAnimationComplete != null) {
                        onAnimationComplete();
                    }
                    break;
                }
            }
            
            // Update frame
            setFrame(currentAnimation.frames[currentFrameIndex]);
        }
    }
    
    /**
     * Get all frame names
     */
    public function getFrameNames():Array<String> {
        var names:Array<String> = [];
        for (name in frames.keys()) {
            names.push(name);
        }
        return names;
    }
    
    /**
     * Get all animation names
     */
    public function getAnimationNames():Array<String> {
        var names:Array<String> = [];
        for (name in animations.keys()) {
            names.push(name);
        }
        return names;
    }
    
    /**
     * Check if an animation exists
     */
    public function hasAnimation(name:String):Bool {
        return animations.exists(name);
    }
    
    /**
     * Check if a frame exists
     */
    public function hasFrame(name:String):Bool {
        return frames.exists(name);
    }
    
    override public function destroy():Void {
        frames.clear();
        animations.clear();
        currentAnimation = null;
        currentFrame = null;
        onAnimationComplete = null;
        
        super.destroy();
    }
}