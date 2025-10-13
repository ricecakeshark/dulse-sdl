module kelp_sdl.graphics.command.copy_pass;

import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer;
import bindbc.sdl;

class GPUCopyPass
{
	SDL_GPUCopyPass* pass_handle;

	@property inout(SDL_GPUCopyPass*) handle() inout pure nothrow @nogc @safe
	{
		return this.pass_handle;
	}

	typeof(this) begin(GPUCommandBuffer command_buffer)
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
		GPUTransferBufferLocation transfer_buffer_location,
		GPUBufferRegion upload_buffer_region,
	)
	{
		SDL_UploadToGPUBuffer(
			this.handle,
			cast(SDL_GPUTransferBufferLocation*)&transfer_buffer_location,
			cast(SDL_GPUBufferRegion*)&upload_buffer_region,
			false
		);
		return this;
	}

	deprecated typeof(this) upload(
		GPUBufferTransferBuffer transfer_buffer,
		uint transfer_offset = 0,
		GPUBuffer upload_buffer,
		uint upload_size,
	)
	in (this.handle !is null)
	in (upload_buffer.handle !is null)
	{
		SDL_GPUTransferBufferLocation buffer_location;
		SDL_GPUBufferRegion buffer_region;
		buffer_location = SDL_GPUTransferBufferLocation(
			transfer_buffer.handle, transfer_offset,
		);
		buffer_region = SDL_GPUBufferRegion(
			upload_buffer.handle, 0, upload_size,
		);
		SDL_UploadToGPUBuffer(this.handle, &buffer_location, &buffer_region, false);
		return this;
	}

	deprecated typeof(this) upload(
		GPUBufferTransferBuffer transfer_buffer,
		GPUBuffer buffer,
		uint offset = 0,
	)
	in (this.handle !is null)
	in (buffer.handle !is null)
	{
		SDL_GPUTransferBufferLocation buffer_location;
		SDL_GPUBufferRegion buffer_region;
		buffer_location = SDL_GPUTransferBufferLocation(
			transfer_buffer.handle, offset,
		);
		buffer_region = SDL_GPUBufferRegion(
			buffer.handle, 0, buffer.sizeInBytes,
		);
		SDL_UploadToGPUBuffer(this.handle, &buffer_location, &buffer_region, false);
		return this;
	}

}
