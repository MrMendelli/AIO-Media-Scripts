# AIO Media Scripts

## About

I wrote these scripts as a means of quickly creating and importing AIO videos for use with Lian Li coolers and their L-Connect 3 software. Other devices and formatting may be supported eventually _(see usage)_. A secondary function is that these scripts retain the name of the input file(s), so I can have more control of how videos are displayed and sorted in L-Connect 3 as the integrated way of importing videos assigns a timestamp-based file name to the output file(s).

## Dependencies

- [ffmpeg](https://www.ffmpeg.org/)

_\*As a prerequisite, ffmpeg must be installed and added to PATH._

- [L-Connect 3](https://lian-li.com/l-connect3/)

_\*The OpenRGB Beta is supported_

- A Lian Li AIO with an LCD screen

_\*Other devices can be supported but for now this is only targeted at what hardware I use and have access to._


## Disclaimer

When using the import script, new animations or videos will not appear in L-Connect if it is already running and the theme selection screen for the AIO is open. You must either restart L-Connect, or click out of, and back into the screen to refresh it.

## Usage

Simply drag-and-drop one or more images or videos onto the `Animation Importer (L-Connect 3).bat` script and the rest is automated. Static images will still work but this is intended for animated formats. This script automates the cropping, scaling, and encoding for what L-Connect expects. Input dimensions are parsed, and a check is ran to determine which factor to crop by resulting in a squared 1:1 aspect ratio. From there the video is scaled to 480x, then outputted to the directory based on your AIO model in the expected formats and locations.

Included is an additional script; `AIO Animation (Squared).bat`. This script allows you to manually create an animation as GIF, MKV, MP4, or WebP as well as choosing the resolution scale. This script does not import the animation to a specific location, and instead will output the converted files to the same location as whatever infilles are used.

## Issues

- This script does not account for more than one AIO video directory, I do not know if it is possible to have more than one so results may vary if this is the case
- Linux version pending, both from lack of experience in Bash, and because I don't know if L-Connect even runs on Linux
- Crop area selection may be possible, but no plans are made for how to approach other options
- Paths or file names containing `!` do not work, indeterminate cause or solution

