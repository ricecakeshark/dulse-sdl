module kelp_sdl.input.text;

import kelp_sdl.graphics.core.gpu_window;
import sdl.video : SDL_Window;
import sdl.keyboard;
import std.exception : enforce;

void start_text_input(ref GpuWindow window)
{
	enforce(SDL_StartTextInput(window.handle));
	return;
}

void stop_text_input(ref GpuWindow window)
{
	enforce(SDL_StopTextInput(window.handle));
	return;
}
