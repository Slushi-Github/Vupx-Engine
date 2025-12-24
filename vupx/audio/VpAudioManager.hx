package vupx.audio;

/**
 * VpAudioManager is a singleton class that manages audio playback using SDL_Mixer.
 * 
 * Author: Slushi
 */
class VpAudioManager {
    /**
     * Singleton instance of VpAudioManager.
     */
    public static var instance:Null<VpAudioManager> = null;

    /**
     * Array of loaded audio file names (to avoid reloading the same file multiple times).
     */
    @:noCompletion
    public var sdlMixerAudios:Null<Map<String, Pointer<Mix_Chunk>>>;

    /**
     * Array of VpAudio instances (both sounds and music).
     */
    @:noCompletion
    public var audiosInstances:Null<Array<VpAudio>>;

    /**
     * Currently playing music track (if any).
     */
    public var music:Null<VpAudio>;

    /**
     * VpAudioManager is a singleton class that manages audio playback.
     */
    public function new() {
        if (instance != null) {
            VupxDebug.log("VpAudioManager is a singleton and has already been instantiated.", WARNING);
            return;
        }
        instance = this;

        sdlMixerAudios = new Map<String, Pointer<Mix_Chunk>>();
        audiosInstances = new Array<VpAudio>();
    }

    /**
     * Plays a sound track
     * 
     * @param fileName Path to the sound file
     * @param loop Whether to loop the sound (default is false)
     */
    public function play(fileName:Null<String>, loop:Null<Bool> = false):Null<VpAudio> {
        var sound = new VpAudio(fileName, VpaudioType.SOUND);
        sound.play(loop);

        return sound;
    }

    /**
     * Plays a music track, stopping any previously playing music.
     * 
     * @param fileName Path to the music file (Only OGG files are supported)
     * @param loop Whether to loop the music (default is false)
     */
    public function playMusic(fileName:Null<String>, loop:Null<Bool> = false):Void {
        if (music != null) {
            music.stop();
        }
        music = new VpAudio(fileName, VpaudioType.MUSIC);
        music.play(loop);
    }

    /**
     * Stops the currently playing music track.
     */
    public function stopMusic():Void {
        if (music != null) {
            music.stop();
            music = null;
        }
    }

    /**
     * Stops all currently playing sounds (not music).
     */
    @:noCompletion
    public function stopAllSounds():Void {
        for (sound in audiosInstances) {
            if (sound != null && sound.audioType == VpaudioType.SOUND) {
                sound.stop();
                audiosInstances.remove(sound);
            }
        }
    }

    /**
     * Stops all sounds and music.
     */
    @:noCompletion
    public function stopAll():Void {
        stopAllSounds();
        stopMusic();
        VupxDebug.log("Stopped all audio", DEBUG);
    }

    /**
     * Clears all VpAudio instances and stops all sounds (not music).
     */
    @:noCompletion
    public function clearAllSounds():Void {
        stopAllSounds();
        for (chunk in sdlMixerAudios) {
            chunk ?? continue;
            SDL_Mixer.Mix_FreeChunk(chunk);
        }
        sdlMixerAudios.clear();
    }

    /**
     * Clears all VpAudio instances and stops all sounds and music.
     */
    @:noCompletion
    public function clearAll():Void {
        stopAll();
        sdlMixerAudios = new Map<String, Pointer<Mix_Chunk>>();
        audiosInstances = new Array<VpAudio>();
    }
}