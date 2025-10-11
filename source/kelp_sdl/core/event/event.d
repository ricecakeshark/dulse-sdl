module kelp_sdl.core.event.event;

import kelp_core.event;
import bindbc.sdl;

import std.array, std.algorithm;

Event[] pollEvent()
{
	return pollSDLEvent()
		.map!(event => event.normalize())
		.array();
}

Event normalize(SDL_Event event) pure nothrow @nogc @safe
{
	switch (event.type)
	{
	case SDL_EVENT_QUIT:
		return Event(EventType.quit);
	default:
		return Event(EventType.none);
	}
}

SDL_Event[] pollSDLEvent()
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
