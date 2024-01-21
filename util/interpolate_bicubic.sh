#!/bin/bash

# usage: interpolate_bicubic.sh source_dir destination_dir

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 source_dir destination_dir"
    exit 1
fi

# Source directory containing files
# Destination directory where renamed files will be stored
source_dir="$1"
destination_dir="$2"

# Check if the source directory exists
if [ ! -d "$source_dir" ]; then
    echo "Source directory does not exist."
    exit 1
fi

# Check if the destination directory exists
if [ ! -d "$destination_dir" ]; then
    echo "Destination directory does not exist."
    exit 1
fi

# Get a list of filenames in source directory
files=$(ls "$source_dir")

# Function to calculate PSNR
interpolate_bicubic() {
    input_file="$1/$2"
    output_file="$3/$2"
    width=${4:-1920}        # Width with a default value of 1920
    height=${5:-1080}       # Height with a default value of 1080

    # interpolate
    ffmpeg -i "$input_file" -vf scale=w="$width":h="$height":flags=bicubic "$output_file" > /dev/null 2>&1

}

# Iterate over common files
for file in $files; do
    interpolate_bicubic "$source_dir" "$file" "$destination_dir"
done

# Print the summary
echo "Done"