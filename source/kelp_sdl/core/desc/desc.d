module kelp_sdl.core.desc.desc;

import bindbc.sdl;
import kelp_core.core.data;

Ver3 from_sdl_version(in int sdl_version) pure nothrow @nogc @safe
{
	return Ver3(
		SDL_VERSIONNUM_MAJOR(sdl_version),
		SDL_VERSIONNUM_MINOR(sdl_version),
		SDL_VERSIONNUM_MICRO(sdl_version),
	);
}
