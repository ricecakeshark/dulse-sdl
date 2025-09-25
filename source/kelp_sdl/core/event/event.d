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
	import std.array : Appender;

	Appender!(SDL_Event[]) event_list;
	SDL_Event event;

	while (SDL_PollEvent(&event))
	{
		event_list.put(event);
	}
	return event_list[];
}
