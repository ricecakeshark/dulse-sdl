module kelp_sdl.graphics.compute.compute_pipeline;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import std.exception;

class GpuComputePipeline
{
	protected SDL_GPUComputePipeline* pipeline_handle;
	protected GpuDevice device;

	this(GpuDevice device)
	{
		this.device = device;
		return;
	}

	~this()
	{
		return;
	}

	@property inout(SDL_GPUComputePipeline*) handle() inout pure nothrow @nogc @safe
	{
		return this.pipeline_handle;
	}

	typeof(this) create(in GpuComputePipelineCreateInfo create_info)
	{
		this.pipeline_handle = SDL_CreateGPUComputePipeline(
			this.device.handle,
			cast(SDL_GPUComputePipelineCreateInfo*)&create_info,
		);
		enforce(this.pipeline_handle !is null);
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
