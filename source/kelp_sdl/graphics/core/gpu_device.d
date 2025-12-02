module kelp_sdl.graphics.core.gpu_device;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.util;
import std.exception;

class GPUDevice
{
	SDL_GPUDevice* device_handle;
	GPUWindow claimed_window;

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
		enforce(this.device_handle !is null);
		return this;
	}

	typeof(this) release()
	{
		if(this is null || this.device_handle is null)
		{
			return this;
		}
		this.release_window();
		if (this.device_handle !is null)
		{
			SDL_DestroyGPUDevice(this.device_handle);
			this.device_handle = null;
		}
		return this;
	}

	typeof(this) claim(GPUWindow window)
	in (this.handle !is null)
	in (this.claimed_window is null)
	in (window.handle !is null)
	{
		enforce(SDL_ClaimWindowForGPUDevice(this.handle, window.handle));
		this.claimed_window = window;
		return this;
	}

	typeof(this) release_window()
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
		bool result;
		SDL_WaitForGPUIdle(this.device_handle).catchSDLError();
		return this;
	}

	@property SDL_GPUTextureFormat getSwapchainTextureFormat()
	in (this.handle !is null)
	in (this.claimed_window !is null)
	in (this.claimed_window.handle !is null)
	{
		return SDL_GetGPUSwapchainTextureFormat(this.handle, this.claimed_window.handle);
	}

	bool supportFormat(
		SDL_GPUTextureFormat format,
		SDL_GPUTextureType type,
		SDL_GPUTextureUsageFlags usage
	)
	in (this.handle !is null)
	{
		return SDL_GPUTextureSupportsFormat(this.handle, format, type, usage);
	}

	invariant
	{
		assert(this !is null, "the instance is not initialized.");
	}
}
