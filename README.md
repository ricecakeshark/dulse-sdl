# Dulse-sdl

## Overview

Dulse-sdl is minimal wrapper of SDL3.

## Lisence

Mozilla Public License Version 2.0

## Usage

### Windows

Accessing [SDL Official Site](https://libsdl.org/),
and download needed files.(SDL3.dll, SDL3_image, SDL3_ttf, SDL3_mixer) 
save above files into "/dulse_sdl/lib/win_x86-64/".

dub.sdl
```SDL
dependency "dulse-sdl" version=">=0.1.0"
```

dub.json
```JSON
"dependencies":{
	"dulse-sdl":">=0.1.0"
}
```

import in Dulse-sdl
```Dlang
import dulse_sdl;
```

## Copyright

Copyright Riceshark(RiceCakeShark). All rights reserved.
