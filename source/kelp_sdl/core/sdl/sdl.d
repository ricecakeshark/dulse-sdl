module kelp_sdl.core.sdl.sdl;

import bindbc.sdl;
import kelp_core.core;
import kelp_sdl.core;

class LibrarySDL
{
	const SDL_InitFlags init_flags = SDL_InitFlags.audio | SDL_InitFlags.video | SDL_InitFlags
		.gamepad;
	Ver3 compiled_version;
	Ver3 linked_version;

	this()
	{
		return;
	}

	void initialize()
	{
		SDL_Init(init_flags).catchSDLError();
		get_version();
		return;
	}

	void finalize()
	{
		SDL_Quit();
		return;
	}

	void get_version()
	{
		compiled_version = from_sdl_version(SDL_VERSION);
		linked_version = from_sdl_version(SDL_GetVersion());
		return;
	}
}
