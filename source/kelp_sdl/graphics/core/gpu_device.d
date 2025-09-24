module kelp_sdl.graphics.core.gpu_device;

import bindbc.sdl;
import kelp_sdl.graphics.core;
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

	bool isNull() const pure nothrow @nogc @safe
	{
		return (this.device_handle is null);
	}

	typeof(this) create()
	in (this.isNull)
	{
		this.device_handle = SDL_CreateGPUDevice(
			SDL_GPU_SHADERFORMAT_SPIRV | SDL_GPU_SHADERFORMAT_DXIL | SDL_GPU_SHADERFORMAT_MSL,
			true, null,
		);
		enforce(this.device_handle !is null);
		return this;
	}

	typeof(this) release()
	in (!this.isNull)
	{
		SDL_DestroyGPUDevice(this.device_handle);
		this.device_handle = null;
		return this;
	}

	typeof(this) claim(GPUWindow window)
	in (this.handle !is null)
	in (window.handle !is null)
	in (this.claimed_window is null)
	{
		enforce(SDL_ClaimWindowForGPUDevice(this.handle, window.handle));
		this.claimed_window = window;
		return this;
	}

	typeof(this) releaseWindow()
	in (!this.isNull)
	in (this.claimed_window !is null)
	{
		SDL_ReleaseWindowFromGPUDevice(this.handle, this.claimed_window.handle);
		this.claimed_window = null;
		return this;
	}

	invariant
	{
		assert(this !is null, "the instance is not initialized.");
	}
}
