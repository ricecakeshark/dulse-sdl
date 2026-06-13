module kelp_sdl.mixer.resource.audio;

import bindbc.sdl;
import kelp_sdl.mixer;
import std.exception : enforce;
import std.string : toStringz;

class Audio
{
	protected MIX_Audio* _handle;
	protected Mixer mixer;

	this(Mixer mixer)
	{
		enforce(this.mixer.is_valid());
		this.mixer = mixer;
		return;
	}

	@property inout(MIX_Audio*) handle() inout pure nothrow @nogc @safe
	{
		return this._handle;
	}

	@property bool is_valid()
	{
		return this._handle !is null;
	}

	typeof(this) load(string path)
	{
		this._handle = MIX_LoadAudio(this.mixer.handle, path.toStringz, true);
		enforce(this._handle !is null);
		return this;
	}

	typeof(this) release()
	{
		if (this._handle is null)
		{
			return this;
		}
		MIX_DestroyAudio(this._handle);
		this._handle = null;
		return this;
	}
}
