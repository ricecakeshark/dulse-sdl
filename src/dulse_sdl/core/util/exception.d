module dulse_sdl.core.util.exception;

import sdl.error;
import std.stdio : writeln;
import std.string : fromStringz;

void catch_sdl_error(in bool succeed) @trusted
{
	if (succeed == false)
	{
		writeln(SDL_GetError().fromStringz());
	}
	return;
}

void write_sdl_error()
{
	SDL_GetError().fromStringz().writeln();
	return;
}