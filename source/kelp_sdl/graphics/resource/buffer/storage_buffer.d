module kelp_sdl.graphics.resource.buffer.storage_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer.buffer;
import kelp_sdl.graphics.desc;

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
	in (this !is null)
	{
		this._capacity = size;
		this.create_by_size(GpuBufferUsageFlags.graphics_storage_read, size);
		return this;
	}
}
