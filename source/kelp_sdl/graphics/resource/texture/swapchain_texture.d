module kelp_sdl.graphics.resource.texture.swapchain_texture;

import sdl.gpu;
import kelp_sdl.graphics.command;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.texture;
import std.exception : enforce;

final class GpuSwapchainTexture : GpuAbstractTexture
{
	GpuWindow window;

	this(GpuDevice device, GpuWindow window)
	{
		super(device);
		this.window = window;
		return;
	}

	typeof(this) acquire(GpuCommandBuffer command_buffer)
	{
		bool succeed;
		succeed = SDL_WaitAndAcquireGPUSwapchainTexture(
			command_buffer.handle,
			this.window.handle,
			&(this.texture_handle),
			&(this._width),
			&(this._height),
		);
		enforce(succeed, "failed to acquire swapchain texture");
		this._format = this.get_format();
		return this;
	}

	typeof(this) set(
		in GpuSwapchainComposition composition,
		in GpuPresentMode present_mode = GpuPresentMode.immediate,
	)
	in (this.device.is_valid)
	in (this.window.is_valid)
	{
		bool succeed = SDL_SetGPUSwapchainParameters(
			this.device.handle,
			this.window.handle,
			cast(SDL_GPUSwapchainComposition) composition,
			cast(SDL_GPUPresentMode) present_mode,
		);
		enforce(succeed);
		return this;
	}

	GpuTextureFormat get_format()
	in (this.device.is_valid)
	in (this.window.is_valid)
	{
		return cast(GpuTextureFormat) SDL_GetGPUSwapchainTextureFormat(
			this.device.handle, this.window.handle
		);
	}

	bool get_composition(in GpuSwapchainComposition composition)
	in (this.device.is_valid)
	in (this.window.is_valid)
	{
		return SDL_WindowSupportsGPUSwapchainComposition(
			this.device.handle,
			this.window.handle,
			cast(SDL_GPUSwapchainComposition) composition,
		);
	}
}
