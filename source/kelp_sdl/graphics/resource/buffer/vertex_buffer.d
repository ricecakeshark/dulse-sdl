module kelp_sdl.graphics.resource.buffer.vertex_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer;

class GpuVertexBuffer : GpuBuffer
{
	size_t _count, _stride;

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

	typeof(this) create(in size_t count, in size_t stride)
	{
		this._count = count;
		this._stride = stride;
		super.create_by_size(SDL_GPU_BUFFERUSAGE_VERTEX, (count * stride));
		return this;
	}
}
