module dulse_sdl.input.mouse;

import dulse.input.device.mouse;
import dulse.input.state.mouse;
import sdl.mouse : SDL_GetMouseState, SDL_MouseButtonFlags;

void catch_up(out MouseState) nothrow @nogc @trusted
{
	scope MouseState state;
	scope SDL_MouseButtonFlags flags;
	flags = SDL_GetMouseState(&(state.pos[0]), &(state.pos[1]));
	state.button[MouseButton.left].pressed = (flags & SDL_MouseButtonFlags.left) == 1;
	state.button[MouseButton.middle].pressed = (flags & SDL_MouseButtonFlags.middle) == 1;
	state.button[MouseButton.right].pressed = (flags & SDL_MouseButtonFlags.right) == 1;
	state.button[MouseButton.x1].pressed = (flags & SDL_MouseButtonFlags.x1) == 1;
	state.button[MouseButton.x2].pressed = (flags & SDL_MouseButtonFlags.x2) == 1;
	return;
}
