<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Controls

<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

Vupx Engine uses the Nintendo Switch’s native controller API in order to handle Switch controls in your game, but in a simplified and more focused way.

Let’s see how to use them:

```haxe
import vupx.Vupx;

if (Vupx.controller.isPressed(VpControlButton.A)) {
    // do something when A is pressed
}

if (Vupx.controller.isJustPressed(VpControlButton.B)) {
    // do something when B is just pressed
}

if (Vupx.controller.isReleased(VpControlButton.X)) {
    // do something when X is released
}

if (Vupx.controller.isJustReleased(VpControlButton.Y)) {
    // do something when Y is just released
}
```

You can also get the joystick values:

```haxe
var leftStick = Vupx.controller.getStickL();
var rightStick = Vupx.controller.getStickR();

var leftStickX = leftStick.x;
var leftStickY = leftStick.y;

var rightStickX = rightStick.x;
var rightStickY = rightStick.y;
```

Finally, you can get the Joy-Con colors:

```haxe
var color:VpJoyConColor = Vupx.controller.getJoyConColor(VpJoyCon.LEFT);

var leftMainColor:VpColor = color.colorMain; // Main color of the left Joy-Con (shell)
var leftSubColor:VpColor = color.colorSub;   // Secondary color of the left Joy-Con (buttons)
```

-----------

- [`vupx.controls.VpControl`](../../../../vupx/controls/VpControl.hx)
- [`vupx.controls.VpControlButton`](../../../../vupx/controls/VpControlButton.hx)
