module kelp_sdl.core.sdl.sdl_mixer;

import bindbc.sdl;
import kelp_sdl.core;
/+
bool MIX_Init();
void MIX_Quit();
int MIX_Version();

class LibrarySDLMixer
{
	SemVersion compiled_version;
	SemVersion linked_version;

	this()
	{
		return;
	}

	void initialize()
	{
		MIX_Init().catchSDLError();
		get_version();
		return;
	}

	void finalize()
	{
		MIX_Quit();
		return;
	}

	void get_version()
	{
		compiled_version = SemVersion(SDL_MIXER_VERSION);
		linked_version = SemVersion(MIX_Version());
		return;
	}
}+/