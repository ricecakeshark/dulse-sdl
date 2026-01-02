module kelp_sdl.core.sdl.sdl_subsystem;

import kelp_core.core;
import kelp_core.logger;
import kelp_sdl.core;

class SDLSubsystem : Subsystem
{
	protected Core core;
	protected LibrarySDL sdl;
	protected LibrarySDLImage sdl_image;
	protected LibrarySDLTTF sdl_ttf;
	protected LoggerSubsystem logger;
	public bool initialized = false;

	this(Core core)
	{
		this.core = core;
		sdl = new LibrarySDL();
		sdl_image = new LibrarySDLImage();
		sdl_ttf = new LibrarySDLTTF();
		return;
	}

	void initialize()
	{
		if (initialized == true)
		{
			return;
		}
		initialized = true;
		this.logger = this.core.subsystem.query!(LoggerSubsystem);
		sdl.initialize();
		sdl_image.initialize();
		sdl_ttf.initialize();
		logger.log(cast(string)(sdl.compiled_version));
		logger.log(cast(string)(sdl.linked_version));
		logger.log(cast(string)(sdl_image.compiled_version));
		logger.log(cast(string)(sdl_image.linked_version));
		logger.log(cast(string)(sdl_ttf.compiled_version));
		logger.log(cast(string)(sdl_ttf.linked_version));
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
