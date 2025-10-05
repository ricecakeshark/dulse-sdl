module kelp_sdl.graphics.resource.texture.abstract_texture;

/+abstract class GPUAbstractTexture
{
	SDL_GPUTexture* texture_handle;
	GPUDevice device;

	this(GPUDevice device)
	{
		this.device = device;
		return;
	}

	@property SDL_GPUTexture* handle() const pure nothrow @nogc @safe
	{
		return this.texture_handle;
	}

	uint sizeInBytes() const pure nothrow @nogc @safe
	{
		return cast(uint)(this.width * this.height * 4);
	}
}+/

public:

