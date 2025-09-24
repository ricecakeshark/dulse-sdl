module kelp_sdl.graphics.desc.sdl_gpu;

import bindbc.sdl;
import kelp_sdl.graphics.resource;

struct GPUBufferBinding
{
	SDL_GPUBuffer* buffer;
	uint offset;

	this(GPUBuffer buffer, uint offset = 0)
	in (buffer.handle !is null)
	{
		this.buffer = buffer.handle;
		this.offset = offset;
		return;
	}
}

struct GPUColorTargetInfo
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer_or_depth_plane;
	SDL_FColor clear_color;
	SDL_GPULoadOp load_op;
	SDL_GPUStoreOp store_op;
	SDL_GPUTexture* resolve_texture;
	uint resolve_mip_level;
	uint resolve_layer;
	bool cycle;
	bool cycle_resolve_texture;
	ubyte padding1;
	ubyte padding2;
}

deprecated struct GPUDepthStencilTargetInfo
{

}
