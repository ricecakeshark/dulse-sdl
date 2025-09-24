module kelp_sdl.graphics.core.gpu_window;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import std.exception, std.string;

class GPUWindow
{
	SDL_Window* window_handle;

	this()
	{
		return;
	}

	~this()
	{
		this.release();
		return;
	}

	@property inout(SDL_Window*) handle() inout pure nothrow @nogc @safe
	{
		return this.window_handle;
	}

	typeof(this) create(int width, int height, string title)
	in (this.handle is null)
	{
		this.window_handle = SDL_CreateWindow(toStringz(title), width, height, 0);
		enforce(this.window_handle !is null);
		return this;
	}

	typeof(this) release()
	in (this.handle !is null)
	{
		SDL_DestroyWindow(this.window_handle);
		this.window_handle = null;
		return this;
	}
}
