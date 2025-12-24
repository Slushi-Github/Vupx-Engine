# Vupx Engine - Bindings de Haxe/C++

<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table> 

Vupx Engine está construido sobre varias librerías que son obligatorias. Dado que este es un proyecto desarrollado en Haxe y las librerías son externas, esta es la razón de los bindings ``@:native`` para el target de Haxe/C++ ([HXCPP -> ``NX``, ``HX_NX``](https://github.com/Slushi-Github/hxcpp-nx) (Nintendo Switch)).

Todos estos bindings fueron hechos específicamente para este proyecto. Honestamente, no pude encontrar bindings de Haxe para estas librerías que estuvieran bien hechos o actualizados y que se ajustaran a lo que necesitaba. Mirando las librerías y lo *común* que es la Nintendo Switch, estoy seguro de que podrían funcionar en otros proyectos, pero su propósito original era el Vupx Engine (Quizás en el futuro publique librerías de Haxe solo con estos bindings, tal como hice con libnx ([hx_libnx](https://github.com/Slushi-Github/hx_libnx))...).

Ninguno de los bindings tiene documentación como tal; solo existen las funciones que se han necesitado hasta ahora.

## Las librerías utilizadas en este proyecto son:

**SDL2**: La librería principal utilizada únicamente para el manejo de ventanas e inicialización de OpenGL.
* **SDL2_Image**: Utilizada para cargar imágenes y enviarlas a OpenGL.
* **SDL2_Mixer**: El motor de audio principal actual para este proyecto.

**OpenAL Soft**: Librería sin usar, pero sirve para reproducir archivos de audio.

**OpenGL 4.3**: La librería de gráficos principal utilizada en este proyecto.

**GLAD**: Utilizada para cargar las funciones de OpenGL.

**GLM**: La librería matemática de OpenGL. 

**stb_truetype** ([Librería externa](../../cppBindings/README.md)): Utilizada para fuentes tipográficas.

**stb_vorbis** ([Librería externa](../../cppBindings/README.md)): Utilizada para decodificar archivos de audio OGG.