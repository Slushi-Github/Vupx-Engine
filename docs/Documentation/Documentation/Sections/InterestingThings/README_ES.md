<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

Otras cosas interesantes

# Teclado en pantalla de la Switch

Puedes crear y iniciar el teclado en pantalla de la Switch de la sigiente manera:

```haxe
import vupx.system.VpScreenKeyboard;

// Crear el objeto de teclado
var keyboard = new VpScreenKeyboard(VpKeyBoardPreset.DEFAULT);
add(keyboard); // Agregarlo al state

// Puedes personalizarlo un poco si lo deseas
keyboard.maxLength = 120; // Maximo de caracteres, por defecto 64
keyboard.minLength = 3; // Minimo de caracteres, por defecto 0
keyboard.headerText = "Encabezado"; // Texto de encabezado, por defecto ""
keyboard.guideText = "Escribe algo"; // Texto de guia, por defecto ""
keyboard.subText = "Subtexto"; // Texto de subtexto, por defecto ""
keyboard.initialText = "Texto inicial"; // Texto inicial, por defecto ""
keyboard.okButtonText = "Aceptar"; // Texto del boton de aceptar, por defecto ""
keyboard.blurBackground = true; // Desenfocar el fondo, por defecto true

// Iniciar el teclado
keyboard.show();

// Debido a que este teclado bloquea el juego mientras este abierto, tenemos que esperar
// a que el usuario lo cierre para poder seguir con el juego

// Obten el resultado del teclado
var result:String = keyboard.resultString;
```

# Navegador web

Puedes crear y iniciar un navegador web de la siguiente manera:

```haxe
import vupx.system.VpSimpleWeb;

// Crear el objeto de navegador
var browser = new VpSimpleWeb("https://google.com");
add(browser); // Agregarlo al state

// Iniciar el navegador
browser.showWebPage();
```

Este tambien bloquea el juego mientras este abierto, ademas ten en cuenta, el navegador de la switch es extremadamente limitado, incluso tiene un limitador de tiempo de 20 minutos.

# Retroilluminacion de la pantalla

Puedes controlar la retroilluminacion de la pantalla de la siguiente manera:

```haxe
import vupx.Vupx;

// Poner al maximo el brillo
Vupx.screenBackLight.setBrightness(1.0);

// Aplicar el cambio
Vupx.screenBackLight.applyBrightnessToBacklight();

// Poner al minimo el brillo
Vupx.screenBackLight.setBrightness(0.0, true); // Aplicar el brillo al backlight inmediatamente

Vupx.screenBackLight.switchBacklightOn(2.0); // Encender el backlight con un fade de 2 segundos
Vupx.screenBackLight.switchBacklightOff(2.0); // Apagar el backlight con un fade de 2 segundos

Vupx.screenBackLight.setDimming(true); // Permitir si es true que la pantalla reduzca el brillo automaticamente 
```

## Obtener informacion y cosas del sistema

Puedes obtener informacion del sistema de la siguiente manera:

```haxe
import vupx.system.VpSystem;

// Obtener la version del sistema
var version:String = VpSystem.SWITCH_VERSION;
var versionInt:Int = VpSystem.SWITCH_VERSION_INT; // Version en entero

// Obtener la version de Atmosphère
var atmosphereVersion:String = VpSystem.ATMOSPHERE_VERSION;
var atmosphereVersionInt:Int = VpSystem.ATMOSPHERE_VERSION_INT; // Version en entero

// Obtener si el consola esta en el dock, osea en modo TV
var isDocked:Bool = VpSystem.IS_DOCKED;

// Obtener el estado del programa
var appletState:VpAppletStateMode = VpSystem.appState;

// Tambien puedes saber si el programa se esta ejecutando en el modo applet
var isApplet:Bool = VpSystem.isRunningAsApplet();

// Tambien puedes crear una ventana de aleta
VpSystem.showNXApplicationError(0, "Error", "Error message");

// Obtener un tiempo preciso en milisegundos desde el procesador ARM
var timeInMs:Float = VpSystem.getARMTimeNow(); // Tambien puedes usar Sys.cpuTIme()

// Obtener la lenguage del sistema
var lenguage:VpSystemLenguage = VpSystem.getSystemLanguage();

// Puedes obtener el modelo de la consola
var consoleModel:VpSystemConsoleModel = VpSystem.getConsoleModel();
```

-----------

- [`vupx.system.VpScreenKeyboard`](../../../../vupx/system/VpScreenKeyboard.hx)

- [`vupx.system.VpSimpleWeb`](../../../../vupx/system/VpSimpleWeb.hx)

- [`vupx.controls.VpScreenBackLight`](../../../../vupx/controls/VpScreenBackLight.hx)

- [`vupx.system.VpSystem`](../../../../vupx/system/VpSystem.hx)