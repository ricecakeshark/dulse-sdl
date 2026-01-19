module kelp_sdl.graphics.resource.buffer.index_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer;

class GpuIndexBuffer : GpuBuffer
{
	GpuIndexElementSize element_size;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

public:
	typeof(this) create(in size_t size)
	{
		super.create_by_size(SDL_GPU_BUFFERUSAGE_INDEX, size);
		return this;
	}

	typeof(this) create(
		in size_t size,
		in GpuIndexElementSize element_size = GpuIndexElementSize._32bit
	)
	{
		this.element_size = element_size;
		super.create_by_size(SDL_GPU_BUFFERUSAGE_INDEX, size);
		return this;
	}
}
