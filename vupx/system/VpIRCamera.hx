package vupx.system;

import switchLib.services.Irs;

/*
 * A class for using the IR camera of the right Joy-Con
 * 
 * Author: Slushi
 */
class VpIRCamera extends VpBase {
    private var irHandle:IrsIrCameraHandle;
    private var irBuffer:Pointer<UInt8>;
    private var rgbaBuffer:Pointer<UInt32>;
    private var irBufferSize:SizeT = 0x12c00;
    private var samplingNumber:UInt64 = 0;
    
    public static inline final IR_WIDTH:Int = 320;
    public static inline final IR_HEIGHT:Int = 240;
    
    /**
     * The texture containing the IR image
     */
    public var texture:VpTexture;

    /**
     * Whether the IR camera is running
     */
    public var isRunning:Bool = false;
    
    public function new(?npadId:Int32 = null) {
        super();

        if (npadId == null) {
            npadId = HidNpadIdType.HidNpadIdType_No1;
        }

        var result:ResultType = Irs.irsInitialize();
        if (Result.R_FAILED(result)) {
            VupxDebug.log('irsInitialize failed: 0x${StringTools.hex(result)}', ERROR);
            return;
        }

        initializeIR(npadId);
    }
    
    private function initializeIR(npadId:Int):Void {
        irBuffer = Stdlib.malloc(irBufferSize);
        if (irBuffer == null) {
            VupxDebug.log("Failed to allocate IR buffer", ERROR);
            return;
        }
        
        rgbaBuffer = Stdlib.malloc(IR_WIDTH * IR_HEIGHT * Stdlib.sizeof(cpp.UInt32));
        if (rgbaBuffer == null) {
            Stdlib.free(irBuffer);
            VupxDebug.log("Failed to allocate RGBA buffer", ERROR);
            return;
        }
        
        // Clear buffers
        CPPHelpers.memset(cast irBuffer, 0, irBufferSize);
        CPPHelpers.memset(cast rgbaBuffer, 0, IR_WIDTH * IR_HEIGHT * Stdlib.sizeof(cpp.UInt32));
        
        // Get IR camera handle
        irHandle = new IrsIrCameraHandle();
        var result = Irs.irsGetIrCameraHandle(Pointer.addressOf(irHandle), npadId);
        
        if (result != 0) {
            VupxDebug.log('irsGetIrCameraHandle failed: 0x${StringTools.hex(result)}', ERROR);
            cleanup();
            return;
        }
        
        // Get default config and start processor
        var config = new IrsImageTransferProcessorConfig();
        Irs.irsGetDefaultImageTransferProcessorConfig(Pointer.addressOf(config));
        
        result = Irs.irsStartImageTransferProcessor(
            irHandle,
            Pointer.addressOf(config), 
            0x100000
        );
        
        if (result != 0) {
            VupxDebug.log('irsStartImageTransferProcessor failed: 0x${StringTools.hex(result)}', ERROR);
            cleanup();
            return;
        }
        
        // Create initial texture
        texture = VpTexture.createFromPixelData(
            IR_WIDTH, 
            IR_HEIGHT, 
            untyped __cpp__("(uint8_t*){0}", rgbaBuffer.raw)
        );
        
        if (texture != null) {
            isRunning = true;
            VupxDebug.log("IR Camera initialized successfully", INFO);
        } else {
            cleanup();
        }
    }
    
    /**
     * Update the IR image and texture
     * @return true if image was updated
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (!isRunning || texture == null) return;
        
        var state = new IrsImageTransferProcessorState();
        var result = Irs.irsGetImageTransferProcessorState(
            irHandle,
            untyped __cpp__("(void*){0}", irBuffer),
            irBufferSize,
            Pointer.addressOf(state)
        );
        
        if (result != 0) {
            // Not an error, maybe just means no new image yet
            return;
        }
        
        // Check if sampling number changed (new image available)
        if (state.sampling_number == samplingNumber) {
            return;
        }
        
        samplingNumber = state.sampling_number;
        
        // Convert grayscale to RGBA (green channel like original)
        untyped __cpp__("
            for (uint32_t i = 0; i < {0} * {1}; i++) {
                uint8_t gray = ((uint8_t*){2})[i];
                ((uint32_t*){3})[i] = 0xFF000000 | (gray << 8); // RGBA: A=255, R=0, G=gray, B=0
            }
        ", IR_WIDTH, IR_HEIGHT, irBuffer, rgbaBuffer);
        
        // Update texture
        texture.updatePixelData(untyped __cpp__("(void*){0}", rgbaBuffer));
        
        return;
    }
    
    /**
     * Get the current sampling number
     */
    public function getSamplingNumber():UInt64 {
        return samplingNumber;
    }
    
    /**
     * Stop the IR camera
     */
    public function stop():Void {
        if (!isRunning) return;
        
        Irs.irsStopImageProcessorAsync(irHandle);
        
        cleanup();
        
        isRunning = false;
        VupxDebug.log("IR Camera stopped", INFO);
    }
    
    private function cleanup():Void {
        if (irBuffer != null) {
            Stdlib.free(irBuffer);
            irBuffer = null;
        }
        
        if (rgbaBuffer != null) {
            Stdlib.free(rgbaBuffer);
            rgbaBuffer = null;
        }
    }
    
    override public function destroy():Void {
        stop();
        if (texture != null) {
            texture.destroy();
            texture = null;
        }
    }
}