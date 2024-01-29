ffmpeg -i logo_video.mp4 -i palette.png -filter_complex "[0:v][1:v] paletteuse=dither=none" prettyStickAround.gif
