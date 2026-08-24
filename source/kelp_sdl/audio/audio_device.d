module kelp_sdl.audio.audio_device;

import kelp_sdl.audio;
import sdl.audio;
import std.array : array;
import std.algorithm : map;
import std.exception : enforce;
import std.string : fromStringz;

class AudioDevice
{
	SDL_AudioDeviceID audio_device_id;
	bool last_result;

	typeof(this) intialize()
	{

		return this;
	}

	typeof(this) finalize()
	{

		return this;
	}

	typeof(this) process()
	{
		return this;
	}

	@property bool is_valid() const pure nothrow @nogc @safe
	{
		return (this.audio_device_id != 0);
	}

	@property inout(SDL_AudioDeviceID) id() inout pure nothrow @nogc @safe
	{
		return this.audio_device_id;
	}

	@property int[] channel()
	in (this.is_valid)
	{
		int* mapping_ref;
		int count;
		mapping_ref = SDL_GetAudioDeviceChannelMap(this.audio_device_id, &count);
		enforce(mapping_ref !is null);
		return mapping_ref[0 .. count];
	}

	typeof(this) get_channel(out int[] channnel_mapping)
	in (this.is_valid)
	{
		int* mapping_ref;
		int count;
		mapping_ref = SDL_GetAudioDeviceChannelMap(this.audio_device_id, &count);
		enforce(mapping_ref !is null);
		channnel_mapping = mapping_ref[0 .. count];
		return this;
	}

	typeof(this) open()
	{
		SdlAudioSpec spec = SdlAudioSpec(SdlAudioFormat.f32le, 1, 8_000);
		this.audio_device_id = SDL_OpenAudioDevice(
			SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK,
			cast(SDL_AudioSpec*)&spec,
		);
		enforce(this.audio_device_id != 0);
		//writeln(this.gain());
		return this;
	}

	typeof(this) close()
	{
		SDL_CloseAudioDevice(this.audio_device_id);
		this.audio_device_id = 0;
		return this;
	}

	typeof(this) get_format(out SdlAudioSpec spec, out int sample_frame)
	in (this.is_valid)
	{
		last_result = SDL_GetAudioDeviceFormat(
			this.audio_device_id,
			cast(SDL_AudioSpec*)&spec,
			&sample_frame
		);
		return this;
	}

	@property float gain()
	{
		return SDL_GetAudioDeviceGain(this.audio_device_id);
	}

	typeof(this) get_gain(out float gain)
	in (this.is_valid)
	{
		gain = SDL_GetAudioDeviceGain(this.audio_device_id);
		enforce(gain != -1.0f);
		return this;
	}

	@property string name()
	{
		return cast(string) SDL_GetAudioDeviceName(this.audio_device_id).fromStringz();
	}

	typeof(this) get_name(out string name)
	in (this.is_valid)
	{
		name = cast(string) SDL_GetAudioDeviceName(this.audio_device_id).fromStringz();
		return this;
	}

	typeof(this) bind(in AudioStream[] audio_stream_list)
	in (this.is_valid)
	in (audio_stream_list.length < int.max)
	{
		last_result = SDL_BindAudioStreams(
			audio_device_id,
			cast(const(SDL_AudioStream*)*) audio_stream_list.map!(stream => stream.handle)
				.array(),
				cast(int) audio_stream_list.length,
		);
		enforce(last_result == true);
		return this;
	}

	typeof(this) resume()
	in (this.is_valid)
	{
		last_result = SDL_ResumeAudioDevice(this.audio_device_id);
		return this;
	}

	typeof(this) pause()
	in (this.is_valid)
	{
		last_result = SDL_PauseAudioDevice(this.audio_device_id);
		return this;
	}
}
