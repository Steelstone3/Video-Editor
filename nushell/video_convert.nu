# --- Configuration ---
let OUTPUT_DIR = "bbr_converted_clips"
let OUTPUT_BASE_NAME = "bbr_clip"
let OUTPUT_EXT = "mp4"

# --- Script Logic ---
print "Starting simple FFmpeg batch conversion for *.MP4 and *.MKV files in the current directory..."
print $"Converted files will be saved in: ./( $OUTPUT_DIR )/"
print "--------------------------------------------------"

# Create the output directory if it doesn't exist
mkdir $OUTPUT_DIR | ignore

# Collect input files (*.MP4 and *.mkv) in the current directory
let input_files = (ls | where name =~ '\.MP4$' or name =~ '\.mkv$' | get name)

# Check if no files were found
if ($input_files | is-empty) {
    print "No .MP4 or .mkv files found in the current directory."
    exit 0
}

# Loop through each file
for input_file in $input_files {
    if (ls $input_file | is-empty) {
        continue
    }

    print $"Processing file: ( $input_file )"

    # Extract filename without extension
    let filename_no_ext = ($input_file | path basename | str replace -r '\.[^.]+$' "")

    # Build output path
    let output_filename = $"( $filename_no_ext )_converted.( $OUTPUT_EXT )"
    let output_path = $"( $OUTPUT_DIR )/( $output_filename )"

    # --- FFmpeg Conversion Command ---
    let ffmpeg_result = (ffmpeg -i $input_file $output_path | complete)

    if $ffmpeg_result.exit_code == 0 {
        print $"Successfully converted '( $input_file )' to '( $output_path )'"
    } else {
        print $"Error: Failed to convert '( $input_file )'."
        print "Please check the ffmpeg output above for details."
    }
    print "--------------------------------------------------"
}

print $"Batch conversion complete. Converted files are in './( $OUTPUT_DIR )/'."

