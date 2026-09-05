module dulse_sdl.graphics.command.copy_pass;

import dulse_sdl.graphics.command;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource.buffer;
import sdl.gpu;

struct GpuCopyPass
{
	private SDL_GPUCopyPass* pass_handle;
	private GpuCommandBuffer command_buffer;

	@disable this(this);

	this(GpuCommandBuffer command_buffer) pure nothrow @nogc @safe
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

	@property inout(SDL_GPUCopyPass*) handle() inout pure nothrow @nogc @safe
	{
		return this.pass_handle;
	}

	ref typeof(this) begin()
	in (command_buffer.handle !is null)
	{
		this.pass_handle = SDL_BeginGPUCopyPass(this.command_buffer.handle);
		return this;
	}

	ref typeof(this) end()
	{
		SDL_EndGPUCopyPass(this.pass_handle);
		this.pass_handle = null;
		return this;
	}
	// upload buffer
	ref typeof(this) upload(
		in GpuTransferBufferLocation buffer_location,
		in GpuBufferRegion buffer_region,
	)
	{
		SDL_UploadToGPUBuffer(
			this.handle,
			cast(SDL_GPUTransferBufferLocation*)&buffer_location,
			cast(SDL_GPUBufferRegion*)&buffer_region,
			false
		);
		return this;
	}
	// upload buffer list
	ref typeof(this) upload(TypeList...)(
		in GpuBufferTransferBuffer transfer_buffer,
		auto ref TypeList buffer_list,
	)
	{
		scope GpuTransferBufferLocation buffer_location;
		buffer_location = GpuTransferBufferLocation(transfer_buffer);
		foreach (buffer; buffer_list)
		{
			scope GpuBufferRegion buffer_region;
			buffer_region = GpuBufferRegion(buffer, 0u);
			SDL_UploadToGPUBuffer(
				this.handle,
				cast(SDL_GPUTransferBufferLocation*)&buffer_location,
				cast(SDL_GPUBufferRegion*)&buffer_region,
				false,
			);
			buffer_location.offset += buffer.size_byte;
		}
		return this;
	}
	// upload texture
	ref typeof(this) upload(
		in GpuTextureTransferInfo transfer_info,
		in GpuTextureRegion texture_region,
	)
	{
		SDL_UploadToGPUTexture(
			this.handle,
			cast(SDL_GPUTextureTransferInfo*)&transfer_info,
			cast(SDL_GPUTextureRegion*)&texture_region,
			false
		);
		return this;
	}
}
