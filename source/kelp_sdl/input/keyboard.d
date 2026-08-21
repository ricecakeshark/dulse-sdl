module kelp_sdl.input.keyboard;

import kelp_core.core.container.ring_buffer;
import kelp_core.input.device.keyboard;
import kelp_core.input.event.event;
import kelp_core.input.state.keyboard;
import bindbc.sdl;

/+struct KeyboardStateList
{
	RingBuffer!(KeyboardState, 5) state_list;

	ref typeof(this) process()
	{
		this.state_list.append(this.state_list.tail);
		return this;
	}

	ref typeof(this) update()
	{
		foreach (key, state; get_keyboard_state())
		{
			this.state_list.tail.key_list[key] = state;
		}
		return this;
	}

	ref typeof(this) apply(in Event[] event_list)
	{
		this.state_list.tail.apply(event_list);
		return this;
	}
}+/

KeyboardState update(ref KeyboardState state)
{
	foreach (key, pressed; get_keyboard_state())
	{
		state[cast(Scancode) key].pressed = pressed;
	}
	return state;
}

const(bool)[] get_keyboard_state()
{
	int* count_key;
	const(bool)* key_list_ptr;
	key_list_ptr = SDL_GetKeyboardState(count_key);
	return key_list_ptr[0 .. cast(size_t) count_key];
}
