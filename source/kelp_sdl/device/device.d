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

	this(Core core)
	{
		this.core = core;
		this.keyboard = new SDLKeyboard();
		return;
	}

	void initialize()
	{
		this.device = core.subsystem.pool.query!(DeviceSubsystem);
		this.keyboard.initialize();
		this.keyboard.device_subsystem = this.device;
	}

	void finalize()
	{
		this.keyboard.finalize();
	}

	void process()
	{
		MouseState temp_mouse = MouseState();

		temp_mouse.update(
			SDL_GetRelativeMouseState(
				&temp_mouse.global.state.data[0], &temp_mouse.global.state.data[1]
		)
		);
		this.device.mouse.update(temp_mouse);

		this.keyboard.process();
		//GamepadState temp_gamepad = GamepadState();
		return;
	}
}

MouseState update(ref MouseState mouse_state, in SDL_MouseButtonFlags button_state)
{
	mouse_state.left = ButtonState((button_state & MouseButton.left) == 1);
	mouse_state.middle = ButtonState((button_state & MouseButton.middle) == 1);
	mouse_state.right = ButtonState((button_state & MouseButton.right) == 1);
	mouse_state.x1 = ButtonState((button_state & MouseButton.x1) == 1);
	mouse_state.x2 = ButtonState((button_state & MouseButton.x2) == 1);
	return mouse_state;
}

GamepadState update(ref GamepadState gamepad_state)
{
	/+
	SDL_GetGamepadAxis(SDL_Gamepad *gamepad, SDL_GamepadAxis axis)
	+/
	return gamepad_state;
}
