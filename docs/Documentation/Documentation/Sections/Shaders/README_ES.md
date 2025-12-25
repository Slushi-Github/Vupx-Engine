<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Shaders

Los shaders (no, no le dire "sombredores") de postprocesado son usados para aplicar efectos visuales a sprites, esta es la parte mas complicada de Vupx Engine, pero vemos como hacerlo:

```haxe
import vupx.core.shaders.VpShader;
import vupx.objects.VpSprite;

// Creamos un sprite
var sprite = new VpSprite();
sprite.createGraphic(320, 320, VpColor.WHITE);

// Ahora creemos un shader de aberración cromática:
var shader = new VpShader(null, '
    #version 430 core
    precision highp float;

    // Coordenadas de textura y salida
    in vec2 TexCoords;
    out vec4 FragColor;

    // Textura
    uniform sampler2D VUPX_TEXTURE0;

    // Intensidad del efecto (0.0 = apagado)
    uniform float uStrength;

    // Centro óptico (normalmente 0.5, 0.5)
    uniform vec2 uCenter;

    void main() {
        vec2 dir = TexCoords - uCenter;
        float dist = length(dir);

        /* Desplazamiento dependiente de distancia */
        vec2 offset = dir * uStrength * dist;

        float r = texture(VUPX_TEXTURE0, TexCoords + offset).r;
        float g = texture(VUPX_TEXTURE0, TexCoords).g;
        float b = texture(VUPX_TEXTURE0, TexCoords - offset).b;

        FragColor = vec4(r, g, b, 1.0);
    }
', "ChromaticAberrationShader");

// Aplicamos el shader al sprite
sprite.setPostShader(shader);

// Agregamos el sprite al state
add(sprite);

// Y ahora ajustamos los parámetros
sprite.setShaderParam("uStrength", ShaderVariable.FLOAT, 0.1);
sprite.setShaderParam("uCenter", ShaderVariable.VEC2, 0.5, 0.5);
```

Los shaders estan en una fase experimental, asi que tengan en cuenta que pueden fallar o tener cambios futuros.

Los shaders **de momento** solo pueden ser aplicados a sprites, no a cámaras, y los textos no soportan shaders todavia.

-----------

- [`vupx.core.shaders.VpShader`](../../../../vupx/core/shaders/VpShader.hx)

- [`vupx.objects.VpSprite`](../../../../vupx/objects/VpSprite.hx)
