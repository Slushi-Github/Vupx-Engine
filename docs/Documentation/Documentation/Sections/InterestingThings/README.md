<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Other Interesting Things

<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

## Nintendo Switch On-Screen Keyboard

You can create and launch the Nintendo Switch on-screen keyboard as follows:

```haxe
import vupx.system.VpScreenKeyboard;

// Create the keyboard object
var keyboard = new VpScreenKeyboard(VpKeyBoardPreset.DEFAULT);
add(keyboard); // Add it to the state

// You can customize it a bit if you want
keyboard.maxLength = 120; // Maximum number of characters, default is 64
keyboard.minLength = 3; // Minimum number of characters, default is 0
keyboard.headerText = "Header"; // Header text, default is ""
keyboard.guideText = "Type something"; // Guide text, default is ""
keyboard.subText = "Subtext"; // Subtext, default is ""
keyboard.initialText = "Initial text"; // Initial text, default is ""
keyboard.okButtonText = "Accept"; // OK button text, default is ""
keyboard.blurBackground = true; // Blur the background, default is true

// Show the keyboard
keyboard.show();

// Since this keyboard blocks the game while it is open, we need to wait
// for the user to close it before continuing the game

// Get the keyboard result
var result:String = keyboard.resultString;
```

## Web Browser

You can create and launch a web browser as follows:

```haxe
import vupx.system.VpSimpleWeb;

// Create the browser object
var browser = new VpSimpleWeb("https://google.com");
add(browser); // Add it to the state

// Launch the browser
browser.showWebPage();
```

This also blocks the game while it is open. Keep in mind that the Switch web browser is extremely limited and even has a 20-minute time limit.

## Screen Backlight

You can control the screen backlight as follows:

```haxe
import vupx.Vupx;

// Set brightness to maximum
Vupx.screenBackLight.setBrightness(1.0);

// Apply the change
Vupx.screenBackLight.applyBrightnessToBacklight();

// Set brightness to minimum
Vupx.screenBackLight.setBrightness(0.0, true); // Apply brightness to the backlight immediately

Vupx.screenBackLight.switchBacklightOn(2.0); // Turn the backlight on with a 2-second fade
Vupx.screenBackLight.switchBacklightOff(2.0); // Turn the backlight off with a 2-second fade

Vupx.screenBackLight.setDimming(true); // Allow the screen to automatically reduce brightness if true
```

## Getting System Information and Other Things

You can get system information as follows:

```haxe
import vupx.system.VpSystem;

// Get the system version
var version:String = VpSystem.SWITCH_VERSION;
var versionInt:Int = VpSystem.SWITCH_VERSION_INT; // Version as an integer

// Get the Atmosphère version
var atmosphereVersion:String = VpSystem.ATMOSPHERE_VERSION;
var atmosphereVersionInt:Int = VpSystem.ATMOSPHERE_VERSION_INT; // Version as an integer

// Check if the console is docked (TV mode)
var isDocked:Bool = VpSystem.IS_DOCKED;

// Get the application state
var appletState:VpAppletStateMode = VpSystem.appState;

// You can also check if the program is running in applet mode
var isApplet:Bool = VpSystem.isRunningAsApplet();

// You can also create a system alert window
VpSystem.showNXApplicationError(0, "Error", "Error message");

// Get a precise time in milliseconds from the ARM processor
var timeInMs:Float = VpSystem.getARMTimeNow(); // You can also use Sys.cpuTime()

// Get the system language
var language:VpSystemLenguage = VpSystem.getSystemLanguage();

// Get the console model
var consoleModel:VpSystemConsoleModel = VpSystem.getConsoleModel();
```

-----------

- [`vupx.system.VpScreenKeyboard`](../../../../vupx/system/VpScreenKeyboard.hx)
- [`vupx.system.VpSimpleWeb`](../../../../vupx/system/VpSimpleWeb.hx)
- [`vupx.controls.VpScreenBackLight`](../../../../vupx/controls/VpScreenBackLight.hx)
- [`vupx.system.VpSystem`](../../../../vupx/system/VpSystem.hx)