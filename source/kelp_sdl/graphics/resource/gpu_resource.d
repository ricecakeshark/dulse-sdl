module kelp_sdl.graphics.resource.gpu_resource;

import kelp_sdl;
import std.range, std.sumtype;
import std.meta;

alias GPUResourceType = SumType!(
	GPUGraphicsPipeline,
	GPUVertexBuffer,
	GPUIndexBuffer,
	GPUTexture,
);

void release(T...)(T resource_list)
if (allSatisfy!(hasRelease, T))
{
	foreach (resource; resource_list)
	{
		resource.release();
	}
	return;
}

void release(T)(T resource_list...)
if (isInputRange!(T) && hasRelease!(ElementType!T))
{
	foreach (resource; resource_list)
	{
		resource.release();
	}
	return;
}

enum hasRelease(T) = __traits(compiles, (T x) { x.release(); });
