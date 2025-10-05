module kelp_sdl.graphics.resource.buffer.draw_buffer;

import bindbc.sdl;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer;
import std.exception : enforce;
import core.stdc.string : memcpy;

class GPUDrawBuffer : GPUBuffer
{
	SDL_GPUIndexedIndirectDrawCommand[] iid_command;
	SDL_GPUIndirectDrawCommand[] id_command;

	this(GPUDevice device)
	{
		super(device);
		return;
	}

public:
	typeof(this) create(
		SDL_GPUIndexedIndirectDrawCommand[] iid_command,
		SDL_GPUIndirectDrawCommand[] id_command,
	)
	{
		this.create((iid_command[0].sizeof * iid_command.length) + (
				id_command[0].sizeof * id_command.length));
		this.set(iid_command, id_command);
		return this;
	}

	typeof(this) create(size_t size)
	{
		super.createBySize(SDL_GPU_BUFFERUSAGE_INDIRECT, size);
		return this;
	}

	typeof(this) set(
		SDL_GPUIndexedIndirectDrawCommand[] iid_command,
		SDL_GPUIndirectDrawCommand[] id_command,
	)
	{
		void* data_ptr;
		this.iid_command = iid_command;
		this.id_command = id_command;
		data_ptr = cast(void*)(this.data);
		memcpy(data_ptr, cast(void*) this.iid_command, iid_command[0].sizeof * iid_command.length);
		data_ptr += this.iid_command[0].sizeof * iid_command.length;
		memcpy(data_ptr, cast(void*) this.id_command, id_command[0].sizeof * id_command.length);
		return this;
	}
}
