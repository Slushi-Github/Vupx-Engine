<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Tweens

Los tweens son para mover objetos de forma suave, con una animación suave, si sabes como hacer tweens en HaxeFlixel, te resultara familiar, solo que con Vupx Engine es un poco diferente, veamos como se usa:

```haxe
import vupx.objects.VpSprite;
import vupx.tweens.VpTween;
import vupx.tweens.VpEase;

var sprite = new VpSprite(100, 100);
sprite.loadImage("path/to/image.png");
add(sprite);

VpTween.tween(sprite, {x: 200, alpha: 0}, 3, VpEase.linear, {
    onStart: function() {
        // Cuando el tween se inicie
    }
    onComplete: function() {
        // Cuando el tween se complete
    },
    onUpdate: function() {
        // Cuando el tween se actualice
    }
});
```

-----------

- [`vupx.tweens.VpTween`](../../../../vupx/tweens/VpTween.hx)
- [`vupx.tweens.VpEase`](../../../../vupx/tweens/VpEase.hx)