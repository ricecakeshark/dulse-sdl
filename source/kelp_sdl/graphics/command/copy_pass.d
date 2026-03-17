module kelp_sdl.graphics.command.copy_pass;

import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer;
import bindbc.sdl;

struct GpuCopyPass
{
	SDL_GPUCopyPass* pass_handle;
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
