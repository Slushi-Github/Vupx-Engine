<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Pantalla táctil de la Switch

Sabemos que la Switch tiene una pantalla tactil, veamos como se usa:

```haxe
import vupx.objects.VpSprite;
import vupx.Vupx;

// Si se presiona un solo toque, el primero siendo el toque 0
if (Vupx.touchScreen.isPressed(0)) {
    // Hacer algo cuando se presiona el toque 0
}

if (Vupx.touchScreen.isJustPressed(0)) {
    // Hacer algo cuando justo se presiona el toque 0
}

if (Vupx.touchScreen.isReleased(0)) {
    // Hacer algo cuando se suelta el toque 0
}

if (Vupx.touchScreen.isJustReleased(0)) {
    // Hacer algo cuando justo se suelta el toque 0
}

// tambien podemos probar con cualquiero toque
if (Vupx.touchScreen.anyPressed()) {
    // Hacer algo cuando se presiona cualquier toque
}

if (Vupx.touchScreen.anyJustPressed()) {
    // Hacer algo cuando justo se presiona cualquier toque
}

if (Vupx.touchScreen.anyReleased()) {
    // Hacer algo cuando se suelta cualquier toque
}

if (Vupx.touchScreen.anyJustReleased()) {
    // Hacer algo cuando justo se suelta cualquier toque
}

var sprite = new VpSprite(100, 100);

if (Vupx.touchScreen.isTouchingAObject(sprite)) {
    // Hacer algo cuando se toca el objeto sprite
}
```

Tambien puedes obtener datos de un toque:

```haxe
var touch = Vupx.touchScreen.getById(0);

var x = touch.x; // Coordenada X
var y = touch.y; // Coordenada Y
var diameter_x = touch.diameter_x; // Diametro X
var diameter_y = touch.diameter_y; // Diametro Y
var rotation_angle = touch.rotation_angle; // Angulo de rotacion
```

Por ultimo puedes obtener una **aproximacion** de la presion de un toque:

```haxe
var pressure:Float = Vupx.touchScreen.estimatePressure(0);
```

Recuerda, esto es una aproximacion, no es exacto, la pantalla tactil es una pantalla capacitiva por lo que no esta pensada para obtener presiones.

-----------

- [`vupx.controls.VpTouchScreen`](../../../../vupx/controls/VpTouchScreen.hx)