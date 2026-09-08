module dulse_sdl.graphics.resource.buffer.draw_buffer;

import sdl.gpu;
import dulse.graphics.resource.draw_command;
import dulse_sdl.graphics.core;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource.buffer;

class GpuDrawBuffer : GpuBuffer
{
	size_t _count_command;
	uint _stride_command = DrawCommandIndirect.sizeof;
	size_t _count_command_indexed;
	uint _stride_command_indexed = DrawCommandIndexedIndirect.sizeof;

	this(GpuDevice device) pure nothrow @nogc @safe
	{
		super(device);
		return;
	}

public:
	override @property inout(size_t) size_byte() inout pure nothrow @nogc @safe
	{
		return (this._stride_command * this._count_command) + (
			this._stride_command_indexed * this._count_command_indexed);
	}

	@property size_t size_command() pure nothrow @nogc @safe
	{
		return this._stride_command * this._count_command;
	}

	@property size_t size_command_indexed() pure nothrow @nogc @safe
	{
		return this._stride_command_indexed * this._count_command_indexed;
	}

	@property size_t count_command() const pure nothrow @nogc @safe
	{
		return this._count_command;
	}

	@property size_t count_command_indexed() const pure nothrow @nogc @safe
	{
		return this._count_command_indexed;
	}

	@property uint stride_command() const pure nothrow @nogc @safe
	{
		return this._stride_command;
	}

	@property uint stride_command_indexed() const pure nothrow @nogc @safe
	{
		return this._stride_command_indexed;
	}

	typeof(this) create(
		in size_t count_command,
		in size_t count_command_indexed,
	)
	{
		this._count_command = count_command;
		this._count_command_indexed = count_command_indexed;
		super.create_by_size(
			GpuBufferUsageFlags.indirect,
			(this._stride_command_indexed * count_command_indexed)
				+ (
					this._stride_command * count_command),
		);
		return this;
	}
}
