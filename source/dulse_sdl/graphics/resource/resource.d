module dulse_sdl.graphics.resource.resource;

import dulse_sdl.graphics.core.device;

interface IGpuResource
{
	IGpuResource release();
}

interface IGpuResourceUpload
{
	@property inout(uint) stride() inout pure nothrow @nogc @safe;
	@property inout(uint) count() inout pure nothrow @nogc @safe;
	@property inout(uint) size_byte() inout pure nothrow @nogc @safe;
}

abstract class GpuResource(Derived) : IGpuResource
{
	protected GpuDevice device;

	this(GpuDevice device) pure nothrow @nogc @safe
	{
		this.device = device;
		return;
	}

	invariant
	{
		assert(this !is null);
		assert(this.device !is null);
	}
}
