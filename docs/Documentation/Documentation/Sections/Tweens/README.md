<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Tweens

Tweens are used to move objects smoothly, with a fluid animation. If you know how to do tweens in HaxeFlixel, it will feel familiar, although with Vupx Engine it is a bit different. Let’s see how to use them:

```haxe
import vupx.objects.VpSprite;
import vupx.tweens.VpTween;
import vupx.tweens.VpEase;

var sprite = new VpSprite(100, 100);
sprite.loadImage("path/to/image.png");
add(sprite);

VpTween.tween(sprite, {x: 200, alpha: 0}, 3, VpEase.linear, {
    onStart: function() {
        // When the tween starts
    },
    onComplete: function() {
        // When the tween completes
    },
    onUpdate: function() {
        // When the tween updates
    }
});
```

-----------

- [`vupx.tweens.VpTween`](../../../../vupx/tweens/VpTween.hx)
- [`vupx.tweens.VpEase`](../../../../vupx/tweens/VpEase.hx)