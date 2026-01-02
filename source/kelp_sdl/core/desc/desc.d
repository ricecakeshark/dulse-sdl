module kelp_sdl.core.desc.desc;

import bindbc.sdl;
import std.format;

struct SemVersion
{
	int major;
	int minor;
	int micro;

	this(int sdl_version)
	{
		this.major = SDL_VERSIONNUM_MAJOR(sdl_version);
		this.minor = SDL_VERSIONNUM_MINOR(sdl_version);
		this.micro = SDL_VERSIONNUM_MICRO(sdl_version);
		return;
	}

	string opCast(T : string)() const
	{
		return format!("[%2d,%2d,%2d]")(major, minor, micro);
	}
}
