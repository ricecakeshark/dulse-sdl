module kelp_sdl.device.keyboard;

import kelp_core.device;
import bindbc.sdl;
import std.algorithm;

class SDLKeyboard
{
	SDL_KeyboardID keyboard_id;
	//KeyboardInputState[2] input_state;
	DeviceSubsystem device_subsystem;

	this()
	{
		return;
	}

	void initialize()
	{
		this.try_open();
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		if (this.device_subsystem)
		{
			this.device_subsystem.keyboard.update(get_keyboard_state());
		}
		return;
	}

	void try_open()
	{
		int count;
		SDL_KeyboardID* keyboard_ptr;
		keyboard_ptr = SDL_GetKeyboards(&count);
		if (count < 1)
		{
			return;
		}
		this.keyboard_id = keyboard_ptr[0];
		return;
	}

	typeof(this) reset()
	{
		SDL_ResetKeyboard();
		return this;
	}

	typeof(this) start_input(SDL_Window* window)
	{
		bool succeed = SDL_StartTextInput(window);
		return this;
	}

	typeof(this) stop_input(SDL_Window* window)
	{
		bool succeed = SDL_StopTextInput(window);
		return this;
	}
}

KeyboardInputState get_keyboard_state()
{
	int num_keys;
	const bool* key_state_ptr = SDL_GetKeyboardState(&num_keys);
	return KeyboardInputState(key_state_ptr[0 .. num_keys]);
}
