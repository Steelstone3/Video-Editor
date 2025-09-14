#!/bin/bash

# Define the output file name
OUTPUT_FILE="video_files.txt"

# Define common video file extensions (you can add or remove as needed)
VIDEO_EXTENSIONS="mp4 avi mkv mov webm flv wmv mpg mpeg 3gp ts"

echo "Finding video files in the current directory..."

# Find files, filter by extension, sort, and save to the output file
find . -maxdepth 1 -type f | \
    grep -iE "\.(${VIDEO_EXTENSIONS// /|})$" | \
    sort -f > "$OUTPUT_FILE"

echo "Done! A list of your video files (alphanumeric order) is in $OUTPUT_FILE."
