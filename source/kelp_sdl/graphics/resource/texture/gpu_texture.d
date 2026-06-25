module kelp_sdl.graphics.resource.texture.gpu_texture;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.texture;
import std.exception : enforce;
import std.file : isFile;
import std.string : toStringz;

final class GpuTexture : GpuAbstractTexture
{
	this(GpuDevice device)
	{
		super(device);
		return;
	}

	~this()
	{
		return;
	}

	typeof(this) create(in GpuTextureCreateInfo create_info)
	in
	{
		assert(create_info.width >= 1);
		assert(create_info.height >= 1);
		assert(create_info.format != GpuTextureFormat.invalid);
	}
	do
	{
		this.texture_handle = SDL_CreateGPUTexture(
			this.device.handle, cast(SDL_GPUTextureCreateInfo*)&create_info
		);
		enforce(this.texture_handle !is null);
		this._width = create_info.width;
		this._height = create_info.height;
		this._format = create_info.format;
		return this;
	}

	typeof(this) release()
	{
		if (this.texture_handle is null || this.device.handle is null)
		{
			return this;
		}
		SDL_ReleaseGPUTexture(this.device.handle, this.handle);
		this.texture_handle = null;
		return this;
	}
}

class GpuRefTexture : GpuAbstractTexture
{
	this(GpuDevice device)
	{
		super(device);
		return;
	}

	~this()
	{
		return;
	}

	typeof(this) refer(SDL_GPUTexture* texture_ref)
	{
		this.texture_handle = texture_ref;
		return this;
	}

	typeof(this) unrefer()
	{
		this.texture_handle = null;
		return this;
	}
}
