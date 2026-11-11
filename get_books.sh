#!/bin/bash
set -euo pipefail

# Take two arguments: bucket name and book directory
BUCKET_NAME="$1"
BOOK_DIR="$2"

# Create the book directory if it doesn't exist yet
mkdir -p "$BOOK_DIR"

# Copy every .txt file from the bucket into the book directory, and nothing else
aws s3 cp "s3://$BUCKET_NAME" "$BOOK_DIR" --recursive --exclude "*" --include "*.txt"

# Write book_list.txt with absolute paths in sorted order
# Write the header line "File path"
echo "File path" > book_list.txt

# Gets the absolute path of the directory
ABS_BOOK_DIR=$(realpath "$BOOK_DIR")

# finds other .txt files and appends to book_list.txt
find "$ABS_BOOK_DIR" -maxdepth 1 -name "*.txt" | sort >> book_list.txt

# print how many books it listed
NUM_BOOKS=$(($(wc -l < book_list.txt) - 1))
echo "Wrote $NUM_BOOKS book files to book_list.txt."
