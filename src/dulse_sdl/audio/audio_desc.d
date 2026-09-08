module dulse_sdl.audio.audio_desc;

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
