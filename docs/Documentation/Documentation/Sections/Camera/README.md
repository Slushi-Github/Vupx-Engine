<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Camera

The Vupx Engine camera is a 2D camera with an orthographic projection.

By default, there is already a base camera. This is `Vupx.camera`, and it is the one used by all Vupx Engine objects.

But let’s create a new camera:

```haxe
import vupx.objects.VpSprite;
import vupx.VpCamera;

var newCamera = new VpCamera(0, 0);

var sprite = new VpSprite(100, 100);
sprite.camera = newCamera; // Assign the camera to the sprite
```

The sprite will now move together with the camera you assigned to it.

```haxe
newCamera.x += 100; // Move the camera on the X axis
newCamera.y += 100; // Move the camera on the Y axis
newCamera.z += 100; // Move the camera on the Z axis
newCamera.angle += 20; // Rotate the camera
newCamera.zoom += 0.1; // Increase the camera zoom
```

-----------

- [`vupx.VpCamera`](../../../../vupx/VpCamera.hx)