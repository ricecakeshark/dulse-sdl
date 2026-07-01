module kelp_sdl.graphics.resource.fence;

import bindbc.sdl;
import kelp_sdl.core;
import kelp_sdl.graphics.core.gpu_device;
import kelp_sdl.graphics.resource.gpu_resource;

class GpuFence : GpuResource
{
	SDL_GPUFence* fence_handle;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

	~this()
	{
		return;
	}

	@property SDL_GPUFence* handle()
	{
		return this.fence_handle;
	}

	typeof(this) wrap(SDL_GPUFence* fence_handle)
	in (this.device !is null)
	{
		this.fence_handle = fence_handle;
		return this;
	}

	typeof(this) release()
	{
		if (this.device.handle is null)
		{
			return this;
		}
		if (this.device.handle !is null)
		{
			SDL_ReleaseGPUFence(this.device.handle, this.fence_handle);
			this.fence_handle = null;
		}
		return this;
	}

	bool query()
	{
		return SDL_QueryGPUFence(this.device.handle, this.fence_handle);
	}

	typeof(this) wait()
	{
		SDL_WaitForGPUFences(
			this.device.handle,
			true,
			[this.fence_handle].ptr,
			1u,
		).catchSDLError();
		return this;
	}
}
