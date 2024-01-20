#!/bin/bash

output_file=""
prange="1 65535"

pscan() {
    local host=$1
    local command

    command="seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u ${host}:{}"

    if [ -n "$output_file" ]; then
        command+=" | tee -a $output_file"
        # seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u "${host}:{}" | tee -a "$output_file"
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
        ;;
    d)
        single_domain="$OPTARG"
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

if [ -n "$file" ]; then
    if [ ! -f "$file" ]; then
        echo "File $file does not exist."
        exit 1
    fi

    while IFS= read -r line; do
        domain=$(extract_domain "$line")
        pscan "$domain"
    done <"$file"

elif [ -n "$single_domain" ]; then
    domain=$(extract_domain "$single_domain")
    pscan "$domain"
else
    echo "Usage: $0 -l <file> or $0 -d <input> [-o <output_file>]"
    echo "Example: $0 -l list.txt or $0 -d x.com -o out.txt"
    exit 1
fi
