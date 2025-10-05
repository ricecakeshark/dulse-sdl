module kelp_sdl.graphics.resource.texture.swapchain_texture;

import bindbc.sdl;
import kelp_sdl.graphics.command;
import kelp_sdl.graphics.core;

final class GPUSwapchainTexture
{
	SDL_GPUTexture* texture_handle;
	GPUDevice device;
	GPUWindow window;
	uint width, height;

	this(GPUDevice device, GPUWindow window)
	{
		this.device = device;
		this.window = window;
		return;
	}

	@property inout(SDL_GPUTexture*) handle() inout pure nothrow @nogc @safe
	{
		return this.texture_handle;
	}

	uint sizeInBytes() const pure nothrow @nogc @safe
	{
		return cast(uint)(this.width * this.height * 4);
	}

	typeof(this) acquire(GPUCommandBuffer command_buffer)
	{
		bool succeed;
		succeed = SDL_WaitAndAcquireGPUSwapchainTexture(
			command_buffer.handle,
			this.window.handle,
			&(this.texture_handle),
			&width,
			&height,
		);
		return this;
	}
}

SDL_GPUTextureFormat getSwapchainTextureFormat(GPUDevice device, GPUWindow window)
in (device.handle !is null)
in (window.handle !is null)
{
	return SDL_GetGPUSwapchainTextureFormat(device.handle, window.handle);
}
