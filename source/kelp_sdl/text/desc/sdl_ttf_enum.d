module kelp_sdl.text.desc.sdl_ttf_enum;

enum TextDirection : uint
{
	invalid = 0,
	LTR = 4,
	RTL = 5,
	TTB = 6,
	BTT = 7,
}

enum TextAlign : int
{
	invalid = -1,
	left = 0,
	center,
	right,
}

enum TextEngineWinding
{
	invalid = -1,
	clockwise,
	counter_clockwise,
}
