package vupx.core.shaders;

/**
 * Shader variable types
 */
enum ShaderVariable {
    INT;
    FLOAT;
    VEC2;
    VEC3;
    VEC4;
    MATRIX4;
    BOOL;
}

/**
 * Shader types
 */
enum ShaderType {
    VERTEX;
    FRAGMENT;
    VERTEX_AND_FRAGMENT;
}

/**
 * This is the class for creating and using OpenGL shaders
 * 
 * Author: Slushi
 */
class VpShader extends VpBase {
    /**
     * The GL program
     */
    public var program(get, never):Null<UInt32>;

    /**
     * The type of the shader
     */
    public var type:Null<ShaderType> = null;

    /**
     * The tag of the shader
     */
    public var tag:Null<String>;

    /**
     * If the shader needs to be updated
     */
    public var needsUpdate:Null<Bool> = false;

    /**
     * If the shader compilation failed
     */
    public var compilationFailed:Null<Bool> = false;
    
    /**
     * The GL vertex shader source code
     */
    private var vertexShaderSource:Null<String> = "";

    /**
     * The GL fragment shader source code
     */
    private var fragmentShaderSource:Null<String> = "";

    /**
     * The GL shader
     */
    private var glShader:Null<UInt32> = null;
    
    /**
     * The VUPX uniforms
     */
    private static var VUPX_UNIFORMS:Array<String> = [
        "uniform float VUPX_ELAPSED;",
        "uniform vec2 VUPX_SCREEN_RESOLUTION;",
        "uniform vec3 VUPX_FIRST_TOUCH_POSITION;",
        "uniform sampler2D VUPX_TEXTURE0;",
    ];
    
    /**
     * Create a new GL shader and GL program
     * @param vertexShaderSource The GL vertex shader source code
     * @param fragmentShaderSource The GL fragment shader source code
     * @param tag The tag of the shader
     */
    public function new(vertexShaderSource:Null<String>, fragmentShaderSource:Null<String>, tag:Null<String> = null, ?type:Null<ShaderType> = null) {
        super();

        if (vertexShaderSource == null && fragmentShaderSource == null || vertexShaderSource == "" && fragmentShaderSource == "") {
            VupxDebug.log("No shader source code provided", ERROR);
            return;
        }
        
        if (tag != null || tag != "") this.tag = tag;
        else this.tag = Type.getClassName(Type.getClass(this)) ?? "NO_TAG";

        this.vertexShaderSource = vertexShaderSource;
        this.fragmentShaderSource = fragmentShaderSource;

        if (vertexShaderSource == null || vertexShaderSource == "" || vertexShaderSource == "NONE") this.vertexShaderSource = "";
        if (fragmentShaderSource == null || fragmentShaderSource == "" || fragmentShaderSource == "NONE") this.fragmentShaderSource = "";

        if (this.vertexShaderSource != null && this.vertexShaderSource != "") this.type = ShaderType.VERTEX;
        else if (this.fragmentShaderSource != null && this.fragmentShaderSource != "") this.type = ShaderType.FRAGMENT;
        else if (type != null) this.type = type;
        else this.type = ShaderType.VERTEX_AND_FRAGMENT;

        glShader = createShaderProgram();
    }

    override public function update(elapsed:Float):Void {
        if (needsUpdate == true && program != null && compilationFailed == false) {
            // Vupx variables
            if (existsVariable("VUPX_ELAPSED")) {
                var shaderUpdateVal:Null<Float> = this.getValue(ShaderVariable.FLOAT, "VUPX_ELAPSED");
                if (shaderUpdateVal != null) {
                    this.setValue(ShaderVariable.FLOAT, "VUPX_ELAPSED", shaderUpdateVal + elapsed);
                }
            }

            if (existsVariable("VUPX_SCREEN_RESOLUTION")) {
                var width:Float = Vupx.screenWidth;
                var height:Float = Vupx.screenHeight;
                this.setValue(ShaderVariable.VEC2, "VUPX_SCREEN_RESOLUTION", width, height);
            }

            if (existsVariable("VUPX_FIRST_TOUCH_POSITION")) {
                var x:Float = Vupx.touchScreen.getById(0).x;
                var y:Float = Vupx.touchScreen.getById(0).y;
                var isTouching:Bool = Vupx.touchScreen.isPressed(0);
                this.setValue(ShaderVariable.VEC3, "VUPX_FIRST_TOUCH_POSITION", x, y, isTouching ? 1.0 : 0.0);
            }
        }
    }

    /**
     * Destroys the GL program
     */
    override public function destroy():Void {
        if (program != null) GL.glDeleteProgram(program);
    }

    /**
     * Injects the VUPX uniforms into the shader
     * @param source Shader source code
     * @return Shader source code with VUPX uniforms
     */
    private function injectVupxUniforms(source:String):String {
        if (source == null || source == "") return source;
        
        // Search for the injection point, which is the first line with "#version"
        var versionRegex = ~/#version\s+\d+(\s+\w+)?/;
        var hasVersion = versionRegex.match(source);
        
        var injectionPoint:Int = 0;
        
        if (hasVersion) {
            var versionLine = versionRegex.matched(0);
            injectionPoint = source.indexOf(versionLine) + versionLine.length;
        }
        
        // Find uniforms to inject
        var injectionsNeeded:Array<String> = [];
        
        for (uniformDecl in VUPX_UNIFORMS) {
            // Get the uniform name
            var nameMatch = ~/uniform\s+\w+\s+(\w+);/;
            if (nameMatch.match(uniformDecl)) {
                var uniformName = nameMatch.matched(1);
                
                // Check if the uniform is already in the source
                var uniformRegex = new EReg("uniform\\s+\\w+\\s+" + uniformName + "\\s*;", "");
                if (!uniformRegex.match(source)) {
                    injectionsNeeded.push(uniformDecl);
                }
            }
        }
        
        // If there are no uniforms to inject, return
        if (injectionsNeeded.length == 0) return source;
        
        // Create the injection
        var injection = "\n// Vupx Engine Auto-injected uniforms\n" + injectionsNeeded.join("\n") + "// ----------------------\n";
        
        // Insert the injection
        return source.substring(0, injectionPoint) + injection + source.substring(injectionPoint);
    }

    /**
     * Create the shader GL program
     */
    private function createShaderProgram():UInt32 {
        var vertexShader:Null<UInt32> = null;
        var fragmentShader:Null<UInt32> = null;
        
        var shaderProgram:UInt32 = GL.glCreateProgram();

        var vsrc = (vertexShaderSource != null && vertexShaderSource != "")
            ? vertexShaderSource
            : VpConstants.VUPX_POST_PROCESS_VERTEX_SHADER;

        var fsrc = (fragmentShaderSource != null && fragmentShaderSource != "")
            ? fragmentShaderSource
            : VpConstants.VUPX_BATCH_BASE_FRAGMENT_SHADER;

        // Inject VUPX uniforms into the shader before compilation
        vsrc = injectVupxUniforms(vsrc);
        fsrc = injectVupxUniforms(fsrc);

        vertexShader = compileShader(vsrc, GL.GL_VERTEX_SHADER);
        fragmentShader = compileShader(fsrc, GL.GL_FRAGMENT_SHADER);

        GL.glAttachShader(shaderProgram, vertexShader);
        GL.glAttachShader(shaderProgram, fragmentShader);

        GL.glLinkProgram(shaderProgram);
        checkLinkErrors(shaderProgram);

        GL.glDeleteShader(vertexShader);
        GL.glDeleteShader(fragmentShader);

        setDefaultValues();

        return shaderProgram;
    }
    
    /**
     * Compile a GL shader and check for errors
     * @param source The GL shader source code
     * @param type The GL shader type
     * @return UInt32
     */
    private function compileShader(source:String, type:Int):UInt32 {
        var shader:UInt32 = GL.glCreateShader(type);
        
        var sourcePtr:ConstCharStar = ConstCharStar.fromString(source);
        var sourcePtrPtr:Pointer<ConstCharStar> = Pointer.addressOf(sourcePtr);
        
        GL.glShaderSource(shader, 1, sourcePtrPtr, null);
        GL.glCompileShader(shader);
        
        checkCompileErrors(shader, type == GL.GL_VERTEX_SHADER ? "VERTEX" : "FRAGMENT");
        
        return shader;
    }
    
    /**
     * Check for GL shader errors
     * @param shader The GL shader 
     * @param type The GL shader type
     */
    private function checkCompileErrors(shader:UInt32, type:String):Void {
        var success:Int = 0;
        GL.glGetShaderiv(shader, GL.GL_COMPILE_STATUS, Pointer.addressOf(success));
        
        if (success == 0) {
            var maxLength:Int = 0;
            GL.glGetShaderiv(shader, GL.GL_INFO_LOG_LENGTH, Pointer.addressOf(maxLength));
            var infoLog:Array<Char> = NativeArray.create(maxLength);
            var infoLogPtr = NativeArray.address(infoLog, 0);
            GL.glGetShaderInfoLog(shader, maxLength, null, infoLogPtr);
            
            // Convert the char array to string
            var errorMsg = "";
            for (i in 0...maxLength) {
                if (infoLog[i] == 0) break;
                errorMsg += String.fromCharCode(infoLog[i]);
            }
            
            VupxDebug.log('OpenGL Shader compilation error (${type} (defined: ${this.type}) - ${tag}):\n\t${errorMsg}\n', ERROR);

            var path:String = VpStorage.getGameSDMCPath() + "engineLogs/shadersFails/";
            var filename:String = 'shader_compile_fail_${tag}_${type}.txt';
            try {
                if (!FileSystem.exists(path)) {
                    FileSystem.createDirectory(path);
                }

                File.saveContent(path + filename, 'Vupx Engine v${VupxEngine.VERSION} | OpenGL 4.3 Shader compilation of type ${type} for shader ${tag} (defined: ${this.type}) failed:\n\n' + errorMsg + '\n--------------\nVertex Shader Source:\n' + (vertexShaderSource != null ? vertexShaderSource : "NONE") + '\n----------------\nFragment Shader Source:\n' + (fragmentShaderSource != null ? fragmentShaderSource : "NONE"));
            
                #if !VUPX_DONT_SHOW_SHADER_ERRORS
                VpSwitch.showNXApplicationError(3836, 'Vupx Engine - Can\'t compile OpenGL ${type} (defined: ${this.type}) shader -> ${tag}:\n\n' + errorMsg + '\n\nClick on "Details" for more info.', 'All OpenGL errors from this shader:\n' + errorMsg + '\n\nThe log can be found in:\n' + VpStorage.getGameSDMCPath() + 'engineLogs/shadersFails/shader_compile_fail_${tag}_${type}.txt');
                #end
            }
            catch (e) {
                VupxDebug.log("Failed to save shader compile fail log: " + e, ERROR);
            }

            compilationFailed = true;
        }
    }

    /**
     * Check for GL program link errors
     * @param program The GL program
     */
    private function checkLinkErrors(program:UInt32):Void {
        var success:Int = 0;
        GL.glGetProgramiv(program, GL.GL_LINK_STATUS, Pointer.addressOf(success));
        
        if (success == 0) {
            var maxLength:Int = 0;
            GL.glGetProgramiv(program, GL.GL_INFO_LOG_LENGTH, Pointer.addressOf(maxLength));
            var infoLog:Array<Char> = NativeArray.create(maxLength);
            var infoLogPtr = NativeArray.address(infoLog, 0);
            GL.glGetProgramInfoLog(program, maxLength, null, infoLogPtr);
            
            // Convert the char array to string
            var errorMsg = "";
            for (i in 0...maxLength) {
                if (infoLog[i] == 0) break;
                errorMsg += String.fromCharCode(infoLog[i]);
            }
            
            VupxDebug.log('OpenGL Shader linking error (${tag}):\n\t${errorMsg}\n', ERROR);

            var path:String = VpStorage.getGameSDMCPath() + "engineLogs/shadersFails/";
            var filename:String = 'shader_link_fail_${tag}_${type}.txt';
            try {
                if (!FileSystem.exists(path)) {
                    FileSystem.createDirectory(path);
                }

                File.saveContent(path + filename, 'Vupx Engine v${VupxEngine.VERSION} | OpenGL 4.3 Shader linking for shader ${tag} (defined: ${this.type}) failed:\n\n' + errorMsg + '\n--------------\nVertex Shader Source:\n' + (vertexShaderSource != null ? vertexShaderSource : "NONE") + '\n----------------\nFragment Shader Source:\n' + (fragmentShaderSource != null ? fragmentShaderSource : "NONE"));
            
                #if !VUPX_DONT_SHOW_SHADER_ERRORS
                VpSwitch.showNXApplicationError(5800, 'Vupx Engine - Can\'t link OpenGL shader -> ${tag}:\n\n' + errorMsg + '\n\nClick on "Details" for more info.', 'All OpenGL errors from this shader:\n' + errorMsg + '\n\nThe log can be found in:\n' + VpStorage.getGameSDMCPath() + 'engineLogs/shadersFails/shader_link_fail_${tag}_${type}.txt');
                #end
            
            }
            catch (e) {
                VupxDebug.log("Failed to save shader link fail log: " + e, ERROR);
            }

            compilationFailed = true;
        }
    }

    //////////////////////////////////
    
    /**
     * Use the GL program
     */
    public function useShader():Void {
        if (program == null || compilationFailed) return;
        GL.glUseProgram(program);
    }

    public function sendTexture(textureNum:Int, texture:UInt32):Void {
        if (program == null || compilationFailed) return;
        switch textureNum {
            case 0:
                this.setValue(ShaderVariable.INT, "VUPX_TEXTURE0", texture);
            default:
                VupxDebug.log("(" + this.tag + ") - Invalid texture number: " + textureNum, ERROR);
        }
    }

    public function stopShader():Void {
        if (program == null || compilationFailed) return;
        GL.glUseProgram(0);
    }

    /**
     * Set the value of a shader variable
     * @param type Shader variable type 
     * @param name Shader variable name
     * @param ...value Shader variable value(s) 
     */
    public function setValue(type:Null<ShaderVariable>, name:Null<String>, ...value:Null<Dynamic>):Void {
        if (program == null || compilationFailed) return;

        if (type == null || name == null || name == "" || value == null) {
            VupxDebug.log("(" + this.tag + ") - Shader variable type, name and value must not be null or empty", ERROR);
            return;
        }

        var location = GL.glGetUniformLocation(program, ConstCharStar.fromString(name));
        if (location == -1) {
            VupxDebug.log("(" + this.tag + ") - Shader variable not found: " + name, ERROR);
            return;
        }

        switch(type) {
            case ShaderVariable.INT:
                if (value[0] == null) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for INT cannot be null", ERROR);
                    return;
                }
                GL.glUniform1i(location, Std.int(value[0]));
            case ShaderVariable.FLOAT:
                if (value[0] == null) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for FLOAT cannot be null", ERROR);
                    return;
                }
                else if (!Std.isOfType(value[0], Float)) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for FLOAT must be of type Float (Value received: " + value[0] + ")", ERROR);
                    return;
                }
                GL.glUniform1f(location, value[0]);
            case ShaderVariable.VEC2:
                if (value[0] == null || value[1] == null) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC2 cannot be null", ERROR);
                    return;
                }
                else if (!Std.isOfType(value[0], Float) || !Std.isOfType(value[1], Float)) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC2 must be of type Float (Values received: " + value[0] + ", " + value[1] + ")", ERROR);
                    return;
                }
                else if (value.length < 2) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC2 must have 2 components", ERROR);
                    return;
                }
                GL.glUniform2f(location, value[0], value[1]);
            case ShaderVariable.VEC3:
                if (value[0] == null || value[1] == null || value[2] == null) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC3 cannot be null", ERROR);
                    return;
                }
                else if (!Std.isOfType(value[0], Float) || !Std.isOfType(value[1], Float) || !Std.isOfType(value[2], Float)) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC3 must be of type Float (Values received: " + value[0] + ", " + value[1] + ", " + value[2] + ")", ERROR);
                    return;
                }
                else if (value.length < 3) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC3 must have 3 components", ERROR);
                    return;
                }
                GL.glUniform3f(location, value[0], value[1], value[2]);
            case ShaderVariable.VEC4:
                if (value[0] == null || value[1] == null || value[2] == null || value[3] == null) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC4 cannot be null", ERROR);
                    return;
                }
                else if (!Std.isOfType(value[0], Float) || !Std.isOfType(value[1], Float) || !Std.isOfType(value[2], Float) || !Std.isOfType(value[3], Float)) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC4 must be of type Float (Values received: " + value[0] + ", " + value[1] + ", " + value[2] + ", " + value[3] + ")", ERROR);
                    return;
                }
                else if (value.length < 4) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for VEC4 must have 4 components", ERROR);
                    return;
                }
                GL.glUniform4f(location, value[0], value[1], value[2], value[3]);
            case ShaderVariable.MATRIX4:
                if (value[0] == null) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for MATRIX4 cannot be null", ERROR);
                    return;
                }

                /*
                 * Haxe can't check the type of value[0] because it's a Matrix4 (Results in a compiler error)
                 * So all we can do is hope that it is... otherwise this is going to crash very badly.
                */

                var matrixPtr = GLM.value_ptr(value[0]);
                GL.glUniformMatrix4fv(location, 1, false, cast matrixPtr);
            case ShaderVariable.BOOL:
                if (value[0] == null) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for BOOL cannot be null", ERROR);
                    return;
                }
                else if (!Std.isOfType(value[0], Bool)) {
                    VupxDebug.log("(" + this.tag + ") - Shader variable value for BOOL must be of type Bool", ERROR);
                    return;
                }
                var value:Bool = value[0];
                GL.glUniform1i(location , value ? 1 : 0);
            default:
                VupxDebug.log("(" + this.tag + ") - Unknown shader variable type: " + type, ERROR);
        }
    }

    /**
     * Get the value of a shader variable
     * 
     * Returns null if the variable is not found or an error occurs
     * 
     * @param type Shader variable type 
     * @param name Shader variable name
     * @return Dynamic - Returns the value(s) of the uniform variable.
     */
    public function getValue(type:Null<ShaderVariable>, name:Null<String>):Null<Dynamic> {
        if (program == null || compilationFailed) return null;
        if (type == null || name == null || name == "") {
            VupxDebug.log("(" + this.tag + ") - Shader variable type and name must not be null or empty", ERROR);
            return null;
        }

        var location = GL.glGetUniformLocation(program, ConstCharStar.fromString(name));
        if (location == -1) {
            VupxDebug.log("(" + this.tag + ") - Shader variable not found: " + name, ERROR);
            return null;
        }

        switch(type) {
            case ShaderVariable.INT:
                var value:Int = 0;
                GL.glGetUniformiv(program, location, Pointer.addressOf(value));
                return value;
            case ShaderVariable.FLOAT:
                var value:Float = 0.0;
                GL.glGetUniformdv(program, location, Pointer.addressOf(value));
                return value;
            case ShaderVariable.VEC2:
                var values:Array<Float> = NativeArray.create(2);
                GL.glGetUniformdv(program, location, cast NativeArray.address(values, 0));
                return new Vec2(values[0], values[1]);
            case ShaderVariable.VEC3:
                var values:Array<Float> = NativeArray.create(3);
                GL.glGetUniformdv(program, location, cast NativeArray.address(values, 0));
                return new Vec3(values[0], values[1], values[2]);
            case ShaderVariable.VEC4:
                var values:Array<Float> = NativeArray.create(4);
                GL.glGetUniformdv(program, location, cast NativeArray.address(values, 0));
                return new Vec4(values[0], values[1], values[2], values[3]);
            case ShaderVariable.MATRIX4:
                var values:Array<Float> = NativeArray.create(16);
                GL.glGetUniformdv(program, location, cast NativeArray.address(values, 0));
                var matrix:Mat4 = GLM.mat4Identity();
                untyped __cpp__("
                    float* matPtr = glm::value_ptr({0});
                    for (int i = 0; i < 16; i++) {
                        matPtr[i] = (float){1}->__get(i);
                    }
                ", matrix, values);

                return matrix;
            default:
                VupxDebug.log("(" + this.tag + ") - Unknown shader variable type: " + type, ERROR);
                return null;
        }

        return null;
    }

    /**
     * Check if a shader variable exists
     * @param name Shader variable name
     * @return Bool
     */
    public function existsVariable(name:Null<String>):Bool {
        if (program == null || compilationFailed) return false;
        if (name == null || name == "") return false;
        var location = GL.glGetUniformLocation(program, ConstCharStar.fromString(name));
        return location != -1;
    }

    /**
     * Set default values for shader variables
     */
    private function setDefaultValues():Void {
        if (program == null || compilationFailed) return;

        // Vupx variables
        if (existsVariable("VUPX_SCREEN_RESOLUTION")) {
            var width:Float = Vupx.screenWidth;
            var height:Float = Vupx.screenHeight;
            this.setValue(ShaderVariable.VEC2, "VUPX_SCREEN_RESOLUTION", width, height);
        }
    }

    private function get_program():UInt32 {
        return glShader;
    }

    //////////////////////////////////
}