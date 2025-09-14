#!/bin/bash

# Check if both arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <video_list_file.txt> <output_video_name.mp4>"
  exit 1
fi

input_list="$1"
output_file="$2"
temp_concat_file="concat_list_$(date +%s%N).txt" # Use timestamp for unique temp file name

# Create a temporary file in FFmpeg's required format
# Each line should be 'file 'path/to/video.mp4''
echo "Preparing video list for FFmpeg..."
> "$temp_concat_file" # Clear/create the temporary file

while IFS= read -r line; do
  # Trim leading/trailing whitespace, just in case
  trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # Skip empty lines or lines that are just whitespace
  if [ -z "$trimmed_line" ]; then
    continue
  fi

  # Add 'file ' prefix and single quotes for filenames with spaces
  echo "file '$trimmed_line'" >> "$temp_concat_file"
done < "$input_list"

# Check if the temporary concatenation file was created and has content
if [ ! -s "$temp_concat_file" ]; then
  echo "Error: No valid video files found in '$input_list' or '$temp_concat_file' is empty."
  rm -f "$temp_concat_file"
  exit 1
fi

echo "Concatenation list content (for debugging):"
cat "$temp_concat_file"
echo "--- End of concatenation list ---"

echo "Concatenating videos into '$output_file'..."
# Use ffmpeg's concat demuxer
# -safe 0 is essential when dealing with arbitrary filenames in the concat list
ffmpeg -f concat -safe 0 -i "$temp_concat_file" -c copy "$output_file"

# Check if FFmpeg command was successful
if [ $? -eq 0 ]; then
  echo "Video concatenation completed successfully!"
else
  echo "Error: FFmpeg concatenation failed. Check FFmpeg output above for details."
fi

# Clean up the temporary concatenation file
rm -f "$temp_concat_file"

exit 0
