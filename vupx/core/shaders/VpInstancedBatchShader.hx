package vupx.core.shaders;

import vupx.core.shaders.VpShader;

/**
 * This is the class for the instanced batch shader
 */
@:noCompletion
class VpInstancedBatchShader extends VpShader {
    public function new() {
        super(VpConstants.VUPX_BATCH_BASE_VERTEX_SHADER, VpConstants.VUPX_BATCH_BASE_FRAGMENT_SHADER, "BaseInstancedBatchShader", ShaderType.VERTEX_AND_FRAGMENT);
    }
}