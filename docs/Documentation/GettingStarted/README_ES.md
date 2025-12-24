<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Empezando con Vupx Engine

Necesitas algunas dependencias para usar este pryecto, las cuales son:

- [Haxe](https://haxe.org)

- [DevkitPro (Guia propia)](https://devkitpro.org/wiki/Getting_Started)

Una vez ya tengas Haxe y DevKitPro con DevKitA64 instalados, ahora instala las dependencias de Vupx Engine:

(Si estas en Linux/MacOS, lo mas probable que debas usar `sudo dkp-pacman` en lugar de `pacman`)

```bash
pacman -S --needed \
switch-bzip2 \
switch-cmake \
switch-curl \
switch-flac \
switch-freetype \
switch-glad \
switch-glm \
switch-harfbuzz \
switch-libdrm_nouveau \
switch-libjpeg-turbo \
switch-libmodplug \
switch-libogg \
switch-libopus \
switch-libpng \
switch-libvorbis \
switch-libvorbisidec \
switch-libwebp \
switch-mesa \
switch-mpg123 \
switch-openal-soft \
switch-opusfile \
switch-pkg-config \
switch-sdl2 \
switch-sdl2_gfx \
switch-sdl2_image \
switch-sdl2_mixer \
switch-sdl2_net \
switch-sdl2_ttf \
switch-tools \
switch-zlib
```

Ya terminamos la parte mas importante y tal vez larga, ahora vamos a crear el proyecto:

Crea una nueva carpeta donde queras el proyecto y entra a ella y abre una terminal y ejecuta:

```bash
haxelib newrepo
```

el ``haxelib newrepo`` es opcional pero lo recomiendo, para evitar entrar en conflicto con otras dependencias que puedas tener.

Necesitas `hx_libnx` y `hxcpp` para poder usar Vupx Engine, estas dependencias son:

```bash
haxelib git hxcpp https://github.com/Slushi-Github/hxcpp-nx.git
```

```bash
haxelib git hx_libnx https://github.com/Slushi-Github/hx_libnx.git
```

``hxcpp-nx`` es un fork de hxcpp hecho para funcionar con la Nintendo Switch, ``hx_libnx`` es la libreria libnx para usarla en Haxe junto a ese fork de hxcpp.

Ahora obten la versión más reciente de Vupx Engine desde GitHub:

```bash
haxelib git vupxengine https://github.com/Slushi-Github/Vupx-Engine.git
```

Ahora necesitas HaxeNXCompiler, este es el compilador principal de proyectos de Haxe en la consola:

Necesitas la versión `3.0.0` o superior de HaxeNXCompiler, consiguela [aquí](https://github.com/Slushi-Github/HaxeNXCompiler/blob/main/docs/guides/GetStarted.md).

Coloca el ejecutable de HaxeNXCompiler en la carpeta raiz de tu proyecto y ejecuta:

```bash
HaxeNXCompiler --prepare
```
(Este comando crea un archivo de proyecto en formato XML pero es SOLO DE EJEMPLO, necesitaras modificarlo para tu proyecto)

Ahora crea una carpeta donde estara el codigo fuente de tu proyecto (que debe estar especificado en el archivo de proyecto), en este ejemplo sera la carpeta `source`. En esta carpeta deberas crear un archivo llamado `Main.hx` con el siguiente contenido:

```haxe
package source;

import vupx.VupxEngine;

class Main {
    public static function main():Void {
        VupxEngine.init("MyProject", new MyFirstState(), true);
    }
}
```

El primer argumento de ``VupxEngine.init`` es el nombre de tu proyecto, el segundo es el state que quieres cargar al iniciar el motor, y el tercer argumento es si quieres usar se muestre una pantalla de inicio antes de cargar el state inicial.

Ah pero espera, que es ese ``new MyFirstState()``? Este es el primer state que buscara cargar el motor, vamos a crearlo tambien en otro archivo llamado ``MyFirstState.hx``:

```haxe
package source;

import vupx.core.VpConstants;
import vupx.objects.VpText;
import vupx.states.VpState;

class MyFirstState extends VpState {
    override public fuction create():Void {
        // Crea un sprite de texto
        var spriteText = new VpText(0, 0, "Hello World", VpConstants.VUPX_DEFAULT_FONT_PATH, 24);
        spriteText.center(); // Centra el texto en la pantalla
        add(spriteText); // Agrega el sprite de texto al state
    }
}
```

Aca creamos una clase llamada ``MyFirstState`` que hereda de ``VpState`` y sobreescribimos el metodo ``create``.

Donde creamos el sprite de texto y lo agregamos al state.

Ya que tienes todo listo, ahora solo debes ejecutar el compilador y listo, tu proyecto estara listo para ser ejecutado en la consola de Nintendo Switch:

```bash
HaxeNXCompiler --compile
```

El proyecto se compilara y el ejecutable se guardara en la carpeta ``TuProyecto/TuOutput/SwitchFiles/TuProyecto.nro``

Si tienes configurada la direccion IP de tu consola en archivo del proyecto, puedes ejecutar el siguente comando para enviar el proyecto compilado a la consola:

```bash
HaxeNXCompiler --send
```