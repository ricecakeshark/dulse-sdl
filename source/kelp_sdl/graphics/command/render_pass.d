module kelp_sdl.graphics.command.render_pass;

import bindbc.sdl;
import std.exception;

import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.rasterize.graphics_pipeline;
import kelp_sdl.graphics.resource;

import std.array, std.algorithm;
import std.exception;

struct GpuRenderPass
{
	SDL_GPURenderPass* pass_handle;
	GpuCommandBuffer command_buffer;

	@disable this(this);

	this(GpuCommandBuffer command_buffer)
	{
		this.command_buffer = command_buffer;
		return;
	}

	invariant
	{
		// this.pass_handle may be null
		assert(this.command_buffer !is null);
	}

	@property bool is_valid() pure nothrow @nogc @safe
	{
		return (this.pass_handle !is null);
	}

	@property SDL_GPURenderPass* handle() pure nothrow @nogc @safe
	{
		return this.pass_handle;
	}

	ref typeof(this) begin(
		in GpuColorTargetInfo[] color_target_info_list,
	)
	in (this.command_buffer.is_valid)
	in (color_target_info_list.length >= 1)
	{
		this.pass_handle = SDL_BeginGPURenderPass(
			this.command_buffer.handle,
			cast(SDL_GPUColorTargetInfo*) color_target_info_list.ptr,
			cast(uint) color_target_info_list.length,
			null,
		);
		return this;
	}

	ref typeof(this) begin(
		in GpuColorTargetInfo[] color_target_info_list,
		in GpuDepthStencilTargetInfo depth_stencil_target_info,
	)
	in (this.command_buffer.is_valid)
	in (color_target_info_list.length >= 1)
	{
		this.pass_handle = SDL_BeginGPURenderPass(
			this.command_buffer.handle,
			cast(SDL_GPUColorTargetInfo*) color_target_info_list.ptr,
			cast(uint) color_target_info_list.length,
			cast(SDL_GPUDepthStencilTargetInfo*)&depth_stencil_target_info,
		);
		return this;
	}

	ref typeof(this) end()
	{
		SDL_EndGPURenderPass(this.handle);
		this.pass_handle = null;
		return this;
	}

	ref typeof(this) bind(GpuGraphicsPipeline pipeline)
	in (this.handle !is null)
	in (pipeline !is null, "Pipeline is null")
	in (pipeline.handle !is null)
	{
		SDL_BindGPUGraphicsPipeline(this.handle, pipeline.handle);
		return this;
	}
	// bind Vertex Buffer
	ref typeof(this) bind(GpuVertexBuffer[] vertex_buffer_list, in uint first_slot = 0)
	in (this.handle !is null)
	in (vertex_buffer_list.all!(buffer => buffer !is null))
	in (vertex_buffer_list.all!(buffer => buffer.handle !is null))
	{
		GpuBufferBinding[] buffer_binding_list;
		buffer_binding_list = vertex_buffer_list.map!(
			vertex_buffer => GpuBufferBinding(vertex_buffer)
		)().array();
		SDL_BindGPUVertexBuffers(
			this.pass_handle,
			first_slot,
			cast(const(SDL_GPUBufferBinding*)) buffer_binding_list,
			cast(uint) buffer_binding_list.length,
		);
		return this;
	}
	// bind Index Buffer
	ref typeof(this) bind(
		GpuIndexBuffer index_buffer
	)
	in (this.handle !is null)
	in (index_buffer !is null)
	in (index_buffer.handle !is null)
	{
		GpuBufferBinding buffer_binding;
		buffer_binding = GpuBufferBinding(index_buffer, 0);
		SDL_BindGPUIndexBuffer(
			this.pass_handle,
			cast(const(SDL_GPUBufferBinding*))&buffer_binding,
			cast(SDL_GPUIndexElementSize) index_buffer.element_size,
		);
		return this;
	}
	// bind Storage Buffer
	ref typeof(this) bind_to_vertex(
		GpuStorageBuffer[] storage_buffer_list,
		uint first_slot,
	)
	{
		SDL_BindGPUVertexStorageBuffers(
			this.pass_handle,
			first_slot,
			cast(SDL_GPUBuffer**) storage_buffer_list.map!(buffer => buffer.handle)
				.array,
				cast(uint) storage_buffer_list.length,
		);
		return this;
	}
	// bind Storage Buffer
	ref typeof(this) bind_to_fragment(
		GpuStorageBuffer[] storage_buffer_list,
		uint first_slot,
	)
	{
		SDL_BindGPUFragmentStorageBuffers(
			this.pass_handle,
			first_slot,
			cast(SDL_GPUBuffer**) storage_buffer_list.map!(buffer => buffer.handle)
				.array,
				cast(uint) storage_buffer_list.length,
		);
		return this;
	}

	ref typeof(this) bind(GpuTexture[] texture_list, in uint first_slot = 0u)
	{
		SDL_GPUTexture*[] texture_binding_list;
		texture_binding_list = texture_list.map!(texture => texture.handle).array();
		SDL_BindGPUFragmentStorageTextures(
			this.pass_handle,
			first_slot,
			cast(SDL_GPUTexture**) texture_binding_list.ptr,
			cast(uint) texture_list.length,
		);
		return this;
	}

	ref typeof(this) bind(in GpuTextureSamplerBinding[] binding_list, in uint first_slot = 0)
	in (this.handle !is null)
	in (binding_list.length >= 1)
	in (binding_list.length < uint.max)
	{
		SDL_BindGPUFragmentSamplers(
			this.pass_handle,
			first_slot,
			cast(const(SDL_GPUTextureSamplerBinding*)) binding_list,
			cast(uint) binding_list.length,
		);
		return this;
	}

	ref typeof(this) set(in GpuViewport viewport)
	in (this.handle !is null)
	{
		SDL_SetGPUViewport(this.handle, cast(const(SDL_GPUViewport*))&viewport);
		return this;
	}

	ref typeof(this) set(in Rect scissor_rect)
	in (this.handle !is null)
	{
		SDL_SetGPUScissor(this.handle, cast(const(SDL_Rect*))&scissor_rect);
		return this;
	}

	ref typeof(this) set(in ubyte stencil_referensce)
	in (this.handle !is null)
	{
		SDL_SetGPUStencilReference(this.handle, stencil_referensce);
		return this;
	}
	// push uniform data list to vertex shader
	ref typeof(this) push_vertex(TypeList...)(
		in uint first_slot = 0,
		TypeList uniform_data_list,
	)
	in
	{
		assert(this.is_valid);
		assert(this.command_buffer.is_valid);
		assert(first_slot + uniform_data_list.length <= 4);
	}
	do
	{
		foreach (uint index, uniform_data; uniform_data_list)
		{
			this.push_vertex(uniform_data, first_slot + index);
		}
		return this;
	}
	// push uniform data list to vertex shader
	ref typeof(this) push_vertex(Type)(
		Type vertex_uniform_data,
		in uint slot_index,
	)
	in
	{
		assert(this.is_valid);
		assert(this.command_buffer.is_valid);
	}
	do
	{
		SDL_PushGPUVertexUniformData(
			this.command_buffer.handle, slot_index,
			cast(const(void*))&vertex_uniform_data, Type.sizeof,
		);
		return this;
	}
	// push manually uniform data list to vertex shader
	ref typeof(this) push_vertex(Type)(
		Type vertex_uniform_data,
		in uint slot_index,
		in uint size,
	)
	in (this.handle !is null)
	in (this.command_buffer.handle !is null)
	{
		SDL_PushGPUVertexUniformData(
			this.command_buffer.handle, slot_index,
			cast(const(void*))&vertex_uniform_data, size,
		);
		return this;
	}
	// push uniform data list to fragment shader
	ref typeof(this) push_fragment(Type...)(
		in uint first_slot,
		Type uniform_data_list,
	)
	in
	{
		assert(this.is_valid);
		assert(this.command_buffer.is_valid);
		// SDL3's limitation ...?
		assert(first_slot + uniform_data_list.length <= 4);
	}
	do
	{
		foreach (uint index, uniform_data; uniform_data_list)
		{
			this.push_fragment(uniform_data, first_slot + index);
		}
		return this;
	}
	// push uniform data to fragment shader
	ref typeof(this) push_fragment(Type)(
		Type fragment_uniform_data,
		in uint first_slot
	)
	in
	{
		assert(this.is_valid);
		assert(this.command_buffer.is_valid);
	}
	do
	{
		SDL_PushGPUFragmentUniformData(
			this.command_buffer.handle, first_slot,
			cast(const(void*))&fragment_uniform_data, Type.sizeof,
		);
		return this;
	}

	ref typeof(this) draw(
		in ParamPrimitive param
	)
	in (this.handle !is null)
	{
		SDL_DrawGPUPrimitives(
			this.handle,
			param.num_vertices,
			param.num_instances,
			param.first_vertex,
			param.first_instance,
		);
		return this;
	}

	ref typeof(this) draw_indexed(
		in ParamIndexedPrimitive param
	)
	in (this.handle !is null)
	{
		SDL_DrawGPUIndexedPrimitives(
			this.handle,
			param.num_indices,
			param.num_instances,
			param.first_index,
			param.vertex_offset,
			param.first_instance,
		);
		return this;
	}

	ref typeof(this) draw_indirect(
		GpuDrawBuffer draw_buffer,
		in ParamPrimitiveIndirect param
	)
	in (this.handle !is null)
	in (draw_buffer.handle !is null)
	{
		SDL_DrawGPUPrimitivesIndirect(
			this.handle,
			draw_buffer.handle,
			param.offset,
			param.draw_count
		);
		return this;
	}

	ref typeof(this) draw_indexed_indirect(
		GpuDrawBuffer draw_buffer,
		in ParamPrimitiveIndirect param
	)
	in (this.handle !is null)
	in (draw_buffer.handle !is null)
	{
		SDL_DrawGPUIndexedPrimitivesIndirect(
			this.handle,
			draw_buffer.handle,
			param.offset,
			param.draw_count,
		);
		return this;
	}

}
