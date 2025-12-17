module kelp_sdl.graphics.command.compute_pass;

import bindbc.sdl;
import kelp_sdl.graphics.command;
import kelp_sdl.graphics.compute;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer.storage_buffer;
import kelp_sdl.graphics.resource.texture;

import std.exception,std.string;

class GPUComputePass
{
	SDL_GPUComputePass* pass_handle;

	this()
	{
		return;
	}

	~this()
	{
		return;
	}

	@property inout(SDL_GPUComputePass*) handle() inout pure nothrow @nogc @safe
	{
		return this.pass_handle;
	}

	typeof(this) begin(
		GPUCommandBuffer command_buffer,
		GPUStorageTextureReadWriteBinding[] texture_binding_list,
	)
	in (command_buffer !is null)
	in (command_buffer.handle !is null)
	in (texture_binding_list.length < uint.max)
	{
		this.pass_handle = SDL_BeginGPUComputePass(
			command_buffer.handle,
			cast(SDL_GPUStorageTextureReadWriteBinding*) texture_binding_list.ptr,
			cast(uint) texture_binding_list.length,
			null,
			cast(uint) 0u,
		);
		enforce(this.pass_handle !is null);
		return this;
	}

	typeof(this) begin(
		GPUCommandBuffer command_buffer,
		GPUStorageTextureReadWriteBinding[] texture_binding_list,
		GPUStorageBufferReadWriteBinding[] buffer_binding_list,
	)
	in (command_buffer !is null)
	in (command_buffer.handle !is null)
	in (texture_binding_list.length < uint.max)
	in (buffer_binding_list.length < uint.max)
	{
		this.pass_handle = SDL_BeginGPUComputePass(
			command_buffer.handle,
			cast(SDL_GPUStorageTextureReadWriteBinding*) texture_binding_list.ptr,
			cast(uint) texture_binding_list.length,
			cast(SDL_GPUStorageBufferReadWriteBinding*) buffer_binding_list.ptr,
			cast(uint) buffer_binding_list.length,
		);
		enforce(this.pass_handle !is null);
		return this;
	}

	typeof(this) end()
	{
		SDL_EndGPUComputePass(this.pass_handle);
		this.pass_handle = null;
		return this;
	}

	typeof(this) bind(GPUComputePipeline compute_pipeline)
	in (this.handle !is null)
	in (compute_pipeline.handle !is null)
	{
		SDL_BindGPUComputePipeline(this.pass_handle, compute_pipeline.handle);
		return this;
	}

	typeof(this) bind(GPUStorageBuffer storage_buffer, uint first_slot)
	in (this.handle !is null)
	in (storage_buffer.handle !is null)
	{
		SDL_BindGPUComputeStorageBuffers(
			this.handle, first_slot,
			cast(SDL_GPUBuffer**)[storage_buffer.handle].ptr, 1,
		);
		return this;
	}

	typeof(this) bind(GPUTextureSamplerBinding[] texture_sampler_binding, uint first_slot)
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

	typeof(this) dispatch(int groupcount_x, int groupcount_y, int groupcount_z)
	in (this.handle !is null)
	{
		SDL_DispatchGPUCompute(this.handle, groupcount_x, groupcount_y, groupcount_z);
		return this;
	}
}
