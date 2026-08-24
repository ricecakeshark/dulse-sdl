module kelp_sdl.input.gamepad;

import kelp_core.input;
import kelp_core.math : Vec1;
import kelp_core.core.container.ring_buffer;
import std.exception : enforce;
import bindbc.sdl;
import std.conv : to;

struct Gamepad
{
	SDL_Gamepad* _handle;
	RingBuffer!(GamepadState, 5) state_list;

	@property inout(SDL_Gamepad*) handle() inout pure nothrow @nogc @safe
	{
		return this._handle;
	}

	@property bool opened() const pure nothrow @nogc @safe
	{
		return this._handle !is null;
	}

	typeof(this) open(SDL_JoystickID id)
	{
		this._handle = SDL_OpenGamepad(id);
		enforce(this._handle !is null);
		this.state_list.fill();
		return this;
	}

	typeof(this) close()
	{
		SDL_CloseGamepad(this._handle);
		return this;
	}

	typeof(this) process()
	{
		if (!this.opened)
		{
			return this;
		}
		this.state_list.append(this.state_list.tail);
		return this;
	}

	typeof(this) update()
	{
		if (!this.opened)
		{
			return this;
		}
		foreach (button; 0 .. GamepadButton.max + 1)
		{
			this.state_list.tail.button[button] = GamepadButtonState(
				SDL_GetGamepadButton(this.handle, cast(SDL_GamepadButton) button,)
			);
		}
		// tirgger
		this.state_list.tail.trigger[GamepadTrigger.left].value[0] =
			SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.leftX).to!float();
		this.state_list.tail.trigger[GamepadTrigger.left].pressed =
			SDL_GetGamepadButton(this.handle, SDL_GamepadButton.leftShoulder,);
		with (this.state_list.tail.trigger[GamepadTrigger.right])
		{
			value[0] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.rightY).to!float();
			pressed = SDL_GetGamepadButton(this.handle, SDL_GamepadButton.rightShoulder,);
		}
		// stick
		with (this.state_list.tail.stick[GamepadStick.left])
		{
			value[0] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.leftX).to!float();
			value[1] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.leftY).to!float();
			pressed = SDL_GetGamepadButton(this.handle, SDL_GamepadButton.leftStick,);
		}
		// stick
		with (this.state_list.tail.stick[GamepadStick.right])
		{
			value[0] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.rightX).to!float();
			value[1] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.rightY).to!float();
			pressed = SDL_GetGamepadButton(this.handle, SDL_GamepadButton.rightStick,);
		}

		return this;
	}

	ref typeof(this) apply(in Event[] event_list...) pure nothrow
	{
		if (!this.opened)
		{
			return this;
		}
		this.state_list.tail.apply(event_list);
		return this;
	}

	bool pressed(GamepadButton button)
	{
		if (!this.opened)
		{
			return false;
		}
		return this.state_list.tail.button[button].pressed;
	}

	bool pressed_just(GamepadButton button)
	{
		if (!this.opened)
		{
			return false;
		}
		return this.state_list[$ - 1].button[button].pressed
			&& !this.state_list[$ - 2].button[button].pressed;
	}

	bool released(GamepadButton button)
	{
		if (!this.opened)
		{
			return false;
		}
		return !this.state_list.tail.button[button].pressed;
	}

	bool released_just(GamepadButton button)
	{
		if (!this.opened)
		{
			return false;
		}
		return !this.state_list[$ - 1].button[button].pressed
			&& this.state_list[$ - 2].button[button].pressed;
	}
}

SDL_JoystickID[] get_gamepad_list()
{
	scope SDL_JoystickID* joystick_list_ptr;
	scope int count;
	joystick_list_ptr = SDL_GetGamepads(&count);
	return joystick_list_ptr[0 .. count];
}
