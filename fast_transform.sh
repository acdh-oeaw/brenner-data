#!/bin/bash

# Start timing
start_time=$(date +%s)

# Check if saxon exists
if [ ! -f "saxon/saxon9he.jar" ]; then
    echo "Error: Saxon processor not found"
    exit 1
fi

# Check if GNU Parallel is installed
if ! command -v parallel &> /dev/null; then
    echo "GNU Parallel is not installed. Installing..."
    sudo apt-get install parallel
fi

# Create editions directory if it doesn't exist
mkdir -p editions

# Create function for transformation
transform_file() {
    local file=$1
    local subfolder=$(basename $(dirname "$file"))
    local filename=$(basename "$file")
    
    mkdir -p "editions/$subfolder"
    java -jar saxon/saxon9he.jar -s:"$file" -xsl:xsl/totei.xsl -o:"editions/$subfolder/$filename"
    echo "Transformed: $file -> editions/$subfolder/$filename"
}

export -f transform_file

# Find all XML files and process them in parallel
find brenner -name "*.xml" | parallel transform_file {}

# Calculate and display execution time
end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Transformation complete in ${execution_time} seconds"