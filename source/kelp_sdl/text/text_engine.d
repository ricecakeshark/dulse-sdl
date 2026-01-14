module kelp_sdl.text.text_engine;

import kelp_sdl.graphics.core;
import kelp_sdl.text;

import bindbc.sdl;

import std.exception : enforce;

abstract class AbstractTextEngine
{
	TTF_TextEngine* text_engine_handle;
	GPUDevice device;

	@property inout(TTF_TextEngine*) handle() inout pure nothrow @nogc @safe
	{
		return this.text_engine_handle;
	}
}

class GPUTextEngine : AbstractTextEngine
{
	this(GPUDevice device)
	{
		this.device = device;
		return;
	}

	typeof(this) create()
	{
		this.text_engine_handle = TTF_CreateGPUTextEngine(device.handle);
		enforce(text_engine_handle !is null);
		return this;
	}

	typeof(this) release()
	{
		TTF_DestroyGPUTextEngine(this.text_engine_handle);
		this.text_engine_handle = null;
		return this;
	}

	typeof(this) set(TextEngineWinding winding)
	{
		TTF_SetGPUTextEngineWinding(this.handle, cast(TTF_GPUTextEngineWinding) winding);
		return this;
	}
}

class SurfaceTextEngine : AbstractTextEngine
{
	this(GPUDevice device)
	{
		this.device = device;
		return;
	}

	typeof(this) create()
	{
		this.text_engine_handle = TTF_CreateSurfaceTextEngine();
		enforce(text_engine_handle !is null);
		return this;
	}

	typeof(this) release()
	{
		TTF_DestroySurfaceTextEngine(this.text_engine_handle);
		this.text_engine_handle = null;
		return this;
	}
}
