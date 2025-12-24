package vupx.utils;


typedef VpTimerObj = {
    time:Float,
    callback:Null<Void->Void>
} 

class VpTimer {
    /**
     * Delta time (tiempo transcurrido desde el último frame en segundos)
     */
    public static var deltaTime(default, null):Float = 0;

    /**
     * Delta time escalado (para mantener consistencia a 60fps)
     */
    public static var deltaTimeScaled(default, null):Float = 0;

    /**
     * Tiempo acumulativo total desde que se inició el motor (en segundos)
     * ESTE es el que debes usar en tus shaders para animaciones fluidas.
     */
    public static var elapsedTime(default, null):Float = 0;

    private static var _lastTime:UInt32 = 0;
    private static var _initialized:Bool = false;
    private static var timers:Array<VpTimerObj> = [];
    
    /**
     * Inicializa el cronómetro
     */
    public static function init():Void {
        if (_initialized) {
            // Suponiendo que VupxDebug existe en tu framework
            // VupxDebug.log("VpTimer already initialized", WARNING);
            return;
        }
        
        _lastTime = SDL_Timer.SDL_GetTicks();
        deltaTime = 0;
        deltaTimeScaled = 0;
        elapsedTime = 0; // Inicia en cero
        timers = [];
        
        _initialized = true;
    }

    /**
     * Agrega un temporizador para ejecutar una función después de X segundos
     */
    public static function after(time:Null<Float>, callback:Null<Void->Void>):VpTimerObj {
        if (time <= 0 || time == null || callback == null) {
            return null;
        }

        var newTimer:VpTimerObj = {
            time:time,
            callback:callback
        };

        timers.push(newTimer);
        return newTimer;
    }
    
    /**
     * Actualiza los valores de tiempo. Debe llamarse en cada frame del loop principal.
     */
    public static function update():Void {
        if (!_initialized) {
            return;
        }
        
        var currentTime:UInt32 = SDL_Timer.SDL_GetTicks();
        
        // Calcular cuánto tiempo pasó en este frame
        deltaTime = ((currentTime - _lastTime) / 1000.0);
        
        // Evitar saltos gigantes si la ventana se congela o se mueve
        if (deltaTime > 0.2) deltaTime = 0.016; 

        // Escalar a 60fps (1.0 = 60fps constantes)
        deltaTimeScaled = deltaTime * 60.0;
        
        // ACTUALIZACIÓN ACUMULATIVA: Sumamos el paso del tiempo al total
        elapsedTime += deltaTime;
        
        _lastTime = currentTime;

        // Lógica de los timers existentes
        if (timers != null && timers.length > 0) {
            var i = timers.length - 1;
            while (i >= 0) {
                var timer = timers[i];
                timer.time -= deltaTime;
                if (timer.time <= 0) {
                    if (timer.callback != null) timer.callback();
                    timers.splice(i, 1);
                }
                i--;
            }
        }
    }
    
    public static function getTicks():UInt32 {
        return SDL_Timer.SDL_GetTicks();
    }
    
    public static function getSeconds():Float {
        return SDL_Timer.SDL_GetTicks() / 1000.0;
    }
}