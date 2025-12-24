<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# HD Rumble

One of the new features introduced with the launch of the Nintendo Switch was HD Rumble on the Joy-Cons. Let’s see how to use it:

```haxe
import vupx.Vupx;

// Prepare the data to send
var vibrationData:VpVibration = {
    joycon: VpJoyCon.LEFT,
    duration: 0.2, // Duration of the vibration in seconds
    amplitude_low: 0.5, // Low amplitude of the vibration on the Joy-Con
    frequency_low: 0.5, // Low frequency of the vibration on the Joy-Con
    amplitude_high: 0.5, // High amplitude of the vibration on the Joy-Con
    frequency_high: 0.5, // High frequency of the vibration on the Joy-Con
}

Vupx.controller.vibration.vibrate(vibrationData);

// Make both Joy-Cons vibrate at the same time using the same data
Vupx.controller.vibration.vibrateBoth(vibrationData);

// Stop the vibration
Vupx.controller.vibration.stop(VpJoyCon.LEFT);
```

-----------

- [`vupx.controls.VpVibration`](../../../../vupx/controls/VpVibration.hx)