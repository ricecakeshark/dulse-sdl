module kelp_sdl.graphics.resource.buffer.storage_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer.buffer;

class GPUStorageBuffer : GPUBuffer
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(uint size)
	{
		this.createBySize(SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE, size);
		return this;
	}

	typeof(this) set(double[] data)
	{
		this.setData(data);
		return this;
	}
}
