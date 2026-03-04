module kelp_sdl.graphics.resource.buffer.index_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer;

class GpuIndexBuffer : GpuBuffer
{
	size_t _count, _stride;
	GpuIndexElementSize element_size;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

public:
	@property size_t capacity() const pure nothrow @nogc @safe
	in (this._count != 0)
	in (this._stride != 0)
	{
		return this._count * this._stride;
	}

	@property size_t count() const pure nothrow @nogc @safe
	in (this._count != 0)
	{
		return this._count;
	}

	@property size_t stride() const pure nothrow @nogc @safe
	in (this._stride != 0)
	{
		return this._stride;
	}

	typeof(this) create(
		in size_t count,
		in GpuIndexElementSize element_size = GpuIndexElementSize._32bit
	)
	{
		this.element_size = element_size;
		final switch (element_size)
		{
		case GpuIndexElementSize._16bit:
			this._stride = 2;
			break;
		case GpuIndexElementSize._32bit:
			this._stride = 4;
			break;
		}
		super.create_by_size(SDL_GPU_BUFFERUSAGE_INDEX, (count * this._stride));
		return this;
	}
}
