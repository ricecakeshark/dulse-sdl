module kelp_sdl.graphics.text.text_engine;

import kelp_sdl.graphics.core;
import kelp_sdl.graphics.text;

import bindbc.sdl;

import std.exception : enforce;

class GPUTextEngine
{
	TTF_TextEngine* text_engine_handle;

	this()
	{
		return;
	}

	@property inout(TTF_TextEngine*) handle() inout pure nothrow @nogc @safe
	{
		return this.text_engine_handle;
	}

	typeof(this) create(GPUDevice device)
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
}
