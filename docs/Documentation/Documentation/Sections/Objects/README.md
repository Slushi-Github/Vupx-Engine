<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Objects

## Sprites

Creating sprites is simple. It is done as follows:

```haxe
import vupx.objects.VpSprite;

var sprite = new VpSprite(100, 100);
```

Here it changes depending on whether you want to load an image or create a graphic:

```haxe
// To load an image:
sprite.loadImage("path/to/image.png");

// To create a graphic:
sprite.createGraphic(200, 200);
```

Finally, you always have to add them to the state:

```haxe
add(sprite);
```

## Text

Creating text is also simple. If you have seen the getting started guide, you have already seen how to create it:

```haxe
import vupx.core.VpConstants;
import vupx.objects.VpText;

var text = new VpText(100, 100, "Hello World", VpConstants.VUPX_DEFAULT_FONT_PATH, 24);
add(text);
```

`VpConstants.VUPX_DEFAULT_FONT_PATH` is the path to the default font. If you want to change it, just change the string.

## Animated sprites

If you want to create an animated sprite, you can do it as follows:

```haxe
import vupx.objects.VpAnimatedSprite;

var sprite = new VpAnimatedSprite(100, 100);
sprite.loadSpritesheet("path/to/spritesheet.xml", "path/to/spritesheet.png");
add(sprite);

sprite.addAnimation("idle", "idle", 8, true);
sprite.play("idle");
```

`sprite.loadSpritesheet` is used to load the spritesheet, `sprite.addAnimation` is used to add an animation, and `sprite.play` is used to play the animation.

## More information

These objects always exist in a 3D space, so you can move and rotate them within that space:

```haxe
// Normal 2D
sprite.x += 100; // Move the sprite on the X axis
sprite.y += 100; // Move the sprite on the Y axis
sprite.angle += 20; // Rotate the sprite

// Now 3D
sprite.z += 100; // Move the sprite away from the camera
sprite.rotationX += 20; // Rotate the sprite on the X axis
sprite.rotationY += 20; // Rotate the sprite on the Y axis
```

And to add a skew effect:

```haxe
sprite.skewX += 20;
sprite.skewY += 20;
```

(Keep in mind that with `VpText`, applying very large skew values that might be small for a `VpSprite` can cause the text to become so distorted that it is no longer readable.)

-----------

- [`vupx.objects.VpBaseObject`](../../../../vupx/objects/VpBaseObject.hx) (Parent of all objects)
- [`vupx.objects.VpSprite`](../../../../vupx/objects/VpSprite.hx)
- [`vupx.objects.VpText`](../../../../vupx/objects/VpText.hx)
- [`vupx.objects.VpAnimatedSprite`](../../../../vupx/objects/VpAnimatedSprite.hx)