module kelp_sdl.graphics.resource.buffer.draw_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer;
import std.exception : enforce;
import core.stdc.string : memcpy;

class GPUDrawBuffer : GPUBuffer
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

public:
	typeof(this) create(size_t size)
	{
		super.create_by_size(SDL_GPU_BUFFERUSAGE_INDIRECT, size);
		return this;
	}
}
