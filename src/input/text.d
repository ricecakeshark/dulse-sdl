module dulse_sdl.input.text;

import dulse_sdl.video.window;
import sdl.video : SDL_Window;
import sdl.keyboard;
import std.exception : enforce;

void start_text_input(ref Window window)
{
	enforce(SDL_StartTextInput(window.handle));
	return;
}

void stop_text_input(ref Window window)
{
	enforce(SDL_StopTextInput(window.handle));
	return;
}
