#!/bin/bash

find_missing_files() {
    for dir in $(find "$1" -type d); do
        cd "$dir" || continue
        mp3_files=($(ls *.mp3 2>/dev/null | grep -oP '^\d{2}' | sort -n))

        if [ ${#mp3_files[@]} -gt 0 ]; then
            start=${mp3_files[0]}
            end=${mp3_files[-1]}
            missing_files=()

            for ((i=start; i<=end; i++)); do
                file=$(printf "%02d" $i)
                if [[ ! " ${mp3_files[@]} " =~ " ${file} " ]]; then
                    missing_files+=("$file")
                fi
            done

            if [ ${#missing_files[@]} -gt 0 ]; then
                echo "Missing files in directory $dir: ${missing_files[*]}"
            fi
        fi
    done
}

current_directory=$(dirname "$(realpath "$0")")
find_missing_files "$current_directory"
