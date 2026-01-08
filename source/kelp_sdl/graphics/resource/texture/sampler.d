module kelp_sdl.graphics.resource.texture.sampler;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;

import std.exception : enforce;

class GPUSampler
{
	SDL_GPUSampler* sampler_handle;
	GPUDevice device;

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

	@property inout(SDL_GPUSampler*) handle() inout pure nothrow @nogc @safe
	{
		return this.sampler_handle;
	}

	typeof(this) create(in GPUSamplerCreateInfo create_info)
	in (this.device !is null)
	{
		this.sampler_handle = SDL_CreateGPUSampler(
			this.device.handle,
			cast(SDL_GPUSamplerCreateInfo*)&create_info
		);
		enforce(this.sampler_handle !is null);
		return this;
	}

	typeof(this) release()
	{
		if (
			(this.device is null || this is null) ||
			(this.device.handle is null || this.sampler_handle is null)
			)
		{
			return this;
		}
		SDL_ReleaseGPUSampler(this.device.handle, this.sampler_handle);
		this.sampler_handle = null;
		return this;
	}

}
