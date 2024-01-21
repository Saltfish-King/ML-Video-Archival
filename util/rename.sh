#!/bin/bash

# usage: scrip.sh source_dir destination_dir
# function: change old integer indices to new zero-padded, starting-from-zero indices

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

# Ensure the destination directory exists
mkdir -p "$destination_dir"

# Iterate over all files in the source directory
for file in "$source_dir"/*; do
    # Check if the file is a regular file
    [ -f "$file" ] || continue

    # Extract filename and extension
    filename=$(basename -- "$file")
    extension="${filename##*.}"

    # Extract the index from the filename (assuming the filename is an integer)
    index=$(echo "$filename" | grep -oE '[0-9]+' | sed 's/^0*//')

    # Subtract 1 from the index
    new_index=$((index - 1))

    # Generate zero-padded index with 8 digits
    padded_new_index=$(printf "%08d" "$new_index")

    # New filename with zero-padded index and original extension
    new_filename="${padded_new_index}.${extension}"

    # Source and destination paths
    source_path="$source_dir/$filename"
    destination_path="$destination_dir/$new_filename"

    # Rename the file
    mv "$source_path" "$destination_path"

    echo "Renamed: $source_path -> $destination_path"
done

echo "File renaming process completed."

