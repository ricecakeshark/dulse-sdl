module kelp_sdl.graphics.sync.fence;

import bindbc.sdl;
import kelp_sdl.core;
import kelp_sdl.graphics.core.gpu_device;

class GpuFence
{
	SDL_GPUFence* fence_handle;
	GpuDevice device;

	this(GpuDevice device)
	{
		this.device = device;
		return;
	}

	~this()
	{
		this.release();
		return;
	}

	typeof(this) wrap(SDL_GPUFence* fence_handle)
	in (this.device !is null)
	{
		this.fence_handle = fence_handle;
		return this;
	}

	typeof(this) release()
	{
		if (this.device.handle !is null && this.fence_handle !is null)
		{
			SDL_ReleaseGPUFence(this.device.handle, this.fence_handle);
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
