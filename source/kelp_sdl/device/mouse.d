module kelp_sdl.device.mouse;

import kelp_core.core;
import kelp_core.device;
import bindbc.sdl;

class SDLMouse
{
	Core core;
	DeviceSubsystem device_subsystem;

	this(DeviceSubsystem device_subsystem)
	{
		this.device_subsystem = device_subsystem;
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
		MouseState temp_mouse;
		if (this.device_subsystem)
		{
			temp_mouse.update(
				SDL_GetRelativeMouseState(
					&temp_mouse.global.state.data[0],
					&temp_mouse.global.state.data[1],
			)
			);
			this.device_subsystem.mouse.update(temp_mouse);
		}
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
