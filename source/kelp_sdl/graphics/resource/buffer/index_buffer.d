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
	typeof(this) create(ushort[] data)
	{
		super.createByData(SDL_GPU_BUFFERUSAGE_INDEX, data);
		return this;
	}

	typeof(this) create(size_t size)
	{
		super.createBySize(SDL_GPU_BUFFERUSAGE_INDEX, size);
		return this;
	}

	typeof(this) set(ushort[] data)
	{
		super.setData(data);
		return this;
	}
}
