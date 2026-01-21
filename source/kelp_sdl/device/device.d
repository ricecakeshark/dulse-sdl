module kelp_sdl.device.device;

import kelp_core.core;
import kelp_core.device;
import kelp_sdl.device;
import bindbc.sdl;

class SDLDeviceSubsystem : Subsystem
{
	Core core;
	DeviceSubsystem device;
	SDLKeyboard keyboard;
	SDLMouse mouse;
	SDLGamepad gamepad;

	this(Core core)
	{
		this.core = core;
		this.keyboard = new SDLKeyboard();
		this.mouse = new SDLMouse();
		this.gamepad = new SDLGamepad();
		return;
	}

	void initialize()
	{
		this.device = core.subsystem.pool.query!(DeviceSubsystem);
		this.keyboard.device_subsystem = this.device;
		this.mouse.device = this.device;
		this.keyboard.initialize();
		this.mouse.initialize();
		this.gamepad.initialize();
		return;
	}

	void finalize()
	{
		this.keyboard.finalize();
		this.mouse.finalize();
		this.gamepad.finalize();
		return;
	}

	void process()
	{
		this.keyboard.process();
		this.mouse.process();
		this.gamepad.process();
		return;
	}
}
