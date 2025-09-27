module kelp_sdl.graphics.graphics;

/+
version (Windows)
{
	import core.sys.windows.dll;

	mixin SimpleDllMain;
}
+/

import kelp_api;

//import kelp_core;
import bindbc.sdl;

//export extern(C):

class SDLGraphicsSubsystem : Subsystem
{

	this()
	{
		return;
	}

	void initialize()
	{
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		return;
	}

}

