<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Vupx Engine external libraries 

This folder contains external C/C++ libraries used by Vupx Engine. Although most of the libraries used by the engine are found in the DevKitPro repositories, there are certain libraries that are not, so they are here.

The structure of the folder is:

```
library
    include
    source
```

Even if it is a library that only has headers, for example, I would still recommend creating the ``source`` folder, and likewise if it were the other way around.

-----

The libraries are:

- [``stb_truetype``](https://github.com/nothings/stb/blob/master/stb_truetype.h): TrueType font rendering library, this library is under the [MIT License](https://github.com/nothings/stb/blob/master/LICENSE). 

- [``stb_vorbis``](https://github.com/nothings/stb/blob/master/stb_vorbis.c): OGG Vorbis audio decoding library, this library is under the [MIT License](https://github.com/nothings/stb/blob/master/LICENSE).