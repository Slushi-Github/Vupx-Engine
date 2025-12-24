package vupx.audio;

/**
 * Type of audio
 */
enum VpaudioType {
    /**
     * Sound type
     */
    SOUND;

    /**
     * Music type
     */
    @:noCompletion
    MUSIC;
}

/**
 * This really sucks. How is it possible that the SDL_Mixer version 
 * for Nintendo Switch doesn't have functions to get the duration or 
 * current time of a song that's playing? And in general, I don't 
 * understand why SDL_Mixer didn't implement that from the beginning... 
 * I think it's basic. Oh well, we'll just have to make do with the Switch's ARM counter and  stb_vorbis...
 * 
 * The trick to getting the current time of the music, I actually got it from Super Hexagon (Really good game heh).
 * (https://github.com/RedTopper/Super-Haxagon/blob/88a8f6c3e0a40cb015b5055d5212c3abec1f279d/driver/Switch/source/MusicSwitch.cpp#L13)
 */
/**
 * Class for handling audio playback using SDL_Mixer.
 * 
 * Author: Slushi
 */
class VpAudio extends VpBase {
    /**
     * Length of the audio in seconds
     */
    public var length(get, never):Float;

    /**
     * Position of the audio in seconds
     */
    public var time(get, set):Float;

    /**
     * Volume of the audio
     */
    public var volume(get, set):Float;

    /**
     * Playback speed of the audio
     */
    public var playing(get, never):Bool;

    /**
     * Whether the audio is paused
     */
    public var paused(get, never):Bool;

    /**
     * Loop of the audio
     */
    public var loop:Bool;

    /**
     * Type of audio (sound effect or music)
     */
    public var audioType:VpaudioType;

    /**
     * File path of the audio file
     */
    public var filePath:String;

    /**
     * Function to call when the audio is complete
     * 
     * Only being called if loop is false
     */
    public var onComplete:Null<Void->Void> = null;

    /**
     * Pointer to Mix_Chunk structure (for sound effects)
     */
    private var audioMixChunkPtr:Pointer<Mix_Chunk>;

    /**
     * Pointer to Mix_Music structure (for music tracks)
     */
    private var audioMixMusicPtr:Pointer<Mix_Music>;

    /**
     * Current SDL_Mixer channel (for sound effects)
     */
    private var currentChannel:Int = -1;

    /**
     * Start time of the audio playback
     */
    private var startTime:Float;

    /**
     * Pause time of the audio playback
     */
    private var pauseTime:Float;

    /**
     * Whether the audio is currently playing
     */
    private var _playing:Bool = false;

    /**
     * Whether the audio is currently paused
     */
    private var _paused:Bool = false;

    /**
     * Whether the audio is currently looping
     */
    private var _volume:Float = 1.0;

    /**
     * Whether the audio is currently looping
     */
    private var _loop:Bool = false;

    /**
     * Internal the length of the audio via stb_vorbis
     */
    private var internalLength:Float = -1;

    /**
     * Whether the audio was paused by suspend the program or the console
     */
    private var _wasPausedBySuspend:Bool = false;

    /**
     * Constructor for VpAudio
     * 
     * ``new VpAudio("path/to/sound.ogg", VpaudioType.SOUND)``
     * 
     * @param filePath Path to the audio file (Only OGG files are supported)
     * @param audioType Type of audio (default is SOUND)
     */
    public function new(filePath:Null<String>, ?audioType:VpaudioType = VpaudioType.SOUND) {
        super();

        this.filePath = filePath;
        this.audioType = audioType;

        if (!FileSystem.exists(filePath)) {
            VupxDebug.log("File not found: " + filePath, ERROR);
            return;
        }
        else if (filePath == null) {
            VupxDebug.log("File path is null", ERROR);
            return;
        }
        else if (!filePath.endsWith(".ogg")) {
            VupxDebug.log("File is not an OGG file: " + filePath, ERROR);
            return;
        }
        else if (audioType == null) {
            VupxDebug.log("Audio type is null", ERROR);
            return;
        }
        else if (VpAudioManager.instance == null) {
            VupxDebug.log("VpAudioManager instance is null", ERROR);
            return;
        }

        switch (audioType) {
            case SOUND:
                VpAudioManager.instance ?? return;
                VpAudioManager.instance.sdlMixerAudios ?? return;

                if (VpAudioManager.instance.sdlMixerAudios.exists(filePath)) {
                    this.audioMixChunkPtr = VpAudioManager.instance.sdlMixerAudios.get(filePath);
                } else {
                    audioMixChunkPtr = SDL_Mixer.Mix_LoadWAV(filePath);
                    if (audioMixChunkPtr == null) {
                        VupxDebug.log("Failed to load sound effect: " + SDL_Mixer.Mix_GetError(), ERROR);
                        return;
                    }
                    VpAudioManager.instance.sdlMixerAudios.set(filePath, audioMixChunkPtr);
                }
            case MUSIC:
                audioMixMusicPtr = SDL_Mixer.Mix_LoadMUS(filePath);
                if (audioMixMusicPtr == null) {
                    VupxDebug.log("Failed to load music: " + SDL_Mixer.Mix_GetError(), ERROR);
                    return;
                }
            default:
                VupxDebug.log("Invalid audio type: " + audioType, ERROR);
                return;
        }

        // Get duration of the audio or music
        internalLength = getDuration();
    }

    /**
     * Play the audio
     * @param loop Whether to loop the audio
     */
    public function play(loop:Null<Bool> = false, volume:Null<Float> = null):Void {
        if (playing) {
            return;
        }

        this.loop = loop ?? false;
        this.volume = volume ?? 1.0;

        switch (audioType) {
            case SOUND:
                audioMixChunkPtr ?? return;
                if (!VpAudioManager.instance.audiosInstances.contains(this)) {
                    VpAudioManager.instance.audiosInstances.push(this);
                }
                var channel:Int = SDL_Mixer.Mix_PlayChannel(currentChannel, audioMixChunkPtr, if (this.loop) -1 else 0);
                if (channel == -1) {
                    VupxDebug.log("No available sound channels!", ERROR);
                    return;
                }
                currentChannel = channel;
            case MUSIC:
                audioMixMusicPtr ?? return;
                SDL_Mixer.Mix_PlayMusic(audioMixMusicPtr, if (this.loop) -1 else 0);
        }

        _playing = true;
        _paused = false;
        startTime = VpSwitch.getARMTimeNow();
        pauseTime = 0;
    }

    /**
     * Resume the audio playback
     */
    public function resume():Void {
        // if (!playing) {
        //     return;
        // }

        switch (audioType) {
            case SOUND:
                if (currentChannel != -1) {
                    SDL_Mixer.Mix_Resume(currentChannel);
                }
            case MUSIC:
                audioMixMusicPtr ?? return;
                if (SDL_Mixer.Mix_PlayingMusic() != 0 && SDL_Mixer.Mix_PausedMusic() != 0) {
                    SDL_Mixer.Mix_ResumeMusic();
                }
        }

        if (pauseTime > 0) {
            startTime += VpSwitch.getARMTimeNow() - pauseTime;
            pauseTime = 0;
        }

        _playing = true;
        _paused = false;
    }

    /**
     * Pause the audio playback
     */
    public function pause():Void {
        if (!playing) {
            return;
        }

        switch (audioType) {
            case SOUND:
                if (currentChannel != -1) {
                    SDL_Mixer.Mix_Pause(currentChannel);
                }
            case MUSIC:
                audioMixMusicPtr ?? return;
                if (SDL_Mixer.Mix_PlayingMusic() != 0 && SDL_Mixer.Mix_PausedMusic() == 0) {
                    SDL_Mixer.Mix_PauseMusic();
                }
        }
        pauseTime = VpSwitch.getARMTimeNow();
        _playing = false;
        _paused = true;
    }

    /**
     * Stop the audio playback
     */
    public function stop():Void {
        switch (audioType) {
            case SOUND:
            audioMixChunkPtr ?? return;
            SDL_Mixer.Mix_HaltChannel(currentChannel);
            _playing = false;
            _paused = false;
            case MUSIC:
                audioMixMusicPtr ?? return;
                SDL_Mixer.Mix_HaltMusic();
                SDL_Mixer.Mix_FreeMusic(audioMixMusicPtr);
                audioMixMusicPtr = null;
        }
        _playing = false;
        _paused = false;
        startTime = 0;
        pauseTime = 0;
        _wasPausedBySuspend = false;
    }

    public function get_time():Float {
        if (!_playing) return 0;
        
        switch (audioType) {
            case SOUND:
                return VpSwitch.getARMTimeNow() - startTime;
            case MUSIC:
                if (_paused && pauseTime > 0) {
                    return pauseTime - startTime;
                }
                return VpSwitch.getARMTimeNow() - startTime;
        }
        return 0;
    }

    public function set_time(value:Null<Float>):Float {
        if (value < 0 || value == null || (internalLength > 0 && value > internalLength)) {
            return value;
        }

        switch (audioType) {
            case SOUND:
                // SDL_Mixer does not support seeking in sound effects
                return 0;
            case MUSIC:
                audioMixMusicPtr ?? return value;
                if (SDL_Mixer.Mix_SetMusicPosition(value) != 0) {
                    VupxDebug.log("Failed to seek music: " + SDL_Mixer.Mix_GetError(), ERROR);
                    return value;
                }
                startTime = VpSwitch.getARMTimeNow() - value;
                if (!playing) {
                    pauseTime = VpSwitch.getARMTimeNow();
                }
                return value;
                
        }
        return value;
    }

    public function get_length():Float {
        return internalLength;
    }

    public function set_volume(value:Float):Float {
        var finalValue:Float = value;
        if (value < 0) {
            finalValue = 0;
        } else if (value > 1) {
            finalValue = 1;
        }

        switch (audioType) {
            case SOUND:
                audioMixChunkPtr ?? return finalValue;
                SDL_Mixer.Mix_VolumeChunk(audioMixChunkPtr, Std.int(finalValue * 128));
                _volume = finalValue;
            case MUSIC:
                audioMixMusicPtr ?? return finalValue;
                SDL_Mixer.Mix_VolumeMusic(Std.int(finalValue * 128));
                _volume = finalValue;
        }

        return finalValue;
    }

    public function get_volume():Float {
        return _volume;
    }

    public function get_playing():Bool {
        return _playing;
    }

    public function get_paused():Bool {
        return _paused;
    }

    ///////////////////////////////////

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Check if the audio should be stopped because it's over
        if (length > 0 && (time * 1000) > length && (!loop && playing)) {
            stop();
            _paused = true;
            if (onComplete != null) {
                onComplete();
            }
        }

        #if VUPX_PAUSES_ON_SUSPEND
        if (Vupx.paused) {
            if (_playing && !_wasPausedBySuspend) {
                _wasPausedBySuspend = true;
                pause();
            }
        }
        else {
            if (_wasPausedBySuspend) {
                _wasPausedBySuspend = false;
                resume();
            }
        }
        #end
    }

    override public function destroy():Void {
        stop();
        super.destroy();
    }

    ///////////////////////////////////

    /**
     * Set the current channel of the audio
     * @param channel
     */
    public function setCurrentChannel(channel:Null<Int>):Void {
        if (channel == null || audioType == MUSIC) {
            return;
        }
        currentChannel = channel;
    }

    ///////////////////////////////////

    /**
     * Get the duration of the audio
     * @return Float (duration in seconds, or 0 if error)
     */
    private function getDuration():Float {
        var error:Int = 0;
        var vorbis:Pointer<Stb_Vorbis> = Stb_VorbisClass.stb_vorbis_open_filename(
            filePath, 
            error.toPointer(), 
            null
        );

        if (vorbis == null) {
            VupxDebug.log('Failed to open Vorbis file for getting duration of [$filePath] (error code: $error)', ERROR);
            switch (error) {
                case 34:
                    VupxDebug.log('Error 34: Invalid Vorbis file, The file must be explicitly an "OGG Vorbis" file.', ERROR);
            }
            return 0;
        }

        var duration:Float = Stb_VorbisClass.stb_vorbis_stream_length_in_seconds(vorbis);
        if (duration == 0) {
            var err:Int = Stb_VorbisClass.stb_vorbis_get_error(vorbis);
            VupxDebug.log('Failed to get duration for: [$filePath] (error: $err)', WARNING);
        }

        Stb_VorbisClass.stb_vorbis_close(vorbis);

        return duration;
    }
}