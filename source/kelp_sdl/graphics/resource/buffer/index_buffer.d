module kelp_sdl.graphics.resource.buffer.index_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer;

class GPUIndexBuffer : GPUBuffer
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

public:
	typeof(this) create(void[] data)
	{
		super.create_by_size(SDL_GPU_BUFFERUSAGE_INDEX, data[0].sizeof * data.length);
		return this;
	}

	typeof(this) create(size_t size)
	{
		super.create_by_size(SDL_GPU_BUFFERUSAGE_INDEX, size);
		return this;
	}
}
