module kelp_sdl.graphics.desc.param;

struct GpuShaderArguments
{
	uint sampler_count;
	uint uniform_buffer_count;
	uint storage_buffer_count;
	uint storage_texture_count;
}

struct ParamPrimitive
{
	uint num_vertices;
	uint num_instances;
	uint first_vertex;
	uint first_instance;
}

struct ParamIndexedPrimitive
{
	uint num_indices;
	uint num_instances;
	uint first_index;
	int vertex_offset;
	uint first_instance;
}

struct ParamPrimitiveIndirect
{
	uint offset;
	uint draw_count;

	this(ulong offset, ulong draw_count)
	in (offset <= uint.max)
	in (draw_count <= uint.max)
	{
		this.offset = cast(uint) offset;
		this.draw_count = cast(uint) draw_count;
		return;
	}
}
