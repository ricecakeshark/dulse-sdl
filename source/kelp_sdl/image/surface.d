module kelp_sdl.image.surface;

import bindbc.sdl;
import kelp_sdl.image;

import std.string : toStringz;
import std.exception;
import std.file : isFile;

class Surface
{
	SDL_Surface* surface_handle;
	bool succeed;

	this()
	{
		return;
	}

	~this()
	{
		return;
	}

	@property inout(SDL_Surface*) handle() inout pure nothrow @nogc @safe
	{
		return this.surface_handle;
	}

	@property int width() const pure nothrow @nogc @safe
	{
		return this.surface_handle.w;
	}

	@property int height() const pure nothrow @nogc @safe
	{
		return this.surface_handle.h;
	}

	@property int pitch() const pure nothrow @nogc @safe
	{
		return this.surface_handle.pitch;
	}

	@property void* data_ptr()
	{
		return this.surface_handle.pixels;
	}

	@property size_t size() const pure nothrow @nogc @safe
	{
		return (this.width * this.height * 4);
	}

	@property SurfaceFlags flag()
	{
		return cast(SurfaceFlags) this.surface_handle.flags;
	}

	typeof(this) create(int width, int height)
	in (this.surface_handle is null)
	{
		this.surface_handle = SDL_CreateSurface(width, height, SDL_PIXELFORMAT_RGBA32);
		enforce(this.surface_handle !is null);
		return this;
	}

	typeof(this) load(string file_uri)
	in (this.surface_handle is null)
	{
		enforce(isFile(file_uri), "the file is not exsist");
		this.surface_handle = IMG_Load(file_uri.toStringz());
		//this.surface_handle = SDL_LoadBMP(file_uri.toStringz());
		enforce(this.surface_handle !is null);
		return this;
	}

	typeof(this) load_for_gpu(string file_uri)
	in (this.surface_handle is null)
	{
		enforce(isFile(file_uri), "the file is not exsist");
		this.surface_handle = IMG_Load(file_uri.toStringz());
		//this.surface_handle = SDL_LoadBMP(file_uri.toStringz());
		enforce(this.surface_handle !is null);

		if (this.surface_handle.format != SDL_PIXELFORMAT_ABGR8888)
		{
			SDL_Surface* temp_handle;
			temp_handle = SDL_ConvertSurface(this.surface_handle, SDL_PIXELFORMAT_ABGR8888);
			SDL_DestroySurface(this.surface_handle);
			this.surface_handle = temp_handle;
		}
		return this;
	}

	typeof(this) release()
	{
		SDL_DestroySurface(this.surface_handle);
		this.surface_handle = null;
		return this;
	}

	int[4] opIndex(size_t x, size_t y)
	{
		int[4] temp;
		ubyte[] data;
		data = cast(ubyte[])(this.data_ptr[0 .. width * height * 4]);
		temp[0] = data[y * pitch + x * 4];
		temp[1] = data[y * pitch + x * 4 + 1];
		temp[2] = data[y * pitch + x * 4 + 2];
		temp[3] = data[y * pitch + x * 4 + 3];
		return temp;
	}

	/+typeof(this) save(string uri)
	in (this.surface_handle !is null)
	{
		succeed = IMG_Save(this.surface_handle, uri.toStringz());
		enforce(succeed);
		return this;
	}+/

	typeof(this) convert(SdlPixelFormat format)
	in (this.surface_handle !is null)
	{
		this.surface_handle = SDL_ConvertSurface(
			this.surface_handle, cast(SDL_PixelFormat) format
		);
		enforce(this.surface_handle !is null);
		return this;
	}

	typeof(this) clear(float r, float g, float b, float a)
	in (this.surface_handle !is null)
	{
		succeed = SDL_ClearSurface(
			this.surface_handle, r, g, b, a
		);
		return this;
	}

	typeof(this) set_blend_mode()
	in (this.surface_handle !is null)
	{
		SDL_SetSurfaceBlendMode(this.surface_handle, SDL_BLENDMODE_BLEND);
		return this;
	}
}
