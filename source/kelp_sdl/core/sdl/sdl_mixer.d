module kelp_sdl.core.sdl.sdl_mixer;

import sdl_mixer;
import kelp_core.core.data.version_;
import kelp_sdl.core;

class LibrarySDLMixer
{
	Ver3 compiled_version;
	Ver3 linked_version;

	this()
	{
		return;
	}

	void initialize()
	{
		MIX_Init().catch_sdl_error();
		get_version();
		return;
	}

	void finalize()
	{
		MIX_Quit();
		return;
	}

	void get_version()
	{
		compiled_version = from_sdl_version(SDL_MIXER_VERSION);
		linked_version = from_sdl_version(MIX_Version());
		return;
	}
}
