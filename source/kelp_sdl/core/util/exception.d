module kelp_sdl.core.util.exception;

import bindbc.sdl;
import std.stdio : writeln;
import std.string : fromStringz;

void catchSDLError(in bool succeed) @trusted
{
	if (succeed == false)
	{
		writeln(SDL_GetError().fromStringz());
	}
	return;
}
