#!/bin/bash

# --- Configuration ---
# Output directory for converted files (will be created if it doesn't exist)
OUTPUT_DIR="bbr_converted_clips"

# Base name for the output files (e.g., "bbr_clip_1.mp4")
OUTPUT_BASE_NAME="bbr_clip"

# Desired output file extension
OUTPUT_EXT="mp4"

# --- Script Logic ---

echo "Starting simple FFmpeg batch conversion for *.MP4 and *.MKV files in the current directory..."
echo "Converted files will be saved in: ./$OUTPUT_DIR/"
echo "--------------------------------------------------"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Initialize a counter for sequential naming (though not currently used for output_filename in this script)
counter=1

# Use an array to store all files matching the patterns
input_files=( *.MP4 *.mkv )

# Check if the glob found any files. If not, the array will contain the literal patterns.
if [ "${#input_files[@]}" -eq 2 ] && [ "${input_files[0]}" == "*.MP4" ] && [ "${input_files[1]}" == "*.mkv" ]; then
    echo "No .MP4 or .mkv files found in the current directory."
    exit 0
fi

# Loop through each .MP4 and .mkv file in the current directory
for input_file in "${input_files[@]}"; do
    # Check if the file actually exists (in case no files match the glob,
    # the pattern itself might be passed as a filename)
    if [ -f "$input_file" ]; then
        echo "Processing file: $input_file"

        # Construct the output filename using the input file's original name and desired extension
        # We replace the original extension with the desired one.
        filename_no_ext=$(basename "$input_file")
        filename_no_ext="${filename_no_ext%.*}" # Remove the last extension

        output_filename="${filename_no_ext}_converted.${OUTPUT_EXT}"
        output_path="${OUTPUT_DIR}/${output_filename}"

        # --- FFmpeg Conversion Command ---
        # This command converts the input file to the specified output format.
        # FFmpeg will automatically select appropriate codecs for MP4.
        # You can add more specific options here if needed, e.g., for quality:
        # ffmpeg -i "$input_file" -c:v libx264 -crf 23 -c:a aac "$output_path"
        ffmpeg -i "$input_file" "$output_path"

        # Check if ffmpeg command was successful
        if [ $? -eq 0 ]; then
            echo "Successfully converted '$input_file' to '$output_path'"
            # Increment the counter for the next file (if you wanted to use it in output_filename)
            # ((counter++))
        else
            echo "Error: Failed to convert '$input_file'."
            echo "Please check the ffmpeg output above for details."
        fi
        echo "--------------------------------------------------"
    fi
done

echo "Batch conversion complete. Converted files are in './$OUTPUT_DIR/'."
