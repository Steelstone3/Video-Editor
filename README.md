# Video Editor

A collection of scripts to trim and sequence videos together.

## Usage

### Trim

Trims the video to a set time range outputs the filename_trimmed.codec

> bash video_trim.sh [video_file] [start_time] [end_time]
>
> e.g bash video_trim.sh cool_clip.mp4 23 23:00 -> cool_clip_trimmed.mp4

### Convert

Converts the video to a new format outputs the filename_converted.codec

> bash video_convert.sh [video_file] [converted_video file]
>
> e.g bash video_convert cool_clip.mkv the_coolest_clip.mp4 -> the_coolest_clip_converted.mp4

### Find

Outputs the video files into a text file named video_files.txt

> bash find_video_files.sh

### Stitch

Uses video_files.txt or a user generated file list and stitches the clips together into an output file

> bash video_stitch.sh [video_list] [output_file]
>
> bash video_stitch.sh video_files.txt output.mp4

## Dependencies

- Bash
- FFMPEG
