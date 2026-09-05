module dulse_sdl.graphics.resource.buffer.index_buffer;

import sdl.gpu;
import dulse_sdl.graphics.core;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource.buffer;

class GpuIndexBuffer : GpuBuffer
{
	private GpuIndexElementSize _element_size;

	this(GpuDevice device) pure nothrow @nogc @safe
	{
		super(device);
		return;
	}

	@property GpuIndexElementSize element_size() pure nothrow @nogc @safe
	{
		return this._element_size;
	}

public:
	typeof(this) create(
		in size_t count,
		in GpuIndexElementSize element_size = GpuIndexElementSize._32bit
	)
	{
		this._element_size = element_size;
		final switch (element_size)
		{
		case GpuIndexElementSize._16bit:
			this._stride = 2;
			break;
		case GpuIndexElementSize._32bit:
			this._stride = 4;
			break;
		}
		super.create(GpuBufferUsageFlags.index, cast(uint) count, cast(uint) this._stride);
		return this;
	}
}
