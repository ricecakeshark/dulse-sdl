module dulse_sdl.text.desc.sdl_ttf_flags;

enum FontHinting : uint
{
	normal = 0,
	light = 1u << 0,
	mono = 1u << 1,
	none = 1u << 2,
	light_subpixel = 1u << 3,
}

enum FontStyle : uint
{
	normal = 0,
	bold = 1u << 0,
	italic = 1u << 1,
	underline = 1u << 2,
	strikethrough = 1u << 3,
}
