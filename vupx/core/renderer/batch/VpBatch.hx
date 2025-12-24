package vupx.core.renderer.batch;

@:access(vupx.objects.VpBaseObject)
class VpBatch {
    /**
     * The maximum number of instances that can be rendered at once
     */
    private static inline final MAX_INSTANCES:Int = 8192;

    /**
     * The number of floats per instance
     */
    private static inline final FLOATS_PER_INSTANCE:Int = 34;
    
    /**
     * The main texture for this batch
     */
    public var texture:VpTexture;

    /**
     * The camera for this batch
     */
    public var camera:VpCamera;

    /**
     * The list of sprites in this batch
     */
    public var sprites:Array<VpBaseObject> = [];
    
    /**
     * The post shader for this batch
     */
    public var postShader:Null<VpShader> = null;

    /**
     * The shader params for this batch
     */
    public var shaderParams:StringMap<ShaderParamValue>;
    
    private var _postFBO:UInt32 = 0;
    private var _postTexture:UInt32 = 0;
    private var _postRBO:UInt32 = 0;
    private var _postVAO:UInt32 = 0;
    private var _postVBO:UInt32 = 0;
    private var fboWidth:Int = 0;
    private var fboHeight:Int = 0;
    
    private var _VAO:UInt32 = 0;
    private var _VBO:UInt32 = 0;
    private var _instanceVBO:UInt32 = 0;
    private var shader:VpInstancedBatchShader;
    
    private var visibleIndices:Array<Int>;
    private var visibleCount:Int = 0;
    
    private var instanceData:Array<Float32>;
    private var dirtySprites:Array<Bool>;
    private var needsGPUUpload:Bool = false;
    
    private var screenMargin:Float = 100.0;
    
    // Cache camera position
    private var lastCameraX:Float = 0;
    private var lastCameraY:Float = 0;
    private var lastCameraZ:Float = 0;
    private var cameraMovementThreshold:Float = 50.0;
    
    private var transformedX:Array<Float>;
    private var transformedY:Array<Float>;
    
    public function new(
        texture:VpTexture, 
        camera:VpCamera, 
        postShader:Null<VpShader> = null,
        shaderParams:Null<StringMap<ShaderParamValue>> = null
    ) {
        this.texture = texture;
        this.camera = camera != null ? camera : Vupx.camera;
        this.shader = new VpInstancedBatchShader();
        this.postShader = postShader;
        
        // Copy shader params
        this.shaderParams = new StringMap<ShaderParamValue>();
        if (shaderParams != null) {
            for (key in shaderParams.keys()) {
                this.shaderParams.set(key, shaderParams.get(key));
            }
        }
        
        var totalFloats = MAX_INSTANCES * FLOATS_PER_INSTANCE;
        this.instanceData = [];
        this.visibleIndices = [];
        
        for (i in 0...totalFloats) {
            this.instanceData[i] = 0.0;
        }
        
        this.dirtySprites = [];
        for (i in 0...MAX_INSTANCES) {
            this.dirtySprites[i] = false;
        }
        
        this.transformedX = [0.0, 0.0, 0.0, 0.0];
        this.transformedY = [0.0, 0.0, 0.0, 0.0];
        
        initializeBuffers();

        if (postShader != null) {
            initializePostProcessing();
        }
    }
    
    private function initializeBuffers():Void {
        final vertices:Array<Float32> = [
            0, 1, 0, 0, 1,
            1, 1, 0, 1, 1,
            0, 0, 0, 0, 0,
            1, 0, 0, 1, 0
        ];
        
        GL.glGenVertexArrays(1, Pointer.addressOf(_VAO));
        GL.glGenBuffers(1, Pointer.addressOf(_VBO));
        GL.glGenBuffers(1, Pointer.addressOf(_instanceVBO));
        
        GL.glBindVertexArray(_VAO);
        
        GL.glBindBuffer(GL.GL_ARRAY_BUFFER, _VBO);
        GL.glBufferData(GL.GL_ARRAY_BUFFER, vertices.length * 4, 
            cast NativeArray.address(vertices, 0), GL.GL_STATIC_DRAW);
        
        GL.glVertexAttribPointer(0, 3, GL.GL_FLOAT, false, 5 * 4, null);
        GL.glEnableVertexAttribArray(0);
        
        var texOff:RawPointer<CppVoid> = untyped __cpp__("(void*)(3*sizeof(float))");
        GL.glVertexAttribPointer(1, 2, GL.GL_FLOAT, false, 5 * 4, cast texOff);
        GL.glEnableVertexAttribArray(1);
        
        GL.glBindBuffer(GL.GL_ARRAY_BUFFER, _instanceVBO);
        GL.glBufferData(GL.GL_ARRAY_BUFFER, MAX_INSTANCES * FLOATS_PER_INSTANCE * 4, 
            null, GL.GL_DYNAMIC_DRAW);

        var stride = FLOATS_PER_INSTANCE * 4;
        var offset = 0;
        
        for (i in 0...4) {
            var offsetPtr:RawPointer<cpp.Void> = untyped __cpp__("(void*)(intptr_t)({0})", offset);
            GL.glVertexAttribPointer(2 + i, 4, GL.GL_FLOAT, false, stride, cast offsetPtr);
            GL.glEnableVertexAttribArray(2 + i);
            GL.glVertexAttribDivisor(2 + i, 1);
            offset += 16; // 4 floats * 4 bytes
        }
        
        var offsetPtr:RawPointer<cpp.Void> = untyped __cpp__("(void*)(intptr_t)({0})", offset);
        GL.glVertexAttribPointer(6, 1, GL.GL_FLOAT, false, stride, cast offsetPtr);
        GL.glEnableVertexAttribArray(6);
        GL.glVertexAttribDivisor(6, 1);
        offset += 4;
        
        offsetPtr = untyped __cpp__("(void*)(intptr_t)({0})", offset);
        GL.glVertexAttribPointer(7, 3, GL.GL_FLOAT, false, stride, cast offsetPtr);
        GL.glEnableVertexAttribArray(7);
        GL.glVertexAttribDivisor(7, 1);
        offset += 12;
        
        offsetPtr = untyped __cpp__("(void*)(intptr_t)({0})", offset);
        GL.glVertexAttribPointer(8, 4, GL.GL_FLOAT, false, stride, cast offsetPtr);
        GL.glEnableVertexAttribArray(8);
        GL.glVertexAttribDivisor(8, 1);
        offset += 16;

        offsetPtr = untyped __cpp__("(void*)(intptr_t)({0})", offset);
        GL.glVertexAttribPointer(9, 1, GL.GL_FLOAT, false, stride, cast offsetPtr);
        GL.glEnableVertexAttribArray(9);
        GL.glVertexAttribDivisor(9, 1);
        offset += 4;
        
        offsetPtr = untyped __cpp__("(void*)(intptr_t)({0})", offset);
        GL.glVertexAttribPointer(10, 1, GL.GL_FLOAT, false, stride, cast offsetPtr);
        GL.glEnableVertexAttribArray(10);
        GL.glVertexAttribDivisor(10, 1);
        offset += 4;
        
        GL.glBindVertexArray(0);
    }
    
    /**
     * Initializes the post processing FBO
     */
    private function initializePostProcessing():Void {
        fboWidth = camera.width;
        fboHeight = camera.height;
        
        GL.glGenFramebuffers(1, Pointer.addressOf(_postFBO));
        GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, _postFBO);
        
        GL.glGenTextures(1, Pointer.addressOf(_postTexture));
        GL.glBindTexture(GL.GL_TEXTURE_2D, _postTexture);
        GL.glTexImage2D(GL.GL_TEXTURE_2D, 0, GL.GL_RGBA, fboWidth, fboHeight, 0, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE, null);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
        GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
        GL.glFramebufferTexture2D(GL.GL_FRAMEBUFFER, GL.GL_COLOR_ATTACHMENT0, GL.GL_TEXTURE_2D, _postTexture, 0);
        
        GL.glGenRenderbuffers(1, Pointer.addressOf(_postRBO));
        GL.glBindRenderbuffer(GL.GL_RENDERBUFFER, _postRBO);
        GL.glRenderbufferStorage(GL.GL_RENDERBUFFER, GL.GL_DEPTH24_STENCIL8, fboWidth, fboHeight);
        GL.glFramebufferRenderbuffer(GL.GL_FRAMEBUFFER, GL.GL_DEPTH_STENCIL_ATTACHMENT, GL.GL_RENDERBUFFER, _postRBO);
        
        if (GL.glCheckFramebufferStatus(GL.GL_FRAMEBUFFER) != GL.GL_FRAMEBUFFER_COMPLETE) {
            VupxDebug.log("Framebuffer for post-processing is not complete!", ERROR);
        }
        
        GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, 0);
        
        final postQuadVertices:Array<Float32> = [
            // Pos        // TexCoords
            -1, -1, 0,    0, 0,
             1, -1, 0,    1, 0,
            -1,  1, 0,    0, 1,
             1,  1, 0,    1, 1
        ];
        
        GL.glGenVertexArrays(1, Pointer.addressOf(_postVAO));
        GL.glGenBuffers(1, Pointer.addressOf(_postVBO));
        
        GL.glBindVertexArray(_postVAO);
        GL.glBindBuffer(GL.GL_ARRAY_BUFFER, _postVBO);
        GL.glBufferData(GL.GL_ARRAY_BUFFER, postQuadVertices.length * 4, 
            cast NativeArray.address(postQuadVertices, 0), GL.GL_STATIC_DRAW);
        
        // Position
        GL.glVertexAttribPointer(0, 3, GL.GL_FLOAT, false, 5 * 4, null);
        GL.glEnableVertexAttribArray(0);
        
        // TexCoords
        var texOff:RawPointer<cpp.Void> = untyped __cpp__("(void*)(3*sizeof(float))");
        GL.glVertexAttribPointer(1, 2, GL.GL_FLOAT, false, 5 * 4, cast texOff);
        GL.glEnableVertexAttribArray(1);
        
        GL.glBindVertexArray(0);
    }
    
    /**
     * Adds a sprite to the batch
     * @param sprite 
     */
    public function addSprite(sprite:VpBaseObject):Void {
        if (sprites.contains(sprite)) return;
        
        if (sprites.length >= MAX_INSTANCES) {
            VupxDebug.log("Batch is full, cannot add more sprites", WARNING);
            return;
        }
        
        sprites.push(sprite);
        sprite.batchIndex = sprites.length - 1;
        sprite.currentBatch = this;
        
        dirtySprites[sprite.batchIndex] = true;
        needsGPUUpload = true;
    }
    
    /**
     * Removes a sprite from the batch
     * @param sprite 
     * @return Bool
     */
    public function removeSprite(sprite:VpBaseObject):Bool {
        if (!sprites.remove(sprite)) return false;
        
        for (i in 0...sprites.length) {
            sprites[i].batchIndex = i;
            dirtySprites[i] = true;
        }
        
        needsGPUUpload = true;
        sprite.currentBatch = null;
        sprite.batchIndex = -1;
        return true;
    }
    
    /**
     * Marks a sprite as dirty
     * @param sprite 
     */
    public function markSpriteDirty(sprite:VpBaseObject):Void {
        if (sprite.batchIndex >= 0 && sprite.batchIndex < sprites.length) {
            dirtySprites[sprite.batchIndex] = true;
            needsGPUUpload = true;
        }
    }
    
    /**
     * Updates the visible sprites
     */
    private function updateVisibleSprites():Void {
        var cameraMoved = Math.abs(camera.x - lastCameraX) > cameraMovementThreshold ||
                            Math.abs(camera.y - lastCameraY) > cameraMovementThreshold ||
                            Math.abs(camera.z - lastCameraZ) > cameraMovementThreshold;
        
        if (cameraMoved) {
            visibleCount = 0;
            visibleIndices.resize(0);
            
            for (i in 0...sprites.length) {
                var sprite = sprites[i];
                
                if (isInView(sprite)) {
                    updateSpriteData(i, visibleCount);
                    visibleIndices.push(i);
                    visibleCount++;
                }
                
                dirtySprites[i] = false;
            }
            
            lastCameraX = camera.x;
            lastCameraY = camera.y;
            lastCameraZ = camera.z;
            return;
        }
        
        for (i in 0...sprites.length) {
            if (!dirtySprites[i]) continue;
            
            var sprite = sprites[i];
            
            var wasVisible = visibleIndices.contains(i);
            var isVisible = isInView(sprite);
            
            if (isVisible && !wasVisible) {
                updateSpriteData(i, visibleCount);
                visibleIndices.push(i);
                visibleCount++;
                
            } else if (!isVisible && wasVisible) {
                visibleIndices.remove(i);
                rebuildVisibleBuffer();
                
            } else if (isVisible && wasVisible) {
                var bufferIndex = visibleIndices.indexOf(i);
                updateSpriteData(i, bufferIndex);
            }
            
            dirtySprites[i] = false;
        }
    }
    
    /**
     * Updates the sprite data
     * @param spriteIndex 
     * @param bufferIndex 
     */
    private function updateSpriteData(spriteIndex:Int, bufferIndex:Int):Void {
        var sprite = sprites[spriteIndex];

        if (sprite == null) {
            VupxDebug.log("Sprite at index " + spriteIndex + " is null, returning!", ERROR);
            return;
        }

        var model = sprite.calculateModelMatrix();
        
        var u0:Float, v0:Float, u1:Float, v1:Float;
        
        if (sprite.customUV != null) {
            u0 = sprite.customUV[0];
            v0 = sprite.customUV[1];
            u1 = sprite.customUV[2];
            v1 = sprite.customUV[3];
            
            if (sprite.flipX) {
                var temp = u0;
                u0 = u1;
                u1 = temp;
            }
            if (sprite.flipY) {
                var temp = v0;
                v0 = v1;
                v1 = temp;
            }
        } else {
            u0 = sprite.flipX ? 1.0 : 0.0;
            u1 = sprite.flipX ? 0.0 : 1.0;
            v0 = sprite.flipY ? 1.0 : 0.0;
            v1 = sprite.flipY ? 0.0 : 1.0;
        }
        
        var alpha = sprite.alpha * (sprite.color.alpha / 255.0);
        var r = sprite.color.red / 255.0;
        var g = sprite.color.green / 255.0;
        var b = sprite.color.blue / 255.0;
        
        // Detect if sprite is text character
        var isText:Float = sprite._isTextCharacter ? 1.0 : 0.0;
        
        writeSpriteDataAtIndex(bufferIndex, model, alpha, r, g, b, u0, v0, u1, v1, sprite.perspectiveStrength, isText);
    }
    
    private function rebuildVisibleBuffer():Void {
        visibleCount = visibleIndices.length;
        
        for (i in 0...visibleCount) {
            var spriteIndex = visibleIndices[i];
            updateSpriteData(spriteIndex, i);
        }
    }
    
    /**
     * Writes the sprite data
     * @param index 
     * @param model 
     * @param alpha 
     * @param r 
     * @param g 
     * @param b 
     * @param u0 
     * @param v0 
     * @param u1 
     * @param v1 
     * @param perspStrength 
     * @param isText 
     */
    private inline function writeSpriteDataAtIndex(
        index:Int,
        model:Mat4,
        alpha:Float,
        r:Float, g:Float, b:Float,
        u0:Float, v0:Float, u1:Float, v1:Float,
        perspStrength:Float,
        isText:Float
    ):Void {
        var baseIndex = index * FLOATS_PER_INSTANCE;
        
        var matrixPtr = GLM.value_ptr(model);
        
        for (i in 0...16) {
            instanceData[baseIndex + i] = untyped __cpp__("{0}[{1}]", matrixPtr, i);
        }
        
        baseIndex += 16;
        
        // Alpha
        instanceData[baseIndex++] = alpha;
        
        // Color
        instanceData[baseIndex++] = r;
        instanceData[baseIndex++] = g;
        instanceData[baseIndex++] = b;
        
        // UVs
        instanceData[baseIndex++] = u0;
        instanceData[baseIndex++] = v0;
        instanceData[baseIndex++] = u1;
        instanceData[baseIndex++] = v1;
        
        // Perspective Strength
        instanceData[baseIndex++] = perspStrength;
        
        // IsText
        instanceData[baseIndex++] = isText;
    }
    
    /**
     * Checks if a sprite is in view
     * @param sprite 
     * @return Bool
     */
    private inline function isInView(sprite:VpBaseObject):Bool {
        if (!sprite.visible || !sprite.enabled || sprite.alpha <= 0) return false;
        
        if (!sprite.hasRotations()) {
            return isInViewFast(sprite);
        }
        
        return isInViewPrecise(sprite);
    }
    
    /**
     * Checks if a sprite is in view fast
     * @param sprite 
     * @return Bool
     */
    private inline function isInViewFast(sprite:VpBaseObject):Bool {
        var minZ = camera.MIN_MAX_Z_COORD != null ? -camera.MIN_MAX_Z_COORD : -4000.0;
        var maxZ = camera.MIN_MAX_Z_COORD != null ? camera.MIN_MAX_Z_COORD : 4000.0;
        
        if (sprite.z < minZ || sprite.z > maxZ) return false;
        
        var perspectiveFactor = 1.0 / (1.0 + (sprite.z / 500.0) * sprite.perspectiveStrength);
        
        var spriteWidth = sprite.width * sprite.scale.x;
        var spriteHeight = sprite.height * sprite.scale.y;
        
        var perspectiveWidth = spriteWidth * perspectiveFactor;
        var perspectiveHeight = spriteHeight * perspectiveFactor;
        
        var centerX = sprite.x + spriteWidth * 0.5;
        var centerY = sprite.y + spriteHeight * 0.5;
        
        var screenCenterX = camera.x + Vupx.screenWidth * 0.5;
        var screenCenterY = camera.y + Vupx.screenHeight * 0.5;
        
        var deltaX = centerX - screenCenterX;
        var deltaY = centerY - screenCenterY;
        
        var perspectiveCenterX = screenCenterX + deltaX * perspectiveFactor;
        var perspectiveCenterY = screenCenterY + deltaY * perspectiveFactor;
        
        var left = perspectiveCenterX - perspectiveWidth * 0.5;
        var right = perspectiveCenterX + perspectiveWidth * 0.5;
        var top = perspectiveCenterY - perspectiveHeight * 0.5;
        var bottom = perspectiveCenterY + perspectiveHeight * 0.5;
        
        var camX = camera.x;
        var camY = camera.y;
        
        return !(right < camX - screenMargin || 
                left > camX + Vupx.screenWidth + screenMargin ||
                bottom < camY - screenMargin || 
                top > camY + Vupx.screenHeight + screenMargin);
    }
    
    /**
     * Checks if a sprite is in view precise
     * @param sprite 
     * @return Bool
     */
    private function isInViewPrecise(sprite:VpBaseObject):Bool {
        var minZ = camera.MIN_MAX_Z_COORD != null ? -camera.MIN_MAX_Z_COORD : -4000.0;
        var maxZ = camera.MIN_MAX_Z_COORD != null ? camera.MIN_MAX_Z_COORD : 4000.0;
        
        if (sprite.z < minZ || sprite.z > maxZ) return false;
        
        var perspectiveFactor = 1.0 / (1.0 + (sprite.z / 500.0) * sprite.perspectiveStrength);

        var model = sprite.calculateModelMatrix();
        
        var camX = camera.x;
        var camY = camera.y;
        var screenCenterX = camX + Vupx.screenWidth * 0.5;
        var screenCenterY = camY + Vupx.screenHeight * 0.5;
        
        var cameraLeft = camX - screenMargin;
        var cameraRight = camX + Vupx.screenWidth + screenMargin;
        var cameraTop = camY - screenMargin;
        var cameraBottom = camY + Vupx.screenHeight + screenMargin;

        var cornerPositions = [
            [0.0, 0.0, 0.0],
            [1.0, 0.0, 0.0],
            [0.0, 1.0, 0.0],
            [1.0, 1.0, 0.0]
        ];
        
        for (i in 0...4) {
            var corner = new Vec3(cornerPositions[i][0], cornerPositions[i][1], cornerPositions[i][2]);
            var transformed = GLM.transformPoint(model, corner);
            
            var deltaX = transformed.x - screenCenterX;
            var deltaY = transformed.y - screenCenterY;
            
            transformedX[i] = screenCenterX + deltaX * perspectiveFactor;
            transformedY[i] = screenCenterY + deltaY * perspectiveFactor;
            
            if (transformedX[i] >= cameraLeft && transformedX[i] <= cameraRight &&
                transformedY[i] >= cameraTop && transformedY[i] <= cameraBottom) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Render the batch
     */
    public function render():Void {
        if (sprites.length == 0 || texture == null || shader == null) return;
        
        if (needsGPUUpload) {
            updateVisibleSprites();
            uploadToGPU();
            needsGPUUpload = false;
        }
        
        if (visibleCount == 0) return;
        
        if (postShader != null && !postShader.compilationFailed) {
            GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, _postFBO);
            
            GL.glViewport(0, 0, fboWidth, fboHeight);
            
            GL.glClearColor(0.0, 0.0, 0.0, 0.0);
            GL.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
            
            renderBatchNormal();
            
            GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, 0);
            
            // sets the default viewport
            GL.glViewport(0, 0, camera.width, camera.height);

            // Apply post-shader
            applyPostShader();
        } else {
            renderBatchNormal();
        }
    }
    
    /**
     * Render the batch without post-processing
     */
    private function renderBatchNormal():Void {
        shader.useShader();
        
        shader.setValue(MATRIX4, "projection", camera.getProjectionMatrix());
        shader.setValue(MATRIX4, "view", camera.getViewMatrix());
        shader.setValue(FLOAT, "cameraAlpha", camera.alpha);
        shader.setValue(FLOAT, "MIN_MAX_Z_COORD", camera.MIN_MAX_Z_COORD);
        
        texture.bind(0);
        shader.sendTexture(0, 0);
        
        GL.glBindVertexArray(_VAO);
        GL.glDrawArraysInstanced(GL.GL_TRIANGLE_STRIP, 0, 4, visibleCount);
        GL.glBindVertexArray(0);
        
        VpTexture.unbind();
        shader.stopShader();
    }
    
    /**
     * Apply post-processing shader
     */
    private function applyPostShader():Void {
        var depthTestEnabled = GL.glIsEnabled(GL.GL_DEPTH_TEST);
        if (depthTestEnabled) GL.glDisable(GL.GL_DEPTH_TEST);
        
        postShader.useShader();

        postShader.update(Vupx.deltaTime);
        
        for (key in shaderParams.keys()) {
            var param = shaderParams.get(key);
            
            switch(param.type) {
                case INT:
                    if (param.values.length >= 1)
                        postShader.setValue(INT, key, param.values[0]);
                case FLOAT:
                    if (param.values.length >= 1)
                        postShader.setValue(FLOAT, key, param.values[0]);
                case VEC2:
                    if (param.values.length >= 2)
                        postShader.setValue(VEC2, key, param.values[0], param.values[1]);
                case VEC3:
                    if (param.values.length >= 3)
                        postShader.setValue(VEC3, key, param.values[0], param.values[1], param.values[2]);
                case VEC4:
                    if (param.values.length >= 4)
                        postShader.setValue(VEC4, key, param.values[0], param.values[1], param.values[2], param.values[3]);
                case MATRIX4:
                    if (param.values.length >= 1)
                        postShader.setValue(MATRIX4, key, param.values[0]);
                case BOOL:
                    if (param.values.length >= 1)
                        postShader.setValue(BOOL, key, param.values[0]);
            }
        }
        
        GL.glActiveTexture(GL.GL_TEXTURE0);
        GL.glBindTexture(GL.GL_TEXTURE_2D, _postTexture);
        postShader.sendTexture(0, 0);
        
        GL.glBindVertexArray(_postVAO);
        GL.glDrawArrays(GL.GL_TRIANGLE_STRIP, 0, 4);
        GL.glBindVertexArray(0);
        
        GL.glBindTexture(GL.GL_TEXTURE_2D, 0);
        postShader.stopShader();
        
        if (depthTestEnabled) GL.glEnable(GL.GL_DEPTH_TEST);
    }
    
    /**
     * Upload the instance data to the GPU
     */
    private function uploadToGPU():Void {
        if (visibleCount == 0) return;
        
        GL.glBindBuffer(GL.GL_ARRAY_BUFFER, _instanceVBO);
        
        var dataSize = visibleCount * FLOATS_PER_INSTANCE * 4;
        
        GL.glBufferSubData(GL.GL_ARRAY_BUFFER, 0, dataSize, 
            cast NativeArray.address(instanceData, 0));
    }
    
    /**
     * Forces a full update of the batch
     */
    public function forceUpdateAll():Void {
        for (i in 0...sprites.length) {
            dirtySprites[i] = true;
        }
        needsGPUUpload = true;
        
        lastCameraX = camera.x - cameraMovementThreshold * 2;
    }
    
    /**
     * Clears the batch
     */
    public function clear():Void {
        for (sprite in sprites) {
            sprite.currentBatch = null;
            sprite.batchIndex = -1;
        }
        sprites.resize(0);
        visibleIndices.resize(0);
        
        for (i in 0...dirtySprites.length) {
            dirtySprites[i] = false;
        }
        
        needsGPUUpload = true;
        visibleCount = 0;
    }
    
    /**
     * Destroys the batch
     */
    public function destroy():Void {
        if (_VAO != 0) GL.glDeleteVertexArrays(1, Pointer.addressOf(_VAO));
        if (_VBO != 0) GL.glDeleteBuffers(1, Pointer.addressOf(_VBO));
        if (_instanceVBO != 0) GL.glDeleteBuffers(1, Pointer.addressOf(_instanceVBO));
        
        // Clean up post-processing
        if (_postFBO != 0) GL.glDeleteFramebuffers(1, Pointer.addressOf(_postFBO));
        if (_postTexture != 0) GL.glDeleteTextures(1, Pointer.addressOf(_postTexture));
        if (_postRBO != 0) GL.glDeleteRenderbuffers(1, Pointer.addressOf(_postRBO));
        if (_postVAO != 0) GL.glDeleteVertexArrays(1, Pointer.addressOf(_postVAO));
        if (_postVBO != 0) GL.glDeleteBuffers(1, Pointer.addressOf(_postVBO));
        
        if (shader != null) shader.destroy();
        
        // Clean up memory
        transformedX = null;
        transformedY = null;
        sprites = null;
        instanceData = null;
        dirtySprites = null;
        visibleIndices = null;
        shaderParams = null;
    }
    
    /**
     * Get debug info about this batch
     * @return String
     */
    public function getDebugInfo():String {
        var shaderName = postShader != null ? postShader.tag : "default";
        return 'Total: ${sprites.length}, Visible: ${visibleCount}, Shader: ${shaderName}, GPU Uploads: ${needsGPUUpload ? "PENDING" : "Clean"}';
    }
}