module kelp_sdl.graphics.desc.sdl_gpu_struct;

import bindbc.sdl;
import kelp_core;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource;
import kelp_sdl.image.desc;

struct GpuBlitInfo
{
	GpuBlitRegion source;
	GpuBlitRegion destination;
	GpuLoadOp load_op;
	Color clear_color;
	SdlFlipMode flip_mode;
	GpuFilter filter;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;

	this(
		GpuBlitRegion source,
		GpuBlitRegion dest,
		GpuLoadOp load_op,
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

struct GpuBlitRegion
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer_or_depth_plane;
	uint x;
	uint y;
	uint w;
	uint h;

	this(
		GpuAbstractTexture texture,
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
		GpuAbstractTexture texture,
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
		GpuAbstractTexture texture,
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

struct GpuBufferBinding
{
	SDL_GPUBuffer* buffer;
	uint offset;

	this(GpuBuffer buffer, uint offset = 0)
	in (buffer.handle !is null)
	{
		this.buffer = buffer.handle;
		this.offset = offset;
		return;
	}
}

struct GpuBufferCreateInfo
{
	GpuBufferUsageFlags usage;
	uint size;

	SDL_PropertiesID props;

	this(GpuBufferUsageFlags flags, size_t size)
	in (size <= uint.max)
	{
		this.usage = flags;
		this.size = cast(uint) size;
		return;
	}
}

struct GpuColorTargetBlendState
{
	GpuBlendFactor src_color_blendfactor;
	GpuBlendFactor dst_color_blendfactor;
	GpuBlendOp color_blend_op;
	GpuBlendFactor src_alpha_blendfactor;
	GpuBlendFactor dst_alpha_blendfactor;
	GpuBlendOp alpha_blend_op;
	GpuColorComponentFlags color_write_mask;
	bool enable_blend;
	bool enable_color_write_mask;
	ubyte padding1;
	ubyte padding2;
}

struct GpuColorTargetDescription
{
	GpuTextureFormat format;
	GpuColorTargetBlendState blend_state;
}

struct GpuColorTargetInfo
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer_or_depth_plane;
	Color clear_color = Color(0.0f, 0.0f, 0.0f, 1.0f);
	GpuLoadOp load_op;
	GpuStoreOp store_op;
	SDL_GPUTexture* resolve_texture;
	uint resolve_mip_level;
	uint resolve_layer;
	bool cycle;
	bool cycle_resolve_texture;
	ubyte padding1;
	ubyte padding2;

	this(GpuAbstractTexture texture, GpuLoadOp load_op, GpuStoreOp store_op)
	{
		this.texture = texture.handle;
		this.load_op = load_op;
		this.store_op = store_op;
		return;
	}

	this(
		GpuAbstractTexture texture,
		GpuLoadOp load_op, GpuStoreOp store_op,
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
			assert(this.load_op != GpuLoadOp.load);
	}
}

struct GpuComputePipelineCreateInfo
{
	size_t code_size;
	const ubyte* code;
	const char* entrypoint;
	GpuShaderFormat format;
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

	this(ShaderFile shader_file)
	{
		import std.string;

		this.code = cast(const(ubyte)*) shader_file.code;
		this.code_size = shader_file.code.length;
		this.entrypoint = toStringz(shader_file.entry_point);
		this.format = cast(GpuShaderFormat) shader_file.frontend_format;
		return;
	}
}

struct GpuDepthStencilState
{
	GpuCompareOp compare_op;
	GpuStencilOpState back_stencil_state;
	GpuStencilOpState front_stencil_state;
	ubyte compare_mask;
	ubyte write_mask;
	bool enable_depth_test;
	bool enable_depth_write;
	bool enable_stencil_test;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
}

struct GpuDepthStencilTargetInfo
{
	SDL_GPUTexture* texture;
	float clear_depth = 0.0f;
	GpuLoadOp load_op;
	GpuStoreOp store_op;
	GpuLoadOp stencil_load_op;
	GpuStoreOp stencil_store_op;
	bool cycle = false;
	ubyte clear_stencil;
	ubyte mip_level;
	ubyte layer;
}

struct GpuGraphicsPipelineCreateInfo
{
	SDL_GPUShader* vertex_shader;
	SDL_GPUShader* fragment_shader;
	GpuVertexInputState vertex_input_state;
	SDL_GPUPrimitiveType primitive_type;
	GpuRasterizerState rasterizer_state;
	GpuMultisampleState multisample_state;
	GpuDepthStencilState depth_stencil_state;
	GpuGraphicsPipelineTargetInfo target_info;

	SDL_PropertiesID props = 0;
}

struct GpuGraphicsPipelineTargetInfo
{
	GpuColorTargetDescription* color_target_descriptions;
	uint num_color_targets;
	GpuTextureFormat depth_stencil_format = GpuTextureFormat.invalid;
	bool has_depth_stencil_target = false;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;

	this(
		GpuColorTargetDescription[] description_list
	)
	in (description_list.length < uint.max)
	{
		this.color_target_descriptions = cast(GpuColorTargetDescription*) description_list.ptr;
		this.num_color_targets = cast(uint) description_list.length;
		return;
	}

	this(
		GpuColorTargetDescription[] description_list,
		GpuTextureFormat depth_stencil_format,
	)
	in (description_list.length < uint.max)
	{
		this.color_target_descriptions = cast(GpuColorTargetDescription*) description_list.ptr;
		this.num_color_targets = cast(uint) description_list.length;
		this.depth_stencil_format = depth_stencil_format;
		this.has_depth_stencil_target = true;
		return;
	}
}

struct GpuMultisampleState
{
	GpuSampleCount sample_count;
	uint sample_mask;
	bool enable_mask;
	bool enable_alpha_to_coverage;
	ubyte padding2;
	ubyte padding3;
}

struct GpuRasterizerState
{
	GpuFillMode fill_mode;
	GpuCullMode cull_mode;
	GpuFrontFace front_face;
	float depth_bias_constant_factor = 0.0f;
	float depth_bias_clamp = 0.0f;
	float depth_bias_slope_factor = 0.0f;
	bool enable_depth_bias;
	bool enable_depth_clip;
	ubyte padding1;
	ubyte padding2;
}

struct GpuSamplerCreateInfo
{
	GpuFilter min_filter;
	GpuFilter mag_filter;
	GpuSamplerMipmapMode mipmap_mode;
	GpuSamplerAddressMode address_mode_u;
	GpuSamplerAddressMode address_mode_v;
	GpuSamplerAddressMode address_mode_w;
	float mip_lod_bias = 0.0f;
	float max_anisotropy = 0.0f;
	GpuCompareOp compare_op;
	float min_lod = 0.0f;
	float max_lod = 0.0f;
	bool enable_anisotropy;
	bool enable_compare;
	ubyte padding1;
	ubyte padding2;
}

struct GpuShaderCreateInfo
{
	size_t code_size;
	const ubyte* code;
	const char* entrypoint;
	GpuShaderFormat format;
	GpuShaderStage stage;
	uint num_samplers;
	uint num_storage_textures;
	uint num_storage_buffers;
	uint num_uniform_buffers;

	this(
		ShaderFile shader_file,
		GpuShaderArguments shader_args
	)
	{
		import std.string : toStringz;

		this.code = cast(const(ubyte*)) shader_file.code;
		this.code_size = shader_file.code.length;
		this.entrypoint = cast(const(char*)) toStringz(shader_file.entry_point);
		this.format = shader_file.frontend_format;
		this.stage = shader_file.shader_stage;
		this.num_samplers = shader_args.sampler_count;
		this.num_uniform_buffers = shader_args.uniform_buffer_count;
		this.num_storage_buffers = shader_args.storage_buffer_count;
		this.num_storage_textures = shader_args.storage_texture_count;
		return;
	}
}

struct GpuStencilOpState
{
	GpuStencilOp fail_op;
	GpuStencilOp pass_op;
	GpuStencilOp depth_fail_op;
	GpuCompareOp compare_op;
}

struct GpuStorageBufferReadWriteBinding
{
	SDL_GPUBuffer* buffer;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;

	this(GpuBuffer buffer, bool cycle = false)
	{
		this.buffer = buffer.handle;
		this.cycle = cycle;
		return;
	}
}

struct GpuStorageTextureReadWriteBinding
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;

	this(GpuTexture texture)
	{
		this.texture = texture.handle;
		return;
	}

	this(GpuTexture texture, uint mip_level, uint layer, bool cycle = false)
	{
		this.texture = texture.handle;
		this.mip_level = mip_level;
		this.layer = layer;
		this.cycle = cycle;
		return;
	}
}

struct GpuTextureCreateInfo
{
	GpuTextureType type;
	GpuTextureFormat format;
	GpuTextureUsageFlags usage;
	uint width;
	uint height;
	uint layer_count_or_depth = 1;
	uint num_levels = 1;
	GpuSampleCount sample_count;

	SDL_PropertiesID props;
}

struct GpuTextureLocation
{
	SDL_GPUTexture* texture;
	uint mip_level;
	uint layer;
	uint x;
	uint y;
	uint z;
}

struct GpuTextureRegion
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

	/+this(GpuTexture texture)
	{
		this.texture = texture.handle;
		this.w = texture.width;
		this.h = texture.height;
		this.d = 1u;
		return;
	}+/
}

struct GpuTextureSamplerBinding
{
	SDL_GPUTexture* texture;
	SDL_GPUSampler* sampler;

	this(SDL_GPUTexture* texture_handle, SDL_GPUSampler* sampler_handle)
	in (texture_handle !is null)
	in (sampler_handle !is null)
	{
		this.texture = texture_handle;
		this.sampler = sampler_handle;
		return;
	}

	this(GpuTexture texture, GpuSampler sampler)
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

struct GpuTextureTransferInfo
{
	SDL_GPUTransferBuffer* transfer_buffer;
	uint offset;
	uint pixels_per_row;
	uint rows_per_layer;

	this(GpuTextureTransferBuffer texture_transfer_buffer,
		uint width, uint height, uint offset = 0,
	)
	{
		this.transfer_buffer = texture_transfer_buffer.handle;
		this.offset = offset;
		this.pixels_per_row = width;
		this.rows_per_layer = height;
		return;
	}

	this(GpuTextureTransferBuffer texture_transfer_buffer, uint offset)
	{
		this.transfer_buffer = texture_transfer_buffer.handle;
		this.offset = offset;
		return;
	}
}

struct GpuTransferBufferCreateInfo
{
	GpuTransferBufferUsage usage;
	uint size;

	SDL_PropertiesID props;
}

struct GpuVertexBufferDescription
{
	uint slot;
	uint pitch;
	GpuVertexInputRate input_rate;
	uint instance_step_rate;
}

struct GpuVertexAttribute
{
	uint location;
	uint buffer_slot;
	GpuVertexElementFormat format;
	uint offset;

	this(
		uint location,
		uint buffer_slot,
		GpuVertexElementFormat format,
		uint offset,
	)
	{
		this.location = location;
		this.buffer_slot = buffer_slot;
		this.format = format;
		this.offset = offset;
		return;
	}

	this(GpuVertexElementFormat format, uint buffer_slot = 0)
	{
		this.format = format;
		this.buffer_slot = buffer_slot;
		return;
	}

	this(
		GpuVertexElementFormat format,
		uint buffer_slot,
		uint location,
		uint offset,
	)
	{
		this.format = format;
		this.buffer_slot = buffer_slot;
		this.location = location;
		this.offset = offset;
		return;
	}
}

struct GpuVertexInputState
{
	GpuVertexBufferDescription* vertex_buffer_descriptions;
	uint num_vertex_buffers;
	GpuVertexAttribute* vertex_attributes;
	uint num_vertex_attributes;

	this(
		in GpuVertexBufferDescription[] description,
		in GpuVertexAttribute[] attribute
	)
	in (description.length < uint.max)
	in (attribute.length < uint.max)
	{
		this.vertex_buffer_descriptions = cast(GpuVertexBufferDescription*) description;
		this.num_vertex_buffers = cast(uint) description.length;
		this.vertex_attributes = cast(GpuVertexAttribute*) attribute;
		this.num_vertex_attributes = cast(uint) attribute.length;
		return;
	}

	typeof(this) position_color_texture()
	{
		this.vertex_buffer_descriptions = cast(GpuVertexBufferDescription*)[
			GpuVertexBufferDescription(
				0, VertexPCT.sizeof, GpuVertexInputRate.vertex, 0
			)
		];
		this.num_vertex_buffers = 1u;
		this.vertex_attributes = cast(GpuVertexAttribute*)[
			GpuVertexAttribute(
				0, 0, GpuVertexElementFormat.float3, 0
			),
			GpuVertexAttribute(
				1, 0, GpuVertexElementFormat.float4, float.sizeof * 3
			),
			GpuVertexAttribute(
				2, 0, GpuVertexElementFormat.float2, float.sizeof * 7
			),
		];
		this.num_vertex_attributes = 3u;
		return this;
	}
}

struct GpuViewport
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

struct GpuTransferBufferLocation
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
		in GpuBufferTransferBuffer transfer_buffer,
		ulong offset = 0u,
	)
	in (transfer_buffer.handle !is null)
	in (offset <= uint.max)
	{
		this.transfer_buffer = cast(SDL_GPUTransferBuffer*) transfer_buffer.handle;
		this.offset = cast(uint) offset;
		return;
	}
}

struct GpuBufferRegion
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
		in GpuBuffer buffer,
		uint offset = 0,
	)
	in (buffer.handle !is null)
	{
		this.buffer = cast(SDL_GPUBuffer*) buffer.handle;
		this.offset = offset;
		this.size = cast(uint) buffer.size;
		return;
	}

	this(
		GpuBuffer buffer,
		uint offset,
		ulong size,
	)
	in (buffer.handle !is null)
	in (size <= uint.max)
	{
		this.buffer = buffer.handle;
		this.offset = offset;
		this.size = cast(uint) size;
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
				"assert( Gpu%s.sizeof == SDL_GPU%s.sizeof, \"Gpu%s != SDL_GPU...\");",
				symbol, symbol, symbol,
		)
		);
	}
}
