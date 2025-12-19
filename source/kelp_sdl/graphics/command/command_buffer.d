module kelp_sdl.graphics.command.command_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.texture.swapchain_texture;

import std.exception, std.string;

class GPUCommandBuffer
{
	SDL_GPUCommandBuffer* command_buffer_handle;
	GPUDevice device;
	GPUWindow window;

	this(GPUDevice device)
	{
		this.device = device;
		return;
	}

	this(GPUDevice device, GPUWindow window)
	{
		this.device = device;
		this.window = window;
		return;
	}

public:
	@property inout(SDL_GPUCommandBuffer*) handle() inout pure nothrow @nogc @safe
	{
		return this.command_buffer_handle;
	}

	typeof(this) acquire_buffer()
	{
		this.command_buffer_handle = SDL_AcquireGPUCommandBuffer(this.device.handle());
		enforce(this.command_buffer_handle !is null);
		return this;
	}

	typeof(this) acquire_texture(
		ref GPUSwapchainTexture swapchain_texture,
	)
	in (this.window !is null)
	{
		SDL_WaitAndAcquireGPUSwapchainTexture(
			this.handle, this.window.handle,
			&(swapchain_texture.texture_handle),
			&(swapchain_texture._width),
			&(swapchain_texture._height),
		);
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

	typeof(this) push_uniform(Type)(Type compute_uniform_data, uint first_slot = 0)
	in (this.handle !is null)
	{
		SDL_PushGPUComputeUniformData(
			this.handle, first_slot,
			cast(const(void*))&compute_uniform_data, Type.sizeof,
		);
		return this;
	}

	typeof(this) blit_texture(GPUBlitInfo info)
	in (this.handle !is null)
	{
		SDL_BlitGPUTexture(this.handle, cast(SDL_GPUBlitInfo*)&info);
		return this;
	}

	/+typeof(this) blitTexture(ref GPUBlitInfo blit_info)
	{
		SDL_BlitGPUTexture(this.handle, cast(SDL_GPUBlitInfo*)&blit_info);
		return this;
	}+/
}
