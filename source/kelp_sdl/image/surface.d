module kelp_sdl.image.surface;

import bindbc.sdl;
import kelp_core.core.data;
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

	@property inout(int) width() inout pure nothrow @nogc @safe
	{
		return this.surface_handle.w;
	}

	@property inout(int) height() inout pure nothrow @nogc @safe
	{
		return this.surface_handle.h;
	}

	@property inout(int) pitch() inout pure nothrow @nogc @safe
	{
		return this.surface_handle.pitch;
	}

	@property inout(SdlPixelFormat) format() inout pure nothrow @nogc @safe
	{
		return cast(SdlPixelFormat) this.surface_handle.format;
	}

	@property void* data_ptr()
	{
		return this.surface_handle.pixels;
	}

	@property inout(size_t) size() inout pure nothrow @nogc @safe
	{
		return (this.width * this.height * 4);
	}

	@property SurfaceFlags flag()
	{
		return cast(SurfaceFlags) this.surface_handle.flags;
	}

	typeof(this) create(
		in int width,
		in int height,
		in SDL_PixelFormat pixel_format = SDL_PIXELFORMAT_ABGR8888,
	)
	in (this.surface_handle is null)
	{
		this.surface_handle = SDL_CreateSurface(width, height, pixel_format);
		enforce(this.surface_handle !is null);
		return this;
	}

	typeof(this) load(in string file_uri)
	in (this.surface_handle is null)
	{
		enforce(isFile(file_uri), "the file is not exsist");
		this.surface_handle = IMG_Load(file_uri.toStringz());
		//this.surface_handle = SDL_LoadBMP(file_uri.toStringz());
		enforce(this.surface_handle !is null);
		return this;
	}

	typeof(this) load_for_gpu(in string file_uri)
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
			SDL_DestroySurface(temp_handle);
		}
		return this;
	}

	typeof(this) release()
	{
		SDL_DestroySurface(this.surface_handle);
		this.surface_handle = null;
		return this;
	}

	int[4] opIndex(in size_t x, in size_t y)
	in (this.surface_handle !is null)
	in (x <= this.width)
	in (y <= this.height)
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

	typeof(this) convert(in SdlPixelFormat format)
	in (this.surface_handle !is null)
	{
		this.surface_handle = SDL_ConvertSurface(
			this.surface_handle, cast(SDL_PixelFormat) format
		);
		enforce(this.surface_handle !is null);
		return this;
	}

	typeof(this) clear(in ColorF color)
	in (this.surface_handle !is null)
	{
		succeed = SDL_ClearSurface(
			this.surface_handle, color.red, color.green, color.blue, color.alpha
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
