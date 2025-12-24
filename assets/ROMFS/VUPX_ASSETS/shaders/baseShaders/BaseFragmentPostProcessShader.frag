// Simple passthrough fragment shader for Vupx Engine
#version 430 core
precision highp float;

in vec2 TexCoords;
out vec4 FragColor;

uniform sampler2D VUPX_TEXTURE0;

void main() {
    FragColor = texture(VUPX_TEXTURE0, TexCoords);
}