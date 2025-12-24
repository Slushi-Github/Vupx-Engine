# Vupx Engine - Haxe/C++ bindings

<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

Vupx Engine is built on several libraries that are required. Since this is a project built on Haxe and the libraries are external, this is the reason for the ``@:native`` bindings for the Haxe C++ target ([HXCPP -> ``NX``, ``HX_NX``](https://github.com/Slushi-Github/hxcpp-nx) (The Nintendo Switch)).

All of these bindings are made specifically for this project. Honestly, I couldn't find any well-made or up-to-date Haxe bindings for the libraries that fit what I needed. Looking at the libraries and how *common* the Nintendo Switch is, I'm sure these libraries could work in other projects, but their purpose was for the Vupx Engine (Perhaps in the future I will publish Haxe libraries of only these bindings, just as I did with libnx ([hx_libnx](https://github.com/Slushi-Github/hx_libnx))...).

None of the bindings have documentation as such; only the functions that have been needed so far exist.

## The libraries used in this project are:

**SDL2**: The main library used for just windowing and intialization of OpenGL.
* **SDL2_Image**: Used for loading images and send them to OpenGL.
* **SDL2_Mixer**: The main current audio engine for this project.

**OpenAL Soft**: Unused library, but it is for play audio files.

**OpenGL 4.3**: The main graphics library used for this project.

**GLAD**: Used to load OpenGL functions.

**GLM**: The OpenGL math library. 

**stb_truetype** ([External library](../../cppBindings/README.md)): Used for fonts.

**stb_vorbis** ([External library](../../cppBindings/README.md)): Used for decoding OGG audio files.