#!/bin/bash

# Check for the input argument (path to the file)
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path_to_file"
    exit 1
fi

FILE_PATH="$1"

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "File $FILE_PATH does not exist."
    exit 1
fi

# Read the file line by line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Ignore comments and empty lines
    if [[ "$line" = \#* ]] || [[ -z "$line" ]]; then
        continue
    fi
    
    # Split the line into key and value
    IFS='=' read -r key value <<< "$line"
    
    # Remove potential spaces in key and value
    key=$(echo $key | xargs)
    value=$(echo $value | xargs)

    # Execute the gh variable set command
    if gh secret set "$key" --body "$value"; then
        echo "Secret $key added successfully."
    else
        exit_code=$?
        echo "Failed to add secret $key. Exit code: $exit_code"
    fi
done < "$FILE_PATH"
