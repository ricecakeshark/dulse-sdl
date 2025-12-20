module kelp_sdl.graphics.resource.texture.gpu_texture;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.texture;
import std.exception : enforce;
import std.file : isFile;
import std.string : toStringz;

final class GPUTexture : GPUAbstractTexture
{
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

	typeof(this) create(GPUTextureCreateInfo create_info)
	in (create_info.width >= 1)
	in (create_info.height >= 1)
	{
		this.texture_handle = SDL_CreateGPUTexture(
			this.device.handle, cast(SDL_GPUTextureCreateInfo*)&create_info
		);
		enforce(this.texture_handle !is null);
		this._width = create_info.width;
		this._height = create_info.height;
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
