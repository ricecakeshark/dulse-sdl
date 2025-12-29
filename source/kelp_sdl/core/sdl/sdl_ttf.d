module kelp_sdl.core.sdl.sdl_ttf;

import bindbc.sdl;
import kelp_sdl.core.sdl_version;
import kelp_sdl.util;

class LibrarySDLTTF
{
	SemVersion compiled_version;
	SemVersion linked_version;

	this()
	{
		return;
	}

	void initialize()
	{
		TTF_Init().catchSDLError();
		return;
	}

	void finalize()
	{
		TTF_Quit();
		return;
	}

	void get_version()
	{
		compiled_version = SemVersion(SDL_TTF_VERSION);
		linked_version = SemVersion(TTF_Version());
		return;
	}
}
