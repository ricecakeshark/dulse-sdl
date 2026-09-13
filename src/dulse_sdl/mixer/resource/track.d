module dulse_sdl.mixer.resource.track;

import sdl.audio, sdl.properties;
import sdl_mixer;
import dulse.core.util;
import dulse_sdl.core.util;
import dulse_sdl.mixer;
import std.exception : enforce;

class Track
{
	protected MIX_Track* _handle;
	protected Mixer mixer;

	this(Mixer mixer)
	{
		this.mixer = mixer;
		return;
	}

	invariant
	{
		assert(this !is null, "this is null");
	}

	@property inout(MIX_Track*) handle() inout pure nothrow @nogc @safe
	{
		return this._handle;
	}

	@property bool is_valid() pure nothrow @nogc @safe
	{
		return (this._handle !is null);
	}

	typeof(this) create()
	{
		this._handle = MIX_CreateTrack(this.mixer.handle);
		enforce(this._handle !is null);
		return this;
	}

	typeof(this) release() @trusted
	{
		if (this._handle is null)
		{
			return this;
		}
		MIX_DestroyTrack(this._handle);
		this._handle = null;
		return this;
	}

	typeof(this) set(Audio audio)
	{
		MIX_SetTrackAudio(this.handle, audio.handle)
			.check("failed to set audio to track");
		return this;
	}

	typeof(this) set(SDL_AudioStream* stream_handle)
	{
		MIX_SetTrackAudioStream(this.handle, stream_handle)
			.check("failed to set audio to track");
		return this;
	}

	typeof(this) play()
	{
		scope bool succeed;
		succeed = MIX_PlayTrack(this._handle, cast(SDL_PropertiesID) 0);
		return this;
	}
}
