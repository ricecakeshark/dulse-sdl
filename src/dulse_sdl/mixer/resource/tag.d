module dulse_sdl.mixer.resource.tag;

import dulse_sdl.mixer.resource;
import dulse_sdl.core.util;
import sdl_mixer,sdl.properties;
import std.string : toStringz;

struct AudioTag
{
	string tag;
	Mixer mixer;
	Track[] tagged_track_list;
	float _gain;

	this(string tag) pure nothrow @nogc @safe
	{
		this.tag = tag;
		return;
	}

	this(string tag, Mixer mixer) pure nothrow @nogc @safe
	{
		this.tag = tag;
		this.mixer = mixer;
		return;
	}

	@property float gain()
	{
		return this._gain;
	}

	@property float gain(float gain)
	{
		this._gain = gain;
		return MIX_SetTagGain(this.mixer.handle, tag.toStringz(), gain);
	}

	typeof(this) play()
	{
		MIX_PlayTag(this.mixer.handle, this.tag.toStringz, cast(SDL_PropertiesID) 0,);
		return this;
	}

	typeof(this) stop(long fade_out_ms = 0)
	{
		MIX_StopTag(this.mixer.handle, this.tag.toStringz, fade_out_ms)
			.expect_sdl("failed to stop with tag");
		return this;
	}

}

/+AudioTag audio_tag()
{

}+/
