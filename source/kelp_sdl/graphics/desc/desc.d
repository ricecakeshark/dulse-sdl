module kelp_sdl.graphics.desc.desc;

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

enum GPUFrontFace
{
	counter_clockwise,
	clockwise
}

enum GPUSampleCount
{
	x1,
	x2,
	x4,
	x8
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

enum GPUTextureUsageFlags : uint
{
	sampler = 1u << 0,
	color_target = 1u << 1,
	depth_stencil_target = 1u << 2,
	graphics_storage_read = 1u << 3,
	compute_storage_read = 1u << 4,
	compute_storage_write = 1u << 5,
	compute_storage_simultaneous_read_write = 1u << 6
}
