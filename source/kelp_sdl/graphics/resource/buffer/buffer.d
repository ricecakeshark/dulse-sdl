module kelp_sdl.graphics.resource.buffer.buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.desc;
import std.exception : enforce;

abstract class GPUBuffer
{
	SDL_GPUBuffer* buffer_handle;
	GPUDevice device;
	void[] data;
	uint _size;

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

	@property uint size() const pure nothrow @nogc @safe
	{
		return cast(uint)(this._size);
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
	deprecated typeof(this) create_by_data(
		SDL_GPUBufferUsageFlags usage_flags,
		void[] setting_data,
	)
	in (setting_data[0].sizeof * setting_data.length <= uint.max, "setting_data is oversized")
	{
		scope SDL_GPUBufferCreateInfo buffer_create_info;
		buffer_create_info = SDL_GPUBufferCreateInfo(
			usage_flags,
			cast(uint)(setting_data[0].sizeof * setting_data.length)
		);
		this.buffer_handle = SDL_CreateGPUBuffer(
			this.device.handle, &buffer_create_info
		);
		enforce(this.buffer_handle !is null);
		this.data = setting_data;
		this._size = cast(uint)(setting_data[0].sizeof * setting_data.length);
		return this;
	}

	typeof(this) create_by_info(
		GPUBufferCreateInfo create_info,
	)
	in (this.device.handle !is null)
	{
		this.buffer_handle = SDL_CreateGPUBuffer(
			this.device.handle, cast(SDL_GPUBufferCreateInfo*)&create_info
		);
		enforce(this.buffer_handle !is null);
		this._size = create_info.size;
		return this;
	}

	typeof(this) create_by_size(
		SDL_GPUBufferUsageFlags usage_flags,
		size_t size,
	)
	in (this.device.handle !is null)
	in (size <= uint.max)
	{
		scope SDL_GPUBufferCreateInfo buffer_create_info;
		buffer_create_info = SDL_GPUBufferCreateInfo(
			usage_flags, cast(uint) size,
		);
		this._size = cast(uint) size;
		this.buffer_handle = SDL_CreateGPUBuffer(
			this.device.handle, &buffer_create_info
		);
		enforce(this.buffer_handle !is null);
		return this;
	}

	typeof(this) set_data(void[] setting_data)
	in (this.handle !is null)
	in (setting_data[0].sizeof * setting_data.length == this.size, "mismatched buffer size with setting size")
	{
		this.data = setting_data;
		return this;
	}
}
