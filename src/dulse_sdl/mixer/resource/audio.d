module dulse_sdl.mixer.resource.audio;

import dulse.audio.desc;
import dulse_sdl.audio.desc;
import dulse_sdl.mixer;
import dulse_sdl.core.util;
import dulse.core.util;
import sdl.audio;
import sdl_mixer;
import std.exception : enforce;
import std.string : toStringz;

class Audio
{
	protected MIX_Audio* _handle;
	protected Mixer mixer;

	this(Mixer mixer)
	{
		this.mixer = mixer;
		return;
	}

	invariant
	{
		assert(this !is null, "this is null");
		assert(this.mixer !is null, "mixer is null");
		assert(this.mixer.is_valid, "mixer is some wrong");
	}

	@property inout(MIX_Audio*) handle() inout pure nothrow @nogc @safe
	{
		return this._handle;
	}

	@property bool is_valid() const pure nothrow @nogc @safe
	{
		return this._handle !is null;
	}

	@property AudioSpec format()
	{
		scope SDL_AudioSpec spec;
		MIX_GetAudioFormat(this._handle, &spec);
		return audio_spec(spec);
	}

	typeof(this) load(string path)
	{
		this._handle = MIX_LoadAudio(this.mixer.handle, path.toStringz, true);
		enforce(this._handle !is null, "failed to load audio file");
		return this;
	}

	typeof(this) release() @trusted
	{
		if (this._handle is null)
		{
			return this;
		}
		MIX_DestroyAudio(this._handle);
		this._handle = null;
		return this;
	}

	typeof(this) play(ref Track track)
	{
		track.set(this);
		track.play();
		return this;
	}

	typeof(this) play()
	{
		MIX_PlayAudio(this.mixer.handle, this.handle)
			.check("failed to play.");
		return this;
	}

protected:
	@property SDL_AudioSpec _format()
	{
		scope SDL_AudioSpec spec;
		MIX_GetAudioFormat(this._handle, &spec);
		return spec;
	}
}
