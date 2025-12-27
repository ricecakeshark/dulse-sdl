module kelp_sdl.graphics.resource.shader.shader;

import bindbc.sdl;
import kelp_sdl.graphics;
import std.algorithm, std.exception, std.file, std.format;
import std.string : toStringz;

abstract class GPUShader(Derived)
{
	SDL_GPUShader* shader_handle;
	GPUDevice device;

	this(GPUDevice device)
	{
		this.device = device;
		return;
	}

	~this()
	{
		this.release();
		return;
	}

	@property inout(SDL_GPUShader*) handle() inout pure nothrow @nogc @safe
	{
		return this.shader_handle;
	}

	protected Derived create(
		GPUShaderCreateInfo shader_create_info
	)
	{
		this.shader_handle = SDL_CreateGPUShader(
			this.device.handle, cast(SDL_GPUShaderCreateInfo*)&shader_create_info
		);
		enforce(this.shader_handle !is null, "failed to create shader");
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

final class GPUVertexShader : GPUShader!(GPUVertexShader)
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(
		string shader_filename,
		GPUShaderArguments shader_args
	)
	in (shader_filename.endsWith(".vert"))
	{
		ShaderCode shader_code;
		shader_code = ShaderCode(device, shader_filename);
		/+GPUShaderCreateInfo shader_create_info = GPUShaderCreateInfo(
			shader_code, SDL_GPU_SHADERSTAGE_VERTEX, shader_args
		);+/
		GPUShaderCreateInfo shader_create_info = GPUShaderCreateInfo(
			shader_code,
			this.device.get_shader_format(),
			GPUShaderStage.vertex,
			shader_args,
		);
		super.create(shader_create_info);
		return this;
	}
}

final class GPUFragmentShader : GPUShader!(GPUVertexShader)
{
	this(GPUDevice device)
	{
		super(device);
		return;
	}

	typeof(this) create(
		string shader_filename,
		GPUShaderArguments shader_args
	)
	in (shader_filename.endsWith(".frag"))
	{
		ShaderCode shader_code;
		shader_code = ShaderCode(device, shader_filename);
		GPUShaderCreateInfo shader_create_info = GPUShaderCreateInfo(
			shader_code, GPUShaderStage.fragment, shader_args
		);
		super.create(shader_create_info);
		return this;
	}
}

struct ShaderCode
{
	public string code;
	public string entry_point;
	public GPUShaderFormat frontend_format;

	this(GPUDevice device, string shader_filename)
	{
		string shader_uri;
		scope GPUShaderFormat backend_formats;
		backend_formats = device.get_shader_format();
		frontend_format = GPUShaderFormat.invalid;

		if (backend_formats & GPUShaderFormat.spirv)
		{
			shader_uri = format("./shader/compiled/SPIRV/%s.spv", shader_filename);
			frontend_format = GPUShaderFormat.spirv;
			entry_point = "main";
		}
		else if (backend_formats & GPUShaderFormat.msl)
		{
			shader_uri = format("./shader/compiled/MSL/%s.msl", shader_filename);
			frontend_format = GPUShaderFormat.msl;
			entry_point = "main0";
		}
		else if (backend_formats & GPUShaderFormat.dxil)
		{
			shader_uri = format("./shader/compiled/DXIL/%s.dxil", shader_filename);
			frontend_format = GPUShaderFormat.dxil;
			entry_point = "main";
		}
		else
		{
			enforce(false, "unrecognized backend shader format");
		}

		enforce(isFile(shader_uri), "shader file was not found.(" ~ shader_uri ~ ")");
		this.code = cast(string) read(shader_uri);
		return;
	}

	this(GPUShaderFormat backend_formats, string shader_filename)
	{
		string shader_uri;
		frontend_format = GPUShaderFormat.invalid;

		if (backend_formats & GPUShaderFormat.spirv)
		{
			shader_uri = format("./shader/compiled/SPIRV/%s.spv", shader_filename);
			frontend_format = GPUShaderFormat.spirv;
			entry_point = "main";
		}
		else if (backend_formats & GPUShaderFormat.msl)
		{
			shader_uri = format("./shader/compiled/MSL/%s.msl", shader_filename);
			frontend_format = GPUShaderFormat.msl;
			entry_point = "main0";
		}
		else if (backend_formats & GPUShaderFormat.dxil)
		{
			shader_uri = format("./shader/compiled/DXIL/%s.dxil", shader_filename);
			frontend_format = GPUShaderFormat.dxil;
			entry_point = "main";
		}
		else
		{
			enforce(false, "unrecognized backend shader format");
		}

		enforce(isFile(shader_uri), "shader file was not found.(" ~ shader_uri ~ ")");
		this.code = cast(string) read(shader_uri);
		return;
	}
}
