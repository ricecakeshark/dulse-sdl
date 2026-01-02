module kelp_sdl.core.sdl.sdl;

import bindbc.sdl;
import kelp_sdl.core;

class LibrarySDL
{
	const SDL_InitFlags init_flags = SDL_InitFlags.audio | SDL_InitFlags.video | SDL_InitFlags
		.gamepad;
	SemVersion compiled_version;
	SemVersion linked_version;

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
		compiled_version = SemVersion(SDL_VERSION);
		linked_version = SemVersion(SDL_GetVersion());
		return;
	}
}
