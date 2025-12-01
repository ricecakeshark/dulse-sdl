module kelp_sdl.graphics.command.render_pass;

import bindbc.sdl;
import std.exception;

import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.rasterize.graphics_pipeline;
import kelp_sdl.graphics.resource;

import std.array, std.algorithm;

class GPURenderPass
{
	SDL_GPURenderPass* pass_handle;

	this()
	{
		return;
	}

	@property SDL_GPURenderPass* handle() pure nothrow @nogc @safe
	{
		return this.pass_handle;
	}

	typeof(this) begin(
		GPUCommandBuffer command_buffer,
		GPUColorTargetInfo[] color_target_info_list,
	)
	in (command_buffer !is null)
	in (command_buffer.handle !is null)
	in (color_target_info_list.length >= 1)
	{
		this.pass_handle = SDL_BeginGPURenderPass(
			command_buffer.handle,
			cast(SDL_GPUColorTargetInfo*) color_target_info_list.ptr,
			cast(uint) color_target_info_list.length,
			null,
		);
		return this;
	}

	typeof(this) begin(
		GPUCommandBuffer command_buffer,
		GPUColorTargetInfo[] color_target_info_list,
		GPUDepthStencilTargetInfo depth_stencil_target_info,
	)
	in (command_buffer !is null)
	in (command_buffer.handle !is null)
	in (color_target_info_list.length >= 1)
	{
		this.pass_handle = SDL_BeginGPURenderPass(
			command_buffer.handle,
			cast(SDL_GPUColorTargetInfo*) color_target_info_list.ptr,
			cast(uint) color_target_info_list.length,
			cast(SDL_GPUDepthStencilTargetInfo*)&depth_stencil_target_info,
		);
		return this;
	}

	typeof(this) end()
	{
		SDL_EndGPURenderPass(this.handle);
		this.pass_handle = null;
		return this;
	}

	typeof(this) bind(GPUGraphicsPipeline pipeline)
	in (this.handle !is null)
	in (pipeline !is null)
	in (pipeline.handle !is null)
	{
		SDL_BindGPUGraphicsPipeline(this.handle, pipeline.handle);
		return this;
	}

	typeof(this) bind(GPUVertexBuffer[] vertex_buffer_list, uint first_slot = 0)
	in (this.handle !is null)
	in (vertex_buffer_list.all!(buffer => buffer !is null))
	in (vertex_buffer_list.all!(buffer => buffer.handle !is null))
	{
		GPUBufferBinding[] buffer_binding_list;
		buffer_binding_list = vertex_buffer_list.map!(
			vertex_buffer => GPUBufferBinding(vertex_buffer)
		)().array();
		SDL_BindGPUVertexBuffers(
			this.pass_handle,
			first_slot,
			cast(const(SDL_GPUBufferBinding*)) buffer_binding_list,
			cast(uint) buffer_binding_list.length,
		);
		return this;
	}

	typeof(this) bind(GPUIndexBuffer index_buffer)
	in (this.handle !is null)
	in (index_buffer !is null)
	in (index_buffer.handle !is null)
	{
		GPUBufferBinding buffer_binding;
		buffer_binding = GPUBufferBinding(index_buffer, 0);
		SDL_BindGPUIndexBuffer(
			this.pass_handle,
			cast(const(SDL_GPUBufferBinding*))&buffer_binding,
			SDL_GPU_INDEXELEMENTSIZE_16BIT,
		);
		return this;
	}

	// bind(GPUTextureSamplerBinding[])

	typeof(this) set(const GPUViewport viewport)
	in (this.handle !is null)
	{
		SDL_SetGPUViewport(this.handle, cast(const(SDL_GPUViewport*))&viewport);
		return this;
	}

	typeof(this) set(const Rect scissor_rect)
	in (this.handle !is null)
	{
		SDL_SetGPUScissor(this.handle, cast(const(SDL_Rect*))&scissor_rect);
		return this;
	}

	typeof(this) set(ubyte stencil_referensce)
	in (this.handle !is null)
	{
		SDL_SetGPUStencilReference(this.handle, stencil_referensce);
		return this;
	}

	typeof(this) draw(
		uint num_vertices,
		uint num_instance,
		uint first_vertex = 0,
		uint first_instance = 0,
	)
	in (this.handle !is null)
	{
		SDL_DrawGPUPrimitives(
			this.handle,
			num_vertices,
			num_instance,
			first_vertex,
			first_instance,
		);
		return this;
	}

	typeof(this) draw_indexed(
		uint num_indices,
		uint num_instances,
		uint first_index = 0,
		int vertex_offset,
		uint first_instance = 0,
	)
	in (this.handle !is null)
	{
		SDL_DrawGPUIndexedPrimitives(
			this.handle,
			num_indices,
			num_instances,
			first_index,
			vertex_offset,
			first_instance,
		);
		return this;
	}

	typeof(this) draw_indirect(
		GPUDrawBuffer draw_buffer,
		uint offset,
		uint draw_count
	)
	in (this.handle !is null)
	{
		SDL_DrawGPUIndexedPrimitivesIndirect(
			this.handle,
			draw_buffer.handle,
			offset,
			draw_count
		);
		return this;
	}

	typeof(this) draw_indexed_indirect(
		GPUDrawBuffer draw_buffer,
		uint offset,
		uint draw_count,
	)
	in (this.handle !is null)
	{
		SDL_DrawGPUIndexedPrimitivesIndirect(
			this.handle,
			draw_buffer.handle,
			offset,
			draw_count,
		);
		return this;
	}
}
