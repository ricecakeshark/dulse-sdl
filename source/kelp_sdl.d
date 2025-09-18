module kelp_sdl;

import kelp_core;
import kelp_api;
public import bindbc.sdl;
import std.exception;

public:

class SDL : SharedLibrary
{
	void initialize()
	{
		bool result;
		result = SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_JOYSTICK | SDL_INIT_GAMEPAD);
		enforce(result == true);
		return;
	}

	void finalize()
	{
		SDL_Quit();
		return;
	}

	int[] getVersion()
	{
		const int linked_version = SDL_GetVersion();
		return [
			SDL_VERSIONNUM_MAJOR(linked_version),
			SDL_VERSIONNUM_MINOR(linked_version),
			SDL_VERSIONNUM_MICRO(linked_version)
		];
	}
}
