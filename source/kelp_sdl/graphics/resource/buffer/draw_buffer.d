module kelp_sdl.graphics.resource.buffer.draw_buffer;

import bindbc.sdl;
import kelp_core.graphics.resource.draw_command;
import kelp_sdl.graphics.core;
import kelp_sdl.graphics.resource.buffer;

class GpuDrawBuffer : GpuBuffer
{
	size_t _count_command;
	size_t _stride_command = DrawCommandIndirect.sizeof;
	size_t _count_command_indexed;
	size_t _stride_command_indexed = DrawCommandIndexedIndirect.sizeof;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

public:
	@property size_t bytes() pure nothrow @nogc @safe
	{
		return this.bytes_command + this.bytes_command_indexed;
	}

	@property size_t bytes_command() pure nothrow @nogc @safe
	{
		return this._stride_command * this._count_command;
	}

	@property size_t bytes_command_indexed() pure nothrow @nogc @safe
	{
		return this._stride_command_indexed * this._count_command_indexed;
	}

	typeof(this) create(
		in size_t count_command,
		in size_t count_command_indexed,
	)
	{
		this._count_command = count_command;
		this._count_command_indexed = count_command_indexed;
		super.create_by_size(SDL_GPU_BUFFERUSAGE_INDIRECT, this.bytes);
		return this;
	}
}
