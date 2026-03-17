module kelp_sdl.graphics.command.command_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.texture.swapchain_texture;

import std.exception, std.string;

class GpuCommandBuffer
{
	SDL_GPUCommandBuffer* command_buffer_handle;
	GpuDevice device;
	GpuWindow window;

	this(GpuDevice device)
	{
		this.device = device;
		return;
	}

	this(GpuDevice device, GpuWindow window)
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

	typeof(this) with_render_pass(
		in GpuColorTargetInfo[] color_target_info_list,
		in GpuDepthStencilTargetInfo depth_stencil_target_info,
		void delegate(GpuRenderPass) dlg
	)
	{
		scope GpuRenderPass render_pass;
		render_pass.begin(
			this,
			color_target_info_list,
			depth_stencil_target_info,
		);
		dlg(render_pass);
		render_pass.end();
		return this;
	}

	typeof(this) with_render_pass(
		in GpuColorTargetInfo[] color_target_info_list,
		void delegate(ref GpuRenderPass) dlg
	)
	{
		scope GpuRenderPass render_pass;
		render_pass.begin(
			this,
			color_target_info_list,
		);
		dlg(render_pass);
		render_pass.end();
		return this;
	}

	typeof(this) with_compute_pass(
		in GpuStorageTextureReadWriteBinding[] texture_binding_list,
		in GpuStorageBufferReadWriteBinding[] buffer_binding_list,
		void delegate(ref GpuComputePass) dlg,
	)
	{
		scope GpuComputePass compute_pass;
		compute_pass.begin(
			this,
			texture_binding_list,
			buffer_binding_list
		);
		dlg(compute_pass);
		compute_pass.end();
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

	typeof(this) push_uniform(Type)(Type compute_uniform_data, in uint first_slot = 0)
	in (this.handle !is null)
	{
		SDL_PushGPUComputeUniformData(
			this.handle, first_slot,
			cast(const(void*))&compute_uniform_data, Type.sizeof,
		);
		return this;
	}

	typeof(this) blit_texture(in GpuBlitInfo info)
	in (this.handle !is null)
	{
		SDL_BlitGPUTexture(this.handle, cast(SDL_GPUBlitInfo*)&info);
		return this;
	}
}
