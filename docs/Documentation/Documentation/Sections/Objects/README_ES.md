<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Objectos

## Sprites

Crear sprites es sencillo, se hace de la siguiente manera:

```haxe
import vupx.objects.VpSprite;

var sprite = new VpSprite(100, 100);
```

Aca cambia si deseas cargar una imagen o crear un grafico:

```haxe
// Para cargar una imagen:
sprite.loadImage("path/to/image.png");

// Para crear un grafico:
sprite.createGraphic(200, 200);
```

Por ultimo siempre tienes que agregarlos al state:

```haxe
add(sprite);
```

## Textos

Crear textos tambien sencillo, si viste la guia de inicio, ya vistias como crearlos:

```haxe
import vupx.core.VpConstants;
import vupx.objects.VpText;

var text = new VpText(100, 100, "Hello World", VpConstants.VUPX_DEFAULT_FONT_PATH, 24);
add(text);
```

Este ``VpConstants.VUPX_DEFAULT_FONT_PATH`` es el path de la fuente por defecto, si deseas cambiarla, solo cambia el string.

## Sprites animados

Bien, si deseas hacer un sprite animado, puedes hacerlo de la siguiente manera:

```haxe
import vupx.objects.VpAnimatedSprite;

var sprite = new VpAnimatedSprite(100, 100);
sprite.loadSpritesheet("path/to/spritesheet.xml", "path/to/spritesheet.png");
add(sprite);

sprite.addAnimation("idle", "idle", 8, true);
sprite.play("idle");
```

El ``sprite.loadSpritesheet`` es para cargar la spritesheet, el ``sprite.addAnimation`` es para agregar una animacion, el ``sprite.play`` es para reproducir la animacion.

## más información

Estos objetos estan siempre en un espacio 3D, asi que puedes moverlos y rotarlos en ese espacio:

```haxe
// Normal 2D
sprite.x += 100; // Mover el sprite en el eje X
sprite.y += 100; // Mover el sprite en el eje Y
sprite.angle += 20; // Rotar el sprite

// Ahora 3D
sprite.z += 100; // Alejar el sprite de la camara
sprite.rotationX += 20; // Rotar el sprite en el eje X
sprite.rotationY += 20; // Rotar el sprite en el eje Y
```

Y para agregar un efecto de sesgo:

```haxe
sprite.skewX += 20;
sprite.skewY += 20;
```

(Ten en cuenta que con `VpText` aplicar valores muy grandes de sesgo que para un `VpSprite` pueden ser aun pequeños, pueden hacer que el texto se deforme tanto que no se pueda leer)

-----------

- [`vupx.objects.VpBaseObject`](../../../../vupx/objects/VpBaseObject.hx) (Padre de todos los objetos)
- [`vupx.objects.VpSprite`](../../../../vupx/objects/VpSprite.hx)
- [`vupx.objects.VpText`](../../../../vupx/objects/VpText.hx)
- [`vupx.objects.VpAnimatedSprite`](../../../../vupx/objects/VpAnimatedSprite.hx)