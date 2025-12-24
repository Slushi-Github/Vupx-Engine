<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Nintendo Switch Touch Screen

We know that the Nintendo Switch has a touch screen. Let’s see how to use it:

```haxe
import vupx.objects.VpSprite;
import vupx.Vupx;

// If a single touch is pressed, the first one being touch 0
if (Vupx.touchScreen.isPressed(0)) {
    // Do something when touch 0 is pressed
}

if (Vupx.touchScreen.isJustPressed(0)) {
    // Do something when touch 0 is just pressed
}

if (Vupx.touchScreen.isReleased(0)) {
    // Do something when touch 0 is released
}

if (Vupx.touchScreen.isJustReleased(0)) {
    // Do something when touch 0 is just released
}

// We can also check for any touch
if (Vupx.touchScreen.anyPressed()) {
    // Do something when any touch is pressed
}

if (Vupx.touchScreen.anyJustPressed()) {
    // Do something when any touch is just pressed
}

if (Vupx.touchScreen.anyReleased()) {
    // Do something when any touch is released
}

if (Vupx.touchScreen.anyJustReleased()) {
    // Do something when any touch is just released
}

var sprite = new VpSprite(100, 100);

if (Vupx.touchScreen.isTouchingAObject(sprite)) {
    // Do something when the sprite object is touched
}
```

You can also get data from a touch:

```haxe
var touch = Vupx.touchScreen.getById(0);

var x = touch.x; // X coordinate
var y = touch.y; // Y coordinate
var diameter_x = touch.diameter_x; // X diameter
var diameter_y = touch.diameter_y; // Y diameter
var rotation_angle = touch.rotation_angle; // Rotation angle
```

Finally, you can get an **approximation** of the touch pressure:

```haxe
var pressure:Float = Vupx.touchScreen.estimatePressure(0);
```

Remember, this is only an approximation, it is not exact. The touch screen is capacitive and is not designed to measure pressure.

-----------

- [`vupx.controls.VpTouchScreen`](../../../../vupx/controls/VpTouchScreen.hx)