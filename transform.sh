#!/bin/bash

start_time=$(date +%s)

# Function to process a single volume
process_volume() {
    local volume=$1
    if [ -d "brenner/$volume" ]; then
        mkdir -p "editions/$volume"
        for file in "brenner/$volume"/*.xml; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                java -jar saxon/saxon9he.jar -s:"$file" -xsl:xsl/totei.xsl -o:"editions/$volume/$filename"
                echo "Transformed: $file -> editions/$volume/$filename"
            fi
        done
    else
        echo "Warning: Volume directory brenner/$volume not found"
    fi
}

# Create editions directory
mkdir -p editions

# Check if volume parameter is provided
if [ -n "$1" ]; then
    # Validate volume parameter
    if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -lt 1 ] || [ "$1" -gt 18 ]; then
        echo "Error: Volume must be a number between 1 and 18"
        exit 1
    fi
    # Process single volume
    volume=$(printf "BR-%02d" "$1")
    process_volume "$volume"
else
    # Process all volumes
    for i in {1..18}; do
        volume=$(printf "BR-%02d" "$i")
        process_volume "$volume"
    done
fi

end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Transformation complete in ${execution_time} seconds"