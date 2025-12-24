<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Librerías externas de Vupx Engine

Esta carpeta contiene librerías externas de C/C++ utilizadas por Vupx Engine. Aunque la mayoría de las librerías utilizadas por el motor se encuentran en los repositorios de DevKitPro, hay ciertas librerías que no están allí, por lo que se incluyen aquí.

La estructura de la carpeta es:


```
librería
    include
    source
```

Incluso si se trata de una librería que solo tiene encabezados (headers), por ejemplo, recomendaría de igual forma crear la carpeta ``source``, y lo mismo en el caso contrario.

-----

Las librerías son:

- [``stb_truetype``](https://github.com/nothings/stb/blob/master/stb_truetype.h): Librería de renderizado de fuentes TrueType, esta librería está bajo la [Licencia MIT](https://github.com/nothings/stb/blob/master/LICENSE). 

- [``stb_vorbis``](https://github.com/nothings/stb/blob/master/stb_vorbis.c): Librería de decodificación de audio OGG Vorbis, esta librería está bajo la [Licencia MIT](https://github.com/nothings/stb/blob/master/LICENSE).