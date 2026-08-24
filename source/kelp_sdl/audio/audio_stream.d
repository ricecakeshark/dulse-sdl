module kelp_sdl.audio.audio_stream;

import kelp_core.audio;
import kelp_sdl.audio;
import sdl.audio;
import std.exception : enforce;

class AudioStream
{
	SDL_AudioStream* audio_stream_handle;
	SdlAudioSpec input_format;
	SdlAudioSpec output_format;
	bool last_result;

	typeof(this) initialize()
	{
		return this;
	}

	typeof(this) finalize()
	{
		this.release();
		return this;
	}

	typeof(this) process()
	{
		return this;
	}

	@property bool is_valid() inout pure nothrow @nogc @safe
	{
		return (this.audio_stream_handle !is null);
	}

	@property inout(SDL_AudioStream*) handle() inout pure nothrow @nogc @safe
	{
		return this.audio_stream_handle;
	}

	@property int channels() inout pure nothrow @nogc @safe
	{
		return this.input_format.channels;
	}

	@property int sample_rate() inout pure nothrow @nogc @safe
	{
		return this.input_format.freq;
	}

	typeof(this) create(in SdlAudioSpec src_spec, in SdlAudioSpec dst_spec)
	{
		this.audio_stream_handle = SDL_CreateAudioStream(
			cast(SDL_AudioSpec*)&src_spec,
			cast(SDL_AudioSpec*)&dst_spec,
		);
		enforce(this.audio_stream_handle !is null);
		this.get_format(input_format, output_format);
		return this;
	}

	typeof(this) release()
	{
		SDL_DestroyAudioStream(this.audio_stream_handle);
		return this;
	}

	typeof(this) get_format(
		out SdlAudioSpec src_spec,
		out SdlAudioSpec dst_spec,
	)
	{
		last_result = SDL_GetAudioStreamFormat(
			this.audio_stream_handle,
			cast(SDL_AudioSpec*)&src_spec,
			cast(SDL_AudioSpec*)&dst_spec,
		);
		enforce(last_result == true);
		return this;
	}

	typeof(this) get_frequency(out float frequency_ratio)
	{
		frequency_ratio = SDL_GetAudioStreamFrequencyRatio(this.audio_stream_handle);
		enforce(frequency_ratio != 0.0f);
		return this;
	}
	// queue
	@property int queued()
	{
		return SDL_GetAudioStreamQueued(this.audio_stream_handle);
	}

	typeof(this) get_queued(out int queued_size)
	{
		queued_size = SDL_GetAudioStreamQueued(this.audio_stream_handle);
		enforce(queued_size != -1);
		return this;
	}

	typeof(this) set_format(in SdlAudioSpec src_spec, in SdlAudioSpec dst_spec)
	in (this.is_valid)
	{
		last_result = SDL_SetAudioStreamFormat(
			this.audio_stream_handle,
			cast(SDL_AudioSpec*)&src_spec,
			cast(SDL_AudioSpec*)&dst_spec,
		);
		return this;
	}

	typeof(this) set_frequency(in float ratio)
	{
		last_result = SDL_SetAudioStreamFrequencyRatio(this.audio_stream_handle, ratio);
		return this;
	}
	// gain
	@property float gain()
	{
		float gain;
		gain = SDL_GetAudioStreamGain(this.audio_stream_handle);
		enforce(gain != -1.0f);
		return gain;
	}

	typeof(this) get_gain(out float gain)
	{
		gain = SDL_GetAudioStreamGain(this.audio_stream_handle);
		enforce(gain != -1.0f);
		return this;
	}

	typeof(this) set_gain(float gain)
	in (this.is_valid)
	in (gain >= 0.0f && gain <= 1.5f)
	{
		last_result = SDL_SetAudioStreamGain(
			this.audio_stream_handle,
			gain,
		);
		return this;
	}

	typeof(this) clear()
	in (this.is_valid)
	{
		last_result = SDL_ClearAudioStream(this.audio_stream_handle);
		return this;
	}
	// bind
	SDL_AudioDeviceID device_id()
	in (this.is_valid)
	{
		return SDL_GetAudioStreamDevice(this.audio_stream_handle);
	}

	typeof(this) get_binded(out SDL_AudioDeviceID device_id)
	{
		device_id = SDL_GetAudioStreamDevice(this.audio_stream_handle);
		return this;
	}

	typeof(this) unbind()
	in (this.is_valid)
	{
		SDL_UnbindAudioStream(this.audio_stream_handle);
		return this;
	}
	// data
	typeof(this) get(Type)(out Type[] data)
	in (this.is_valid)
	{
		float* buffer_ptr;
		int len;
		SDL_GetAudioStreamData(this.audio_stream_handle, buffer_ptr, len);
		data = cast(Type[]) buffer_ptr[0 .. len];
		return this;
	}

	typeof(this) put(in AudioFragment fragment)
	in (this.is_valid)
	in (fragment.size < int.max)
	{
		last_result = SDL_PutAudioStreamData(
			this.audio_stream_handle, //cast(const(void*))&data_buffer,
			fragment.buffer.ptr,
			cast(int)(fragment.size),
		);
		enforce(last_result == true);
		return this;
	}

	typeof(this) flush()
	in (this.is_valid)
	{
		last_result = SDL_FlushAudioStream(this.audio_stream_handle);
		enforce(last_result == true);
		return this;
	}

	typeof(this) resume()
	{
		last_result = SDL_ResumeAudioStreamDevice(this.audio_stream_handle);
		return this;
	}

	typeof(this) pause()
	{
		last_result = SDL_PauseAudioStreamDevice(this.audio_stream_handle);
		return this;
	}

	typeof(this) if_queueable(void delegate() dlg)
	{
		if (this.queued <= this.sample_rate * 0.05)
		{
			dlg();
		}
		return this;
	}
}
