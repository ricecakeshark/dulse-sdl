module kelp_sdl.graphics.compute.compute_pipeline;

import bindbc.sdl;
import kelp_sdl.graphics.core;

class GPUComputePipeline
{
	protected SDL_GPUComputePipeline* pipeline_handle;
	protected GPUDevice device;

	this(GPUDevice device)
	{
		this.device = device;
		return;
	}

	~this()
	{
		this.release();
		return;
	}

	@property inout(SDL_GPUComputePipeline*) handle() inout pure nothrow @nogc @safe
	{
		return this.pipeline_handle;
	}

	typeof(this) create()
	{
		return this;
	}

	typeof(this) release()
	{
		if (this.pipeline_handle is null || this.device.handle is null)
		{
			return this;
		}
		SDL_ReleaseGPUComputePipeline(this.device.handle, this.pipeline_handle);
		this.pipeline_handle = null;
		return this;
	}
}
