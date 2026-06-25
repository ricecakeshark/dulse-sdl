module kelp_sdl.graphics.resource.buffer.storage_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer.buffer_abstract;
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
		return this._capacity;
	}

	typeof(this) create(in size_t count, in size_t stride)
	in (this !is null)
	{
		this._capacity = count * stride;
		super.create(GpuBufferUsageFlags.graphics_storage_read, count, stride);
		return this;
	}

	typeof(this) create(in size_t size)
	in (this !is null)
	{
		this._capacity = size;
		super.create(GpuBufferUsageFlags.graphics_storage_read, size, 1u);
		return this;
	}
}
