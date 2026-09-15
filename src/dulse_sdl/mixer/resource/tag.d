module dulse_sdl.mixer.resource.tag;

import dulse_sdl.mixer.resource;
import dulse_sdl.core.util;
import dulse.core.util;
import sdl_mixer, sdl.properties;
import std.string : toStringz;

struct AudioTag
{
	string tag_name;
	Mixer mixer;
	Track[] tagged_track_list;
	float _gain;

	this(string tag_name) pure nothrow @nogc @safe
	{
		this.tag_name = tag_name;
		return;
	}

	this(string tag_name, Mixer mixer) pure nothrow @nogc @safe
	{
		this.tag_name = tag_name;
		this.mixer = mixer;
		return;
	}

	@property bool is_valid() pure nothrow @nogc @safe
	{
		return (this.mixer !is null && this.mixer.is_valid);
	}


	@property string name() pure nothrow @nogc @safe
	{
		return this.tag_name;
	}
	@property float gain()
	{
		return this._gain;
	}

	@property float gain(float gain)
	{
		this._gain = gain;
		return MIX_SetTagGain(this.mixer.handle, this.tag_name.toStringz(), gain);
	}

	typeof(this) play()
	{
		if (expect(this.is_valid, "cannot play with tag"))
		{
			return this;
		}
		MIX_PlayTag(this.mixer.handle, this.tag_name.toStringz, cast(SDL_PropertiesID) 0,)
			.expect_sdl("failed to play with tag");
		return this;
	}

	typeof(this) stop(long fade_out_ms = 0)
	{
		if (expect(this.is_valid, "cannot stop with tag"))
		{
			return this;
		}
		MIX_StopTag(this.mixer.handle, this.tag_name.toStringz, fade_out_ms,)
			.expect_sdl("failed to stop with tag");
		return this;
	}

	typeof(this) pause()
	{
		if (expect(this.is_valid, "cannot pause with tag"))
		{
			return this;
		}
		MIX_PauseTag(this.mixer.handle, this.tag_name.toStringz,)
			.expect_sdl("failed to pause with tag");
		return this;
	}

	typeof(this) resume()
	{
		if (expect(this.is_valid, "cannot resume with tag"))
		{
			return this;
		}
		MIX_ResumeTag(this.mixer.handle, this.tag_name.toStringz,)
			.expect_sdl("failed to resume with tag");
		return this;
	}

}

/+AudioTag audio_tag()
{

}+/
