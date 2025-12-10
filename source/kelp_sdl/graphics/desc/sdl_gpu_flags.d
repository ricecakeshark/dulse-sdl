module kelp_sdl.graphics.desc.sdl_gpu_flags;

enum GPUColorComponentFlags : uint
{
	r = 1u << 0,
	g = 1u << 1,
	b = 1u << 2,
	a = 1u << 3,
}

enum GPUShaderFormat : uint
{
	invalid = 0,
	_private = (1u << 0),
	spirv = (1u << 1),
	dxbc = (1u << 2),
	dxil = (1u << 3),
	msl = (1u << 4),
	matllib = (1u << 5),
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
