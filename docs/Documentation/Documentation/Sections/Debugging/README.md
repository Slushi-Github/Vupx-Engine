<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Debugging in Vupx Engine

If you want to print debugging information, it is as simple as using the [`vupx.backend.logging.VupxDebug`](../../../../vupx/backend/logging/VupxDebug.hx) class:

```haxe
import vupx.backend.logging.VupxDebug;

// This is to print information to the terminal but not save it to the log file
VupxDebug.DONT_SAVE_LOGS = true;

VupxDebug.log("This is a debug message", INFO);

// This is to print unformatted information:
VupxDebug.printToLogFileDirectly("This is an unformatted debug message");
```

As long as `DONT_SAVE_LOGS` is set to false, all debug messages will be printed to the terminal and saved to the log file, which is located at: `SDMC/switch/YourGameName/engineLogs/logs/`

-----------

- [`vupx.backend.logging.VupxDebug`](../../../../vupx/backend/logging/VupxDebug.hx)