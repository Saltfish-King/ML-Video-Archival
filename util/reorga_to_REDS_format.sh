#!/bin/bash

# Source directory containing files indexed starting at 0
source_directory=$1

# Destination directory for reorganized subdirectories
destination_directory=$2

# Create the destination directory if it doesn't exist
mkdir -p "$destination_directory"

# Counter for subdirectory indexing
counter_index=0
subdirectory_index=0
file_index=0

# Loop through files in the source directory
for file in "$source_directory"/*; do
    # Create a subdirectory if the current subdirectory is full (100 files)
    if [ "$((counter_index % 100))" -eq 0 ]; then
        current_subdirectory="$(printf "%03d" "$subdirectory_index")"
        current_subdirectory="$destination_directory/$current_subdirectory"
        mkdir -p "$current_subdirectory"
        ((subdirectory_index++))
        file_index=0
    fi
    
    # Move the file to the current subdirectory
    new_filename=$(printf "%08d.png" "$file_index")
    mv "$file" "$new_filename"
    mv "$new_filename" "$current_subdirectory/"
    ((file_index++))
    # Increment the subdirectory index
    ((counter_index++))
done

echo "Reorganization complete."
