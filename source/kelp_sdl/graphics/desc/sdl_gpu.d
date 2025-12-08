module kelp_sdl.graphics.desc.sdl_gpu;

import bindbc.sdl;
import kelp_sdl.graphics.desc;
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

struct GPUDepthStencilState
{
	GPUCompareOp compare_op;
	GPUStencilOpState back_stencil_state;
	GPUStencilOpState front_stencil_state;
	ubyte compare_mask;
	ubyte write_mask;
	bool enable_depth_test;
	bool enable_depth_write;
	bool enable_stencil_test;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
}

struct GPUDepthStencilTargetInfo
{
	SDL_GPUTexture* texture;
	float clear_depth = 0.0f;
	SDL_GPULoadOp load_op;
	SDL_GPUStoreOp store_op;
	SDL_GPULoadOp stencil_load_op;
	SDL_GPUStoreOp stencil_store_op;
	bool cycle = false;
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
	GPURasterizerState rasterizer_state;
	SDL_GPUMultisampleState multisample_state;
	GPUDepthStencilState depth_stencil_state;
	GPUGraphicsPipelineTargetInfo target_info;

	SDL_PropertiesID props;
}

struct GPUGraphicsPipelineTargetInfo
{
	const GPUColorTargetDescription* color_target_description;
	uint num_color_targets;
	GPUTextureFormat depth_stencil_format;
	bool has_depth_stencil_target;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
}

struct GPURasterizerState
{
	GPUFillMode fill_mode;
	GPUCullMode cull_mode;
	GPUFrontFace front_face;
	float depth_bias_constant_factor;
	float depth_bias_clamp;
	float depth_bias_slope_factor;
	bool enable_depth_bias;
	bool enable_depth_clip;
	ubyte padding1;
	ubyte padding2;
}

struct GPUSamplerCreateInfo
{
	GPUFilter min_filter;
	GPUFilter mag_filter;
	GPUSamplerMipmapMode mipmap_mode;
	GPUSamplerAddressMode address_mode_u;
	GPUSamplerAddressMode address_mode_v;
	GPUSamplerAddressMode address_mode_w;
	float mip_lod_bias;
	float max_anisotropy;
	GPUCompareOp compare_op;
	float min_lod;
	float max_lod;
	bool enable_anisotropy;
	bool enable_compare;
	ubyte padding1;
	ubyte padding2;
}

struct GPUShaderCreateInfo
{
	size_t code_size;
	const ubyte* code;
	const char* entrypoint;
	SDL_GPUShaderFormat format;
	SDL_GPUShaderStage stage;
	uint num_samplers;
	uint num_storage_textures;
	uint num_storage_buffers;
	uint num_uniform_buffers;

	this(ShaderCode shader_code, SDL_GPUShaderStage stage, GPUShaderArguments shader_args)
	{
		import std.string : toStringz;

		this.code = cast(const(ubyte)*) shader_code.code;
		this.code_size = shader_code.code.length;
		this.entrypoint = toStringz(shader_code.entry_point);
		this.format = shader_code.frontend_format;
		this.stage = stage;
		this.num_samplers = shader_args.sampler_count;
		this.num_uniform_buffers = shader_args.uniform_buffer_count;
		this.num_storage_buffers = shader_args.storage_buffer_count;
		this.num_storage_textures = shader_args.storage_texture_count;
		return;
	}
}

struct GPUStencilOpState
{
	GPUStencilOp fail_op;
	GPUStencilOp pass_op;
	GPUStencilOp depth_fail_op;
	GPUCompareOp compare_op;
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
	GPUTextureType type;
	GPUTextureFormat format;
	GPUTextureUsageFlags usage;
	uint width;
	uint height;
	uint layer_count_or_depth = 1;
	uint num_levels = 1;
	GPUSampleCount sample_count;

	SDL_PropertiesID props;
}

struct GPUTextureLocation
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer;
	uint x;
	uint y;
	uint z;
}

struct GPUTextureRegion
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer;
	uint x;
	uint y;
	uint z;
	uint w;
	uint h;
	uint d;
}

struct GPUTextureSamplerBinding
{
	SDL_GPUTexture* texture;
	SDL_GPUSampler* sampler;

	this(GPUTexture texture, GPUSampler sampler)
	in (texture !is null)
	in (texture.handle !is null)
	in (sampler !is null)
	in (sampler.handle !is null)
	{
		this.texture = texture.handle;
		this.sampler = sampler.handle;
		return;
	}
}

struct GPUTextureTransferInfo
{
	SDL_GPUTransferBuffer* transfer_buffer;
	uint offset;
	uint pixels_per_row;
	uint rows_per_layer;
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

struct GPUViewport
{
	float x;
	float y;
	float w;
	float h;
	float min_depth;
	float max_depth;

	this(float x, float y, float w, float h)
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.min_depth = 0.0f;
		this.max_depth = +1.0f;
		return;
	}
}

struct GPUTransferBufferLocation
{
	SDL_GPUTransferBuffer* transfer_buffer;
	uint offset;

	this(
		SDL_GPUTransferBuffer* transfer_buffer_handle,
		uint offset = 0,
	)
	in (transfer_buffer_handle !is null)
	{
		this.transfer_buffer = transfer_buffer_handle;
		this.offset = offset;
		return;
	}

	this(
		GPUBufferTransferBuffer transfer_buffer,
		uint offset = 0,
	)
	in (transfer_buffer.handle !is null)
	{
		this.transfer_buffer = transfer_buffer.handle;
		this.offset = offset;
		return;
	}
}

struct GPUBufferRegion
{
	SDL_GPUBuffer* buffer;
	uint offset;
	uint size;

	this(
		SDL_GPUBuffer* buffer_handle,
		uint offset,
		uint size,
	)
	in (buffer_handle !is null)
	{
		this.buffer = buffer_handle;
		this.offset = offset;
		this.size = size;
		return;
	}

	this(
		GPUBuffer buffer,
		uint offset = 0,
	)
	in (buffer.handle !is null)
	{
		this.buffer = buffer.handle;
		this.offset = offset;
		this.size = buffer.size;
		return;
	}
}
