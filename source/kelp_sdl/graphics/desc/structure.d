module kelp_sdl.graphics.desc.structure;

struct PositionVertex
{
	float x, y, z;
}

struct PositionColorVertex
{
	float x, y, z;
	ubyte r, g, b, a;
}

struct PositionTextureVertex
{
	float x, y, z;
	float u, v;
}
