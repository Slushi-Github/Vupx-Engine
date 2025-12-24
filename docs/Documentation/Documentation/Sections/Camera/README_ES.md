<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

Cámara

La cámara de Vupx Engine es una cámara 2D, una cámara con proyección ortográfica

Por defecto ya hay una camara base, esta es `Vupx.camera`, y es la que usan todos los objetos de Vupx Engine.

Pero vamos a crear una nueva camara:

```haxe
import vupx.objects.VpSprite;
import vupx.VpCamera;

var newCamera = new VpCamera(0, 0);

var sprite = new VpSprite(100, 100);
sprite.camera = newCamera; // Agregar la camara al sprite
```

El sprite ahora se movera con la camara que le asignaste

```haxe
newCamera.x += 100; // Mover la camara en el eje X
newCamera.y += 100; // Mover la camara en el eje Y
newCamera.z += 100; // Mover la camara en el eje Z
newCamera.angle += 20; // Rotar la camara
newCamera.zoom += 0.1; // Aumentar el zoom de la camara
```

-----------

- [`vupx.VpCamera`](../../../../vupx/VpCamera.hx)