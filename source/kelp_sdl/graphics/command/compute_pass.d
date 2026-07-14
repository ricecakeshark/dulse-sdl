module kelp_sdl.graphics.command.compute_pass;

import bindbc.sdl;
import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer.storage_buffer;
import kelp_sdl.graphics.resource.pipeline;
import kelp_sdl.graphics.resource.texture;

import std.exception, std.string;
import std.array : array;
import std.algorithm : map;

struct GpuComputePass
{
	SDL_GPUComputePass* pass_handle;
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

	@property inout(SDL_GPUComputePass*) handle() inout pure nothrow @nogc @safe
	{
		return this.pass_handle;
	}

	ref typeof(this) begin(
		in GpuStorageTextureReadWriteBinding[] texture_binding_list,
	)
	in (this.command_buffer.is_valid)
	in (command_buffer.handle !is null)
	in (texture_binding_list.length < uint.max)
	{
		this.pass_handle = SDL_BeginGPUComputePass(
			this.command_buffer.handle,
			cast(SDL_GPUStorageTextureReadWriteBinding*) texture_binding_list.ptr,
			cast(uint) texture_binding_list.length,
			null,
			cast(uint) 0u,
		);
		enforce(this.pass_handle !is null);
		return this;
	}

	ref typeof(this) begin(
		in GpuStorageTextureReadWriteBinding[] texture_binding_list,
		in GpuStorageBufferReadWriteBinding[] buffer_binding_list,
	)
	in (this.command_buffer.is_valid)
	in (texture_binding_list.length < uint.max)
	in (buffer_binding_list.length < uint.max)
	{
		this.pass_handle = SDL_BeginGPUComputePass(
			this.command_buffer.handle,
			cast(SDL_GPUStorageTextureReadWriteBinding*) texture_binding_list.ptr,
			cast(uint) texture_binding_list.length,
			cast(SDL_GPUStorageBufferReadWriteBinding*) buffer_binding_list.ptr,
			cast(uint) buffer_binding_list.length,
		);
		enforce(this.pass_handle !is null);
		return this;
	}

	ref typeof(this) end()
	{
		SDL_EndGPUComputePass(this.pass_handle);
		this.pass_handle = null;
		return this;
	}
	// bind compute pipeline
	ref typeof(this) bind(GpuComputePipeline compute_pipeline)
	in (this.handle !is null)
	in (compute_pipeline.handle !is null)
	{
		SDL_BindGPUComputePipeline(this.pass_handle, compute_pipeline.handle);
		return this;
	}
	// bind Storage Buffer List
	ref typeof(this) bind(
		in GpuStorageBuffer[] storage_buffer_list,
		in uint first_slot
	)
	in (this.handle !is null)
	{
		SDL_BindGPUComputeStorageBuffers(
			this.handle,
			first_slot,
			cast(SDL_GPUBuffer**) storage_buffer_list.map!(buffer => buffer.handle)
				.array,
				cast(uint) storage_buffer_list.length,
		);
		return this;
	}
	// bind texture sampler
	ref typeof(this) bind(
		in uint first_slot = 0,
		in GpuTextureSamplerBinding[] texture_sampler_binding...
	)
	in (this.handle !is null)
	in (texture_sampler_binding.length >= 1)
	{
		SDL_BindGPUComputeSamplers(
			this.handle, first_slot,
			cast(SDL_GPUTextureSamplerBinding*) texture_sampler_binding.ptr,
			cast(uint) texture_sampler_binding.length,
		);
		return this;
	}
	// bind texture sampler
	ref typeof(this) bind(
		in GpuTextureSamplerBinding[] texture_sampler_binding...
	)
	in (this.handle !is null)
	in (texture_sampler_binding.length >= 1)
	{
		this.bind(0, texture_sampler_binding);
		return this;
	}
	// bind texture sampler
	/+
	deprecated ref typeof(this) bind(
		in GpuTextureSamplerBinding[] texture_sampler_binding,
		in uint first_slot = 0,
	)
	in (this.handle !is null)
	in (texture_sampler_binding.length >= 1)
	{
		SDL_BindGPUComputeSamplers(
			this.handle, first_slot,
			cast(SDL_GPUTextureSamplerBinding*) texture_sampler_binding.ptr,
			cast(uint) texture_sampler_binding.length,
		);
		return this;
	}+/
	// push uniform data list to compute shader
	ref typeof(this) push(Type...)(
		in uint first_slot,
		Type uniform_data_list,
	)
	in
	{
		assert(this.handle !is null);
		assert(this.command_buffer !is null);
		assert(this.command_buffer.handle !is null);
		// SDL3 limitation (maybe)
		assert(first_slot + uniform_data_list.length <= 4);
	}
	do
	{
		foreach (uint index, uniform_data; uniform_data_list)
		{
			this.push(uniform_data, first_slot + index);
		}
		return this;
	}
	// push uniform data to compute shader
	ref typeof(this) push(Type)(
		Type compute_uniform_data,
		in uint slot_index = 0
	)
	in
	{
		assert(this.is_valid);
		assert(this.is_valid);
	}
	do
	{
		SDL_PushGPUComputeUniformData(
			this.command_buffer.handle, slot_index,
			cast(const(void*))&compute_uniform_data, Type.sizeof,
		);
		return this;
	}

	ref typeof(this) dispatch(
		in int[3] group_count_list...
	)
	in (this.handle !is null)
	{
		SDL_DispatchGPUCompute(
			this.handle,
			group_count_list[0],
			group_count_list[1],
			group_count_list[2],
		);
		return this;
	}
}
