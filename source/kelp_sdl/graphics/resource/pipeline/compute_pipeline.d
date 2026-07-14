module kelp_sdl.graphics.resource.pipeline.compute_pipeline;

import bindbc.sdl;
import kelp_core.math;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource;
import std.exception : enforce;

class GpuComputePipeline : GpuResource!(GpuComputePipeline)
{
	protected SDL_GPUComputePipeline* pipeline_handle;

	int[3] local_size;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

	~this()
	{
		return;
	}

	int[3] dispatch_size(int[3] screen_size...) const pure nothrow @nogc @safe
	{
		return [
			devide_ceil(screen_size[0], local_size[0]),
			devide_ceil(screen_size[1], local_size[1]),
			devide_ceil(screen_size[2], local_size[2]),
		];
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
		local_size[0] = create_info.threadcount_x;
		local_size[1] = create_info.threadcount_y;
		local_size[2] = create_info.threadcount_z;
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

protected:
int devide_ceil(int x, int y) pure nothrow @nogc @safe
in (y != 0)
{
	return x / y + (x % y != 0 ? 1 : 0);
}
