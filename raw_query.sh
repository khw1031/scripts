#!/bin/bash

# Add this to your .zshrc or .bashrc file
raw_query() {
    if [ $# -eq 0 ]; then
        echo "Usage: raw_query <query>"
        return 1
    fi
    if ! command -v fabric &> /dev/null; then
        echo "Error: fabric command not found"
        return 1
    fi
    echo "$*" | fabric -p raw_query
}