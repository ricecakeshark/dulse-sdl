module kelp_sdl.graphics.resource.buffer.transfer_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core.gpu_device;
import kelp_sdl.graphics.resource.buffer;
import kelp_sdl.graphics.resource.texture;
import kelp_sdl.image;

import std.exception : enforce;
import std.algorithm : map, sum;
import core.stdc.string : memcpy;

class GPUTransferBuffer(Derived)
{
	SDL_GPUTransferBuffer* buffer_handle;
	GPUDevice device;
	uint size;
	void* transfer_ptr;

	this(GPUDevice device)
	{
		this.device = device;
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

	Derived createBySize(uint size)
	{
		this.size = size;
		SDL_GPUTransferBufferCreateInfo create_info = {
			usage: SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
			size: size,
		};
		this.buffer_handle = SDL_CreateGPUTransferBuffer(this.device.handle, &create_info);
		enforce(this.buffer_handle !is null);
		return cast(Derived) this;
	}

	Derived createByData(void[] data)
	in (data[0].sizeof * data.length <= uint.max, "data is oversized than uint.max")
	{
		this.size = cast(uint)(data[0].sizeof * data.length);
		SDL_GPUTransferBufferCreateInfo create_info = {
			usage: SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
			size: cast(uint)(data[0].sizeof * data.length),
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

	Derived map()
	in (this.handle !is null)
	in (this.device.handle !is null)
	{
		this.transfer_ptr = cast(void*) SDL_MapGPUTransferBuffer(
			this.device.handle, this.handle, false,
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

	Derived set_data(void[] set_data, size_t write_offset = 0)
	in (this.transfer_ptr !is null)
	in (set_data[0].sizeof * set_data.length <= uint.max)
	in (write_offset + (set_data[0].sizeof * set_data.length) <= this.size)
	{
		memcpy(
			transfer_ptr + write_offset,
			cast(void*) set_data,
			set_data[0].sizeof * set_data.length
		);
		return cast(Derived) this;
	}
}

class GPUBufferTransferBuffer : GPUTransferBuffer!(GPUBufferTransferBuffer)
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(uint size)
	{
		this.createBySize(size);
		return this;
	}

	typeof(this) set(void[] data, size_t write_offset = 0)
	in (this !is null)
	in (this.buffer_handle !is null)
	in (write_offset + (data[0].sizeof * data.length) <= this.size)
	{
		super.set_data(data, write_offset);
		return this;
	}

	typeof(this) set(TypeList...)(TypeList data_list)
	in
	{
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
			super.set_data(data, temp_offset);
			temp_offset += (data[0].sizeof * data.length);
		}
		return this;
	}
}

class GPUTextureTransferBuffer : GPUTransferBuffer!(GPUTextureTransferBuffer)
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(uint size)
	{
		super.createBySize(size);
		return this;
	}

	typeof(this) set(Surface surface)
	in (this !is null)
	in (this.buffer_handle !is null)
	{
		memcpy(
			this.transfer_ptr,
			surface.data_ptr,
			surface.size,
		);
		return this;
	}

	/+@disable typeof(this) set(GPUTexture texture)
	{
		memcpy(
			this.transfer_ptr,
			cast(void*)texture.data,
			texture.size,
		);
		return this;
	}+/
}
