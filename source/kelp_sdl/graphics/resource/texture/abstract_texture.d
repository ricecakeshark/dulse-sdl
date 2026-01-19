module kelp_sdl.graphics.resource.texture.abstract_texture;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.texture;

abstract class GpuAbstractTexture
{
	SDL_GPUTexture* texture_handle;
	GpuDevice device;
	uint _width, _height;

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
		return cast(uint)(this.width * this.height * 4);
	}
}
