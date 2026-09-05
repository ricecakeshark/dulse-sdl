module dulse_sdl.core.sdl.sdl_ttf;

import sdl_ttf;
import dulse.core;
import dulse_sdl.core;

class LibrarySDLTTF
{
	Ver3 compiled_version;
	Ver3 linked_version;

	this()
	{
		return;
	}

	void initialize()
	{
		TTF_Init().catch_sdl_error();
		get_version();
		return;
	}

	void finalize()
	{
		TTF_Quit();
		return;
	}

	void get_version()
	{
		compiled_version = from_sdl_version(SDL_TTF_VERSION);
		linked_version = from_sdl_version(TTF_Version());
		return;
	}
}
