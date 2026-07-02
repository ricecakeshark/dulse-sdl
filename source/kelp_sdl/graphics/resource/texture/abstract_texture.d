module kelp_sdl.graphics.resource.texture.abstract_texture;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource;

abstract class GpuAbstractTexture : GpuResource!(GpuAbstractTexture)
{
	SDL_GPUTexture* texture_handle;
	uint _width, _height;
	protected GpuTextureFormat _format;

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

	@property inout(GpuTextureFormat) format() inout pure nothrow @nogc @safe
	in (this.texture_handle !is null)
	{
		return this._format;
	}

	@property inout(uint) size() inout pure nothrow @nogc @safe
	in (this.texture_handle !is null)
	{
		return cast(uint)(this.width * this.height * size_of_format(this._format));
	}

	@property bool is_valid() const pure nothrow @nogc @safe
	{
		if (this is null)
		{
			return false;
		}
		if (this.texture_handle is null)
		{
			return false;
		}
		if (this._format == GpuTextureFormat.invalid)
		{
			return false;
		}
		return true;
	}
}

uint size_of_format(in GpuTextureFormat format) pure nothrow @nogc @safe
{
	switch (format)
	{
	case GpuTextureFormat.invalid:
		assert(false, "texture format was invalid");
	case GpuTextureFormat.r8g8b8a8_unorm, GpuTextureFormat.r8g8b8a8_int, GpuTextureFormat.r8g8b8a8_uint:
		return 1 * 4;
	case GpuTextureFormat.r16g16b16a16_float:
		return 2 * 4;
	case GpuTextureFormat.r32g32b32a32_float:
		return 4 * 4;
	default:
		assert(false, "the texture format is not supported");
	}
}
