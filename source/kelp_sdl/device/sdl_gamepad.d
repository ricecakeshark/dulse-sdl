module kelp_sdl.device.sdl_gamepad;

import kelp_core.core;
import kelp_core.device;
import bindbc.sdl;
import std.exception : enforce;

class SDLGamepad
{
	Core core;
	DeviceSubsystem device_subsystem;
	private SdlGampepad[] gamepad_list;

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
		update_list();
		if (this.device_subsystem)
		{
			GamepadState temp;
			temp = GamepadState();
			this.device_subsystem.gamepad.update(temp);
		}
		return;
	}

	@property bool has()
	{
		return SDL_HasGamepad();
	}

	typeof(this) if_has(void delegate() dlg)
	{
		if (this.has)
		{
			dlg();
		}
		return this;
	}

	typeof(this) update_list()
	{
		gamepad_list = [];
		if (!this.has)
		{
			return this;
		}
		int gamepad_count;
		SDL_JoystickID* gamepad_ptr;
		gamepad_ptr = SDL_GetGamepads(&gamepad_count);
		enforce(gamepad_ptr !is null);
		foreach (SDL_JoystickID joystick_id; gamepad_ptr[0 .. gamepad_count])
		{
			this.gamepad_list ~= SdlGampepad().open(joystick_id);
		}
		return this;
	}
}

struct SdlGampepad
{
	SDL_Gamepad* gamepad_handle;

	@property bool connected()
	{
		if (this.gamepad_handle is null)
		{
			return false;
		}
		return SDL_GamepadConnected(this.gamepad_handle);
	}

	typeof(this) open(SDL_JoystickID joystick_id)
	{
		if (SDL_IsGamepad(joystick_id) == false)
		{
			return this;
		}
		this.gamepad_handle = SDL_OpenGamepad(joystick_id);
		return this;
	}

	typeof(this) close()
	{
		SDL_CloseGamepad(this.gamepad_handle);
		this.gamepad_handle = null;
		return this;
	}

	typeof(this) rumble(uint dur, short low_freq, short high_freq)
	in (this.connected)
	{
		SDL_RumbleGamepad(this.gamepad_handle, low_freq, high_freq, dur);
		return this;
	}
}

GamepadState update(ref GamepadState gamepad_state)
{
	/+
	SDL_GetGamepadAxis(SDL_Gamepad *gamepad, SDL_GamepadAxis axis)
	+/
	return gamepad_state;
}
