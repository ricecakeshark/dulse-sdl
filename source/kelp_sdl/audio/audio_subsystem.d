module kelp_sdl.audio.audio_subsystem;

import kelp_sdl.audio;
import kelp_core.core.subsystem;

class AudioSubsystem : Subsystem
{
	void initialize()
	{
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		return;
	}

	AudioDevice open_device()
	{
		return new AudioDevice();
	}

	AudioStream create_stream()
	{
		return new AudioStream();
	}
}
