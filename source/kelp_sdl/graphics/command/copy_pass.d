module kelp_sdl.graphics.command.copy_pass;

import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer;
import bindbc.sdl;

class GpuCopyPass
{
	SDL_GPUCopyPass* pass_handle;

	@property inout(SDL_GPUCopyPass*) handle() inout pure nothrow @nogc @safe
	{
		return this.pass_handle;
	}

	typeof(this) begin(GpuCommandBuffer command_buffer)
	in (command_buffer.handle !is null)
	{
		this.pass_handle = SDL_BeginGPUCopyPass(command_buffer.handle);
		return this;
	}

	typeof(this) end()
	{
		SDL_EndGPUCopyPass(this.pass_handle);
		this.pass_handle = null;
		return this;
	}

	typeof(this) upload(
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

	typeof(this) upload(
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
