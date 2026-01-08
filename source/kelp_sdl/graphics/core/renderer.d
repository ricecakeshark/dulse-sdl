module kelp_sdl.graphics.core.renderer;

import kelp_sdl.graphics.core;

import bindbc.sdl;

class Renderer
{
	SDL_Renderer* renderer_handle;

	this(SDL_Renderer* renderer_handle)
	{
		this.renderer_handle = renderer_handle;
		return;
	}

	this(GPUDevice device, GPUWindow window)
	{
		this.renderer_handle = SDL_CreateGPURenderer(device.handle, window.handle);
		return;
	}

	@property inout(SDL_Renderer*) handle() inout pure nothrow @nogc @safe
	{
		return this.renderer_handle;
	}
}
