package vupx.backend.managers;

import vupx.audio.VpAudioManager;

/**
 * A class to manage SDL_Mixer
 * 
 * Author: Slushi
 */
class VpSDLMixerManager {
    
    /**
     * Initializes SDL_Mixer
     */
    public static function init():Void {
        SDL_Mixer.Mix_Init(MIX_INIT_OGG);

        var result = SDL_Mixer.Mix_OpenAudioDevice(44100, SDL_Mixer.MIX_DEFAULT_FORMAT, 2, 2048, null, 0);
        if (result < 0) {
            throw "Failed to initialize SDL_mixer: " + SDL_Mixer.Mix_GetError();
        }

        VupxDebug.log("SDL_Mixer initialized!", INFO);

        // Initialize VpAudioManager
        new VpAudioManager();
        Vupx.audio = VpAudioManager.instance;
    }

    /**
     * Quits SDL_Mixer
     */
    public static function quit():Void {
        if (Vupx.audio != null) {
            Vupx.audio.clearAll();
        }

        SDL_Mixer.Mix_CloseAudio();
        SDL_Mixer.Mix_Quit();
        VupxDebug.log("SDL_Mixer quit!", INFO);
    }
}

