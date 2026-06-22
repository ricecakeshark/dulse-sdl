module kelp_sdl.graphics.resource.buffer.transfer_buffer;

import bindbc.sdl;
import kelp_core.graphics.resource;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource;
import kelp_sdl.image;

import std.exception : enforce;
import std.algorithm : map, sum;
import std.traits : isArray;
import core.stdc.string : memcpy;

class GpuTransferBuffer(Derived) : GpuResource, IGpuResource
{
	SDL_GPUTransferBuffer* buffer_handle;
	uint _size;
	void* transfer_ptr;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

	~this()
	{
		this.release();
		return;
	}

	@property inout(SDL_GPUTransferBuffer*) handle() inout pure nothrow @nogc @safe
	{
		return this.buffer_handle;
	}

	@property inout(uint) size() inout pure nothrow @nogc @safe
	{
		return this._size;
	}

	Derived create_by_info(const ref GpuTransferBufferCreateInfo create_info)
	{
		this._size = create_info.size;
		this.buffer_handle = SDL_CreateGPUTransferBuffer(
			this.device.handle, cast(SDL_GPUTransferBufferCreateInfo*)&create_info
		);
		enforce(this.buffer_handle !is null);
		return cast(Derived) this;
	}

	Derived create_by_size(in uint size)
	{
		this._size = size;
		SDL_GPUTransferBufferCreateInfo create_info = {
			usage: SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
			size: size,
		};
		this.buffer_handle = SDL_CreateGPUTransferBuffer(this.device.handle, &create_info);
		enforce(this.buffer_handle !is null);
		return cast(Derived) this;
	}

	Derived release()
	{
		if (this.buffer_handle is null || this.device.handle is null)
		{
			return cast(Derived) this;
		}
		SDL_ReleaseGPUTransferBuffer(this.device.handle, this.handle);
		this.buffer_handle = null;
		return cast(Derived) this;
	}

	Derived map(in bool cycle = false)
	in (this.handle !is null)
	in (this.device.handle !is null)
	{
		this.transfer_ptr = cast(void*) SDL_MapGPUTransferBuffer(
			this.device.handle, this.handle, cycle,
		);
		enforce(this.transfer_ptr !is null);
		return cast(Derived) this;
	}

	Derived unmap()
	in (this.handle !is null)
	in (this.device.handle !is null)
	{
		SDL_UnmapGPUTransferBuffer(this.device.handle, this.handle,);
		this.transfer_ptr = null;
		return cast(Derived) this;
	}

	Derived set_data(Type)(
		Type[] set_data,
		in size_t write_offset = 0,
	)
	in (this.transfer_ptr !is null)
	in (Type.sizeof * set_data.length <= uint.max)
	in (write_offset + (Type.sizeof * set_data.length) <= this.size)
	{
		memcpy(
			transfer_ptr + write_offset,
			cast(void*) set_data,
			Type.sizeof * set_data.length
		);
		return cast(Derived) this;
	}

	Derived set_data(Type)(
		Type[] set_data,
		in size_t write_offset,
		in ulong set_size,
	)
	in (this.transfer_ptr !is null)
	in (Type.sizeof * set_data.length <= uint.max)
	in (set_size <= uint.max)
	in (set_size <= this.size)
	{
		memcpy(
			transfer_ptr + write_offset,
			cast(void*) set_data,
			set_size
		);
		return cast(Derived) this;
	}
}

class GpuBufferTransferBuffer : GpuTransferBuffer!(GpuBufferTransferBuffer)
{
	this(GpuDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(G : GfxGeometry!(V, I), V, I)(G geometry, bool cycle = false)
	{
		this.create_by_size(cast(uint)geometry.size)
			.map(cycle)
			.set(geometry.vertices, geometry.offset_vertex)
			.set(geometry.indices, geometry.offset_index)
			.unmap();
		return this;
	}

	typeof(this) create(in GpuTransferBufferCreateInfo create_info)
	{
		super.create_by_info(create_info);
		return this;
	}

	typeof(this) create(in size_t size)
	in (size <= uint.max)
	{
		this.create_by_size(cast(uint) size);
		return this;
	}

	typeof(this) set(Type)(Type[] data, in size_t write_offset)
	in (this !is null)
	in (this.buffer_handle !is null)
	in (write_offset + (Type.sizeof * data.length) <= this.size)
	{
		super.set_data(data, write_offset);
		return this;
	}

	typeof(this) set(Type)(Type[] data, in size_t write_offset, in size_t write_size)
	in (this !is null)
	in (this.buffer_handle !is null)
	in (write_offset + (Type.sizeof * data.length) <= this.size)
	{
		super.set_data(data, write_offset, write_size);
		return this;
	}

	/+typeof(this) set(TypeList...)(TypeList data_list)
	if (TypeList.length >= 2)
	in
	{
		assert(this.size >= 1);
		scope size_t temp_size;
		foreach (data; data_list)
		{
			temp_size += data[0].sizeof * data.length;
		}
		assert(temp_size <= this.size);
	}
	do
	{
		size_t temp_offset = 0;
		foreach (data; data_list)
		{
			super.set_data(data, temp_offset, data[0].sizeof * data.length);
			temp_offset += (data[0].sizeof * data.length);
		}
		return this;
	}+/
}

class GpuTextureTransferBuffer : GpuTransferBuffer!(GpuTextureTransferBuffer)
{
	this(GpuDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(const ref GpuTransferBufferCreateInfo create_info)
	{
		super.create_by_info(create_info);
		return this;
	}

	typeof(this) create(in size_t size)
	in (size <= uint.max)
	{
		super.create_by_size(cast(uint) size);
		return this;
	}

	typeof(this) set(const ref Surface surface)
	in (this !is null)
	in (this.buffer_handle !is null)
	{
		memcpy(
			this.transfer_ptr,
			surface.handle.pixels,
			surface.size,
		);
		return this;
	}
}
