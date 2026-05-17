module kelp_sdl.graphics.resource.texture.swapchain_texture;

import bindbc.sdl;
import kelp_sdl.graphics.command;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.texture;

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
}
