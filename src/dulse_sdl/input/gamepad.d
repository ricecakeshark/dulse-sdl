module dulse_sdl.input.gamepad;

import dulse.input;
import dulse.math : Vec1;
import dulse.core.container.ring_buffer;
import std.exception : enforce;
import sdl.gamepad, sdl.joystick;
import std.conv : to;

struct Gamepad
{
	private SDL_Gamepad* _handle;
	RingBuffer!(GamepadState, 5) state_list;

	@property inout(SDL_Gamepad*) handle() inout pure nothrow @nogc @safe
	{
		return this._handle;
	}

	@property bool opened() pure nothrow @nogc @safe
	{
		return this._handle !is null;
	}

	ref typeof(this) open(SDL_JoystickID id)
	{
		this._handle = SDL_OpenGamepad(id);
		enforce(this._handle !is null);
		this.state_list.fill();
		return this;
	}

	ref typeof(this) close()
	{
		SDL_CloseGamepad(this._handle);
		return this;
	}

	ref typeof(this) process()
	{
		this.update();
		return this;
	}

	protected ref typeof(this) update() nothrow @nogc @trusted
	{
		scope GamepadState temp_state;
		if (!this.opened)
		{
			this.state_list.append(GamepadState.init);
			return this;
		}
		temp_state = (!this.state_list.is_empty) ? this.state_list.tail : GamepadState.init;
		foreach (button; 0 .. GamepadButton.max + 1)
		{
			temp_state.button[button] = GamepadButtonState(
				SDL_GetGamepadButton(this.handle, cast(SDL_GamepadButton) button,)
			);
		}
		// tirgger
		temp_state.trigger[GamepadTrigger.left].value[0] =
			SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.leftX).to!float();
		temp_state.trigger[GamepadTrigger.left].pressed =
			SDL_GetGamepadButton(this.handle, SDL_GamepadButton.leftShoulder,);
		with (temp_state.trigger[GamepadTrigger.right])
		{
			value[0] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.rightY).to!float();
			pressed = SDL_GetGamepadButton(this.handle, SDL_GamepadButton.rightShoulder,);
		}
		// stick
		with (temp_state.stick[GamepadStick.left])
		{
			value[0] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.leftX).to!float();
			value[1] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.leftY).to!float();
			pressed = SDL_GetGamepadButton(this.handle, SDL_GamepadButton.leftStick,);
		}
		// stick
		with (temp_state.stick[GamepadStick.right])
		{
			value[0] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.rightX).to!float();
			value[1] = SDL_GetGamepadAxis(this.handle, SDL_GamepadAxis.rightY).to!float();
			pressed = SDL_GetGamepadButton(this.handle, SDL_GamepadButton.rightStick,);
		}

		this.state_list.append(temp_state);
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

	bool pressed(GamepadButton button) pure nothrow @nogc @safe
	{
		if (!this.opened)
		{
			return false;
		}
		return this.state_list.tail.button[button].pressed;
	}

	bool pressed_just(GamepadButton button) pure nothrow @nogc @safe
	{
		if (!this.opened)
		{
			return false;
		}
		return this.state_list[$ - 1].button[button].pressed
			&& !this.state_list[$ - 2].button[button].pressed;
	}

	bool released(GamepadButton button) pure nothrow @nogc @safe
	{
		if (!this.opened)
		{
			return false;
		}
		return !this.state_list.tail.button[button].pressed;
	}

	bool released_just(GamepadButton button) pure nothrow @nogc @safe
	{
		if (!this.opened)
		{
			return false;
		}
		return !this.state_list[$ - 1].button[button].pressed
			&& this.state_list[$ - 2].button[button].pressed;
	}
}

SDL_JoystickID[] get_gamepad_list() nothrow @nogc @trusted
{
	scope SDL_JoystickID* joystick_list_ptr;
	scope int count;
	joystick_list_ptr = SDL_GetGamepads(&count);
	return joystick_list_ptr[0 .. count];
}
