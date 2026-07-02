module kelp_sdl.graphics.resource.shader.shader;

import bindbc.sdl;
import kelp_sdl.graphics;
import std.algorithm;
import std.exception : enforce;
import std.file : isFile, read;
import std.format : format;
import std.path : extension;
import std.string : fromStringz, toStringz;

abstract class GpuShader(Derived) : GpuResource!(GpuShader)
{
	SDL_GPUShader* shader_handle;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

	~this()
	{
		return;
	}

	@property inout(SDL_GPUShader*) handle() inout pure nothrow @nogc @safe
	{
		return this.shader_handle;
	}

	protected Derived create(in GpuShaderCreateInfo shader_create_info)
	{
		this.shader_handle = SDL_CreateGPUShader(
			this.device.handle, cast(SDL_GPUShaderCreateInfo*)&shader_create_info
		);
		enforce(this.shader_handle !is null, SDL_GetError().fromStringz());
		return cast(Derived) this;
	}

	Derived release()
	{
		if (this.shader_handle is null || this.device.handle is null)
		{
			return cast(Derived) this;
		}
		SDL_ReleaseGPUShader(this.device.handle, this.shader_handle);
		this.shader_handle = null;
		return cast(Derived) this;
	}
}

final class GpuVertexShader : GpuShader!(GpuVertexShader)
{
	this(GpuDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(
		ShaderFile shader_file,
		in GpuShaderArguments shader_args
	)
	{
		GpuShaderCreateInfo shader_create_info = GpuShaderCreateInfo(
			shader_file,
			shader_args,
		);
		super.create(shader_create_info);
		return this;
	}
}

final class GpuFragmentShader : GpuShader!(GpuVertexShader)
{
	this(GpuDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(
		ShaderFile shader_file,
		in GpuShaderArguments shader_args
	)
	{
		GpuShaderCreateInfo shader_create_info = GpuShaderCreateInfo(
			shader_file,
			shader_args,
		);
		super.create(shader_create_info);
		return this;
	}
}

struct ShaderFile
{
	public string shader_uri;
	GpuShaderFormat frontend_format = GpuShaderFormat.invalid;
	GpuShaderStage shader_stage;
	public string entry_point;
	public ubyte[] code;
	protected string shader_dir, shader_ext;

	this(string file_name, in GpuShaderFormat backend_formats)
	{
		if (backend_formats & GpuShaderFormat.spirv)
		{
			shader_dir = "./shader/compiled/SPIRV/";
			shader_ext = ".spv";
			frontend_format = GpuShaderFormat.spirv;
			entry_point = "main";
		}
		else if (backend_formats & GpuShaderFormat.msl)
		{
			shader_dir = "./shader/compiled/MSL/";
			shader_ext = ".msl";
			frontend_format = GpuShaderFormat.msl;
			entry_point = "main0";
		}
		else if (backend_formats & GpuShaderFormat.dxil)
		{
			shader_dir = "./shader/compiled/DXIL/";
			shader_ext = ".dxil";
			frontend_format = GpuShaderFormat.dxil;
			entry_point = "main";
			/+switch (file_name.extension)
			{
			case ".vert":
				entry_point = "VSMain";
				break;
			case ".frag":
				entry_point = "PSMain";
				break;
			default:
				break;
			}+/
		}
		else
		{
			enforce(false, "unrecognized backend shader format");
		}
		shader_uri = shader_dir ~ file_name ~ shader_ext;

		switch (file_name.extension)
		{
		case ".vert":
			shader_stage = GpuShaderStage.vertex;
			break;
		case ".frag":
			shader_stage = GpuShaderStage.fragment;
			break;
		case ".comp":
			break;
		default:
			throw new Exception("cannot set shader_stage");
		}
		enforce(isFile(shader_uri));
		code = cast(ubyte[]) read(shader_uri);
		return;
	}
}
