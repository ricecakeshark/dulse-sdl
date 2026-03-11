module kelp_sdl.core.subsystem;

import kelp_core.core;
import kelp_sdl;

kelp_core.Core append_sdl_subsystem(ref kelp_core.Core core)
{
	core.subsystem.append(
		new SDLSubsystem(core),
		new SDLDeviceSubsystem(core),
		new SDLEventSubsystem(core),
		new AudioSubsystem(),
	);
	return core;
}
