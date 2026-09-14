module dulse_sdl.mixer.resource.mixer;

import dulse.audio.desc;
import dulse_sdl.audio.desc;
import dulse_sdl.mixer;
import dulse.core.util;
import dulse_sdl.core.util;
import sdl.audio, sdl.properties;
import sdl_mixer;
import std.array : Appender;
import std.conv : to;
import std.exception : enforce;
import std.string : fromStringz, toStringz;

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

	@property float gain()
	{
		enforce(this.is_valid, "handle is null");
		return MIX_GetMixerGain(this._handle);
	}

	@property float gain(float gain)
	{
		enforce(this.is_valid, "handle is null");
		MIX_SetMixerGain(this._handle, gain);
		return gain;
	}

	@property AudioSpec format()
	{
		scope SDL_AudioSpec spec;
		enforce(this.is_valid, "handle is null");
		MIX_GetMixerFormat(this._handle, &spec);
		return audio_spec(spec);
	}

	@property string[] decoders()
	{
		return this.get_decoder();
	}

	typeof(this) create()
	{
		if (this._handle !is null)
		{
			return this;
		}
		this._handle = MIX_CreateMixerDevice(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, null);
		enforce(this._handle !is null, "failed to create mixer device");
		return this;
	}

	typeof(this) create(SDL_AudioDeviceID device_id)
	{
		if (this._handle !is null)
		{
			return this;
		}
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

	typeof(this) pause()
	{
		enforce(this.is_valid, "handle is null");
		MIX_PauseAllTracks(this._handle)
			.expect_sdl("failed to pause all tracks");
		return this;
	}

	typeof(this) resume()
	{
		enforce(this.is_valid, "handle is null");
		MIX_ResumeAllTracks(this._handle)
			.expect_sdl("failed to resume all tracks");
		return this;
	}

	typeof(this) play(string tag)
	{
		enforce(this.is_valid, "handle is null");
		MIX_PlayTag(this._handle, tag.toStringz(), cast(SDL_PropertiesID) 0)
			.expect_sdl("failed to play tracks with tag");
		return this;
	}

	typeof(this) resume(string tag)
	{
		enforce(this.is_valid, "handle is null");
		MIX_ResumeTag(this._handle, tag.toStringz())
			.expect_sdl("failed to resume tracks with tag");
		return this;
	}

	//available_format

protected:
	@property SDL_AudioSpec _format()
	{
		scope SDL_AudioSpec spec;
		enforce(this.is_valid, "handle is null");
		MIX_GetMixerFormat(this._handle, &spec);
		return spec;
	}

	string[] get_decoder()
	{
		Appender!(string[]) decoder_list;
		enforce(this.is_valid, "handle is null");
		foreach (index; 0 .. MIX_GetNumAudioDecoders())
		{
			decoder_list ~= MIX_GetAudioDecoder(index).fromStringz().to!string();
		}
		return decoder_list[];
	}
}
