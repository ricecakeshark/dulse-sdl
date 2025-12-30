module kelp_sdl.core.sdl.sdl_image;

import bindbc.sdl;
import kelp_sdl.core;

class LibrarySDLImage
{
	SemVersion compiled_version;
	SemVersion linked_version;

	this()
	{
		return;
	}

	void initialize()
	{
		// no need IMG_Init() and more
		return;
	}

	void finalize()
	{
		// no need something
		return;
	}

	void get_version()
	{
		compiled_version = SemVersion(SDL_IMAGE_VERSION);
		linked_version = SemVersion(IMG_Version());
		return;
	}
}
