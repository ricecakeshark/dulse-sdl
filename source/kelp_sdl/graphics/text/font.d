module kelp_sdl.graphics.text.font;

import bindbc.sdl;
import kelp_sdl.core.util : catchSDLError;
import sdl_ttf;

import std.exception;
import std.string : toStringz, fromStringz;

class TextFont
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

	typeof(this) set_SDF()
	{
		TTF_SetFontSDF(this.font_handle, true)
			.catchSDLError();
		return this;
	}

	typeof(this) set_align()
	{
		TTF_SetFontWrapAlignment(this.font_handle, TTF_HORIZONTAL_ALIGN_CENTER);
		return this;
	}
}
