module kelp_sdl.graphics.resource.buffer.vertex_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer;

class GPUVertexBuffer : GPUBuffer
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

public:
	typeof(this) create(void[] data)
	{
		super.createByData(SDL_GPU_BUFFERUSAGE_VERTEX, data);
		return this;
	}
}
