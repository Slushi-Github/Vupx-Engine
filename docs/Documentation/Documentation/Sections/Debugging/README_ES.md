<table align="center">
    <tr>
        <td><a href="./README.md">English<a></td>
        <td><a href="./README_ES.md">Español</a></td>
    </tr>
</table>

# Depuración en Vupx Engine

Si deseas imprimir información de depuración, es tan facil como usar la clase [`vupx.backend.logging.VupxDebug`](../../../../vupx/backend/logging/VupxDebug.hx):

```haxe
import vupx.backend.logging.VupxDebug;

// Esto es para imprimir información a la terminal pero no guardarla en el archivo de log
VupxDebug.DONT_SAVE_LOGS = true;

VupxDebug.log("Esto es un mensaje de depuracion", INFO);

// Esto es para imprimir información sin formato:
VupxDebug.printToLogFileDirectly("Esto es un mensaje de depuracion sin formato");
```

Mientras `DONT_SAVE_LOGS` sea falso, todos los mensajes de depuración se imprimen a la terminal y se guardan en el archivo de log, que se encuentra en: ``SDMC/switch/YourGameName/engineLogs/logs/``

-----------

- [`vupx.backend.logging.VupxDebug`](../../../../vupx/backend/logging/VupxDebug.hx)