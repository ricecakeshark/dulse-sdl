module kelp_sdl.graphics.desc.param;

struct GPUShaderArguments
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
}
