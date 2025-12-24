<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Audio y musica

En esta seccion veremos como usar el audio y la musica en Vupx Engine

## Audio

Es tan simple como:

```haxe
import vupx.Vupx;

// Reproducir un sonido
Vupx.audio.play("path/to/sound.ogg", false); // false para que no se repita
```

Una vez ya reproduciste un sonido una vez, este se guarda en memoria y se puede reproducir de nuevo sin tener que volver a cargarlo.

## Musica

Es tan simple como:

```haxe
import vupx.Vupx;

// Reproducir una musica
Vupx.audio.playMusic("path/to/music.ogg", false); // false para que no se repita
```

Puedes acceder al objeto de musica con `Vupx.audio.music`

-----------

- [`vupx.audio.VpAudio`](../../../../vupx/audio/VpAudio.hx)