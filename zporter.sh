#!/bin/bash

output_file=""

port_scan() {
    local host=$1
    local cmd

    cmd="seq 1 65535 | xargs -P 200 -I {} httpx -silent -sc -cl -title -u ${host}:{}"

    if [ -n "$output_file" ]; then
        cmd+=" -o $output_file"
    fi

    eval "$cmd"
}

extract_domain() {
    local input=$1

    local domain=$(echo "$input" | grep -oP '^(?:http:\/\/|https:\/\/)?\K[^\/\?:#]+')

    echo "$domain"
}

while getopts "l:d:o:" opt; do
    case $opt in
    l)
        file="$OPTARG"
        if [ ! -s "$file" ]; then
            echo "File $file is missing or empty."
            exit 1
        fi
        while IFS= read -r line; do
            local domain=$(extract_domain "$line")
            port_scan "$domain"
        done <"$file"
        ;;
    d)
        input="$OPTARG"
        local domain=$(extract_domain "$input")
        port_scan "$domain"
        ;;
    o)
        output_file="$OPTARG"
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    echo "Usage: $0 -l <file> or $0 -d <input> [-o <output_file>]"
    exit 1
fi
