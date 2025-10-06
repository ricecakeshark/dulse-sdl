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

struct GPUColorTargetDescription
{
	SDL_GPUTextureFormat format;
	SDL_GPUColorTargetBlendState blend_state;
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

struct GPUDepthStencilTargetInfo
{
	SDL_GPUTexture* texture;
	float clear_depth;
	SDL_GPULoadOp load_op;
	SDL_GPUStoreOp store_op;
	SDL_GPULoadOp stencil_load_op;
	SDL_GPUStoreOp stencil_store_op;
	bool cycle;
	ubyte clear_stencil;
	ubyte mip_level;
	ubyte layer;
}

struct GPUGraphicsPipelineCreateInfo
{
	SDL_GPUShader* vertex_shader;
	SDL_GPUShader* fragment_shader;
	GPUVertexInputState vertex_input_state;
	SDL_GPUPrimitiveType primitive_type;
	SDL_GPURasterizerState rasterizer_state;
	SDL_GPUMultisampleState multisample_state;
	SDL_GPUDepthStencilState depth_stencil_state;
	GPUGraphicsPipelineTargetInfo target_info;

	SDL_PropertiesID props;
}

struct GPUGraphicsPipelineTargetInfo
{
	const GPUColorTargetDescription* color_target_description;
	uint num_color_targets;
	SDL_GPUTextureFormat depth_stencil_format;
	bool has_depth_stencil_target;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
}

struct GPUStorageTextureReadWriteBinding
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
}

struct GPUTextureCreateInfo
{
	SDL_GPUTextureType type;
	SDL_GPUTextureFormat format;
	SDL_GPUTextureUsage usage;
	uint width;
	uint height;
	uint layer_count_or_depth = 1;
	uint num_levels = 1;
	SDL_GPUSampleCount sample_count;

	SDL_PropertiesID props;
}

struct GPUTextureSamplerBinding
{
	SDL_GPUTexture* texture;
	SDL_GPUSampler* sampler;
}

struct GPUVertexBufferDescription
{
	uint slot;
	uint pitch;
	SDL_GPUVertexInputRate input_rate;
	uint instance_step_rate;
}

struct GPUVertexAttribute
{
	uint location;
	uint buffer_slot;
	SDL_GPUVertexElementFormat format;
	uint offset;
}

struct GPUVertexInputState
{
	const GPUVertexBufferDescription* vertex_buffer_description;
	uint num_vertex_buffers;
	const GPUVertexAttribute* vertex_attribute;
	uint num_vertex_attributes;
}
