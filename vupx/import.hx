#if !macro
// For haxe/C++ interaction or engine bindings
import cpp.*;
import cpp.Void as CppVoid;
import vupx.bindings.CPPHelpers;
import vupx.bindings.CPPHelpers.CArray;
import vupx.bindings.CPPHelpers.CConstArray;

// Engine base libraries /////////////////////

// libnx imports for most used classes on the engine
import switchLib.Result;
import switchLib.Types.ResultType;
import switchLib.runtime.Pad;
import switchLib.services.Hid;
import switchLib.arm.Counter;
import switchLib.services.Applet;

// GLM imports
import vupx.bindings.glm.Vec2;
import vupx.bindings.glm.Vec4;
import vupx.bindings.glm.Vec3;
import vupx.bindings.glm.Mat4;
import vupx.bindings.glm.GLM;

// OpenAL imports (Unused imports)
import vupx.bindings.openal.Al;
import vupx.bindings.openal.Alc;
import vupx.bindings.openal.Alc.ALCcontext;
import vupx.bindings.openal.Alc.ALCdevice;

// OpenGL and Glad imports
import vupx.bindings.opengl.GL;
import vupx.bindings.opengl.Glad;

// SDL2 imports
import vupx.bindings.sdl2.SDL;
import vupx.bindings.sdl2.SDL_Video;
import vupx.bindings.sdl2.SDL_Video.SDL_Window;
import vupx.bindings.sdl2.SDL_Video.SDL_WindowFlags;
import vupx.bindings.sdl2.SDL_Video.SDL_DisplayMode;
import vupx.bindings.sdl2.SDL_Pixels.SDL_Color;
import vupx.bindings.sdl2.SDL_Pixels.SDL_Palette;
import vupx.bindings.sdl2.SDL_Pixels.SDL_PixelFormat;
import vupx.bindings.sdl2.SDL_Pixels.SDL_PixelsClass;
import vupx.bindings.sdl2.SDL_Surface;
import vupx.bindings.sdl2.SDL_Surface.SDL_BlitMap;
import vupx.bindings.sdl2.SDL_Surface.SDL_Surface;
import vupx.bindings.sdl2.SDL_Surface.SDL_SurfaceClass;
import vupx.bindings.sdl2.SDL_BlendMode;
import vupx.bindings.sdl2.SDL_Stdinc;
import vupx.bindings.sdl2.SDL_Stdinc.SDL_Bool;
import vupx.bindings.sdl2.SDL_Error;
import vupx.bindings.sdl2.SDL_Image;
import vupx.bindings.sdl2.SDL_Image.IMG_InitFlags;
import vupx.bindings.sdl2.SDL_Mixer;
import vupx.bindings.sdl2.SDL_Mixer.Mix_Chunk;
import vupx.bindings.sdl2.SDL_Mixer.Mix_Music;
import vupx.bindings.sdl2.SDL_Mixer.MIX_InitFlags;
import vupx.bindings.sdl2.SDL_Mixer.Mix_MusicType;
import vupx.bindings.sdl2.SDL_Mixer.SDL_Mixer;
import vupx.bindings.sdl2.SDL_Rect.SDL_FPoint;
import vupx.bindings.sdl2.SDL_Rect.SDL_FRect;
import vupx.bindings.sdl2.SDL_Rect.SDL_FRect;
import vupx.bindings.sdl2.SDL_Rect.SDL_Point;
import vupx.bindings.sdl2.SDL_Rect.SDL_Rect;
import vupx.bindings.sdl2.SDL_Timer;
import vupx.bindings.sdl2.SDL_Render;

// stb_truetype imports
import vupx.bindings.stb_truetype.Stb_TrueType;

// stb_vorbis imports
import vupx.bindings.stb_vorbis.Stb_Vorbis;
import vupx.bindings.stb_vorbis.Stb_Vorbis.Stb_VorbisClass;

// Engine imports //////////////////////////////

import vupx.backend.logging.VupxDebug;
import vupx.backend.logging.VupxCrashHandler;
import vupx.backend.managers.VpSDLImageManager;
import vupx.backend.managers.VpSDLVideoManager;
import vupx.backend.managers.VpSDLMixerManager;
import vupx.backend.VpStateHandler;

import vupx.audio.VpAudio;
import vupx.audio.VpAudioManager;

import vupx.controls.VpControl;
import vupx.controls.VpControlButton;
import vupx.controls.VpScreenBackLight;
import vupx.controls.VpTouchScreen;
import vupx.controls.VpVibrationHD;

import vupx.core.graphics.VpTexture;
import vupx.core.graphics.VpTextureCache;
import vupx.core.graphics.VpTextFont;
import vupx.core.renderer.batch.VpBatch;
import vupx.core.renderer.batch.VpBatchManager;
import vupx.core.renderer.VpGLRendererSetup;
import vupx.core.renderer.VpSDLWindow;
import vupx.core.renderer.VpGLRenderer;
import vupx.core.shaders.VpInstancedBatchShader;
import vupx.core.shaders.VpShader;
import vupx.core.VpConstants;

import vupx.math.VpVector2;
import vupx.math.VpVector3;
import vupx.math.VpRect;
import vupx.math.VpPoint2;

import vupx.modules.VpModulesManager;

import vupx.groups.VpGroup;

import vupx.objects.VpAnimatedSprite;
import vupx.objects.VpBaseObject;
import vupx.objects.VpSprite;
import vupx.objects.VpText;

import vupx.states.internalStates.VupxIntro;
import vupx.states.VpState;
import vupx.states.VpSubState;

import vupx.system.VpIRCamera;
import vupx.system.VpSimpleWeb;
import vupx.system.VpSwitch;
import vupx.system.VpScreenKeyboard;

import vupx.tweens.VpEase;
import vupx.tweens.VpTween;
import vupx.tweens.VpTweenManager;

import vupx.utils.VpSaveUtil;
import vupx.utils.VpShakeUtil;
import vupx.utils.VpStorage;
import vupx.utils.VpUtils;
import vupx.utils.VpColor;
import vupx.utils.VpTimer;

// Haxe imports /////////////////////

import Std;
import sys.io.File;
import sys.FileSystem;
import haxe.Timer;
import haxe.Json;
import haxe.ds.StringMap;
import cpp.vm.Gc;

using StringTools;
using vupx.bindings.CPPHelpers;
#end