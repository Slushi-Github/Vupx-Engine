<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

Vibración HD

Algo nuevo que se presento cuando se lanzo la Nintendo Switch, fue la vibración HD de sus Joy-Cons, veamos como se usa:

```haxe
import vupx.Vupx;

// Ppreparemos los datos para enviar
var vibrationData:VpVibration = {
    joycon: VpJoyCon.LEFT,
    duration: 0.2, // Duración de la vibración en segundos
    amplitude_low: 0.5, // Amplitud baja de la vibración en el Joy-Con 
    frequency_low: 0.5, // Frecuencia baja de la vibración en el Joy-Con
    amplitude_high: 0.5, // Amplitud alta de la vibración en el Joy-Con 
    frequency_high: 0.5, // Frecuencia alta de la vibración en el Joy-Con
}

Vupx.controller.vibration.vibrate(vibrationData);

// Podemos hacer que los dos Joy-Cons vibren al mismo tiempo con los mismos datos
Vupx.controller.vibration.vibrateBoth(vibrationData);

// Parar la vibración
Vupx.controller.vibration.stop(VpJoyCon.LEFT);
```

-----------

- [`vupx.controls.VpVibration`](../../../../vupx/controls/VpVibration.hx)