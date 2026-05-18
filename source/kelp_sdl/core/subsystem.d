module kelp_sdl.core.subsystem;

import kelp_core.core;
import kelp_sdl;

Core append_sdl_subsystem(ref Core core)
{
	core.subsystem.append(
		new SDLSubsystem(core),
		new SDLDeviceSubsystem(core),
		new SDLEventSubsystem(core),
		new AudioSubsystem(core),
	);
	return core;
}
