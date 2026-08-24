module kelp_sdl.graphics.command.command_buffer;

import sdl.gpu, sdl.error;
import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.texture.swapchain_texture;
import kelp_sdl.graphics.resource.fence;

import std.exception : enforce;
import std.string : fromStringz;

class GpuCommandBuffer
{
	private SDL_GPUCommandBuffer* command_buffer_handle;
	private GpuDevice _device;
	private GpuWindow _window;
	// (copy pass)
	this(GpuDevice device) pure nothrow @nogc @safe
	{
		this._device = cast(GpuDevice) device;
		this._window = null;
		return;
	}
	// need swapchain texture (render-pass, compute-pass)
	this(GpuDevice device, GpuWindow window) pure nothrow @nogc @safe
	{
		this._device = device;
		this._window = window;
		return;
	}

	invariant
	{
		assert(this !is null);
		assert(this._device !is null);
	}

public:
	bool is_valid() pure nothrow @nogc @safe
	{
		return (this.command_buffer_handle !is null);
	}

	@property inout(SDL_GPUCommandBuffer*) handle() inout pure nothrow @nogc @safe
	{
		return this.command_buffer_handle;
	}

	@property inout(GpuDevice) device() inout pure nothrow @nogc @safe
	{
		return this._device;
	}

	@property inout(GpuWindow) window() inout pure nothrow @nogc @safe
	{
		return this._window;
	}

	typeof(this) acquire_buffer()
	in (this.device !is null)
	in (this.device.handle !is null)
	{
		this.command_buffer_handle = SDL_AcquireGPUCommandBuffer(this.device.handle);
		enforce(this.command_buffer_handle !is null);
		return this;
	}

	typeof(this) acquire_texture(
		ref GpuSwapchainTexture swapchain_texture,
	)
	in (this.handle !is null)
	in (this.window !is null)
	{
		swapchain_texture.acquire(this);
		return this;
	}
	// submit command buffer
	typeof(this) submit()
	in (this.handle !is null)
	{
		bool succeed;
		succeed = SDL_SubmitGPUCommandBuffer(this.command_buffer_handle);
		enforce(succeed, SDL_GetError().fromStringz());
		this.command_buffer_handle = null;
		return this;
	}
	// submit command and acquire 
	typeof(this) submit(ref GpuFence fence)
	in (this.handle !is null)
	{
		fence.wrap(SDL_SubmitGPUCommandBufferAndAcquireFence(this.command_buffer_handle));
		enforce(fence.handle !is null, SDL_GetError().fromStringz());
		this.command_buffer_handle = null;
		return this;
	}

	alias push_vert = push_vertex;
	// push single uniform to render_pass
	typeof(this) push_vertex(Type)(
		Type vertex_uniform_data,
		in uint slot_index
	)
	in (this.handle !is null)
	{
		SDL_PushGPUVertexUniformData(
			this.handle, slot_index,
			cast(const(void*))&vertex_uniform_data, Type.sizeof,
		);
		return this;
	}
	// push multiple uniform to render_pass
	typeof(this) push_vertex(TypeList...)(
		in uint first_slot,
		TypeList vertex_uniform_list,
	)
	in (this.handle !is null)
	{
		foreach (uint index, uniform; vertex_uniform_list)
		{
			SDL_PushGPUVertexUniformData(
				this.handle, first_slot + index,
				cast(const(void*))&uniform, uniform.sizeof,
			);
		}
		return this;
	}
	// push vertex uniform data with size manually (only render_pass)
	typeof(this) push_vertex(Type)(
		Type vertex_uniform_data,
		in uint slot_index,
		in uint size
	)
	in (this.handle !is null)
	{
		SDL_PushGPUVertexUniformData(
			this.handle, slot_index,
			cast(const(void*))&vertex_uniform_data, size,
		);
		return this;
	}

	alias push_frag = push_fragment;
	// push fragment uniform data (only render_pass)
	typeof(this) push_fragment(Type)(
		Type fragment_uniform_data,
		in uint first_slot = 0
	)
	in (this.handle !is null)
	{
		SDL_PushGPUFragmentUniformData(
			this.handle, first_slot,
			cast(const(void*))&fragment_uniform_data, Type.sizeof,
		);
		return this;
	}
	// push multiple uniform to fragment
	typeof(this) push_fragment(TypeList)(
		in uint first_slot = 0,
		TypeList fragment_uniform_list,
	)
	in (this.handle !is null)
	{
		foreach (uint index, uniform; fragment_uniform_list)
		{
			SDL_PushGPUFragmentUniformData(
				this.handle, first_slot + index,
				cast(const(void*))&uniform, uniform.sizeof,
			);
		}
		return this;
	}

	alias push_comp = push_compute;
	// push single uniform to compute pass 
	typeof(this) push_compute(Type)(
		Type compute_uniform_data,
		in uint first_slot = 0
	)
	in (this.handle !is null)
	{
		SDL_PushGPUComputeUniformData(
			this.handle, first_slot,
			cast(const(void*))&compute_uniform_data, Type.sizeof,
		);
		return this;
	}
	// push multiple uniform to compute pass 
	typeof(this) push_compute(TypeList...)(
		in uint first_slot = 0,
		TypeList compute_uniform_list,
	)
	in (this.handle !is null)
	{
		foreach (uint index, uniform; compute_uniform_list)
		{
			SDL_PushGPUComputeUniformData(
				this.handle, first_slot + index,
				cast(const(void*))&compute_uniform_data, Type.sizeof,
			);
		}
		return this;
	}
	// blit texture. (no need beginned ~~~_pass)
	alias blit = blit_texture;
	typeof(this) blit_texture(in GpuBlitInfo info)
	in (this.handle !is null)
	{
		SDL_BlitGPUTexture(this.handle, cast(SDL_GPUBlitInfo*)&info);
		return this;
	}
}
