module kelp_sdl.graphics.resource.texture.abstract_texture;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource;

abstract class GpuAbstractTexture : GpuResource , IGpuResource
{
	SDL_GPUTexture* texture_handle;
	uint _width, _height;
	protected GpuTextureFormat format;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

	@property inout(SDL_GPUTexture*) handle() inout pure nothrow @nogc @safe
	{
		return this.texture_handle;
	}

	@property inout(uint) width() inout pure nothrow @nogc @safe
	in (this.texture_handle !is null)
	{
		return this._width;
	}

	@property inout(uint) height() inout pure nothrow @nogc @safe
	in (this.texture_handle !is null)
	{
		return this._height;
	}

	@property inout(uint) size() inout pure nothrow @nogc @safe
	in (this.texture_handle !is null)
	{
		return cast(uint)(this.width * this.height * size_of_format(this.format));
	}
}

uint size_of_format(GpuTextureFormat format) pure nothrow @nogc @safe
{
	switch(format)
	{
		case GpuTextureFormat.r8g8b8a8_unorm:
			return 32u;
		case GpuTextureFormat.r32g32b32a32_float:
			return 32u*4;
		default:
			assert(false,"the texture format is not supported");
	}	
}
