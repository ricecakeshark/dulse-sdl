module kelp_sdl.graphics.core.gpu_device;

import bindbc.sdl;
import kelp_sdl.core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.core;

import std.exception, std.string;

class GpuDevice
{
	SDL_GPUDevice* device_handle;
	GpuWindow claimed_window;

	this()
	{
		return;
	}

	~this()
	{
		this.release();
		return;
	}

	@property inout(SDL_GPUDevice*) handle() inout pure @safe
	{
		return this.device_handle;
	}

	typeof(this) create()
	in (this.handle is null)
	{
		this.device_handle = SDL_CreateGPUDevice(
			SDL_GPU_SHADERFORMAT_SPIRV | SDL_GPU_SHADERFORMAT_DXIL | SDL_GPU_SHADERFORMAT_MSL,
			true, null,
		);
		enforce(this.device_handle !is null, SDL_GetError().fromStringz());
		return this;
	}

	typeof(this) release()
	{
		if (this is null || this.device_handle is null)
		{
			return this;
		}
		SDL_DestroyGPUDevice(this.device_handle);
		this.device_handle = null;
		return this;
	}

	typeof(this) claim(GpuWindow window)
	in (this.handle !is null)
	in (window !is null)
	in (window.handle !is null)
	{
		enforce(SDL_ClaimWindowForGPUDevice(this.handle, window.handle));
		return this;
	}

	typeof(this) release_window(GpuWindow window)
	in (this.device_handle !is null)
	{
		SDL_ReleaseWindowFromGPUDevice(this.handle, window.handle);
		return this;
	}

	deprecated typeof(this) release_window()
	in (this.device_handle !is null)
	{
		if (this.claimed_window !is null && this.claimed_window.handle !is null)
		{
			return this;
		}
		SDL_ReleaseWindowFromGPUDevice(this.handle, this.claimed_window.handle);
		this.claimed_window = null;
		return this;
	}

	typeof(this) wait()
	in (this.handle !is null)
	{
		SDL_WaitForGPUIdle(this.device_handle).catchSDLError();
		return this;
	}

	bool support_format(
		in SDL_GPUTextureFormat format,
		in SDL_GPUTextureType type,
		in SDL_GPUTextureUsageFlags usage
	)
	in (this.handle !is null)
	{
		return SDL_GPUTextureSupportsFormat(this.handle, format, type, usage);
	}

	GpuShaderFormat get_shader_format()
	{
		return cast(GpuShaderFormat) cast(SDL_GPUShaderFormat) SDL_GetGPUShaderFormats(
			this.device_handle);
	}

	invariant
	{
		assert(this !is null, "the instance is not initialized.");
	}
}
