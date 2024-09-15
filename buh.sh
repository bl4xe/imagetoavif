#!/bin/bash

# Set the source and destination directories
source_dir="/home/bl4ze/Downloads/Camera-Roll"
dest_dir="/home/bl4ze/Downloads/zuh"

# Function to convert images to AVIF
convert_image() {
    file="$1"
    base_name=$(basename "$file")
    new_file="${dest_dir}/${base_name%.*}.avif"

    # Check if the file is an image
    if [[ -f "$file" ]] && [[ -r "$file" ]] && [[ "$file" =~ \.(jpg|jpeg|png|webp|gif|bmp|tiff)$ ]]; then
        echo "Converting image to AVIF: $file"
        magick convert "$file" -set EXIF:* c -define formats:write_exif=true -quality 100 -colorspace sRGB "$new_file"

        echo "Moving original file to $new_file"
        mv "$file" "$new_file"
    fi
}

    # Function to convert videos to Matroshka
convert_video() {
    file="$1"
    base_name=$(basename "$file")
    new_file="${dest_dir}/${base_name%.*}.mkv"

    # Check if the file is a video
    if [[ -f "$file" ]] && [[ -r "$file" ]] && [[ "$file" =~ \.(mp4|mov|avi|mkv|flv|mpeg|mpg)$ ]]; then
        echo "Converting video to Matroshka: $file"
        ffmpeg -i "$file" -c:v libx264 -crf 23 -c:a aac -b:a 128k -movflags faststart -metadata title="My Video Title" -metadata artist="John Doe" "$new_file"

        echo "Moving original file to $new_file"
        mv "$file" "$new_file"
    fi
}

# Find all files in the source directory
find "$source_dir" -type f -print0 | while IFS= read -r -d '' file; do
    echo "Processing file: $file"

    # Check if the file is an image or video
    if [[ "$file" =~ \.(jpg|jpeg|png|webp|gif|bmp|tiff|mp4|mov|avi|mkv|flv|mpeg|mpg)$ ]]; then
        # Convert the file to AVIF or Matroshka based on its type
        if [[ "$file" =~ \.(jpg|jpeg|png|webp|gif|bmp|tiff)$ ]]; then
            echo "Converting image: $file"
            convert_image "$file"
        else
            echo "Converting video: $file"
            convert_video "$file"
        fi
    fi
done
