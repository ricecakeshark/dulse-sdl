module dulse_sdl.graphics.resource.buffer.storage_buffer;

import sdl.gpu;
import dulse_sdl.graphics.core;
import dulse_sdl.graphics.resource.buffer.buffer_abstract;
import dulse_sdl.graphics.desc;

class GpuStorageBuffer : GpuBuffer
{
	private size_t _capacity;

	this(GpuDevice device) pure nothrow @nogc @safe
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
