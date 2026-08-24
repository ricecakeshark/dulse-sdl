module kelp_sdl.graphics.core.gpu_window;

import sdl.gpu;
import sdl.properties;
import sdl.video;
//import sdl.window;
import kelp_core.core;
import kelp_sdl.graphics.core;
import std.exception : enforce;
import std.string : toStringz;

class GpuWindow
{
	private SDL_Window* window_handle;

	invariant
	{
		assert(this !is null);
	}

	@property bool is_valid() pure nothrow @nogc @safe
	{
		return (this.window_handle !is null);
	}

	@property inout(SDL_Window*) handle() inout pure nothrow @nogc @safe
	{
		return this.window_handle;
	}

	typeof(this) create(in int width, in int height, in string title)
	in (this.handle is null)
	{
		this.window_handle = SDL_CreateWindow(
			toStringz(title), width, height, 0
		);
		enforce(this.window_handle !is null);
		return this;
	}

	typeof(this) release() @trusted
	{
		if (this.window_handle is null)
		{
			return this;
		}
		SDL_DestroyWindow(this.window_handle);
		this.window_handle = null;
		return this;
	}
}
