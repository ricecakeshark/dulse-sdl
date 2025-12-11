module kelp_sdl.graphics.desc.sdl_gpu_struct;

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

struct GPUColorTargetBlendState
{
	GPUBlendFactor src_color_blendfactor;
	GPUBlendFactor dst_color_blendfactor;
	GPUBlendOp color_blend_op;
	GPUBlendFactor src_alpha_blendfactor;
	GPUBlendFactor dst_alpha_blendfactor;
	GPUBlendOp alpha_blend_op;
	GPUColorComponentFlags color_write_mask;
	bool enable_blend;
	bool enable_color_write_mask;
	ubyte padding1;
	ubyte padding2;
}

struct GPUColorTargetDescription
{
	SDL_GPUTextureFormat format;
	GPUColorTargetBlendState blend_state;
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

struct GPUComputePipelineCreateInfo
{
	size_t code_size;
	const ubyte* code;
	const char* entrypoint;
	GPUShaderFormat format;
	uint num_samplers;
	uint num_readonly_storage_textures;
	uint num_readonly_storage_buffers;
	uint num_readwrite_storage_textures;
	uint num_readwrite_storage_buffers;
	uint num_uniform_buffers;
	uint threadcount_x;
	uint threadcount_y;
	uint threadcount_z;

	SDL_PropertiesID props;
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

	this(
		GPUColorTargetDescription[] description,
		uint num_target,
		GPUTextureFormat format,
		bool has_depth_stencil_target,
	)
	in (num_target <= description.length)
	{
		this.color_target_description = cast(GPUColorTargetDescription*) description;
		this.num_color_targets = num_target;
		this.depth_stencil_format = format;
		this.has_depth_stencil_target = has_depth_stencil_target;
		return;
	}

	this(
		GPUColorTargetDescription[] description,
		uint num_target,
	)
	in (num_target <= description.length)
	{
		this.color_target_description = cast(GPUColorTargetDescription*) description;
		this.num_color_targets = num_target;
		return;
	}

	this(
		GPUColorTargetDescription[] description
	)
	in (description.length < uint.max)
	{
		this.color_target_description = cast(GPUColorTargetDescription*) description;
		this.num_color_targets = cast(uint) description.length;
		return;
	}

	this(
		GPUColorTargetDescription[] description,
		GPUTextureFormat depth_stencil_format,
	)
	in (description.length < uint.max)
	{
		this.color_target_description = cast(GPUColorTargetDescription*) description;
		this.num_color_targets = cast(uint) description.length;
		this.depth_stencil_format = depth_stencil_format;
		this.has_depth_stencil_target = true;
		return;
	}
}

struct GPURasterizerState
{
	GPUFillMode fill_mode;
	GPUCullMode cull_mode;
	GPUFrontFace front_face;
	float depth_bias_constant_factor = 0.0f;
	float depth_bias_clamp = 0.0f;
	float depth_bias_slope_factor = 0.0f;
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
	float mip_lod_bias = 0.0f;
	float max_anisotropy = 0.0f;
	GPUCompareOp compare_op;
	float min_lod = 0.0f;
	float max_lod = 0.0f;
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
	GPUVertexInputRate input_rate;
	uint instance_step_rate;
}

struct GPUVertexAttribute
{
	uint location;
	uint buffer_slot;
	GPUVertexElementFormat format;
	uint offset;
}

struct GPUVertexInputState
{
	const GPUVertexBufferDescription* vertex_buffer_descriptions;
	uint num_vertex_buffers;
	const GPUVertexAttribute* vertex_attributes;
	uint num_vertex_attributes;

	this(
		GPUVertexBufferDescription[] description,
		uint num_buffers,
		GPUVertexAttribute[] attribute,
		uint num_attributes,
	)
	in (description.length < uint.max)
	in (attribute.length < uint.max)
	{
		this.vertex_buffer_descriptions = cast(GPUVertexBufferDescription*) description;
		this.num_vertex_buffers = cast(uint) num_buffers;
		this.vertex_attributes = cast(GPUVertexAttribute*) attribute;
		this.num_vertex_attributes = cast(uint) num_attributes;
		return;
	}

	this(GPUVertexBufferDescription[] description, GPUVertexAttribute[] attribute)
	in (description.length < uint.max)
	in (attribute.length < uint.max)
	{
		this.vertex_buffer_descriptions = cast(GPUVertexBufferDescription*) description;
		this.num_vertex_buffers = cast(uint) description.length;
		this.vertex_attributes = cast(GPUVertexAttribute*) attribute;
		this.num_vertex_attributes = cast(uint) attribute.length;
		return;
	}
}

struct GPUViewport
{
	float x;
	float y;
	float w;
	float h;
	float min_depth = 0.0f;
	float max_depth = 1.0f;

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
