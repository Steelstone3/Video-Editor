#!/bin/bash

# --- Video Trimmer Script (with Arguments) ---

# This script uses FFmpeg to trim a specified video file based on
# start and end times provided as command-line arguments.
#
# Usage: ./trim_video.sh <input_file> <start_time> <end_time>
#
# Examples:
#   ./trim_video.sh my_video.mp4 00:01:30 00:02:45
#   ./trim_video.sh holiday_clip.mov 60 180

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "FFmpeg is not installed. Please install it to use this script."
    echo "On Debian/Ubuntu: sudo apt update && sudo apt install ffmpeg"
    echo "On macOS (with Homebrew): brew install ffmpeg"
    exit 1
fi

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_file> <start_time> <end_time>"
    echo "Examples:"
    echo "  $0 my_video.mp4 00:01:30 00:02:45"
    echo "  $0 holiday_clip.mov 60 180"
    exit 1
fi

# Assign arguments to variables
input_file="$1"
start_time="$2"
end_time="$3"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File not found at '$input_file'. Make sure it's in the current directory or provide the full path."
    exit 1
fi

# Extract base name and extension for the output file
filename_without_ext=$(basename "$input_file" | cut -f 1 -d '.')
extension="${input_file##*.}"

# Construct output filename in the current directory
output_file="${filename_without_ext}_trimmed.${extension}"

echo "--- FFmpeg Video Trimmer ---"
echo "Input File: $input_file"
echo "Trimming from: $start_time"
echo "To: $end_time"
echo "Output File: $output_file"

# FFmpeg command to trim the video
# -ss: specifies the start time
# -to: specifies the end time
# -i: specifies the input file
# -c:v copy -c:a copy: copies the video and audio streams without re-encoding.
#                 This is faster and avoids quality loss. If you encounter issues,
#                 remove these options to force re-encoding (e.g., if cuts aren't clean).
ffmpeg -ss "$start_time" -to "$end_time" -i "$input_file" -c:v copy -c:a copy "$output_file"

if [ $? -eq 0 ]; then
    echo "--- Video trimmed successfully! ---"
    echo "Your trimmed video is located at: $output_file"
else
    echo "--- An error occurred during trimming. ---"
    echo "Please check your input parameters or try removing '-c:v copy -c:a copy' from the script."
fi
