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
