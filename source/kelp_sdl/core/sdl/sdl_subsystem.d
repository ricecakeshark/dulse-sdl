module kelp_sdl.core.sdl.sdl_subsystem;

import kelp_core.core;
import kelp_sdl.core.sdl;

class SDLSubsystem : Subsystem
{
	LibrarySDL sdl;
	LibrarySDLImage sdl_image;
	LibrarySDLTTF sdl_ttf;

	this()
	{
		sdl = new LibrarySDL();
		sdl_image = new LibrarySDLImage();
		sdl_ttf = new LibrarySDLTTF();
		return;
	}

	void initialize()
	{
		sdl.initialize();
		sdl_image.initialize();
		sdl_ttf.initialize();
		return;
	}

	void finalize()
	{
		sdl_ttf.finalize();
		sdl_image.finalize();
		sdl.finalize();
		return;
	}

	void process()
	{
		return;
	}
}
