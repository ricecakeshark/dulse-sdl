module kelp_sdl.graphics.resource.gpu_resource;

import kelp_sdl.graphics.core.gpu_device;

interface IGpuResource
{
	
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
