module kelp_sdl.graphics.command.command_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;

import std.exception, std.string;

class GPUCommandBuffer
{
	SDL_GPUCommandBuffer* command_buffer_handle;
	GPUDevice device;

	this(GPUDevice device)
	{
		this.device = device;
		return;
	}

public:
	@property SDL_GPUCommandBuffer* handle() pure nothrow @nogc @safe
	{
		return this.command_buffer_handle;
	}

	typeof(this) acquire()
	{
		this.command_buffer_handle = SDL_AcquireGPUCommandBuffer(this.device.handle());
		return this;
	}

	typeof(this) submit()
	in (this.handle !is null)
	{
		bool succeed;
		succeed = SDL_SubmitGPUCommandBuffer(this.command_buffer_handle);
		enforce(succeed, SDL_GetError().fromStringz());
		this.command_buffer_handle = null;
		return this;
	}

	typeof(this) push_vertex(Type)(Type vertex_uniform_data, uint first_slot = 0)
	in (this.handle !is null)
	{
		SDL_PushGPUVertexUniformData(
			this.handle, first_slot,
			cast(const(void*))&vertex_uniform_data, Type.sizeof,
		);
		return this;
	}

	typeof(this) push_fragment(Type)(Type fragment_uniform_data, uint first_slot = 0)
	in (this.handle !is null)
	{
		SDL_PushGPUFragmentUniformData(
			this.handle, first_slot,
			cast(const(void*))&fragment_uniform_data, Type.sizeof,
		);
		return this;
	}

	typeof(this) push_compute(Type)(Type compute_uniform_data, uint first_slot = 0)
	in (this.handle !is null)
	{
		SDL_PushGPUComputeUniformData(
			this.handle, first_slot,
			cast(const(void*))&compute_uniform_data, Type.sizeof,
		);
		return this;
	}

	/+typeof(this) blitTexture(GPUAbstractTexture dst_texture, GPUAbstractTexture src_texture)
	in (this.handle !is null)
	in (dst_texture.handle !is null)
	in (src_texture.handle !is null)
	{
		SDL_GPUBlitInfo blit_info;
		with (blit_info)
		{
			source.texture = src_texture.handle;
			source.w = 960;
			source.h = 540;
			destination.texture = dst_texture.handle;
			destination.w = 960;
			destination.h = 540;
			load_op = SDL_GPU_LOADOP_DONT_CARE;
			filter = SDL_GPU_FILTER_LINEAR;
		}
		SDL_BlitGPUTexture(this.handle, &blit_info);
		return this;
	}+/

	/+typeof(this) blitTexture(ref GPUBlitInfo blit_info)
	{
		SDL_BlitGPUTexture(this.handle, cast(SDL_GPUBlitInfo*)&blit_info);
		return this;
	}+/
}
