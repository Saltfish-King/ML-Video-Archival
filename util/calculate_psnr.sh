#!/bin/bash

# usage: calculate_psnr.sh inferenced_dir original_dir

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

# Get a list of common filenames in both directories
common_files=$(comm -12 <(ls "$source_dir") <(ls "$destination_dir"))

total_psnr=0
max_psnr=0
min_psnr=9999

# Function to calculate PSNR
calculate_psnr() {
    file1="$1/$2"
    file2="$3/$2"

    # Ensure both images have the same dimensions
    dimensions1=$(identify -format "%wx%h" "$file1")
    dimensions2=$(identify -format "%wx%h" "$file2")

    if [ "$dimensions1" != "$dimensions2" ]; then
        echo "Error: Images must have the same dimensions."
        exit 1
    fi

    # Calculate PSNR
    psnr=$(compare -metric PSNR "$file1" "$file2" /dev/null 2>&1)

    echo "PSNR for $2: $psnr dB"
    
    # Update total, max, and min PSNR values
    total_psnr=$(awk "BEGIN {print $total_psnr + $psnr}")
    if (( $(echo "$psnr > $max_psnr" | bc -l) )); then
        max_psnr=$psnr
    fi
    if (( $(echo "$psnr < $min_psnr" | bc -l) )); then
        min_psnr=$psnr
    fi
}

# Iterate over common files and calculate PSNR
for file in $common_files; do
    calculate_psnr "$source_dir" "$file" "$destination_dir"
done

# Calculate average PSNR
num_files=$(echo $common_files | wc -w)
average_psnr=$(awk "BEGIN {print $total_psnr / $num_files}")

# Print the summary
echo "Average PSNR: $average_psnr dB, Maximum PSNR: $max_psnr dB, Minimum PSNR: $min_psnr dB"