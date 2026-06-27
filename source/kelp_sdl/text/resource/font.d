module kelp_sdl.text.resource.font;

import bindbc.sdl;
import kelp_sdl.core.util : catchSDLError;
import kelp_sdl.text;

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

	typeof(this) create(in string font_uri, in float font_size)
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

	// font wrap align
	@property TextAlign wrap_align()
	{
		return cast(TextAlign) TTF_GetFontWrapAlignment(this.font_handle);
	}

	typeof(this) set(TextAlign font_align)
	{
		TTF_SetFontWrapAlignment(
			this.font_handle, cast(TTF_HorizontalAlignment) font_align
		);
		return this;
	}
	// Direction
	@property TextDirection direction()
	{
		return cast(TextDirection) TTF_GetFontDirection(this.font_handle);
	}

	typeof(this) set(TextDirection font_direction)
	{
		TTF_SetFontDirection(this.font_handle, cast(TTF_Direction) font_direction)
			.catchSDLError();
		return this;
	}
	// Hinting
	@property FontHinting hinting()
	{
		return cast(FontHinting) TTF_GetFontHinting(this.font_handle);
	}

	typeof(this) set(FontHinting font_hinting)
	{
		TTF_SetFontHinting(this.font_handle, cast(TTF_HintingFlags) font_hinting);
		return this;
	}
	// SDF
	@property bool SDF()
	{
		return TTF_GetFontSDF(this.font_handle);
	}

	typeof(this) set_SDF(in bool mode_SDF = true)
	{
		TTF_SetFontSDF(this.font_handle, mode_SDF)
			.catchSDLError();
		return this;
	}
	// Size
	@property float size()
	{
		return cast(FontHinting) TTF_GetFontSize(this.font_handle);
	}

	typeof(this) get_size(out float size)
	{
		size = TTF_GetFontSize(this.font_handle);
		return this;
	}

	typeof(this) set_size(in float font_size)
	{
		TTF_SetFontSize(this.font_handle, font_size)
			.catchSDLError();
		return this;
	}
	// string size
	typeof(this) get_string_size(in string text, out int w, out int h)
	{
		TTF_GetStringSize(this.font_handle, toStringz(text), text.length, &w, &h)
			.catchSDLError();
		return this;
	}

	// Style
	@property FontStyle style()
	{
		return cast(FontStyle) TTF_GetFontStyle(this.font_handle);
	}

	typeof(this) set(FontStyle font_style)
	{
		TTF_SetFontStyle(this.font_handle, font_style);
		return this;
	}
}
