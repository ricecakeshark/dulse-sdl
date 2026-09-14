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

void expect_sdl(in bool succeed, string message = null) @trusted
{
	if (succeed == false)
	{
		if (message !is null)
		{
			writeln(message);
		}
		writeln(SDL_GetError().fromStringz());
	}
	return;
}

void write_sdl_error()
{
	SDL_GetError().fromStringz().writeln();
	return;
}
