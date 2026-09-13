module dulse_sdl.mixer.resource.mixer;

import dulse.audio.desc;
import dulse_sdl.audio.desc;
import dulse_sdl.mixer;
import dulse.core.util;
import dulse_sdl.core.util;
import sdl.audio;
import sdl_mixer;
import std.exception : enforce;

class Mixer
{
	protected MIX_Mixer* _handle;

	this()
	{

	}

	invariant
	{
		assert(this !is null, "this is null");
	}

	@property inout(MIX_Mixer*) handle() inout pure nothrow @nogc @safe
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
		MIX_GetMixerFormat(this._handle, &spec);
		return audio_spec(spec);
	}

	typeof(this) create()
	{
		this._handle = MIX_CreateMixerDevice(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, null);
		enforce(this._handle !is null, "failed to create mixer device");
		return this;
	}

	typeof(this) create(SDL_AudioDeviceID device_id)
	{
		this._handle = MIX_CreateMixerDevice(device_id, null);
		enforce(this._handle !is null, "failed to create mixer device");
		return this;
	}

	typeof(this) release()
	{
		if (this._handle is null)
		{
			return this;
		}
		MIX_DestroyMixer(this._handle);
		this._handle = null;
		return this;
	}

	//available_format

protected:
	@property SDL_AudioSpec _format()
	{
		scope SDL_AudioSpec spec;
		MIX_GetMixerFormat(this._handle, &spec);
		return spec;
	}
}
