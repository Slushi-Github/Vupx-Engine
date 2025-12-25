<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Shaders

Post-processing shaders are used to apply visual effects to sprites. This is the most complex part of Vupx Engine, but let’s see how to do it:

```haxe
import vupx.core.shaders.VpShader;
import vupx.objects.VpSprite;

// Create a sprite
var sprite = new VpSprite();
sprite.createGraphic(320, 320, VpColor.WHITE);

// Now let's create a chromatic aberration shader:
var shader = new VpShader(null, '
    #version 430 core
    precision highp float;

    // Texture coordinates and output
    in vec2 TexCoords;
    out vec4 FragColor;

    // Texture
    uniform sampler2D VUPX_TEXTURE0;

    // Effect intensity (0.0 = disabled)
    uniform float uStrength;

    // Optical center (usually 0.5, 0.5)
    uniform vec2 uCenter;

    void main() {
        vec2 dir = TexCoords - uCenter;
        float dist = length(dir);

        /* Distance-dependent offset */
        vec2 offset = dir * uStrength * dist;

        float r = texture(VUPX_TEXTURE0, TexCoords + offset).r;
        float g = texture(VUPX_TEXTURE0, TexCoords).g;
        float b = texture(VUPX_TEXTURE0, TexCoords - offset).b;

        FragColor = vec4(r, g, b, 1.0);
    }
', "ChromaticAberrationShader");

// Apply the shader to the sprite
sprite.setPostShader(shader);

// Add the sprite to the state
add(sprite);

// Now adjust the parameters
sprite.setShaderParam("uStrength", ShaderVariable.FLOAT, 0.1);
sprite.setShaderParam("uCenter", ShaderVariable.VEC2, 0.5, 0.5);
```

Shaders are currently in an experimental phase, so keep in mind that they may fail or change in the future.

**At the moment**, shaders can only be applied to sprites, not to cameras, and the texts do not support shaders yet.

-----------

- [`vupx.core.shaders.VpShader`](../../../../vupx/core/shaders/VpShader.hx)
- [`vupx.objects.VpSprite`](../../../../vupx/objects/VpSprite.hx)