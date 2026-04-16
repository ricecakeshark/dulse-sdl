module kelp_sdl.text.text;

import kelp_core.core;
import kelp_sdl.core.util;
import kelp_sdl.text;
import kelp_sdl.image;

import bindbc.sdl;

import std.exception : enforce;
import std.string : toStringz;

abstract class AbstractText
{
	TTF_Text* text_handle;
	AbstractTextEngine text_engine;
	TextFont text_font;

	typeof(this) create(in string text_string)
	{
		this.text_handle = TTF_CreateText(
			this.text_engine.handle, this.text_font.handle,
			text_string.toStringz(), text_string.length,
		);
		enforce(this.text_handle !is null);
		return this;
	}

	typeof(this) release()
	{
		TTF_DestroyText(this.text_handle);
		this.text_handle = null;
		return this;
	}

	// text color
	typeof(this) get(out ColorF color)
	{
		TTF_GetTextColorFloat(
			this.text_handle, &(color.red), &(color.green), &(color.blue), &(color.alpha)
		).catchSDLError();
		return this;
	}

	typeof(this) get(out ColorU color)
	{
		TTF_GetTextColor(
			this.text_handle, &(color.red), &(color.green), &(color.blue), &(color.alpha)
		).catchSDLError();
		return this;
	}

	typeof(this) set(in ColorF color)
	in (this.text_handle !is null)
	{
		TTF_SetTextColorFloat(
			this.text_handle, color.red, color.green, color.blue, color.alpha
		).catchSDLError();
		return this;
	}

	typeof(this) set(in ColorU color)
	in (this.text_handle !is null)
	{
		TTF_SetTextColor(
			this.text_handle, color.red, color.green, color.blue, color.alpha
		).catchSDLError();
		return this;
	}
	// text direction
	typeof(this) get(out TextDirection text_direction)
	{
		text_direction = cast(TextDirection) TTF_GetTextDirection(this.text_handle);
		return this;
	}

	typeof(this) set(in TextDirection text_direction)
	{
		TTF_SetTextDirection(
			this.text_handle, cast(TTF_Direction) text_direction
		).catchSDLError();
		return this;
	}
	// text position
	typeof(this) get_pos(out int[2] pos)
	in (this.text_handle !is null)
	{
		TTF_GetTextPosition(
			this.text_handle, &(pos[0]), &(pos[1]),
		).catchSDLError();
		return this;
	}

	typeof(this) set_pos(in int[2] pos)
	in (this.text_handle !is null)
	{
		TTF_SetTextPosition(
			this.text_handle, pos[0], pos[1],
		).catchSDLError();
		return this;
	}
	// text size
	typeof(this) get_size(out int w, out int h)
	{
		TTF_GetTextSize(this.text_handle, &w, &h)
			.catchSDLError();
		enforce(w >= 1);
		enforce(h >= 1);
		return this;
	}
	// text string
	// no getter string
	typeof(this) set_string(in string str)
	{
		TTF_SetTextString(
			this.text_handle, str.toStringz(), str.length
		).catchSDLError();
		return this;
	}
}

class GpuText : AbstractText
{
	this(GpuTextEngine engine, TextFont font)
	{
		this.text_engine = engine;
		this.text_font = font;
		return;
	}

	TTF_GPUAtlasDrawSequence* get_draw_data()
	out (draw_data_ptr; draw_data_ptr !is null)
	{
		return TTF_GetGPUTextDrawData(this.text_handle);
	}
}

class SurfaceText : AbstractText
{
	this(SurfaceTextEngine engine, TextFont font)
	{
		this.text_engine = engine;
		this.text_font = font;
		return;
	}

	typeof(this) draw(ref Surface surface, in int x = 0, in int y = 0)
	{
		TTF_DrawSurfaceText(this.text_handle, x, y, surface.handle)
			.catchSDLError();
		return this;
	}
}
