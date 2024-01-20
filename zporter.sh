#!/bin/bash

output_file=""

port_scan() {
    local host=$1
    local command

    command="seq 1 65535 | xargs -P 200 -I {} httpx -silent -sc -cl -title -u ${host}:{}"

    if [ -n "$output_file" ]; then
        command+=" -o $output_file"
    fi

    eval "$command"
}

extract_domain() {
    local input=$1

    echo "$input" | grep -oP '^(?:http:\/\/|https:\/\/)?\K[^\/\?:#]+' | sort -u # i realy hate this ):
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
            domain=$(extract_domain "$line")
            port_scan "$domain"
        done <"$file"
        ;;
    d)
        input="$OPTARG"
        domain=$(extract_domain "$input")
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
    echo "Example: $0 -l list.txt or $0 -d x.com -o out.txt"
    exit 1
fi
