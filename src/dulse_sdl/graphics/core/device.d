module dulse_sdl.graphics.core.device;

import sdl.error;
import sdl.gpu;
import sdl.properties;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.core;
import dulse_sdl.video.window;

import std.exception : enforce;
import std.string : fromStringz, toStringz;

class GpuDevice
{
	private SDL_GPUDevice* device_handle;
	private Window claimed_window;

	this()
	{
		return;
	}

	invariant
	{
		assert(this !is null, "the instance is not initialized.");
	}

	@property bool is_valid() pure nothrow @nogc @safe
	{
		return (this.device_handle !is null);
	}

	@property inout(SDL_GPUDevice*) handle() inout pure nothrow @nogc @safe
	{
		return this.device_handle;
	}

	typeof(this) create(GpuBackend backend_prior = GpuBackend.none)
	in (this.handle is null)
	{
		string backend_selector;
		switch (backend_prior)
		{
		case GpuBackend.vulkan:
			backend_selector = "vulkan";
			SDL_PropertiesID props = SDL_CreateProperties();
			SDL_GPUVulkanOptions vkopts;
			vkopts.vulkan_api_version = (1u << 22) | (4u << 12) | (0u);
			SDL_SetPointerProperty(
				props,
				SDL_PROP_GPU_DEVICE_CREATE_VULKAN_OPTIONS_POINTER,
				&vkopts,
			);
			SDL_SetStringProperty(
				props,
				SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING,
				"vulkan",
			);
			SDL_SetBooleanProperty(
				props,
				SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN,
				true,
			);
			this.device_handle = SDL_CreateGPUDeviceWithProperties(
				cast(SDL_PropertiesID) props,
			);
			return this;
		case GpuBackend.direct3d12:
			backend_selector = "direct3d12";
			break;
		case GpuBackend.metal:
			backend_selector = "metal";
			break;
		default:
			break;
		}
		if (backend_selector)
		{
			this.device_handle = SDL_CreateGPUDevice(
				SDL_GPU_SHADERFORMAT_SPIRV | SDL_GPU_SHADERFORMAT_DXIL | SDL_GPU_SHADERFORMAT_MSL,
				true, backend_selector.toStringz(),
			);
		}
		else
		{
			this.device_handle = SDL_CreateGPUDevice(
				SDL_GPU_SHADERFORMAT_SPIRV | SDL_GPU_SHADERFORMAT_DXIL | SDL_GPU_SHADERFORMAT_MSL,
				true, null,
			);
		}
		// "vulkan".toStringz()
		enforce(this.device_handle !is null, SDL_GetError().fromStringz());
		return this;
	}

	typeof(this) release()
	{
		if (this is null || this.device_handle is null)
		{
			return this;
		}
		SDL_DestroyGPUDevice(this.device_handle);
		this.device_handle = null;
		return this;
	}

	typeof(this) claim(Window window)
	in (this.handle !is null)
	in (window !is null)
	in (window.handle !is null)
	{
		enforce(SDL_ClaimWindowForGPUDevice(this.handle, window.handle));
		return this;
	}

	typeof(this) release_window(Window window)
	in (this.device_handle !is null)
	{
		SDL_ReleaseWindowFromGPUDevice(this.handle, window.handle);
		return this;
	}

	typeof(this) wait()
	in (this.handle !is null)
	{
		SDL_WaitForGPUIdle(this.device_handle).enforce();
		return this;
	}

	bool support_format(
		in SDL_GPUTextureFormat format,
		in SDL_GPUTextureType type,
		in SDL_GPUTextureUsageFlags usage
	)
	in (this.handle !is null)
	{
		return SDL_GPUTextureSupportsFormat(this.handle, format, type, usage);
	}

	GpuShaderFormat get_shader_format()
	{
		return cast(GpuShaderFormat) cast(SDL_GPUShaderFormat) SDL_GetGPUShaderFormats(
			this.device_handle);
	}

	string get_driver()
	{
		return SDL_GetGPUDeviceDriver(this.handle).fromStringz().idup;
	}

	string[] get_driver_list()
	{
		scope string[] driver_list;
		scope const int driver_len = SDL_GetNumGPUDrivers();
		driver_list.length = driver_len;
		foreach (const count; 0 .. driver_len)
		{
			driver_list[count] = SDL_GetGPUDriver(count).fromStringz().idup;
		}
		return driver_list;
	}
}
