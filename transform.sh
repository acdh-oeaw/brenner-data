#!/bin/bash

start_time=$(date +%s)

mkdir -p editions

for dir in brenner/*/; do
    subfolder=$(basename "$dir")
    mkdir -p "editions/$subfolder"
    
    for file in "brenner/$subfolder"/*.xml; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            java -jar saxon/saxon9he.jar -s:"$file" -xsl:xsl/totei.xsl -o:"editions/$subfolder/$filename"
            echo "Transformed: $file -> editions/$subfolder/$filename"
        fi
    done
done

echo "Transformation complete"

end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Transformation complete in ${execution_time} seconds"