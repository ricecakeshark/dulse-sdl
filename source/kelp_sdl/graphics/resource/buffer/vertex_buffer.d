module kelp_sdl.graphics.resource.buffer.vertex_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer;

class GpuVertexBuffer : GpuBuffer
{
	this(GpuDevice device)
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
