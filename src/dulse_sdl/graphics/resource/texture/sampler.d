module dulse_sdl.graphics.resource.texture.sampler;

import sdl.gpu;
import dulse_sdl.graphics.core;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource;

import std.exception : enforce;

class GpuSampler : GpuResource!(GpuSampler)
{
	SDL_GPUSampler* sampler_handle;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

	~this()
	{
		return;
	}

	@property inout(SDL_GPUSampler*) handle() inout pure nothrow @nogc @safe
	{
		return this.sampler_handle;
	}

	typeof(this) create(in GpuSamplerCreateInfo create_info)
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
