// Base OpenGL 4.3 Fragment Shader for instanced batched rendering in Vupx Engine
#version 430 core

in vec2 TexCoords;
in float Alpha;
in vec3 Color;
in float IsText;

out vec4 FragColor;

void main() {
    // Early discard for invisible sprites
    if (Alpha < 0.001) discard;
    
    vec4 texColor = texture(VUPX_TEXTURE0, TexCoords);
    
    vec3 finalColor;
    float finalAlpha;
    
    if (IsText > 0.5) {
        // VpText object:
        bool isGrayscale = (texColor.g < 0.01 && texColor.b < 0.01);
        
        if (isGrayscale) {
            // Grayscale texture
            finalColor = Color;
            finalAlpha = texColor.r * Alpha;
        } else {
            // Color texture
            finalColor = texColor.rgb * Color;
            finalAlpha = texColor.a * Alpha;
        }
    } else {
        // VpSprite and sprite objects:
        finalColor = texColor.rgb * Color;
        finalAlpha = texColor.a * Alpha;
    }
    
    FragColor = vec4(finalColor, finalAlpha);
    
    // Discard transparent
    if (FragColor.a < 0.01) discard;
}