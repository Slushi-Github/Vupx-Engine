// Base OpenGL 4.3 Vertex Shader for instanced batched rendering in Vupx Engine
#version 430 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aBaseTexCoords;

// Instanced attributes 
layout (location = 2) in mat4 instanceModel;       // Model matrix pre-calculated from CPU 
layout (location = 6) in float instanceAlpha;      // Alpha
layout (location = 7) in vec3 instanceColor;       // Color RGB
layout (location = 8) in vec4 instanceUV;          // u0, v0, u1, v1
layout (location = 9) in float instancePerspStrength;  // Perspective strength per-instance
layout (location = 10) in float instanceIsText;     // IsText flag

out vec2 TexCoords;
out float Alpha;
out vec3 Color;
out float IsText;

uniform mat4 projection;
uniform mat4 view;
uniform float cameraAlpha;
uniform float MIN_MAX_Z_COORD;

void main() {
    // Early discard for invisible sprites
    if (instanceAlpha < 0.001) {
        gl_Position = vec4(0.0);
        Alpha = 0.0;
        return;
    }
    
    Alpha = instanceAlpha * cameraAlpha;
    Color = instanceColor;
    IsText = instanceIsText;
    
    // UVs mapping
    TexCoords = vec2(
        mix(instanceUV.x, instanceUV.z, aBaseTexCoords.x),
        mix(instanceUV.y, instanceUV.w, aBaseTexCoords.y)
    );
    
    // Aplicate matrix model
    vec4 worldPos = instanceModel * vec4(aPos, 1.0);
    
    // Aplicate matrix from camera
    vec4 clipPos = projection * view * worldPos;
    
    // Z-buffer mapping
    float zNear = -MIN_MAX_Z_COORD;
    float zFar = MIN_MAX_Z_COORD;
    float normalizedZ = (worldPos.z - zNear) / (zFar - zNear);
    clipPos.z = normalizedZ * 2.0 - 1.0;
    
    // Aplicate perspective strength
    clipPos.w += worldPos.z * instancePerspStrength;
    
    gl_Position = clipPos;
}