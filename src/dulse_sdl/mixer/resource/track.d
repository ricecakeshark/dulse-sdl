module dulse_sdl.mixer.resource.track;

import sdl.audio, sdl.properties;
import sdl_mixer;
import dulse.core.util;
import dulse.math.linalg.vector;
import dulse_sdl.core.util;
import dulse_sdl.mixer;
import std.exception : enforce;
import std.string : toStringz;

class Track
{
	protected MIX_Track* _handle;
	protected Mixer mixer;

	this(Mixer mixer)
	{
		this.mixer = mixer;
		return;
	}

	invariant
	{
		assert(this !is null, "this is null");
	}

	@property inout(MIX_Track*) handle() inout pure nothrow @nogc @safe
	{
		return this._handle;
	}

	@property bool is_valid() pure nothrow @nogc @safe
	{
		return (this._handle !is null);
	}

	@property float gain()
	{
		enforce(this.is_valid, "handle is null");
		return MIX_GetTrackGain(this._handle);
	}

	@property float gain(float gain)
	{
		enforce(this.is_valid, "handle is null");
		MIX_SetTrackGain(this._handle, gain);
		return gain;
	}

	@property int loop()
	{
		enforce(this.is_valid, "handle is null");
		return MIX_GetTrackLoops(this._handle);
	}

	@property int loop(int loop_count)
	{
		enforce(this.is_valid, "handle is null");
		return MIX_SetTrackLoops(this._handle, loop_count);
	}

	@property bool playing()
	{
		enforce(this.is_valid, "handle is null");
		return MIX_TrackPlaying(this._handle);
	}

	@property bool paused()
	{
		enforce(this.is_valid, "handle is null");
		return MIX_TrackPaused(this._handle);
	}

	@property Vec3 pos()
	{
		enforce(this.is_valid, "handle is null");
		scope MIX_Point3D _pos = MIX_Point3D(0.0f, 0.0f, 0.0f);
		MIX_GetTrack3DPosition(this._handle, &_pos)
			.expect_sdl("failed to get track 3d position");
		return _pos.to_vec3();
	}

	@property Vec3 pos(Vec3 pos)
	{
		enforce(this.is_valid, "handle is null");
		scope MIX_Point3D _pos = pos.from_vec3();
		MIX_GetTrack3DPosition(this._handle, &_pos)
			.expect_sdl("failed to set track 3d position");
		return pos;
	}

	typeof(this) create()
	{
		if (this._handle !is null)
		{
			return this;
		}
		this._handle = MIX_CreateTrack(this.mixer.handle);
		enforce(this._handle !is null);
		return this;
	}

	typeof(this) release() @trusted
	{
		if (this._handle is null)
		{
			return this;
		}
		MIX_DestroyTrack(this._handle);
		this._handle = null;
		return this;
	}

	typeof(this) set(Audio audio)
	{
		MIX_SetTrackAudio(this.handle, audio.handle)
			.expect_sdl("failed to set audio to track");
		return this;
	}

	typeof(this) set(SDL_AudioStream* stream_handle)
	{
		MIX_SetTrackAudioStream(this.handle, stream_handle)
			.expect_sdl("failed to set audio to track");
		return this;
	}

	typeof(this) play()
	{
		enforce(this.is_valid, "cannot play, the track is not valid");
		MIX_PlayTrack(this._handle, cast(SDL_PropertiesID) 0)
			.expect_sdl("failed to play track");
		return this;
	}

	typeof(this) stop(long fade_out_ms = 0,)
	{
		enforce(this.is_valid, "cannot stop, the track is not valid");
		MIX_StopTrack(this._handle, fade_out_ms,)
			.expect_sdl("failed to stop track");
		return this;
	}

	typeof(this) pause()
	{
		enforce(this.is_valid, "cannot pause, the track is not valid");
		MIX_PauseTrack(this._handle,)
			.expect_sdl("failed to pause track");
		return this;
	}

	typeof(this) resume()
	{
		enforce(this.is_valid, "cannot resume, the track is not valid");
		MIX_ResumeTrack(this._handle,)
			.expect_sdl("failed to resume track");
		return this;
	}

	typeof(this) tag(in string tag_name, out AudioTag tag)
	{
		enforce(this.is_valid, "cannot set tag, the track is not valid");
		MIX_TagTrack(this._handle, tag_name.toStringz())
			.expect_sdl("failed to set tag to track");
		tag = AudioTag(tag_name, this.mixer);
		return this;
	}

	typeof(this) tag(in string tag_name)
	{
		enforce(this.is_valid, "cannot set tag, the track is not valid");
		MIX_TagTrack(this._handle, tag_name.toStringz())
			.expect_sdl("failed to set tag to track");
		return this;
	}

	typeof(this) set_loop(int num_loop)
	{
		enforce(this.is_valid, "cannot set tag, the track is not valid");
		MIX_SetTrackLoops(this._handle, num_loop)
			.expect_sdl("failed to set tag to track");
		return this;
	}

	typeof(this) set_gain(in float gain)
	{
		enforce(this.is_valid, "handle is null");
		MIX_SetTrackGain(this._handle, gain);
		return this;
	}
}

Vec3 to_vec3(in MIX_Point3D point) pure nothrow @nogc @safe
{
	return Vec3(point.x, point.y, point.z);
}

MIX_Point3D from_vec3(in Vec3 pos) pure nothrow @nogc @safe
{
	return MIX_Point3D(pos.x, pos.y, pos.z);
}
