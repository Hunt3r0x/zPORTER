#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

output=""
prange="1 65535"

# pscan() {
#     local host=$1
#     local command

#     command="seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u ${host}:{}"

#     if [ -n "$output_file" ]; then
#         command+=" | tee -a $output_file"
#         # seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u "${host}:{}" | tee -a "$output_file"
#     fi

#     eval "$command"
# }

pscan() {
    local host=$1

    if [ -n "$output" ]; then
        echo -e "${GREEN} results will be saved --> ${YELLOW}${output}${NC}\n"
        seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u ${host}:{} | tee -a "$output"
    else
        seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u ${host}:{}
    fi
}

filter() {
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
        output="$OPTARG"
        ;;
    \?)
        echo -e "${RED}Invalid option:${NC} -$OPTARG" >&2
        exit 1
        ;;
    esac
done

if [ -n "$file" ]; then
    if [ ! -f "$file" ]; then
        echo -e "${YELLOW}File $file does not exist.${NC}"
        exit 1
    fi

    while IFS= read -r line; do
        domain=$(filter "$line")
        pscan "$domain"
    done <"$file"

elif [ -n "$single_domain" ]; then
    domain=$(filter "$single_domain")
    pscan "$domain"
else
    echo -e "${GREEN}USAGE:${NC}"
    echo -e "    ${YELLOW}./zporter.sh -l <file>${NC}"
    echo -e "        domains from a file"
    echo -e "    ${YELLOW}./zporter.sh -d <input> [-o <output>]${NC}"
    echo -e "        single domain/IP"
    echo -e "${GREEN}EXAMPLES:${NC}"
    echo -e "    ${YELLOW}./zporter.sh -d x.com -o out.txt${NC}"
    echo -e "    ${YELLOW}./zporter.sh -l list.txt -o out.txt${NC}"
    exit 1
fi
