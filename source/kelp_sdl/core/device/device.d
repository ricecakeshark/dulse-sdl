module kelp_sdl.core.device.device;

import kelp_core.core.subsystem;
import kelp_sdl.core.device;

final class SDLDeviceSubsystem : Subsystem
{
	SDLKeyboard keyboard;

	this()
	{
		this.keyboard = new SDLKeyboard();
		return;
	}

	void initialize()
	{
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		this.keyboard.process();
		return;
	}
}
