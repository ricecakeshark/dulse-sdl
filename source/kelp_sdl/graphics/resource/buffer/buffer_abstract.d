module kelp_sdl.graphics.resource.buffer.buffer_abstract;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource;
import std.exception : enforce;

abstract class GpuBuffer : GpuResource, IGpuResource, IGpuResourceUpload
{
	SDL_GPUBuffer* buffer_handle;
	protected size_t _count, _stride;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

	~this()
	{
		return;
	}

public:
	@property inout(SDL_GPUBuffer*) handle() inout pure nothrow @nogc @safe
	{
		return this.buffer_handle;
	}

	@property inout(size_t) count() inout pure nothrow @nogc @safe
	{
		return this._count;
	}

	@property inout(size_t) stride() inout pure nothrow @nogc @safe
	in (this._stride != 0)
	{
		return this._stride;
	}

	@property inout(size_t) size_byte() inout pure nothrow @nogc @safe
	{
		return this._count * this._stride;
	}

	typeof(this) release()
	{
		if (this.buffer_handle is null || this.device.handle is null)
		{
			return this;
		}
		SDL_ReleaseGPUBuffer(this.device.handle, this.handle);
		this.buffer_handle = null;
		return this;
	}

protected:
	deprecated typeof(this) create_by_info(
		in GpuBufferCreateInfo create_info,
	)
	in (this.device.handle !is null)
	{
		this.buffer_handle = SDL_CreateGPUBuffer(
			this.device.handle, cast(SDL_GPUBufferCreateInfo*)&create_info
		);
		enforce(this.buffer_handle !is null);
		//this._size = create_info.size;
		return this;
	}

	deprecated typeof(this) create_by_size(
		in GpuBufferUsageFlags usage_flags,
		in size_t size,
	)
	in (this.device.handle !is null)
	in (size <= uint.max)
	{
		scope SDL_GPUBufferCreateInfo buffer_create_info;
		//this._size = size;
		buffer_create_info = SDL_GPUBufferCreateInfo(
			cast(SDL_GPUBufferUsageFlags) usage_flags, cast(uint) size,
		);
		this.buffer_handle = SDL_CreateGPUBuffer(
			this.device.handle, &buffer_create_info
		);
		enforce(this.buffer_handle !is null);
		return this;
	}

	typeof(this) create(
		in GpuBufferUsageFlags usage_flags,
		in size_t count,
		in size_t stride,
	)
	{
		scope GpuBufferCreateInfo buffer_create_info;
		this._count = count;
		this._stride = stride;
		buffer_create_info = GpuBufferCreateInfo(
			usage_flags, cast(uint)(count * stride),
		);
		this.buffer_handle = SDL_CreateGPUBuffer(
			this.device.handle,
			cast(SDL_GPUBufferCreateInfo*)&buffer_create_info
		);
		enforce(this.buffer_handle !is null);
		return this;
	}
}
