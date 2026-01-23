module kelp_sdl.core.event.event;

import kelp_core.core;
import kelp_core.event;
import bindbc.sdl;

import std.array, std.algorithm;

class SDLEventSubsystem : Subsystem
{
	Core core;
	EventSubsystem event;

	this(Core core)
	{
		this.core = core;
	}

	void initialize()
	{
		event = this.core.subsystem.pool.query!(EventSubsystem);
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		event.pool.append(poll_event());
		return;
	}
}

Event[] poll_event()
{
	return poll_sdl_event()
		.map!(event => event.normalize())
		.array();
}

Event normalize(in SDL_Event event) pure nothrow @nogc @safe
{
	switch (event.type)
	{
	case SDL_EVENT_QUIT:
		return Event(EventType.quit);
	default:
		return Event(EventType.none);
	}
}

SDL_Event[] poll_sdl_event()
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
