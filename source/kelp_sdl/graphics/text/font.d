module kelp_sdl.graphics.text.font;

import bindbc.sdl;

import std.exception;
import std.string : toStringz, fromStringz;

class GPUTextFont
{
	TTF_Font* font_handle;

	this()
	{
		return;
	}

	@property inout(TTF_Font*) handle() inout pure nothrow @nogc @safe
	{
		return this.font_handle;
	}

	typeof(this) create(string font_uri, float font_size)
	{
		font_handle = TTF_OpenFont(toStringz(font_uri), font_size);
		enforce(font_handle !is null);
		return this;
	}

	typeof(this) release()
	{
		TTF_CloseFont(this.font_handle);
		this.font_handle = null;
		return this;
	}

	string style_name()
	in (this.font_handle !is null)
	{
		return cast(string) TTF_GetFontStyleName(this.font_handle).fromStringz();
	}

	string family_name()
	in (this.font_handle !is null)
	{
		return cast(string) TTF_GetFontFamilyName(this.font_handle).fromStringz();
	}
}
