module kelp_sdl.input.keyboard;

import kelp_core.core.container.ring_buffer;
import kelp_core.input.device.keyboard;
import kelp_core.input.event.event;
import kelp_core.input.state.keyboard;
import sdl.keyboard;

void update(ref KeyboardState state) nothrow @safe
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
