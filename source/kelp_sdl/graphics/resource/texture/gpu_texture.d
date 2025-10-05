module kelp_sdl.graphics.resource.texture.gpu_texture;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import std.exception : enforce;
import std.file : isFile;
import std.string : toStringz;

final class GPUTexture
{
	SDL_GPUTexture* texture_handle;
	GPUDevice device;
	uint width, height;
	SDL_Surface* surface_handle;

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

	@property inout(SDL_GPUTexture*) handle() inout pure nothrow @nogc @safe
	{
		return this.texture_handle;
	}

	@property inout(uint) sizeInbytes() inout pure nothrow @nogc @safe
	in (this.handle !is null)
	{
		return (this.width * this.height * 4);
	}

	typeof(this) create(string uri)
	{
		SDL_Surface* temp_surface, temp_surface2;
		GPUTextureCreateInfo create_info;
		enforce(isFile(uri), "image file is not found.");
		temp_surface = IMG_Load(toStringz(uri));
		enforce(temp_surface !is null, "failed to create surface.");
		if (temp_surface.format != SDL_PIXELFORMAT_ABGR8888)
		{
			temp_surface2 = SDL_ConvertSurface(
				temp_surface, SDL_PIXELFORMAT_ABGR8888
			);
			SDL_DestroySurface(temp_surface);
			temp_surface = temp_surface2;
			SDL_DestroySurface(temp_surface2);
		}
		this.surface_handle = temp_surface;
		this.width = temp_surface.w;
		this.height = temp_surface.h;
		with (create_info)
		{
			type = SDL_GPU_TEXTURETYPE_2D;
			format = SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM;
			width = temp_surface.w;
			height = temp_surface.h;
			layer_count_or_depth = 1;
			num_levels = 1;
			usage = SDL_GPU_TEXTUREUSAGE_SAMPLER;
		}
		this.texture_handle = SDL_CreateGPUTexture(
			this.device.handle,
			cast(SDL_GPUTextureCreateInfo*)&create_info,
		);
		enforce(this.texture_handle !is null, "failed to create GPUTexture.");
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
