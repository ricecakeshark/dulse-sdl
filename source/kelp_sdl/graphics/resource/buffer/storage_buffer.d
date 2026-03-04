module kelp_sdl.graphics.resource.buffer.storage_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer.buffer;

class GpuStorageBuffer : GpuBuffer
{
	size_t _capacity;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

public:
	@property size_t capacity() const pure nothrow @nogc @safe
	{
		return this._size;
	}

	typeof(this) create(in uint size)
	{
		this._capacity = size;
		this.create_by_size(SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE, size);
		return this;
	}
}
