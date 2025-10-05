module kelp_sdl.graphics.resource.buffer.transfer_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core.gpu_device;
import kelp_sdl.graphics.resource.texture;
import std.exception : enforce;
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

	Derived create(uint size)
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

	typeof(this) set(void[] data)
	in (data[0].sizeof * data.length == this.size)
	{
		memcpy(transfer_ptr, cast(void*) data, data[0].sizeof * data.length);
		return this;
	}
}

class GPUTextureTansferBuffer : GPUTransferBuffer!(GPUTextureTansferBuffer)
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

	typeof(this) set(GPUTexture texture)
	{
		memcpy(
			this.transfer_ptr,
			texture.surface_handle.pixels,
			texture.sizeInbytes,
		);
		return this;
	}
}
