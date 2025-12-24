<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Audio and Music

In this section we will see how to use audio and music in Vupx Engine.

## Audio

It’s as simple as:

```haxe
import vupx.Vupx;

// Play a sound
Vupx.audio.play("path/to/sound.ogg", false); // false so it does not loop
```

Once you have played a sound at least once, it is kept in memory and can be played again without having to load it again.

## Music

It’s just as simple:

```haxe
import vupx.Vupx;

// Play music
Vupx.audio.playMusic("path/to/music.ogg", false); // false so it does not loop
```

You can access the music object through `Vupx.audio.music`.

-----------

- [`vupx.audio.VpAudio`](../../../../vupx/audio/VpAudio.hx)