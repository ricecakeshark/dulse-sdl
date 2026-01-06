module kelp_sdl.graphics.text.text;

import kelp_core.core;
import kelp_sdl.core.util;
import kelp_sdl.graphics.text;

import bindbc.sdl;

import std.exception : enforce;
import std.string : toStringz;

class GPUText
{
	TTF_Text* text_handle;
	GPUTextEngine text_engine;
	GPUTextFont text_font;

	this(GPUTextEngine engine, GPUTextFont font)
	{
		this.text_engine = engine;
		this.text_font = font;
		return;
	}

	typeof(this) create(string text_string)
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
		TTF_Destroy(this.text_handle);
		this.text_handle = null;
		return this;
	}

	typeof(this) set_color(ColorU color)
	in (this.text_handle !is null)
	{
		TTF_SetTextColor(
			this.text_handle, color.red, color.green, color.blue, color.alpha
		).catchSDLError();
		return this;
	}
}
