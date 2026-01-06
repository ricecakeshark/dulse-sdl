module kelp_sdl.graphics.desc.sdl_gpu_struct;

import bindbc.sdl;
import kelp_core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource;
import kelp_sdl.image.desc;

struct GPUBlitInfo
{
	GPUBlitRegion source;
	GPUBlitRegion destination;
	GPULoadOp load_op;
	Color clear_color;
	SdlFlipMode flip_mode;
	GPUFilter filter;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;

	this(
		GPUBlitRegion source,
		GPUBlitRegion dest,
		GPULoadOp load_op,
		Color color = Color(0.0f, 0.0f, 0.0f, 1.0f),
	)
	{
		this.source = source;
		this.destination = dest;
		this.load_op = load_op;
		this.clear_color = color;
		return;
	}
}

struct GPUBlitRegion
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer_or_depth_plane;
	uint x;
	uint y;
	uint w;
	uint h;

	this(
		GPUAbstractTexture texture,
		uint x, uint y,
		uint w, uint h,
	)
	{
		this.texture = texture.handle;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		return;
	}

	this(
		GPUAbstractTexture texture,
	)
	{
		this.texture = texture.handle;
		this.x = 0u;
		this.y = 0u;
		this.w = texture.width;
		this.h = texture.height;
		return;
	}

	this(
		GPUAbstractTexture texture,
		uint mip_level, uint layer_or_depth_plane,
		uint x, uint y, uint w, uint h
	)
	{
		this.texture = texture.handle;
		this.mip_level = mip_level;
		this.layer_or_depth_plane = layer_or_depth_plane;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		return;
	}
}

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

struct GPUBufferCreateInfo
{
	GPUBufferUsageFlags usage;
	uint size;

	SDL_PropertiesID props;

	this(GPUBufferUsageFlags flags, size_t size)
	in (size <= uint.max)
	{
		this.usage = flags;
		this.size = cast(uint) size;
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
	GPUTextureFormat format;
	GPUColorTargetBlendState blend_state;
}

struct GPUColorTargetInfo
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer_or_depth_plane;
	Color clear_color = Color(0.0f, 0.0f, 0.0f, 1.0f);
	GPULoadOp load_op;
	GPUStoreOp store_op;
	SDL_GPUTexture* resolve_texture;
	uint resolve_mip_level;
	uint resolve_layer;
	bool cycle;
	bool cycle_resolve_texture;
	ubyte padding1;
	ubyte padding2;

	this(GPUAbstractTexture texture, GPULoadOp load_op, GPUStoreOp store_op)
	{
		this.texture = texture.handle;
		this.load_op = load_op;
		this.store_op = store_op;
		return;
	}

	this(
		GPUAbstractTexture texture,
		GPULoadOp load_op, GPUStoreOp store_op,
		uint mip_level,
		uint depth,
	)
	{
		this.texture = texture.handle;
		this.load_op = load_op;
		this.store_op = store_op;
		this.mip_level = mip_level;
		this.layer_or_depth_plane = depth;
		this.store_op = store_op;
		return;
	}

	invariant
	{
		if (cycle == true)
			assert(this.load_op != GPULoadOp.load);
	}
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

	this(ShaderCode shader_code)
	{
		import std.string;

		this.code = cast(const(ubyte)*) shader_code.code;
		this.code_size = shader_code.code.length;
		this.entrypoint = toStringz(shader_code.entry_point);
		this.format = cast(GPUShaderFormat) shader_code.frontend_format;
		return;
	}
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
	GPUMultisampleState multisample_state;
	GPUDepthStencilState depth_stencil_state;
	GPUGraphicsPipelineTargetInfo target_info;

	SDL_PropertiesID props = 0;
}

struct GPUGraphicsPipelineTargetInfo
{
	GPUColorTargetDescription* color_target_descriptions;
	uint num_color_targets;
	GPUTextureFormat depth_stencil_format = GPUTextureFormat.init;
	bool has_depth_stencil_target;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;

	this(
		GPUColorTargetDescription[] description_list
	)
	in (description_list.length < uint.max)
	{
		this.color_target_descriptions = cast(GPUColorTargetDescription*) description_list.ptr;
		this.num_color_targets = cast(uint) description_list.length;
		return;
	}

	this(
		GPUColorTargetDescription[] description_list,
		GPUTextureFormat depth_stencil_format,
	)
	in (description_list.length < uint.max)
	{
		this.color_target_descriptions = cast(GPUColorTargetDescription*) description_list.ptr;
		this.num_color_targets = cast(uint) description_list.length;
		this.depth_stencil_format = depth_stencil_format;
		this.has_depth_stencil_target = true;
		return;
	}
}

struct GPUMultisampleState
{
	GPUSampleCount sample_count;
	uint sample_mask;
	bool enable_mask;
	bool enable_alpha_to_coverage;
	ubyte padding2;
	ubyte padding3;
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
	GPUShaderFormat format;
	GPUShaderStage stage;
	uint num_samplers;
	uint num_storage_textures;
	uint num_storage_buffers;
	uint num_uniform_buffers;

	this(ShaderCode shader_code, GPUShaderStage stage, GPUShaderArguments shader_args)
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

	this(
		ShaderCode shader_code,
		GPUShaderFormat frontend_format,
		GPUShaderStage stage,
		GPUShaderArguments shader_args
	)
	{
		import std.string : toStringz;

		this.code = cast(const(ubyte)*) shader_code.code;
		this.code_size = shader_code.code.length;
		this.entrypoint = toStringz(shader_code.entry_point);
		this.format = frontend_format;
		this.stage = stage;
		this.num_samplers = shader_args.sampler_count;
		this.num_uniform_buffers = shader_args.uniform_buffer_count;
		this.num_storage_buffers = shader_args.storage_buffer_count;
		this.num_storage_textures = shader_args.storage_texture_count;
		return;
	}

	this(
		ShaderFile shader_file,
		GPUShaderStage stage,
		GPUShaderArguments shader_args
	)
	{
		import std.string : toStringz;

		this.code = cast(const(ubyte)*) shader_file.code;
		this.code_size = shader_file.code.length;
		this.entrypoint = toStringz(shader_file.entry_point);
		this.format = shader_file.frontend_format;
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

struct GPUStorageBufferReadWriteBinding
{
	SDL_GPUBuffer* buffer;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;

	this(GPUBuffer buffer, bool cycle = false)
	{
		this.buffer = buffer.handle;
		this.cycle = cycle;
		return;
	}
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

	this(GPUTexture texture)
	{
		this.texture = texture.handle;
		return;
	}

	this(GPUTexture texture, uint mip_level, uint layer, bool cycle = false)
	{
		this.texture = texture.handle;
		this.mip_level = mip_level;
		this.layer = layer;
		this.cycle = cycle;
		return;
	}
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

	/+this(GPUTexture texture)
	{
		this.texture = texture.handle;
		this.w = texture.width;
		this.h = texture.height;
		this.d = 1u;
		return;
	}+/
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

	this(GPUTextureTransferBuffer texture_transfer_buffer, uint offset)
	{
		this.transfer_buffer = texture_transfer_buffer.handle;
		this.offset = offset;
		return;
	}
}

struct GPUTransferBufferCreateInfo
{
	GPUTransferBufferUsage usage;
	uint size;

	SDL_PropertiesID props;
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
	GPUVertexBufferDescription* vertex_buffer_descriptions;
	uint num_vertex_buffers;
	GPUVertexAttribute* vertex_attributes;
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

unittest
{
	import std.stdio;
	import std.format;

	static foreach (symbol; [
			"PrimitiveType", "ColorTargetInfo", "ColorTargetDescription", "LoadOp",
			"StoreOp"
		])
	{
		mixin(
			format(
				"assert( GPU%s.sizeof == SDL_GPU%s.sizeof, \"GPU%s != SDL_GPU...\");",
				symbol, symbol, symbol,
		)
		);
	}
}
