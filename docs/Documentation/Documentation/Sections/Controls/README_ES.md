<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Controles

Vupx Engine usa la API directa de los controles de la Switch para poder usar los controles de la Switch en tu juego, pero simplificando y enfocando sus usos.

Asi que veamos como usarlos:

```haxe
import vupx.Vupx;

if (Vupx.controller.isPressed(VpControlButton.A)) {
    // hacer algo cuando se presiona A
}

if (Vupx.controller.isJustPressed(VpControlButton.B)) {
    // hacer algo cuando justo se presiona B
}

if (Vupx.controller.isReleased(VpControlButton.X)) {
    // hacer algo cuando se suelta X
}

if (Vupx.controller.isJustReleased(VpControlButton.Y)) {
    // hacer algo cuando justo se suelta Y
}
```

Tambien puedes obtener los valores de los joysticks:

```haxe
var leftStick = Vupx.controller.getStickL();
var rightStick = Vupx.controller.getStickR();

var leftStickX = leftStick.x;
var leftStickY = leftStick.y;

var rightStickX = rightStick.x;
var rightStickY = rightStick.y;
```

Por ultimo, puedes obtener el color de los Joy-Cons:

```haxe
var color:VpJoyConColor = Vupx.controller.getJoyConColor(VpJoyCon.LEFT);

var leftMainColor:VpColor = color.colorMain; // Color principal del Joy-Con izquierdo, de la carcasa
var leftSubColor:VpColor = color.colorSub; // Color secundario del Joy-Con izquierdo, de los botones
```

-----------

- [`vupx.controls.VpControl`](../../../../vupx/controls/VpControl.hx)
- [`vupx.controls.VpControlButton`](../../../../vupx/controls/VpControlButton.hx)