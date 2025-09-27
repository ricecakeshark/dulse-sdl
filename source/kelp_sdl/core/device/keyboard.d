module kelp_sdl.core.device.keyboard;

import kelp_core.device;
import bindbc.sdl;
import std.algorithm;

class SDLKeyboard
{
	SDL_KeyboardID keyboard_id;
	KeyboardInputState input_state;

	this()
	{
		return;
	}

	void initialize()
	{
		this.tryOpen();
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		this.input_state = getKeyboardState();
		return;
	}

	void tryOpen()
	{
		int count;
		SDL_KeyboardID* keyboard_ptr;
		keyboard_ptr = SDL_GetKeyboards(&count);
		if(count < 1)
		{
			return;
		}
		this.keyboard_id = keyboard_ptr[0];
		return;
	}


}

KeyboardInputState getKeyboardState()
{
	int num_keys;
	const bool* key_state_ptr = SDL_GetKeyboardState(&num_keys);
	return KeyboardInputState(key_state_ptr[0..num_keys]);
}