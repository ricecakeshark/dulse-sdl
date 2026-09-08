module dulse_sdl.graphics.resource.buffer.vertex_buffer;

import sdl.gpu;
import dulse_sdl.graphics.core;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource.buffer;

class GpuVertexBuffer : GpuBuffer
{
	this(GpuDevice device) pure nothrow @nogc @safe
	{
		super(device);
		return;
	}

public:
	typeof(this) create(in size_t count, in size_t stride)
	{
		this._count = count;
		this._stride = stride;
		super.create(GpuBufferUsageFlags.vertex, cast(uint) count, cast(uint) stride);
		return this;
	}
}
