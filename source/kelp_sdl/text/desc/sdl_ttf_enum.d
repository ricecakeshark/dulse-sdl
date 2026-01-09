module kelp_sdl.text.desc.sdl_ttf_enum;

enum FontDirection : uint
{
	invalid = 0,
	LTR = 4,
	RTL = 5,
	TTB = 6,
	BTT = 7,
}

enum FontAlign : int
{
	invalid = -1,
	left = 0,
	center,
	right,
}
