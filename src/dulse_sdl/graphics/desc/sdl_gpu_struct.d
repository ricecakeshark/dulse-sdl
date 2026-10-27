module dulse_sdl.graphics.desc.sdl_gpu_struct;

import sdl.gpu;
import sdl.properties;
import dulse.core.data;
import dulse.graphics;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource;
import dulse_sdl.video.surface.desc : SdlFlipMode;

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
		GpuLoadOp load_op = GpuLoadOp.dont_care,
		Color color = Color(0.0f, 0.0f, 0.0f, 1.0f),
	) pure nothrow @nogc @safe
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
	) pure nothrow @nogc @safe
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
	) pure nothrow @nogc @safe
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
	) pure nothrow @nogc @safe
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

	this(GpuBuffer buffer, in uint offset = 0) pure nothrow @nogc @safe
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

	this(in GpuBufferUsageFlags flags, in size_t size) pure nothrow @nogc @safe
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

	this(
		GpuAbstractTexture texture,
		in GpuLoadOp load_op, in GpuStoreOp store_op,
		in Color clear_color = Color(0.0f, 0.0f, 0.0f, 1.0f),
	) pure nothrow @nogc @safe
	{
		this.texture = texture.handle;
		this.load_op = load_op;
		this.store_op = store_op;
		this.clear_color = clear_color;
		return;
	}

	this(GpuAbstractTexture texture, in GpuLoadOp load_op, in GpuStoreOp store_op) pure nothrow @nogc @safe
	{
		this.texture = texture.handle;
		this.load_op = load_op;
		this.store_op = store_op;
		return;
	}

	this(
		GpuAbstractTexture texture,
		in uint mip_level = 0,
		in uint depth = 0,
		in ColorF clear_color = ColorF(1.0f, 0.0f, 1.0f, 0.0f),
		in GpuLoadOp load_op = GpuLoadOp.load,
		in GpuStoreOp store_op = GpuStoreOp.store,
	) pure nothrow @nogc @safe
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

	this(ShaderFile shader_file) pure nothrow @nogc
	{
		this.code_size = shader_file.code.length;
		this.code = cast(const(ubyte)*) shader_file.code;
		this.entrypoint = shader_file.entry_point.ptr;
		this.format = cast(GpuShaderFormat) shader_file.frontend_format;
		return;
	}

	this(typeof(this.tupleof[0 .. $ - 1]) args) pure nothrow @nogc @safe
	{
		foreach (count, arg; args)
		{
			this.tupleof[count] = arg;
		}
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
	GpuLoadOp load_op = GpuLoadOp.dont_care;
	GpuStoreOp store_op = GpuStoreOp.dont_care;
	GpuLoadOp stencil_load_op = GpuLoadOp.dont_care;
	GpuStoreOp stencil_store_op = GpuStoreOp.dont_care;
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
	GpuPrimitiveType primitive_type;
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
	) pure nothrow @nogc
	in (description_list.length < uint.max)
	{
		this.color_target_descriptions = cast(GpuColorTargetDescription*) description_list.ptr;
		this.num_color_targets = cast(uint) description_list.length;
		return;
	}

	this(
		in GpuColorTargetDescription[] description_list,
		in GpuTextureFormat depth_stencil_format,
	) pure nothrow @nogc
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
	GpuFilter min_filter = GpuFilter.nearest;
	GpuFilter mag_filter = GpuFilter.nearest;
	GpuSamplerMipmapMode mipmap_mode = GpuSamplerMipmapMode.nearest;
	GpuSamplerAddressMode address_mode_u = GpuSamplerAddressMode.clamp_to_edge;
	GpuSamplerAddressMode address_mode_v = GpuSamplerAddressMode.clamp_to_edge;
	GpuSamplerAddressMode address_mode_w = GpuSamplerAddressMode.clamp_to_edge;
	float mip_lod_bias = 0.0f;
	float max_anisotropy = 1.0f;
	GpuCompareOp compare_op;
	float min_lod = 0.0f;
	float max_lod = 0.0f;
	bool enable_anisotropy;
	bool enable_compare;
	ubyte padding1;
	ubyte padding2;

	this(
		in GpuFilter min_filter,
		in GpuFilter mag_filter,
		in GpuSamplerAddressMode addres_mode = GpuSamplerAddressMode.clamp_to_edge,
	) pure nothrow @nogc @safe
	{
		this.min_filter = min_filter,
		this.mag_filter = mag_filter,
		this.address_mode_u = addres_mode;
		this.address_mode_v = addres_mode;
		this.address_mode_w = addres_mode;
		return;
	}
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
		in ShaderFile shader_file,
		in GpuShaderArguments shader_args
	) pure nothrow
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

	this(GpuBuffer buffer, in bool cycle = false) pure nothrow @nogc @safe
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

	this(GpuTexture texture) pure nothrow @nogc @safe
	{
		this.texture = texture.handle;
		return;
	}

	this(GpuTexture texture, in uint mip_level, in uint layer, in bool cycle = false) pure nothrow @nogc @safe
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
	GpuSampleCount sample_count = GpuSampleCount.x1;

	SDL_PropertiesID props;

	this(
		in GpuTextureType type,
		in GpuTextureFormat format,
		in GpuTextureUsageFlags usage,
		in uint width,
		in uint height,
		in uint layer_count_or_depth = 1,
		in uint num_levels = 1,
		GpuSampleCount sample_count = GpuSampleCount.x1,
	)
	in (format != GpuTextureFormat.invalid)
	{
		this.type = type;
		this.format = format;
		this.usage = usage;
		this.width = width;
		this.height = height;
		this.layer_count_or_depth = layer_count_or_depth;
		this.num_levels = num_levels;
		return;
	}
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

	this(GpuTexture texture) pure nothrow @nogc @safe
	{
		this.texture = texture.handle;
		this.w = texture.width;
		this.h = texture.height;
		this.d = 1u;
		return;
	}
}

struct GpuTextureSamplerBinding
{
	SDL_GPUTexture* texture;
	SDL_GPUSampler* sampler;

	this(SDL_GPUTexture* texture_handle, SDL_GPUSampler* sampler_handle) pure nothrow @nogc @safe
	in (texture_handle !is null)
	in (sampler_handle !is null)
	{
		this.texture = texture_handle;
		this.sampler = sampler_handle;
		return;
	}

	this(GpuTexture texture, GpuSampler sampler) pure nothrow @nogc @safe
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
		in uint width, in uint height, in uint offset = 0,
	) pure nothrow @nogc @safe
	{
		this.transfer_buffer = texture_transfer_buffer.handle;
		this.offset = offset;
		this.pixels_per_row = width;
		this.rows_per_layer = height;
		return;
	}

	this(GpuTextureTransferBuffer texture_transfer_buffer, in uint offset = 0) pure nothrow @nogc @safe
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
		in uint location,
		in uint buffer_slot,
		in GpuVertexElementFormat format,
		in uint offset,
	) pure nothrow @nogc @safe
	{
		this.location = location;
		this.buffer_slot = buffer_slot;
		this.format = format;
		this.offset = offset;
		return;
	}

	this(
		in GpuVertexElementFormat format,
		in uint buffer_slot,
		in uint location,
		in uint offset,
	) pure nothrow @nogc @safe
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
	) pure nothrow @nogc
	in (description.length < uint.max)
	in (attribute.length < uint.max)
	{
		this.vertex_buffer_descriptions = cast(GpuVertexBufferDescription*) description;
		this.num_vertex_buffers = cast(uint) description.length;
		this.vertex_attributes = cast(GpuVertexAttribute*) attribute;
		this.num_vertex_attributes = cast(uint) attribute.length;
		return;
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

	this(in float x, in float y, in float w, in float h) pure nothrow @nogc @safe
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
		in uint offset = 0,
	) pure nothrow @nogc @safe
	in (transfer_buffer_handle !is null)
	{
		this.transfer_buffer = transfer_buffer_handle;
		this.offset = offset;
		return;
	}

	this(
		GpuBufferTransferBuffer transfer_buffer,
		in ulong offset = 0u,
	) pure nothrow @nogc @safe
	in (transfer_buffer.handle !is null)
	in (offset <= uint.max)
	{
		this.transfer_buffer = transfer_buffer.handle;
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
		in uint offset,
		in uint size,
	) pure nothrow @nogc @safe
	in (buffer_handle !is null)
	{
		this.buffer = buffer_handle;
		this.offset = offset;
		this.size = size;
		return;
	}

	this(
		GpuBuffer buffer,
		in uint offset = 0,
	) pure nothrow @nogc @safe
	in (buffer.handle !is null)
	{
		this.buffer = buffer.handle;
		this.offset = offset;
		this.size = cast(uint) buffer.size;
		return;
	}

	this(
		GpuBuffer buffer,
		in uint offset,
		in ulong size,
	) pure nothrow @nogc @safe
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
			"PrimitiveType", "ColorTargetInfo", "ColorTargetDescription",
			"LoadOp",
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
/+
static foreach (str; [
		"GraphicsPipelineCreateInfo", "GraphicsPipelineTargetInfo"
	])
{
	mixin("alias " ~ str ~ " = Gpu" ~ str ~ ";\n");
}+/
