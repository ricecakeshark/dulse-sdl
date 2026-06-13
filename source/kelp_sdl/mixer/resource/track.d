module kelp_sdl.mixer.resource.track;

import bindbc.sdl;
import kelp_sdl.mixer;
import std.exception : enforce;

class Track
{
	protected MIX_Track* _handle;
	protected Mixer mixer;

	this(Mixer mixer)
	{
		this.mixer = mixer;
		return;
	}

	@property inout(MIX_Track*) handle() inout pure nothrow @nogc @safe
	{
		return this._handle;
	}

	@property bool is_valid()
	{
		return this._handle !is null;
	}

	typeof(this) create()
	{
		this._handle = MIX_CreateTrack(this.mixer.handle);
		enforce(this._handle !is null);
		return this;
	}

	typeof(this) release()
	{
		if (this._handle is null)
		{
			return this;
		}
		MIX_DestroyTrack(this._handle);
		this._handle = null;
		return this;
	}

	typeof(this) play()
	{
		scope bool succeed;
		succeed = MIX_PlayTrack(this._handle, cast(SDL_PropertiesID) 0);
		return this;
	}
}
