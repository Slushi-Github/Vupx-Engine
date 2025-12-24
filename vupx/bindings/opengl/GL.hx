package vupx.bindings.opengl;

@:buildXml('<include name="${haxelib:vupxengine}/include.xml"/>')
@:include("glad/glad.h")
extern class GL {
    @:native("GL_COLOR_BUFFER_BIT")
    extern public static var GL_COLOR_BUFFER_BIT:Int;
    
    @:native("GL_DEPTH_BUFFER_BIT")
    extern public static var GL_DEPTH_BUFFER_BIT:Int;
    
    @:native("GL_DEPTH_TEST")
    extern public static var GL_DEPTH_TEST:Int;
    
    @:native("GL_TRIANGLES")
    extern public static var GL_TRIANGLES:Int;
    
    @:native("GL_FLOAT")
    extern public static var GL_FLOAT:Int;
    
    @:native("GL_FALSE")
    extern public static var GL_FALSE:Int;
    
    @:native("GL_STATIC_DRAW")
    extern public static var GL_STATIC_DRAW:Int;
    
    @:native("GL_ARRAY_BUFFER")
    extern public static var GL_ARRAY_BUFFER:Int;
    
    @:native("GL_VERTEX_SHADER")
    extern public static var GL_VERTEX_SHADER:Int;
    
    @:native("GL_FRAGMENT_SHADER")
    extern public static var GL_FRAGMENT_SHADER:Int;
    
    @:native("GL_COMPILE_STATUS")
    extern public static var GL_COMPILE_STATUS:Int;
    
    @:native("GL_LINK_STATUS")
    extern public static var GL_LINK_STATUS:Int;

    @:native("GL_LEQUAL")
    public static final GL_LEQUAL:Int;

    @:native("GL_TEXTURE_2D")
    public static final GL_TEXTURE_2D:Int;

    @:native("GL_TEXTURE0")
    public static final GL_TEXTURE0:Int;

    @:native("GL_TEXTURE1")
    public static final GL_TEXTURE1:Int;

    @:native("GL_RGB")
    public static final GL_RGB:Int;

    @:native("GL_RGBA")
    public static final GL_RGBA:Int;

    @:native("GL_ALPHA")
    public static final GL_ALPHA:Int;

    @:native("GL_RED")
    public static final GL_RED:Int;

    @:native("GL_UNSIGNED_BYTE")
    public static final GL_UNSIGNED_BYTE:Int;

    @:native("GL_TEXTURE_WRAP_S")
    public static final GL_TEXTURE_WRAP_S:Int;

    @:native("GL_TEXTURE_WRAP_T")
    public static final GL_TEXTURE_WRAP_T:Int;

    @:native("GL_TEXTURE_MIN_FILTER")
    public static final GL_TEXTURE_MIN_FILTER:Int;

    @:native("GL_TEXTURE_MAG_FILTER")
    public static final GL_TEXTURE_MAG_FILTER:Int;

    @:native("GL_LINEAR")
    public static final GL_LINEAR:Int;

    @:native("GL_INT")
    public static final GL_INT:Int;

    @:native("GL_FLOAT_VEC4")
    public static final GL_FLOAT_VEC4:Int;

    @:native("GL_FLOAT_VEC2")
    public static final GL_FLOAT_VEC2:Int;

    @:native("GL_BOOL")
    public static final GL_BOOL:Int;

    @:native("GL_FLOAT_MAT4")
    public static final GL_FLOAT_MAT4:Int;

    @:native("GL_ACTIVE_UNIFORMS")
    public static final GL_ACTIVE_UNIFORMS:Int;

    @:native("GL_FLOAT_VEC3")
    public static final GL_FLOAT_VEC3:Int;

    @:native("GL_CLAMP_TO_EDGE")
    public static final GL_CLAMP_TO_EDGE:Int;

    @:native("GL_ELEMENT_ARRAY_BUFFER")
    public static final GL_ELEMENT_ARRAY_BUFFER:Int;

    @:native("GL_UNSIGNED_INT")
    public static final GL_UNSIGNED_INT:Int;

    @:native("GL_BLEND")
    public static final GL_BLEND:Int;

    @:native("GL_SRC_ALPHA")
    public static final GL_SRC_ALPHA:Int;

    @:native("GL_ONE_MINUS_SRC_ALPHA")
    public static final GL_ONE_MINUS_SRC_ALPHA:Int;

    @:native("GL_POINTS")
    public static final GL_POINTS:Int;

    @:native("GL_FRONT_AND_BACK")
    public static final GL_FRONT_AND_BACK:Int;

    @:native("GL_LINE")
    public static final GL_LINE:Int;

    @:native("GL_FILL")
    public static final GL_FILL:Int;

    @:native("GL_PROGRAM_POINT_SIZE")
    public static final GL_PROGRAM_POINT_SIZE:Int;

    @:native("GL_LESS")
    public static final GL_LESS:Int;

    @:native("GL_FRAMEBUFFER")
    extern public static var GL_FRAMEBUFFER:Int;

    @:native("GL_COLOR_ATTACHMENT0")
    extern public static var GL_COLOR_ATTACHMENT0:Int;

    @:native("GL_FRAMEBUFFER_COMPLETE")
    extern public static var GL_FRAMEBUFFER_COMPLETE:Int;

    @:native("GL_RENDERBUFFER")
    extern public static var GL_RENDERBUFFER:Int;

    @:native("GL_DEPTH24_STENCIL8")
    extern public static var GL_DEPTH24_STENCIL8:Int;

    @:native("GL_STENCIL_ATTACHMENT")
    extern public static var GL_STENCIL_ATTACHMENT:Int;

    @:native("GL_DEPTH_ATTACHMENT")
    extern public static var GL_DEPTH_ATTACHMENT:Int;

    @:native("GL_DEPTH_STENCIL_ATTACHMENT")
    extern public static var GL_DEPTH_STENCIL_ATTACHMENT:Int;

    @:native("GL_TRIANGLE_STRIP")
    extern public static var GL_TRIANGLE_STRIP:Int;

    @:native("GL_ALWAYS")
    extern public static var GL_ALWAYS:Int;

    @:native("GL_CULL_FACE")
    extern public static var GL_CULL_FACE:Int;

    @:native("GL_BACK")
    extern public static var GL_BACK:Int;

    @:native("GL_INFO_LOG_LENGTH")
    extern public static var GL_INFO_LOG_LENGTH:Int;

    @:native("GL_DYNAMIC_DRAW")
    extern public static var GL_DYNAMIC_DRAW:Int;

    @:native("GL_ONE")
    extern public static var GL_ONE:Int;

    @:native("GL_R32F")
    extern public static var GL_R32F:Int;

    @:native("GL_NEAREST")
    extern public static var GL_NEAREST:Int;

    @:native("GL_COLOR_ATTACHMENT1")
    extern public static var GL_COLOR_ATTACHMENT1:Int;

    @:native("GL_SHADER_STORAGE_BUFFER")
    extern public static var GL_SHADER_STORAGE_BUFFER:Int;

    //////////////////////////////////////////////
    
    @:native("glClearColor")
    extern public static function glClearColor(r:Float, g:Float, b:Float, a:Float):Void;
    
    @:native("glClear")
    extern public static function glClear(mask:Int):Void;
    
    @:native("glViewport")
    extern public static function glViewport(x:Int, y:Int, width:Int, height:Int):Void;
    
    @:native("glEnable")
    extern public static function glEnable(cap:Int):Void;

    @:native("glDisable")
    extern public static function glDisable(cap:Int):Void;
    
    @:native("glCreateShader")
    extern public static function glCreateShader(type:Int):UInt32;
    
    @:native("glShaderSource")
    extern public static function glShaderSource(shader:UInt32, count:Int, string:Pointer<ConstCharStar>, length:Pointer<Int>):Void;
    
    @:native("glCompileShader")
    extern public static function glCompileShader(shader:UInt32):Void;
    
    @:native("glGetShaderiv")
    extern public static function glGetShaderiv(shader:UInt32, pname:Int, params:Pointer<Int>):Void;
    
    @:native("glGetShaderInfoLog")
    extern public static function glGetShaderInfoLog(shader:UInt32, maxLength:Int, length:Pointer<Int>, infoLog:Pointer<cpp.Char>):Void;
    
    @:native("glCreateProgram")
    extern public static function glCreateProgram():UInt32;

    @:native("glDepthMask")
    extern public static function glDepthMask(flag:Bool):Void;
    
    @:native("glAttachShader")
    extern public static function glAttachShader(program:UInt32, shader:UInt32):Void;
    
    @:native("glLinkProgram")
    extern public static function glLinkProgram(program:UInt32):Void;
    
    @:native("glGetProgramiv")
    extern public static function glGetProgramiv(program:UInt32, pname:Int, params:Pointer<Int>):Void;
    
    @:native("glGetProgramInfoLog")
    extern public static function glGetProgramInfoLog(program:UInt32, maxLength:Int, length:Pointer<Int>, infoLog:Pointer<cpp.Char>):Void;
    
    @:native("glDeleteShader")
    extern public static function glDeleteShader(shader:UInt32):Void;
    
    @:native("glUseProgram")
    extern public static function glUseProgram(program:UInt32):Void;

    @:native("glDeleteProgram")
    extern public static function glDeleteProgram(program:UInt32):Void;

    @:native("glIsEnabled")
    extern public static function glIsEnabled(cap:Int):Bool;

    @:native("glGenVertexArray")
    extern public static function glGenVertexArray(array:Pointer<UInt32>):Void;
    
    @:native("glGenVertexArrays")
    extern public static function glGenVertexArrays(n:Int, arrays:Pointer<UInt32>):Void;
    
    @:native("glGenBuffers")
    extern public static function glGenBuffers(n:Int, buffers:Pointer<UInt32>):Void;
    
    @:native("glBindVertexArray")
    extern public static function glBindVertexArray(array:UInt32):Void;
    
    @:native("glBindBuffer")
    extern public static function glBindBuffer(target:Int, buffer:UInt32):Void;

    @:native("glDrawBuffers")
    extern public static function glDrawBuffers(n:Int, bufs:Pointer<Int>):Void;
    
    @:native("glBufferData")
    extern public static function glBufferData(target:Int, size:Int, data:Pointer<CppVoid>, usage:Int):Void;
    
    @:native("glVertexAttribPointer")
    extern public static function glVertexAttribPointer(index:Int, size:Int, type:Int, normalized:Bool, stride:Int, pointer:RawPointer<CppVoid>):Void;
    
    @:native("glEnableVertexAttribArray")
    extern public static function glEnableVertexAttribArray(index:Int):Void;
    
    @:native("glDrawArrays")
    extern public static function glDrawArrays(mode:Int, first:Int, count:Int):Void;

    @:native("glBindBufferBase")
    extern public static function glBindBufferBase(target:Int, index:Int, buffer:UInt32):Void;
    
    @:native("glDeleteVertexArrays")
    extern public static function glDeleteVertexArrays(n:Int, arrays:Pointer<UInt32>):Void;
    
    @:native("glDeleteBuffers")
    extern public static function glDeleteBuffers(n:Int, buffers:Pointer<UInt32>):Void;

    @:native("glGenTextures")
    public static function glGenTextures(n:Int, textures:Pointer<UInt32>):Void;

    @:native("glBindTexture")
    public static function glBindTexture(target:Int, texture:UInt32):Void;

    @:native("glTexImage2D")
    public static function glTexImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, pixels:Pointer<CppVoid>):Void;

    @:native("glTexParameteri")
    public static function glTexParameteri(target:Int, pname:Int, param:Int):Void;

    @:native("glActiveTexture")
    public static function glActiveTexture(texture:Int):Void;

    @:native("glBufferSubData")
    public static function glBufferSubData(target:Int, offset:Int, size:Int, data:Pointer<CppVoid>):Void;

    @:native("glDeleteTextures")
    public static function glDeleteTextures(n:Int, textures:Pointer<UInt32>):Void;

    @:native("glDrawElements")
    public static function glDrawElements(mode:Int, count:Int, type:Int, indices:Pointer<CppVoid>):Void;

    @:native("glGetUniformLocation")
    public static function glGetUniformLocation(program:UInt32, name:ConstCharStar):Int;

    @:native("glUniform1i")
    public static function glUniform1i(location:Int, v0:Int):Void;

    @:native("glUniform4f")
    public static function glUniform4f(location:Int, v0:Float, v1:Float, v2:Float, v3:Float):Void;

    @:native("glUniform3f")
    public static function glUniform3f(location:Int, v0:Float, v1:Float, v2:Float):Void;

    @:native("glUniform2f")
    public static function glUniform2f(location:Int, v0:Float, v1:Float):Void;

    @:native("glUniformMatrix4fv")
    public static function glUniformMatrix4fv(location:Int, count:Int, transpose:Bool, value:Pointer<cpp.Float32>):Void;

    @:native("glUniform1f")
    public static function glUniform1f(location:Int, v0:Float):Void;

    @:native("glBlendFunc")
    public static function glBlendFunc(sfactor:Int, dfactor:Int):Void;

    @:native("glPolygonMode")
    public static function glPolygonMode(face:Int, mode:Int):Void;

    @:native("glGetUniformdv")
    public static function glGetUniformdv(program:UInt32, location:Int, params:Pointer<Float>):Void;

    @:native("glGetUniformiv")
    public static function glGetUniformiv(program:UInt32, location:Int, params:Pointer<Int>):Void;

    @:native("glGetUniformfv")
    public static function glGetUniformfv(program:UInt32, location:Int, params:Pointer<Float>):Void;

    @:native("glGetAttribLocation")
    public static function glGetAttribLocation(program:UInt32, name:ConstCharStar):Int;

    @:native("glDepthFunc")
    public static function glDepthFunc(func:Int):Void;

    @:native("glDepthRange")
    public static function glDepthRange(near:Float, far:Float):Void;

    @:native("glCullFace")
    public static function glCullFace(mode:Int):Void;

    @:native("glGenFramebuffers")
    public static function glGenFramebuffers(n:Int, framebuffers:Pointer<UInt32>):Void;

    @:native("glBindFramebuffer")
    public static function glBindFramebuffer(target:Int, framebuffer:UInt32):Void;

    @:native("glFramebufferTexture2D")
    public static function glFramebufferTexture2D(target:Int, attachment:Int, textarget:Int, texture:UInt32, level:Int):Void;

    @:native("glFramebufferRenderbuffer")
    public static function glFramebufferRenderbuffer(target:Int, attachment:Int, renderbuffertarget:Int, renderbuffer:UInt32):Void;

    @:native("glCheckFramebufferStatus")
    public static function glCheckFramebufferStatus(target:Int):Int;

    @:native("glDeleteFramebuffers")
    public static function glDeleteFramebuffers(n:Int, framebuffers:Pointer<UInt32>):Void;

    @:native("glRenderbufferStorage")
    public static function glRenderbufferStorage(target:Int, internalformat:Int, width:Int, height:Int):Void;

    @:native("glGenRenderbuffers")
    public static function glGenRenderbuffers(n:Int, renderbuffers:Pointer<UInt32>):Void;

    @:native("glBindRenderbuffer")
    public static function glBindRenderbuffer(target:Int, renderbuffer:UInt32):Void;

    @:native("glDeleteRenderbuffers")
    public static function glDeleteRenderbuffers(n:Int, renderbuffers:Pointer<UInt32>):Void;

    @:native("glGetActiveUniform")
    public static function glGetActiveUniform(glShader:UInt32, index:Int, maxLength:Int, length:Pointer<Int>, size:Pointer<Int>, type:Pointer<Int>, name:Pointer<CppVoid>):Void;

    @:native("glTexSubImage2D")
    public static function glTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, pixels:Pointer<CppVoid>):Void;

    @:native("glReadPixels")
    public static function glReadPixels(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:Pointer<CppVoid>):Void;

    @:native("glDrawArraysInstanced")
    public static function glDrawArraysInstanced(mode:Int, first:Int, count:Int, instancecount:Int):Void;

    @:native("glVertexAttribDivisor")
    public static function glVertexAttribDivisor(index:Int, divisor:Int):Void;

    @:native("glDrawElementsInstanced")
    public static function glDrawElementsInstanced(mode:Int, count:Int, type:Int, indices:Pointer<CppVoid>, instancecount:Int):Void;
}