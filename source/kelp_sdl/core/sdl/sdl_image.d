module kelp_sdl.core.sdl.sdl_image;

import sdl_image;
import kelp_core.core.data.version_;
import kelp_sdl.core.desc;

class LibrarySDLImage
{
	Ver3 compiled_version;
	Ver3 linked_version;

	this()
	{
		return;
	}

	void initialize()
	{
		// no need IMG_Init() and more
		get_version();
		return;
	}

	void finalize()
	{
		// no need something
		return;
	}

	void get_version()
	{
		compiled_version = from_sdl_version(SDL_IMAGE_VERSION);
		linked_version = from_sdl_version(IMG_Version());
		return;
	}
}
