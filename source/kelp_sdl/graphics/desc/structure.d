module kelp_sdl.graphics.desc.structure;

struct Rect
{
	int x, y;
	int w, h;

	this(int x, int y, int w, int h)
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		return;
	}

	this(int w, int h)
	{
		this.w = w;
		this.h = h;
		return;
	}
}

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
