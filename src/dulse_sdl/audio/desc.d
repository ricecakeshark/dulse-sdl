module dulse_sdl.audio.desc;

import dulse.audio.desc;
import sdl.audio;

struct SdlAudioSpec
{
	SdlAudioFormat format;
	int channels;
	int freq;
}

enum SdlAudioFormat
{
	unknown = 0x0000u,
	u8 = 0x0008u,
	s8 = 0x8008u,
	s16le = 0x8010u,
	s16be = 0x9010u,
	s32le = 0x8020u,
	s32be = 0x9020u,
	f32le = 0x8120u,
	f32be = 0x9120u,
}

AudioSpec audio_spec(SDL_AudioSpec spec)
{
	return AudioSpec(
		spec.format.convert_to(),
		spec.channels,
		spec.freq,
	);
}

AudioFormat convert_to(SDL_AudioFormat format) pure nothrow @nogc @safe
{
	final switch (format)
	{
	case SDL_AudioFormat.unknown:
		return AudioFormat.unknown;
	case SDL_AudioFormat.u8:
		return AudioFormat.u8;
	case SDL_AudioFormat.s8:
		return AudioFormat.s8;
	case SDL_AudioFormat.s16LE:
		return AudioFormat.s16le;
	case SDL_AudioFormat.s16BE:
		return AudioFormat.s16be;
	case SDL_AudioFormat.s32LE:
		return AudioFormat.s32le;
	case SDL_AudioFormat.s32BE:
		return AudioFormat.s32be;
	case SDL_AudioFormat.f32LE:
		return AudioFormat.f32le;
	case SDL_AudioFormat.f32BE:
		return AudioFormat.f32be;
	}
}
