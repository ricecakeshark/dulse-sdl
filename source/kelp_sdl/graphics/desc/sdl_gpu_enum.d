module kelp_sdl.graphics.desc.sdl_gpu_enum;

enum GPUBlendFactor
{
	invalid,
	zero, /**< 0 */
	one, /**< 1 */
	src_color, /**< source color */
	one_minus_src_color, /**< 1 - source color */
	dst_color, /**< destination color */
	one_minus_dst_color, /**< 1 - destination color */
	src_alpha, /**< source alpha */
	one_minus_src_alpha, /**< 1 - source alpha */
	dst_alpha, /**< destination alpha */
	one_minus_dst_alpha, /**< 1 - destination alpha */
	constant_color, /**< blend constant */
	one_minus_constant_color, /**< 1 - blend constant */
	src_alpha_saturate /**< min(source alpha, 1 - destination alpha) */
}

enum GPUBlendOp
{
	invalid,
	add,
	subtract,
	reverse_subtract,
	min,
	max
}

enum GPUCompareOp
{
	invalid,
	never, // = false
	less, // <
	equal, // ==
	less_or_eqaul, // <=
	greater, // >
	not_equal, // !=
	greater_or_equal, // >=
	always,
}

enum GPUCullMode
{
	none,
	front,
	back
}

enum GPUFillMode
{
	fill,
	line
}

enum GPUFilter
{
	nearest,
	linear,
}

enum GPUFrontFace
{
	counter_clockwise,
	clockwise
}

enum GPUPrimitiveType
{
	triangle_list,
	triangle_strip,
	line_list,
	line_strip,
	point_list,
}

enum GPUSampleCount
{
	x1,
	x2,
	x4,
	x8
}

enum GPUSamplerAddressMode
{
	repeat,
	mirrored_repeat,
	clamp_to_edge,
}

enum GPUSamplerMipmapMode
{
	nearest,
	linear,
}

enum GPUShaderStage
{
	vertex,
	fragment,
}

enum GPUStencilOp
{
	invalid,
	keep,
	zero,
	replace,
	increment_and_clamp,
	decrement_and_clamp,
	invert,
	increment_and_wrap,
	decrement_and_wrap,
}

enum GPUTextureFormat
{
	invalid,

	/* unsigned normalized float color formats */
	a8_unorm,
	r8_unorm,
	r8g8_unorm,
	r8g8b8a8_unorm,
	r16_unorm,
	r16g16_unorm,
	r16g16b16a16_unorm,
	r10g10b10a2_unorm,
	b5g6r5_unorm,
	b5g5r5a1_unorm,
	b4g4r4a4_unorm,
	b8g8r8a8_unorm,
	/* compressed unsigned normalized float color formats */
	bc1_rgba_unorm,
	bc2_rgba_unorm,
	bc3_rgba_unorm,
	bc4_r_unorm,
	bc5_rg_unorm,
	bc7_rgba_unorm,
	/* compressed signed float color formats */
	bc6h_rgb_float,
	/* compressed unsigned float color formats */
	bc6h_rgb_ufloat,
	/* signed normalized float color formats  */
	r8_snorm,
	r8g8_snorm,
	r8g8b8a8_snorm,
	r16_snorm,
	r16g16_snorm,
	r16g16b16a16_snorm,
	/* signed float color formats */
	r16_float,
	r16g16_float,
	r16g16b16a16_float,
	r32_float,
	r32g32_float,
	r32g32b32a32_float,
	/* unsigned float color formats */
	r11g11b10_ufloat,
	/* unsigned integer color formats */
	r8_uint,
	r8g8_uint,
	r8g8b8a8_uint,
	r16_uint,
	r16g16_uint,
	r16g16b16a16_uint,
	r32_uint,
	r32g32_uint,
	r32g32b32a32_uint,
	/* signed integer color formats */
	r8_int,
	r8g8_int,
	r8g8b8a8_int,
	r16_int,
	r16g16_int,
	r16g16b16a16_int,
	r32_int,
	r32g32_int,
	r32g32b32a32_int,
	/* srgb unsigned normalized color formats */
	r8g8b8a8_unorm_srgb,
	b8g8r8a8_unorm_srgb,
	/* compressed srgb unsigned normalized color formats */
	bc1_rgba_unorm_srgb,
	bc2_rgba_unorm_srgb,
	bc3_rgba_unorm_srgb,
	bc7_rgba_unorm_srgb,
	/* depth formats */
	d16_unorm,
	d24_unorm,
	d32_float,
	d24_unorm_s8_uint,
	d32_float_s8_uint,
	/* compressed astc normalized float color formats*/
	astc_4x4_unorm,
	astc_5x4_unorm,
	astc_5x5_unorm,
	astc_6x5_unorm,
	astc_6x6_unorm,
	astc_8x5_unorm,
	astc_8x6_unorm,
	astc_8x8_unorm,
	astc_10x5_unorm,
	astc_10x6_unorm,
	astc_10x8_unorm,
	astc_10x10_unorm,
	astc_12x10_unorm,
	astc_12x12_unorm,
	/* compressed srgb astc normalized float color formats*/
	astc_4x4_unorm_srgb,
	astc_5x4_unorm_srgb,
	astc_5x5_unorm_srgb,
	astc_6x5_unorm_srgb,
	astc_6x6_unorm_srgb,
	astc_8x5_unorm_srgb,
	astc_8x6_unorm_srgb,
	astc_8x8_unorm_srgb,
	astc_10x5_unorm_srgb,
	astc_10x6_unorm_srgb,
	astc_10x8_unorm_srgb,
	astc_10x10_unorm_srgb,
	astc_12x10_unorm_srgb,
	astc_12x12_unorm_srgb,
	/* compressed astc signed float color formats*/
	astc_4x4_float,
	astc_5x4_float,
	astc_5x5_float,
	astc_6x5_float,
	astc_6x6_float,
	astc_8x5_float,
	astc_8x6_float,
	astc_8x8_float,
	astc_10x5_float,
	astc_10x6_float,
	astc_10x8_float,
	astc_10x10_float,
	astc_12x10_float,
	astc_12x12_float
}

enum GPUTextureType
{
	_2d,
	_2d_array,
	_3d,
	cube,
	cube_array
}

enum GPUVertexElementFormat
{
	invalid,

	/* 32-bit signed integers */
	int1,
	int2,
	int3,
	int4,

	/* 32-bit unsigned integers */
	uint1,
	uint2,
	uint3,
	uint4,

	/* 32-bit floats */
	float1,
	float2,
	float3,
	float4,

	/* 8-bit signed integers */
	byte2,
	byte4,

	/* 8-bit unsigned integers */
	ubyte2,
	ubyte4,

	/* 8-bit signed normalized */
	byte2_norm,
	byte4_norm,

	/* 8-bit unsigned normalized */
	ubyte2_norm,
	ubyte4_norm,

	/* 16-bit signed integers */
	short2,
	short4,

	/* 16-bit unsigned integers */
	ushort2,
	ushort4,

	/* 16-bit signed normalized */
	short2_norm,
	short4_norm,

	/* 16-bit unsigned normalized */
	ushort2_norm,
	ushort4_norm,

	/* 16-bit floats */
	half2,
	half4
}

enum GPUVertexInputRate
{
	vertex,
	instance,
}
