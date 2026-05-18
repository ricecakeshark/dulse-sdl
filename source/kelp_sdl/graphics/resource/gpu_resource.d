module kelp_sdl.graphics.resource.gpu_resource;

import kelp_sdl.graphics.core.gpu_device;

interface IGpuResource
{

}

interface IGpuResourceUpload
{
	@property inout(uint) stride() inout pure nothrow @nogc @safe;
	@property inout(uint) count() inout pure nothrow @nogc @safe;
	@property inout(uint) size_byte() inout pure nothrow @nogc @safe;
}

abstract class GpuResource
{
	protected GpuDevice device;

	this(GpuDevice device)
	{
		this.device = device;
	}

	invariant
	{
		assert(this !is null);
		assert(this.device !is null);
	}
}
