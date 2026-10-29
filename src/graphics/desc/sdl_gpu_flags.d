module dulse_sdl.graphics.desc.sdl_gpu_flags;

enum GpuBufferUsageFlags : uint
{
	vertex = 1u << 0,
	index = 1u << 1,
	indirect = 1u << 2,
	graphics_storage_read = 1u << 3,
	compute_storage_read = 1u << 4,
	compute_storage_write = 1u << 5,
}

enum GpuColorComponentFlags : ubyte
{
	r = 1u << 0,
	g = 1u << 1,
	b = 1u << 2,
	a = 1u << 3,
}

enum GpuShaderFormat : uint
{
	invalid = 0,
	_private = (1u << 0),
	spirv = (1u << 1),
	dxbc = (1u << 2),
	dxil = (1u << 3),
	msl = (1u << 4),
	metallib = (1u << 5),
}

enum GpuTextureUsageFlags : uint
{
	sampler = 1u << 0,
	color_target = 1u << 1,
	depth_stencil_target = 1u << 2,
	graphics_storage_read = 1u << 3,
	compute_storage_read = 1u << 4,
	compute_storage_write = 1u << 5,
	compute_storage_simultaneous_read_write = 1u << 6
}
