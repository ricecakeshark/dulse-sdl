module kelp_sdl.mixer.resource.mixer;

import sdl.audio;
import sdl_mixer;
import std.exception : enforce;

class Mixer
{
	protected MIX_Mixer* _handle;

	this()
	{

	}

	@property inout(MIX_Mixer*) handle() inout pure nothrow @nogc @safe
	{
		return this._handle;
	}

	@property bool is_valid()
	{
		return this._handle !is null;
	}

	typeof(this) create(SDL_AudioDeviceID device_id)
	{
		this._handle = MIX_CreateMixerDevice(device_id, null);
		enforce(this._handle !is null);
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
}
