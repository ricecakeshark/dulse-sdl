module kelp_sdl.core.event.event;

import kelp_core.event;
import bindbc.sdl;

Event normalize(SDL_EventType event_type)
{
	switch (event_type)
	{
	case SDL_EVENT_QUIT:
		return Event.quit;
	default:
		assert(false, "the event type is not supported");
	}
}

SDL_Event[] pollEvent()
{
	SDL_Event[] temp_event_queue;
	SDL_Event event;

	while(SDL_PollEvent(&event))
	{
		temp_event_queue ~= event;
	}
	return temp_event_queue;
}
