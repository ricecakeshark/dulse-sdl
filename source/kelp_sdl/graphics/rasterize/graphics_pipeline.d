module kelp_sdl.graphics.rasterize.graphics_pipeline;

import bindbc.sdl;
import kelp_sdl.graphics;
import std.exception, std.string;

class GPUGraphicsPipeline
{
	SDL_GPUGraphicsPipeline* pipeline_handle;
	protected GPUDevice device;

	this(GPUDevice device)
	{
		this.device = device;
		return;
	}

	@property inout(SDL_GPUGraphicsPipeline*) handle() inout pure nothrow @nogc @safe
	{
		return this.pipeline_handle;
	}

	typeof(this) create(GPUGraphicsPipelineCreateInfo create_info)
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
