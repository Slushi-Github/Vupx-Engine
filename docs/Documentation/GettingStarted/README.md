<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Getting Started with Vupx Engine

You need some dependencies to use this project. These are:

- [Haxe](https://haxe.org)

- [DevkitPro (Official Guide)](https://devkitpro.org/wiki/Getting_Started)

Once you have Haxe and DevKitPro with DevKitA64 installed, install the Vupx Engine dependencies:

(If you are on Linux/macOS, you will most likely need to use `sudo dkp-pacman` instead of `pacman`)

```bash
pacman -S --needed 
switch-bzip2 
switch-cmake 
switch-curl 
switch-flac 
switch-freetype 
switch-glad 
switch-glm 
switch-harfbuzz 
switch-libdrm_nouveau 
switch-libjpeg-turbo 
switch-libmodplug 
switch-libogg 
switch-libopus 
switch-libpng 
switch-libvorbis 
switch-libvorbisidec 
switch-libwebp 
switch-mesa 
switch-mpg123 
switch-openal-soft 
switch-opusfile 
switch-pkg-config 
switch-sdl2 
switch-sdl2_gfx 
switch-sdl2_image 
switch-sdl2_mixer 
switch-sdl2_net 
switch-sdl2_ttf 
switch-tools 
switch-zlib
```

We are now done with the most important (and possibly longest) part. Next, we are going to create the project:

Create a new folder wherever you want the project to live, enter it, open a terminal, and run:

```bash
haxelib newrepo
```

`haxelib newrepo` is optional, but it is recommended to avoid conflicts with other dependencies you may already have.

You need `hx_libnx` and `hxcpp` in order to use Vupx Engine. These dependencies are:

```bash
haxelib git hxcpp https://github.com/Slushi-Github/hxcpp-nx.git
```

```bash
haxelib git hx_libnx https://github.com/Slushi-Github/hx_libnx.git
```

`hxcpp-nx` is a fork of hxcpp made to work on the Nintendo Switch, and `hx_libnx` is the libnx library for use in Haxe together with that hxcpp fork.

Now get the latest version of Vupx Engine from GitHub:

```bash
haxelib git vupxengine https://github.com/Slushi-Github/Vupx-Engine.git
```

Next, you need HaxeNXCompiler. This is the main compiler for Haxe projects on the console:

You need version `3.0.0` or higher of HaxeNXCompiler. Get it [here](https://github.com/Slushi-Github/HaxeNXCompiler/blob/main/docs/guides/GetStarted.md).

Place the HaxeNXCompiler executable in the root folder of your project and run:

```bash
HaxeNXCompiler --prepare
```

(This command creates an example XML project file, but it is ONLY AN EXAMPLE. You will need to modify it for your own project.)

Now create a folder where your project’s source code will live (this must be specified in the project file). In this example, it will be the `source` folder. Inside this folder, create a file called `Main.hx` with the following content:

```haxe
package source;

import vupx.VupxEngine;

class Main {
    public static function main():Void {
        VupxEngine.init("MyProject", new MyFirstState(), true);
    }
}
```

The first argument of `VupxEngine.init` is your project name, the second one is the state you want to load when the engine starts, and the third argument specifies whether you want to show a splash screen before loading the initial state.

But wait, what is that `new MyFirstState()`? This is the first state the engine will try to load. Let’s create it as well in another file called `MyFirstState.hx`:

```haxe
package source;

import vupx.core.VpConstants;
import vupx.objects.VpText;
import vupx.states.VpState;

class MyFirstState extends VpState {
    override public function create():Void {
        // Create a text sprite
        var spriteText = new VpText(0, 0, "Hello World", VpConstants.VUPX_DEFAULT_FONT_PATH, 24);
        spriteText.center(); // Center the text on the screen
        add(spriteText); // Add the text sprite to the state
    }
}
```

Here we create a class called `MyFirstState` that extends `VpState` and override the `create` method.

Inside it, we create a text sprite and add it to the state.

Once everything is ready, you just need to run the compiler and that’s it. Your project will be ready to run on the Nintendo Switch console:

```bash
HaxeNXCompiler --compile
```

The project will be compiled and the executable will be saved in the folder:
`YourProject/YourOutput/SwitchFiles/YourProject.nro`

If you have configured your console’s IP address in the project file, you can run the following command to send the compiled project to the console:

```bash
HaxeNXCompiler --send
```