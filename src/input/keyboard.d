module dulse_sdl.input.keyboard;

import dulse.core.container.ring_buffer;
import dulse.input.device.keyboard;
import dulse.input.event.event;
import dulse.input.state.keyboard;
import sdl.keyboard;

void catch_up(ref KeyboardState state) nothrow @safe
{
	foreach (key, pressed; get_keyboard_state())
	{
		state[cast(Scancode) key].pressed = pressed;
	}
	return;
}

const(bool)[] get_keyboard_state() nothrow @trusted
{
	scope int* count_key;
	scope const(bool)* key_list_ptr;
	key_list_ptr = SDL_GetKeyboardState(count_key);
	return key_list_ptr[0 .. cast(size_t) count_key].idup;
}
