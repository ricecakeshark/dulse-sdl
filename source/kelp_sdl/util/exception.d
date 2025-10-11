module kelp_sdl.util.exception;

import bindbc.sdl;
import std.stdio;
import std.string : fromStringz;

void catchSDLError(const bool succeed) @trusted
{
	if (succeed == false)
	{
		writeln(SDL_GetError().fromStringz());
	}
	return;
}
