module kelp_sdl.graphics.resource.buffer.buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;

abstract class GPUBuffer
{
	SDL_GPUBuffer* buffer_handle;
	GPUDevice device;
	void[] data;
	uint size;

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

public:
	@property SDL_GPUBuffer* handle() pure nothrow @nogc @safe
	{
		return this.buffer_handle;
	}

	@property uint count() const pure nothrow @nogc @safe
	in (this.data !is null)
	{
		return cast(uint)(this.data.length);
	}

	@property uint sizeInBytes() const pure nothrow @nogc @safe
	in (this.data !is null)
	{
		return cast(uint)(this.data[0].sizeof * this.data.length);
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
	typeof(this) createByData(
		SDL_GPUBufferUsageFlags usage_flags,
		void[] setting_data,
	)
	{
		SDL_GPUBufferCreateInfo buffer_create_info;
		buffer_create_info = SDL_GPUBufferCreateInfo(
			usage_flags,
			cast(uint)(setting_data[0].sizeof * setting_data.length)
		);

		this.buffer_handle = SDL_CreateGPUBuffer(
			this.device.handle, &buffer_create_info
		);
		return this;
	}
}
