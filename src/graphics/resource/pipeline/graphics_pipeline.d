module dulse_sdl.graphics.resource.pipeline.graphics_pipeline;

import sdl.error;
import sdl.gpu;
import dulse_sdl.graphics;
import std.exception : enforce;
import std.string : fromStringz;

class GpuGraphicsPipeline : GpuResource!(GpuGraphicsPipeline)
{
	protected SDL_GPUGraphicsPipeline* pipeline_handle;

	this(GpuDevice device) pure nothrow @nogc @safe
	{
		super(device);
		return;
	}

	@property inout(SDL_GPUGraphicsPipeline*) handle() inout pure nothrow @nogc @safe
	{
		return this.pipeline_handle;
	}

	typeof(this) create(in GpuGraphicsPipelineCreateInfo create_info)
	{
		this.pipeline_handle = SDL_CreateGPUGraphicsPipeline(
			this.device.handle,
			cast(SDL_GPUGraphicsPipelineCreateInfo*)&create_info,
		);
		enforce(this.pipeline_handle !is null, SDL_GetError().fromStringz());
		return this;
	}

	typeof(this) release()
	{
		if (this.pipeline_handle is null || this.device.handle is null)
		{
			return this;
		}
		SDL_ReleaseGPUGraphicsPipeline(this.device.handle, this.pipeline_handle);
		this.pipeline_handle = null;
		return this;
	}
}
